//
//  AppDelegate.swift
//  FortyDayChallenge
//
//  Created by Shane Denham on 8/26/15.
//  Copyright (c) 2015 Covenent Eyes. All rights reserved.
//

import UIKit
import RealmSwift
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //var dayBlogIDs = []

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		Fabric.with( [ Crashlytics.self ] )
		
        // Data Migrations
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: {
                migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {
                        var newObjectID = 1
                        
                        // Add the new actionID attribute to the DayActions objects stored in the Realm
                        migration.enumerate(DayAction.className()) { oldObject, newObject in
                            newObject!["actionID"] = newObjectID
                            newObjectID = newObjectID + 1
                        }
                    }
                    if (oldSchemaVersion < 2) {
                        
                        // Add the new reflectionQuestion attribute to
                        // the ChallengeDay objects stored in the Realm
                        migration.enumerate(ChallengeDay.className()) { oldObject, newObject in
                            newObject!["reflectionQuestion"] = "Write down at least one memorable take-away for today’s lesson."
                        }
                    }
                    if (oldSchemaVersion < 3) {
                    
                        // Add the new useAlerts attribute to the User objects stored in the Realm
                        migration.enumerate(User.className()) { oldObject, newObject in
                            newObject!["useAlerts"] = "Y"
                        }
                        
                        // update day intros
                        self.remove_luke_from_intros()
                    }

            }
        )

        // check for new user and/or passcode isEnabled
        getUserAndPasscode(true)
        
        let realm = try! Realm()
        let challengeDaysArray = realm.objects(ChallengeDay)
        
        // Customize status bar style
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        // Customize navigation bar styles
        UINavigationBar.appearance().barTintColor = BrandStandards.colorBlue
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //UITabBar.appearance().backgroundColor = UIColor.yellowColor();
        
        // Global font styles
        UITextView.appearance().font = UIFont(name: "Helvetica Neue", size: 14)
        UILabel.appearance().font = UIFont(name: "Helvetica Neue", size: 14)
        
        
        if challengeDaysArray.count == 0 {
            populateChallengeDays()
            GlobalQueries.setProgressForChallengeDays(0)
        }
        
        if !GlobalQueries.isActionData() {
            populateActionSteps()
        }
        
        // push notifications
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)

        return true

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        getUserAndPasscode(false)
		
		// We take much of the logic out of App Delegate. We always cancel without dispute.
		// 
		// Scheduling logic is as follows:
		// - If user does NOT yet exist, schedule.
		// - If user DOES exist, schedule iff their settings permit.
		//
		GlobalElements.cancelPushNotifications()
		GlobalElements.maybeSchedulePushNotifcations()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

        populateActionSteps()
        getUserAndPasscode(false)

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    // Data Functions
    func populateChallengeDays() {
        
        // Check for the 40DayChallengeData CSV file
        if let contentsOfURL = Bundle.main.url(forResource: "40DayChallengeData", withExtension: "csv") {
            
            // Pull in and parse the data from the CSV
            getChallengeDayData(contentsOfURL, completionHandler: {(dayData:[(dayTitle:String, dayIntro: String, actionStep: String, question: String)]) -> Void in
                
                // Save the data to the Realm
                self.saveChallangeDaysDataToRealm(dayData)
            })
        }
    }
    
    func getChallengeDayData(_ contentsOfURL: URL, completionHandler:(_ data:[(dayTitle:String, dayIntro: String, actionStep: String, question: String)]) -> Void) {
        
        var error:NSError?
        let dayChallengeData = DataManager.parseDataFromCSV(contentsOfURL, encoding: String.Encoding.utf8, error: &error)
        
        completionHandler(data: dayChallengeData!)
    }
    
    
    func saveChallangeDaysDataToRealm(_ dayData:[(dayTitle:String, dayIntro: String, actionStep: String, question: String)]) {
        
        var dayNumber = 1
        
        let realm = try! Realm()
        
        try! realm.write() {
            
            for day in dayData {
                let newDay = ChallengeDay()
                
                newDay.name = day.dayTitle
                newDay.dayIntro = day.dayIntro
                newDay.actionStep = day.actionStep
                newDay.reflectionQuestion = day.question
                newDay.dayNumber = dayNumber
                newDay.imageFile = "Day \(String(dayNumber))"
                
                // Add the newDay object to the Realm
                realm.add(newDay)
                
                dayNumber = dayNumber + 1
            }
            
        }
    }
    
    static func getBlogDataForChallengeDays(_ completion:@escaping (_ actionDayData: [(dayNumber:Int,dayBlogTitle:String,dayBlogContent:String,actionID:Int)]) -> Void)
    {
        // Gather blog information in a background thread.
        DispatchQueue.global( priority: DispatchQueue.GlobalQueuePriority.default).async
            {
                let dayBlogIDs = [(1,"40583",1), (2,"56791",2), (3,"56757",3), (4,"56830",4), (5,"49680",5), (6,"44134",6), (6,"53816",7), (7,"44404",8), (8,"49872",9), (9,"55228",10), (10,"52119",11), (11,"36510",12), (12,"28851",13), (13,"42132",14), (14,"12512",15), (15,"49680",16), (16,"54592",17), (17,"43125",18), (18,"54461",19), (19,"54612",20), (20,"10861",21), (21,"42421",22), (21,"55008",23), (22,"10715",24), (23,"55117",25), (24,"54488",26), (25,"56764",27), (26,"4045",28), (27,"8437",29), (28,"54279",30), (29,"22307",31), (30,"6277",32), (31,"42476",33), (32,"49804",34), (33,"53685",35), (34,"57103",36), (35,"34779",37), (36,"54499",38), (37,"32888",39), (38,"53762",40), (39,"6290",41), (40,"40583",42)]
                
                var dayActionData: [(dayNumber:Int,dayBlogTitle:String,dayBlogContent:String,actionID:Int)] = []
                
                // Create synchronization objects.
                let lock = NSObject()
                let group = DispatchGroup()
                
                // Loop through blog IDs.
                for (dayNumber, blogID, actionID) in dayBlogIDs {
                    // Record that we're entering the group, probably in a thread.
                    group.enter()
                    
                    DataManager.setBlogDataForChallengeDay( blogID ) {
                            (dayBlogTitle, dayBlogContent) in
                            
                            // Prevent simultaneous access to dayActionTitles by multiple threads.
                            objc_sync_enter( lock )
                            
                            // Store the result.
                        let newAction = ( dayNumber: dayNumber, dayBlogTitle: dayBlogTitle, dayBlogContent: dayBlogContent, actionID: actionID )
                            print(String(newAction.dayNumber))
                            dayActionData.append(newAction)
                            
                            // Finish syncing threads.
                            objc_sync_exit( lock )
                            
                            group.leave()
                    }
                }
                
                // Wait for all completion handlers to finish.
                group.wait(timeout: DispatchTime.distantFuture )
                
                // Call `completion`, but in the main thread.
                DispatchQueue.main.async {
                    completion( dayActionData )
                }
        }
    }
    
    
    func saveActionDataToRealm(_ dayActionData: [(dayNumber:Int,dayBlogTitle:String,dayBlogContent:String,actionID:Int)]) {
        
        print("Saving Action data to Realm")
        
        let realm = try! Realm()
        
        for (dayNumber,dayBlogTitle,dayBlogContent,actionID) in dayActionData {
            
            // Get ChallengeDay for the Action
            let dayForAction = realm.objectForPrimaryKey(ChallengeDay.self, key: dayNumber)
            
            // Set up New Action
            let newAction = DayAction()
            newAction.actionTitle = dayBlogTitle
            newAction.actionContent = dayBlogContent
            newAction.day = dayForAction
            newAction.actionID = actionID
            
            // Save the new action to the Realm
            try! realm.write {
                realm.add(newAction, update: true)
            }
        }
    }
    
    func setActionDataForFirstDay() {
        let realm = try! Realm()
        let firstDay = realm.objectForPrimaryKey(ChallengeDay.self, key: 1)
        let dayAction = realm.objects(DayAction).filter("day == %@", firstDay!)
        let firstDayAction = dayAction[0]
        
        try! realm.write{
            firstDayAction.actionTitle = "Choose Your Partner"
            firstDayAction.actionContent = "<p>Once you <a href=\"http://www.covenanteyes.com/support-articles/set-up-your-software/\">have all the software set up</a>, your next step is to choose your Accountability Partner. Picking the right person for this role is critical for your succes.</p><p><iframe src=\"http://player.vimeo.com/video/68239625?title=0&amp;byline=0&amp;portrait=0\" width=\"470\" height=\"264\" frameborder=\"0\" allowfullscreen=\"allowfullscreen\"></iframe></p><h3>1. Choose your Partner</h3><p>A good Accountability Partner will be conversational but confidential, and challenging but not condemning. Learn <a href=\"http://www.covenanteyes.com/support-articles/what-is-an-accountability-partner/\">what makes a good Accountability Partner</a>.</p><h3>2. Learn What Your Partner Will See</h3><p>Accountability Reports don't show browsing history from before you installed Covenant Eyes. Learn more about what your new Partners will <a href=\"http://www.covenanteyes.com/support-articles/what-do-partners-see-on-the-report/\">see on your Accountability Reports</a>.</p><h3>3. Add Partners to Your Account</h3><p>You can have as many Accountability Partners as you'd like for free! Learn how to <a href=\"http://www.covenanteyes.com/support-articles/inviting-accountability-partners/\">invite a new Partner</a>.</p>"
        }
    }
    
    func setActionDataForLastDay() {
        let realm = try! Realm()
        let lastDay = realm.objectForPrimaryKey(ChallengeDay.self, key: 40)
        let dayAction = realm.objects(DayAction).filter("day == %@", lastDay!)
        let lastDayAction = dayAction[0]
        
        try! realm.write{
            lastDayAction.actionTitle = "Day 40: Overcome Porn"
            lastDayAction.actionContent = "<h3>You made it! Watch the video to find out what's next.</h3><p>We hope you've enjoyed and learned a lot during the 40 Day Challenge.</p><p>Today is not just the end of the challenge; it is the first day of something new. <em>How do you plan a long-term strategy for freedom beyond today?</em> Watch the video below to learn more.</p><p><iframe src=\"https://player.vimeo.com/video/134742070?color=ffffff&amp;title=0&amp;byline=0&amp;portrait=0\" width=\"750\" height=\"422\" frameborder=\"0\" allowfullscreen=\"allowfullscreen\"></iframe></p><h2>More Free Resources</h2><p><a href=\"http://www.covenanteyes.com/e-books/\"><strong>We encourage you to download any of our free e-books</strong></a>, covering a broad variety of topics concerning pornography and online safety.</p>"
        }
    }
    
    func populateActionSteps() {
        if DataManager.connectedToNetwork() {
            
            let alert = UIAlertView(title: "Please wait...", message: "Data is being downloaded for Overcome Porn: The 40 Day Challenge.", delegate: nil, cancelButtonTitle: nil)
            if !GlobalQueries.isActionData() {
                alert.show()
            }
            AppDelegate.getBlogDataForChallengeDays() {
                days in
                self.saveActionDataToRealm( days )
                self.setActionDataForFirstDay()
                self.setActionDataForLastDay()
                alert.dismiss(withClickedButtonIndex: -1, animated: true)
            }
        } else {
            let alert = UIAlertView(title: "No Internet Connection", message: "Please check Internet connection. This app needs to connect to the internet in order to finish set up.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func getUserAndPasscode(_ isLaunch: Bool) {

        // if account exists, skip the account create process
        if GlobalQueries.userExists() {

            // get the user
            let user = GlobalQueries.getUser()

            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            if (user.usePasscode == "Y" && user.passcode != "") {
                
                if (isLaunch) {
                    
                    let passcodeController: PasscodeController = mainStoryboard.instantiateViewController(withIdentifier: "PasscodeController") as! PasscodeController
                    self.window?.rootViewController = passcodeController
                    
                } else {

                    let passcodeController: PasscodeController = mainStoryboard.instantiateViewController(withIdentifier: "PasscodeController") as! PasscodeController
                    let rootViewController: BlankVC = mainStoryboard.instantiateViewController(withIdentifier: "BlankVC") as! BlankVC
                    window?.rootViewController = rootViewController
                    window?.makeKeyAndVisible()
                    rootViewController.present(passcodeController, animated: false, completion: nil)

                }

            } else {
                
                if (isLaunch) {

                    let swRevealViewController: SWRevealViewController = mainStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.window?.rootViewController = swRevealViewController
                    
                } else {
                    
                    let swRevealViewController: SWRevealViewController = mainStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    let rootViewController: BlankVC = mainStoryboard.instantiateViewController(withIdentifier: "BlankVC") as! BlankVC
                    window?.rootViewController = rootViewController
                    window?.makeKeyAndVisible()
                    rootViewController.present(swRevealViewController, animated: false, completion: nil)

                }

            }

        }

    }
    
    //
    // Update Day Intros to remove Luke's name
    //
    // This function can be removed in a future release
    //
    func remove_luke_from_intros() {
        DispatchQueue(label: "background", attributes: []).async {
            autoreleasepool {
                let realm = try! Realm()
                let challengeDays = realm.objects(ChallengeDay)
        
                for day in challengeDays {
                    print("day \(String(day.dayNumber))")
                    var intro = day.dayIntro
                    print(intro)
                    intro = intro.replacingOccurrences(of: "\\n\\nBlessings,\\n\\nLuke Gilkerson", with: "", options: NSString.CompareOptions.literal, range: nil)
                    try! realm.write{
                        day.dayIntro = intro
                    }
                }
            }
        }
    }

}
