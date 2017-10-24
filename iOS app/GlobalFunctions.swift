//
//  GlobalFunctions.swift
//  FortyDayChallenge
//
//  Created by Shane Denham on 11/24/15.
//  Copyright © 2015 Covenent Eyes. All rights reserved.
//

import Foundation
import UIKit

class GlobalElements {
    class func addButton(_ viewWidth:CGFloat, frameY:CGFloat, label:String) -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = BrandStandards.colorBlue
        btn.frame = CGRect(x: viewWidth / 4, y: frameY, width: viewWidth / 2, height: 50)
        btn.layer.cornerRadius = 25
        
        if let label_nextButton: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: btn.frame.width, height: btn.frame.height)) {
            label_nextButton.textAlignment = NSTextAlignment.center
            label_nextButton.font = UIFont.systemFont(ofSize: 16.0)
            label_nextButton.text = label
            label_nextButton.textColor = UIColor.white
            btn.addSubview(label_nextButton)
        }
        
        return btn
    }
    
    class func optionButton(_ btnWidth:CGFloat, frameX:CGFloat, frameY:CGFloat, label:String) -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = BrandStandards.colorBlue
        btn.frame = CGRect(x: frameX, y: frameY, width: btnWidth, height: 50)
        btn.layer.cornerRadius = 25
        
        if let label_nextButton: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: btn.frame.width, height: btn.frame.height)) {
            label_nextButton.textAlignment = NSTextAlignment.center
            label_nextButton.font = UIFont.systemFont(ofSize: 16.0)
            label_nextButton.text = label
            label_nextButton.textColor = UIColor.white
            btn.addSubview(label_nextButton)
        }
        
        return btn
    }
    
    class func navButton(_ label: String, x: CGFloat, width: CGFloat, current: Bool) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: x, y: 0, width: width, height: 55)
        if let buttonText: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: button.frame.width, height: button.frame.height)) {
            
            buttonText.textAlignment = NSTextAlignment.center
            buttonText.font = UIFont.systemFont(ofSize: 14.0)
            buttonText.text = label.uppercased()
            let length = (buttonText.text?.characters.count)! * 9
            
            if current == true {
                buttonText.textColor = UIColor.white
                
                let bottomBorder = CALayer()
                bottomBorder.borderColor = UIColor.white.cgColor
                bottomBorder.frame = CGRect(x: (buttonText.frame.size.width - CGFloat(length)) / 2, y: buttonText.frame.size.height - 15, width: CGFloat(length), height: 1)
                bottomBorder.borderWidth = 0.75
                buttonText.layer.addSublayer(bottomBorder)
                
            } else {
                buttonText.textColor = BrandStandards.colorLightGray
            }
            
            button.addSubview(buttonText)
        }
        
        return button
    }
}