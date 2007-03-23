<?

	ini_set("display_errors","1");
	
	require_once(dirname(__FILE__)."/../classes/News.php");
	require_once(dirname(__FILE__)."/../includes/lastRSS/lastRSS.php");


	$news = new News();

	$news->setUserID($_COOKIE['userID']);
	$in_home = $news->getRssInHome();


	$rss = new lastRSS;
//	$rss->cache_dir = '/home/scielo-org/htdocs/applications/scielo-org/rss_temp/';
//	$rss->cache_time = 1200;
	$rss->items_limit = 5;
	$rss->CDATA = "content";

	$url = $in_home->getRSSURL();


	if($url != ''){

	/**
	*	descobrindo o encoding do RSS . . .
	*/
		$fp = fopen($url,"rb");
		$line = fgets($fp,1024);
		fclose($fp);
		$line = trim($line);
		$line = substr($line,2,	strpos($line,'>')-1);
		$arr = split("\ ",$line);
		$encoding = split("\=",$arr[2]);
		$encoding = str_replace("\"","",$encoding[1]);
		$encoding = strtolower(str_replace("?>","",$encoding));


		$trans = get_html_translation_table(HTML_ENTITIES);
		$trans = array_flip($trans);

		if ($rs = $rss->get($url)) {
			if ($encoding=='utf-8'){
				$titleRSS = utf8_decode($rs[title]);
			}else{
				$titleRSS = $rs[title];
			}
			?>
			<div class="rss">
				<strong>
				<?=$titleRSS?>
				</strong>
			<?

			echo "<ul>\n";
			foreach($rs['items'] as $item) {
				$original = strtr($encoded, $trans);

				$description = strtr($item['description'], $trans);
				$title = $item['title'];

				if($encoding == "utf-8"){
					$description = utf8_decode($description);
					$title = utf8_decode($title);
				}
				echo "\t<li><strong><a href=\"$item[link]\">".$title."</a></strong><br /></li>\n";
			}
			echo "</ul>\n</div>";
		}else{
			echo RSS_PROBLEM." - ".$url;
		}
	}else{
		?>
		<script>
			document.getElementById('news').className = 'hide';
		</script>
		<?
		echo "javascript:";
	}
?>