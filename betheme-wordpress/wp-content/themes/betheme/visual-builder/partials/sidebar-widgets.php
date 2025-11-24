<?php
if( ! defined( 'ABSPATH' ) ){
	exit; // Exit if accessed directly
}

$widgetsClass =  new Mfn_Builder_Fields();
$widgets = $widgetsClass->get_items();

if ( !defined( 'ICL_SITEPRESS_VERSION' ) ) unset($widgets['header_language_switcher']);
if ( !defined( 'WCML_VERSION' ) ) unset($widgets['header_currency_switcher']);

$favs = json_decode( get_option( 'mfn_fav_items_'.get_current_user_id() ) );

echo '<div class="panel panel-items" id="mfn-widgets-list">
    <div class="panel-search mfn-form">
        <input class="mfn-form-control mfn-form-input search mfn-search" type="search" autocomplete="off" placeholder="Search">
    </div>';

    if( !isset($this->template_type) || $this->template_type != 'header' ){
	    echo '<div class="mfn-fav-items-wrapper '.($favs && count($favs) > 0 ? 'isset-favs' : 'empty-favs').'">';
		 	echo '<h5>'.esc_html__('Favourite elements', 'mfn-opts').'</h5>';

		 	echo '<div class="mfn-fav-items-content">';
		 	echo '<ul class="items-list fav-items-list clearfix">';
		 	if( $favs && count($favs) > 0 ) {
		 		foreach( $favs as $fav ) {
		 			if( $widgets[$fav]['cat'] !== 'header' )
		 				echo '<li class="mfn-item-'.$fav.' category-'.$widgets[$fav]['cat'].'" data-title="'.$widgets[$fav]['title'].'" data-type="'.$fav.'" data-alias="'.$fav.'"><a href="#"><div class="mfn-icon card-icon"></div><span class="title">'.$widgets[$fav]['title'].'</span></a></li>';
		 		}
		 	}
		 	echo '</ul>';
		 	echo '<span class="empty-favs-info">Collect favourite elements in one place by<br /> <span class="mfn-icon mfn-icon-right-click"></span> &gt; <i>Add to favourites'. ( ! is_admin() ? ' (Unavailable in Demo)' : '' ) .'</i></span>';
		 echo '</div></div>';
	}

    echo '<ul class="items-list list clearfix">';

    foreach($widgets as $w=>$widget) {
    	if( isset($this->template_type) && $this->template_type == 'header' ) {
    		// if header
    		if($widget['cat'] == 'header' || in_array($w, array('column', 'button', 'heading', 'html', 'payment_methods', 'image', 'plain_text', 'header_language_switcher', 'header_currency_switcher'))){
		    	echo '<li class="mfn-item-'.$w.' category-'.$widget['cat'].'" data-title="'.$widget['title'].'" data-alias="'.$w.'" data-type="'.$widget['type'].'"><a href="#"><div class="mfn-icon card-icon"></div><span class="title">'.$widget['title'].'</span></a></li>';
		    }
    	}elseif( isset($this->template_type) && $this->template_type == 'megamenu' ) {
    		if($widget['cat'] == 'megamenu' || ( !in_array($widget['cat'], array('woocommerce', 'shop-archive', 'single-product', 'header', 'footer', 'single-post', 'single-blog-post', 'single-portfolio-post', 'archive', 'archive-post', 'archive-portfolio', 'cart', 'checkout', 'thanks', 'order-shared')) && !in_array($w, array('before_after', 'chart', 'content', 'offer', 'offer_thumb', 'our_team', 'our_team_list', 'sidebar_widget', 'slider_plugin', 'table_of_contents', 'testimonials_list', 'timeline', 'sidemenu_menu', 'popup_exit')) ) ){
		    	echo '<li class="mfn-item-'.$w.' category-'.$widget['cat'].'" data-title="'.$widget['title'].'" data-alias="'.$w.'" data-type="'.$widget['type'].'"><a href="#"><div class="mfn-icon card-icon"></div><span class="title">'.$widget['title'].'</span></a></li>';
		    }
    	}elseif( isset($this->template_type) && $this->template_type == 'popup' ) {
    		if($widget['cat'] == 'popup' || ( !in_array($widget['cat'], array('loops', 'cart', 'checkout', 'thanks', 'order-shared', 'woocommerce', 'shop-archive', 'single-product', 'single-post', 'single-blog-post', 'single-portfolio-post', 'header', 'footer', 'megamenu', 'archive', 'archive-post', 'portfolio')) && !in_array($w, array('sidebar_widget', 'slider_plugin', 'table_of_contents', 'slider', )) ) ){
		    	echo '<li class="mfn-item-'.$w.' category-'.$widget['cat'].'" data-title="'.$widget['title'].'" data-alias="'.$w.'" data-type="'.$widget['type'].'"><a href="#"><div class="mfn-icon card-icon"></div><span class="title">'.$widget['title'].'</span></a></li>';
		    }
    	}elseif( isset($this->template_type) && $this->template_type == 'sidemenu' ) {
    		if($widget['cat'] == 'sidemenu' || ( $widget['cat'] == 'header' && !in_array($w, array('header_menu', 'header_burger')) ) || ( !in_array($widget['cat'], array('popup', 'cart', 'checkout', 'order-shared', 'thanks', 'loops', 'woocommerce', 'shop-archive', 'single-product', 'header', 'footer', 'megamenu', 'single-post', 'single-blog-post', 'single-portfolio-post', 'archive', 'archive-post', 'portfolio')) && !in_array($w, array('sidebar_widget', 'slider_plugin', 'table_of_contents', 'slider', 'content')) ) ){
		    	echo '<li class="mfn-item-'.$w.' category-'.$widget['cat'].'" data-title="'.$widget['title'].'" data-alias="'.$w.'" data-type="'.$widget['type'].'"><a href="#"><div class="mfn-icon card-icon"></div><span class="title">'.$widget['title'].'</span></a></li>';
		    }
    	}elseif(
    		// rest
	    	( !in_array($widget['cat'], array('shop-archive', 'archive-product', 'single-product', 'header', 'megamenu', 'footer', 'popup', 'sidemenu', 'single-post', 'single-blog-post', 'single-portfolio-post', 'archive', 'archive-post', 'blog', 'portfolio', 'archive-portfolio', 'cart', 'checkout', 'thanks', 'order-shared', 'woocommerce')) ) ||
			( isset($this->template_type) && $this->template_type == 'single-product' && in_array($widget['cat'], array('single-product', 'woocommerce')) ) ||
			( isset($this->template_type) && $this->template_type == 'footer' && $widget['cat'] == 'footer' ) ||
			( isset($this->template_type) && $this->template_type == 'cart' && ( $widget['cat'] == 'cart' || $widget['cat'] == 'order-shared' ) ) ||
			( isset($this->template_type) && $this->template_type == 'checkout' && ( $widget['cat'] == 'checkout' || $widget['cat'] == 'order-shared' ) ) ||
			( isset($this->template_type) && $this->template_type == 'thanks' && ( $widget['cat'] == 'thanks' || $widget['cat'] == 'order-shared' ) ) ||
			( isset($this->template_type) && $this->template_type == 'popup' && $widget['cat'] == 'popup' ) ||
			( isset($this->template_type) && $this->template_type == 'single-post' && ($widget['cat'] == 'single-post' || $widget['cat'] == 'single-blog-post') ) ||
			( isset($this->template_type) && $this->template_type == 'archive-post' && ($widget['cat'] == 'single-post' || $widget['cat'] == 'single-blog-post' || $widget['cat'] == 'archive' || $widget['cat'] == 'blog' ) && $w != 'post_blog_related' ) ||
			( isset($this->template_type) && $this->template_type == 'archive-portfolio' && ($widget['cat'] == 'single-post' || $widget['cat'] == 'single-portfolio-post' || $widget['cat'] == 'archive' || $widget['cat'] == 'portfolio' ) && $w != 'post_portfolio_related' ) ||
			( isset($this->template_type) && $this->template_type == 'single-portfolio' && ($widget['cat'] == 'single-post' || $widget['cat'] == 'single-portfolio-post') ) ||
			( isset($this->template_type) && $this->template_type == 'archive-product' && in_array($widget['cat'], array('shop-archive', 'woocommerce')) ) || 
			( isset($this->template_type) && strpos($this->template_type, 'archive-') !== false && in_array($widget['cat'], array('archive')) && !in_array($this->template_type, array('shop-archive', 'woocommerce', 'archive-product')) ) || 
			( isset($this->template_type) && strpos($this->template_type, 'single-') !== false && in_array($widget['cat'], array('single-post')) && !in_array($w, array('post_excerpt', 'post_comments', 'post_love')) && !in_array($this->template_type, array('single-product')) )
	    ){
	    	echo '<li class="mfn-item-'.$w.' category-'.$widget['cat'].'" data-title="'.$widget['title'].'" data-alias="'.$w.'" data-type="'.$widget['type'].'"><a href="#"><div class="mfn-icon card-icon"></div><span class="title">'.$widget['title'].'</span></a></li>';
	    }

	}
	echo '</ul>
</div>';
?>
