<?php
ini_set("display_errors","1");
error_reporting(E_ALL ^ E_NOTICE);

ini_set("include_path",".");

require_once(dirname(__FILE__)."/../classes/Links.php");
require_once(dirname(__FILE__)."/../../../php/include.php");
require_once(dirname(__FILE__)."/langs.php");
require_once(dirname(__FILE__)."/functions.php");

$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

$baseDir = "";

if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
	$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
}else{
	$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
}

$site = parse_ini_file($baseDir."ini/" . $lang . "/bvs.ini", true);

$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def", true);
$home = $ini['this']['url'];

//ob_start("ob_gzhandler");
//session_start();

if(isset($_COOKIE['userID']))
{
	$link = new links();
	$link->setUser_id($_COOKIE['userID']);
	$linkList = $link->getInHomeLinks();
	if (count($linkList) > 0){
	?><ul><?
		for($i = 0; $i < count($linkList); $i++)
		{
			$link_id = $linkList[$i]->getLink_id();
			$name = $linkList[$i]->getName();
			$description = $linkList[$i]->getDescription();
			$rate = $linkList[$i]->getRate();
			$url = $linkList[$i]->getUrl();
?>
		<li>
			<a href="<?=$url?>" target="_blank"><?=$name?></a>
		</li>
		<?}?>
		</ul>
	<?}else{?>
		<script>
			document.getElementById('links').className = 'hide';
		</script>
	<?  echo "javascript:";
	}
}else{?>
		<script>
			document.getElementById('links').className = 'hide';
		</script>
	<?  echo "javascript:";
}?>