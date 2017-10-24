<?php

/*
Module Layout Shortcodes
*/

add_shortcode('module', 'ce_modules');

function ce_modules($atts, $content = null) {

    extract(shortcode_atts(array(
        'layout' => '',
        'heading' => '',
        'subheading' => ''
    ), $atts));

    /* Set the path to the module file */
    $theme_dir = get_template_directory();
    $modules_dir = $theme_dir . '/modules/';
    $module = '';

    ob_start();

    $module = $modules_dir . $layout . '.php';

?>

<!-- Display the heading and subheading -->
<?php if ($heading != "") { ?>
    <div class="row module">
    	<div class="small-12 medium-8 large-6 medium-centered columns center">
    		<h2><?php echo $heading; ?></h2>
    		<p><?php if ($subheading != "") { echo $subheading; } ?></a></p>
    	</div>
    </div>
    <div class="divider"></div>
<?php } ?>

<!-- Display the module -->
<?php require $module; ?>

<?php

    $output = ob_get_clean();

    return $output;
}

?>