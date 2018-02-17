<?php 
/**
 * The sidebar containing the main widget area
 */
 ?>

<aside id="sidebar1" class="sidebar small-12 medium-2 large-1 cell" role="complementary">

	<?php if ( is_active_sidebar( 'sidebar1' ) ) : ?>

		<div class="stuck">
			<?php dynamic_sidebar( 'sidebar1' ); ?>
		</div>

	<?php else : ?>

	<!-- This content shows up if there are no widgets defined in the backend. -->
						
	<div class="alert help">
		<p><?php _e( 'Please activate some Widgets.', 'jointswp' );  ?></p>
	</div>

	<?php endif; ?>

</aside>