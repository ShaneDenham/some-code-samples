<?php

// This functionality will eventually be moved into a plugin and display
// trending content rather than content related by category.

// Get the current post ID and categories
$post_id = get_the_ID();
$categories = get_the_category( $post_id );

// Create an array of the category IDs
$cat_ids = array();
if ( $categories && !is_wp_error( $categories ) ) {

    foreach ( $categories as $category ) {

        array_push( $cat_ids, $category->term_id );

    }

}

// Build query to grab other posts in the same categories as the current post
$current_post_type = get_post_type( $post_id );
$args = array(
    'category__in' => $cat_ids,
    'post_type' => $current_post_type,
    'posts_per_page' => '20',
    'post__not_in' => array( $post_id )
);
$query = new WP_Query( $args );
 ?>

<?php if ( $query->have_posts() ) : ?>
	<div class="grid-x grid-margin-x grid-padding-x trending">
		<div class="cell small-12">
			<p class="title">Related Content</p>
		</div>
		<div class="cell small-12">
			<div class="trending-content grid-x">
				<?php while ( $query->have_posts() ) : $query->the_post(); ?>
					<div class="card">
					        <div class="card-section">
					        	<div class="card-image">
								  	<?php the_post_thumbnail('medium'); ?>
								</div>

					        	<h4><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h4>
					        </div>
				    </div>
				<?php endwhile; ?>
			</div>
		</div>
	</div>
<?php endif; ?>