<?php
ini_set("display_errors","1");
error_reporting(E_ALL ^E_NOTICE);
$lang = isset($_REQUEST['lang'])?($_REQUEST['lang']):"";
$pid = isset($_REQUEST['pid'])?($_REQUEST['pid']):"";
$text = isset($_REQUEST['text'])?($_REQUEST['text']):"";

require_once(dirname(__FILE__)."/../../applications/scielo-org/users/functions.php");
require_once(dirname(__FILE__)."/../../applications/scielo-org/users/langs.php");	
require_once(dirname(__FILE__)."/../../classDefFile.php");
require_once(dirname(__FILE__)."/../../applications/scielo-org/classes/services/ArticleServices.php");
//require_once(dirname(__FILE__)."/../../class.XSLTransformer.php");

//$transformer = new XSLTransformer();
$defFile = parse_ini_file(dirname(__FILE__)."/../../scielo.def");

$applServer = $defFile["SERVER_SCIELO"];
$databasePath = $defFile["PATH_DATABASE"];

//geting metadatas from PID
$articleService = new ArticleService($applServer);
$articleService->setParams($pid);
$article = $articleService->getArticle();
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
				<link rel="stylesheet" href="/applications/scielo-org/css/public/style-<?=$lang?>.css" type="text/css" media="screen"/>
			</head>
			<body>
				<div class="container">
					<div class="level2">
						<div class="bar">
						</div>
						<div class="top">
							<div id="parent">
								<img src="/applications/scielo-org/img/<?=$lang?>/scielobre.gif')}" alt="SciELO - Scientific Electronic Librery Online"/>
							</div>
							<div id="identification">
								<h1>
									<span>
										SciELO.org - Scientific Electronic Library Online
									</span>
								</h1>
							</div>
						</div>
						<div class="middle">
							<div id="collection">
								<div class="content">
									<h3>
										<span>
											<?=ARTICLE_REFERENCES?>
										</span>
									</h3>
									<TABLE border="0" cellpadding="0" cellspacing="2" width="550" align="center">
									<TR>
										<TD colspan="2">
											<?=ARTICLE_TITLE?> . <?=getTitle($article->getTitle());?>
										</TD> 
									</TR>
									<TR>
										<TD height="15">
										</TD>
									</TR>
									<TR>
										<TD colspan="2"><?php
											$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=search.xis&database=".$databasePath ."artigo/artigo&search=r=" . $pid . "$"; 
											$xml = file_get_contents($serviceUrl);
											$xsl = dirname(__FILE__)."/../xsl/reference.xsl";
											$transformer = new XSLTransformer();
											$transformer->setXslBaseUri(dirname(__FILE__));
											$transformer->setXML($xml);
											$transformer->setXSL($xsl);
											$transformer->transform();
											$output = $transformer->getOutput();
											echo ($output);
											?>
										</TD>
									</TR>
								</TABLE>
						</div>
					<div style="clear: both;float: none;width: 100%;">
					</div>
				</div>
			</div>
		</div>
			<? 
				if($defFile['LOG']['ACTIVATE_LOG'] == '1') {
			?>
				<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
				<script type="text/javascript">
						_uacct = "UA-604844-1";
						urchinTracker();
				</script>
			<?}?>
	</BODY>
</HTML>