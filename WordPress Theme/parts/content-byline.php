<?php
/**
 * The template part for displaying an author byline
 */
?>

<div class="byline">
	<span class="photo-circle float-left"><?php echo userphoto_the_author_thumbnail(); ?></span> 
	<p class="meta"><?php the_author_posts_link(); ?>  <?php echo nl2br(get_the_author_meta('description')); ?><br/>
	<?php the_time('F j, Y') ?></p>
</div>