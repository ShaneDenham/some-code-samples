<?php
/**
 * The off-canvas menu uses the Off-Canvas Component
 *
 * For more info: http://jointswp.com/docs/off-canvas-menu/
 */
?>

<div class="top-bar stacked-for-medium" id="top-bar-menu">
	<div class="top-bar-left float-left">
		<ul class="menu">
			<a href="http://www.covenanteyes.com">
                <img src="<?php echo get_template_directory_uri(); ?>/images/Logo_1_Color_300px.png" class="logo" />
            </a>
		</ul>
	</div>
	<div class="top-bar-right show-for-medium">
		<div class="grid-x">
			<div class="cell auto">
			  	<?php joints_top_nav(); ?>
			</div>
		    <div class="cell shrink">
		    	<ul class="menu dropdown">
		    		<li><a href="#">My Account</a></li>
		    		<li><a href="#" class="gradient-button">
		    			<div class="svg">
                            <?php $imgWidth = "21"; $imgHeight = "20"; include( 'svg/create-account.php' ); ?>
                        </div><span>Create Account</span>
		    		</a></li>
		    	</ul>
		    </div>
		</div>
	</div>
	<div class="top-bar-right float-right show-for-small-only">
		<ul class="menu">
			<!-- <li><button class="menu-icon" type="button" data-toggle="off-canvas"></button></li> -->
			<li><a data-toggle="off-canvas"><?php _e( 'Menu', 'jointswp' ); ?></a></li>
		</ul>
	</div>
</div>