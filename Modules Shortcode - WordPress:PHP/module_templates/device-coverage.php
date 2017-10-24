<?php

	function feature_coverage($covered) {
	 	if ($covered == 'yes') {
			$covered = '<span class="icon icon-checkmark"></span>';
		} elseif($covered == 'In-App') {
			$covered = '<a href="/support-articles/how-do-i-use-the-iphone-browser-app/">In-App Only</a>';
		} elseif ($covered == '') {
			$covered = 'empty';
		}
		return $covered;
	}

	function device_table_row($row) {

		echo '<tr><td>' . $row['feature'] . ' <span data-tooltip aria-haspopup="true" 
            class="has-tip icon icon-info" title="' . $row['tooltip'] . '" ></span></td>';

		if (is_array($row['covered'])) {
			foreach ($row['covered'] as $covered) {
	            $covered = feature_coverage($covered);
				echo '<td>' . $covered . '</td>';
			}
		} else {
			$covered = feature_coverage($row['covered']);
			echo '<td>' . $covered . '</td>';
		}

		echo '</tr>';
	}

	function display_device_table_rows($covered) {

		$tooltips = array(
			'accountability'=>  "This service monitors the websites you visit and sends an Accountability Report 
			                     to a person you trust. On Android devices, limited app monitoring is available. On iPhone, 
			                     monitoring is limited to the Covenant Eyes browser.", 
			'filtering' 	=> 	"We block content based on age-appropriateness. You can also set custom Block and 
			                     Allow lists. (On mobile devices, Filtering is only available via protected browsers.)",
			'uninstall' 	=>  "When you uninstall Covenant Eyes, we'll let your Accountability Partner know, 
	                             so they can make sure you weren't trying to hide your Internet activity. (This feature 
	                             is not available for iOS&reg;.)",
			'support' 		=>  "Have a question, or need some help? Call us toll-free at 877.479.1119. We'd love to talk to you!",
		);

		$rows = array(
	    			array(
	    				'feature' => 'Internet Accountability',
	    				'covered' => $covered['accountability'],
	    				'tooltip' => 'accountability'
    				),
    				array(
	    				'feature' => 'Filtering',
	    				'covered' => $covered['filtering'],
	    				'tooltip' => 'filtering'
    				),
    				array(
	    				'feature' => 'Uninstall Notification',
	    				'covered' => $covered['uninstall'],
	    				'tooltip' => 'uninstall'
    				),
    				array(
	    				'feature' => 'Expert Customer Support',
	    				'covered' => $covered['support'],
	    				'tooltip' => 'support'
    				),
    			);

    	foreach ($rows as $new_row) {
    		$row = array('feature' => $new_row['feature'], 'tooltip' => $tooltips[$new_row['tooltip']], 'covered' => $new_row['covered']);
    		device_table_row($row);
    	}
	}
?>

<table class="devices show-for-medium-up">
    <tr>
        <th width="25%">&nbsp;</th>
        <th><span class="icon icon-windows8"></span> Windows&reg;</th>
        <th><span class="icon icon-apple"></span> MacOS&reg;</th>
        <th><span class="icon icon-apple"></span> iOS&reg;</th>
        <th><span class="icon icon-android"></span> Android&trade;</th>
        <th>Kindle Fire&trade;</th>
    </tr>
    <?php
    	$covered = array('accountability' => array('yes','yes','In-App','yes','yes'),
	    				'filtering' => array('yes','yes','In-App','yes','No'),
	    				'uninstall' => array('yes','yes','No','yes','yes'),
	    				'support' => array('yes','yes','yes','yes','yes')
    			);

    	display_device_table_rows($covered);
    ?>
</table>

<ul class="accordion devices-mobile show-for-small-only" data-accordion>
    <li class="accordion-navigation active">
        <a href="#windows8" class="os"><span class="icon icon-windows8"></span> Windows&reg;</a>
        <div id="windows8" class="content active">
            <table>
                <?php
				    $covered = array('accountability' => 'yes',
					    			'filtering' => 'yes',
					    			'uninstall' => 'yes',
					    			'support' => 'yes'
				    		);

				    display_device_table_rows($covered);
				?>
            </table>
        </div>
    </li>
    <li class="accordion-navigation">
        <a href="#mac" class="os"><span class="icon icon-apple"></span> MacOS&reg;</a>
        <div id="mac" class="content">
            <table>
                <?php
				    $covered = array('accountability' => 'yes',
					    			'filtering' => 'yes',
					    			'uninstall' => 'yes',
					    			'support' => 'yes'
				    		);

				    display_device_table_rows($covered);
				?>
            </table>
        </div>
    </li>
    <li class="accordion-navigation">
        <a href="#ios" class="os"><span class="icon icon-apple"></span> iOS&reg;</a>
        <div id="ios" class="content">
            <table>
                <?php
				    $covered = array('accountability' => 'In-App',
					    			'filtering' => 'In-App',
					    			'uninstall' => 'no',
					    			'support' => 'yes'
				    		);

				    display_device_table_rows($covered);
				?>
            </table>
        </div>
    </li>
    <li class="accordion-navigation">
        <a href="#android" class="os"><span class="icon icon-android"></span> Android&trade;</a>
        <div id="android" class="content">
            <table>
                <?php
				    $covered = array('accountability' => 'yes',
					    			'filtering' => 'yes',
					    			'uninstall' => 'yes',
					    			'support' => 'yes'
				    		);

				    display_device_table_rows($covered);
				?>
            </table>
        </div>
    </li>
    <li class="accordion-navigation">
        <a href="#kindle" class="os">Kindle Fire&trade;</a>
        <div id="kindle" class="content">
            <table>
                <?php
				    $covered = array('accountability' => 'yes',
					    			'filtering' => 'No',
					    			'uninstall' => 'yes',
					    			'support' => 'yes'
				    		);

				    display_device_table_rows($covered);
				?>
            </table>
        </div>
    </li>
</ul>
