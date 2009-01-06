<?php
$current=dirname(__FILE__).'/';
include_once($current . "./include.php");

$reload = $_REQUEST["reload"];
$expire = 3600*6; 		//cache expire time

if ($reload == "rss")	//flag to force reload of all RSS
	$expire = 0;

define('MAGPIE_DIR', $current. 'rss/');
define('MAGPIE_CACHE_DIR', $def['DATABASE_PATH'] . "rss/");
define('MAGPIE_CACHE_AGE', $expire); // set cache timeout

require_once(MAGPIE_DIR.'rss_fetch.inc');

if ( $url ) {

	$url = str_replace("%HTTP_HOST%", $_SERVER["HTTP_HOST"], $url );
	
	// caso seja RSS do componente REDES adiciona o parametro bvs para navegação no site
	if ( eregi("\/bvsnet\/rss", $url ) ){
		if ( strpos($url,"?") === false ){
			$url .= "?";
		}	
	    $url .= "&bvs=" . $def["SERVERNAME"];
	}
		
	$rss = fetch_rss( $url );
	if ($rss == false){
		echo "rss error: " . $MAGPIE_ERROR;
	}else{
		$channel = $rss->channel['title'];	
		if ($channel == 'BVS Network'){
			/* lista de bandeira dos paises */
			echo $rss->items[0]['description'];
		}else{
			if (eregi('^Newsletter',$channel)){
				/* mostra somente edicao da newsletter */
				$channel = "Ed. " . eregi_replace('Newsletter|VHL|BVS',"",$channel); 
				/* logo já deve estar definido como titulo do componente no bvs-site */
				$rss->image = null;
			}
			if ($rss->image['url'] != ''){
				echo "<a href=\"" . htmlentities($rss->image['link'])  . "\" target=\"news\">" . 
						"<img src=\"" . $rss->image['url'] . "\" class=\"logo\" alt=\"logo\"/>" .
					 "</a><br/>";
			}	

			if ($rss->channel['link'] != ''){
				echo "<a href=\"" . htmlentities($rss->channel['link'])  . "\" target=\"news\">" . 
						"<span class=\"channel\">" . $channel . "</span></a>";
			}			
			echo "<ul>";
			foreach ($rss->items as $item) {
				$href = htmlentities($item['link']);		
				$title = $item['title'];
				echo "<li><a href=\"$href\" target=\"_blank\">$title</a></li>";
			}
			echo "</ul>";
		}
	}
}
?>
