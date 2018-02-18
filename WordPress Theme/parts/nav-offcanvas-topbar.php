<?php
/**
 * The off-canvas menu uses the Off-Canvas Component
 *
 * For more info: http://jointswp.com/docs/off-canvas-menu/
 */
?>

<div class="top-bar stacked-for-medium" id="top-bar-menu">
	<div class="top-bar-left float-left">
		<h1><a href="<?php echo esc_url( home_url( '/' ) ); ?>" title="<?php bloginfo('name'); ?>"><?php bloginfo('name'); ?></a></h1>
		<h2><?php bloginfo('description'); ?></h2>
	</div>
	<div class="top-bar-right show-for-medium">
		<div class="grid-x">
			<div class="cell auto">
			  	<?php joints_top_nav(); ?>
			</div>
		    <div class="cell shrink">
		    	<ul class="menu dropdown">
		    		<li><a href="#">Cool Link</a></li>
		    		<li><a href="#" class="gradient-button">
		    			<div class="svg">
                            <?php $imgWidth = "21"; $imgHeight = "20"; include( 'svg/create-account.php' ); ?>
                        </div><span>Nice Button</span>
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