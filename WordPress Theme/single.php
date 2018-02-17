<?php 
/**
 * The template for displaying all single posts and attachments
 */

get_header(); ?>

<div class="content grid-container">

	<?php if (have_posts()) : while (have_posts()) : the_post(); ?>

		<div class="grid-x grid-margin-x">
            <div class="cell">
                <div class="blog-header-img">
                    <?php the_post_thumbnail('full'); ?>
                </div>
            </div>
        </div>

		<div class="inner-content grid-x grid-margin-x grid-padding-x">

			<?php get_sidebar(); ?>

			<main class="main small-12 medium-10 large-8 large-offset-1 cell" role="main">

			    	<?php get_template_part( 'parts/loop', 'single' ); ?>

			</main> <!-- end #main -->

		</div> <!-- end #inner-content -->

		<?php get_template_part( 'parts/content', 'subscribe' ); ?>

		<div class="grid-x grid-margin-x">
				<?php comments_template(); ?>
		</div>


	<?php endwhile; else : ?>

		<div class="inner-content grid-x grid-margin-x grid-padding-x">

			<?php get_sidebar(); ?>

			<main class="main small-12 medium-8 large-8 cell" role="main">

			   	<?php get_template_part( 'parts/content', 'missing' ); ?>

			</main> <!-- end #main -->

		</div> <!-- end #inner-content -->

	<?php endif; ?>

</div> <!-- end #content -->

<?php get_footer(); ?>