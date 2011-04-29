<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL);
	$lang = isset($_REQUEST['lang'])?($_REQUEST['lang']):"";
	$pid = isset($_REQUEST['pid'])?($_REQUEST['pid']):"";
	$text = isset($_REQUEST['text'])?($_REQUEST['text']):"";

	require_once(dirname(__FILE__)."/../../applications/scielo-org/users/langs.php");	
	$defFile = parse_ini_file(dirname(__FILE__)."/../../scielo.def.php");

?>

<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<link rel="stylesheet" href="/applications/scielo-org/css/public/style-<?=$lang?>.css" type="text/css" media="screen"/>
				<style>
					.articleList TH {
						text-align: left;
						border-bottom: 2px solid #AAA;
						padding: 2px 0px;
					}
					.articleList TD {
						padding-bottom: 6px;
							
					}
					.articleList TD TD {
						border-bottom: 1px solid #AAA;
					}
					.articleList TD TD TD {
						border-bottom: 1px solid #DEDEDE;
					}
					.region {
						padding-top: 12px;
					}
					.state {
						margin-top: 12px;
					}
				</style>
			</head>
			<body>
				<div class="container">
					<div class="level2">
						<div class="bar">
						</div>
						<div class="top">
							<div id="parent">
								<img src="/img/<?=$lang?>/scielobre.gif" alt="SciELO - Scientific Electronic Library Online"/>
							</div>
							<div id="identification">
								<h1>
									<span>
										SciELO - Scientific Electronic Library Online
									</span>
								</h1>
							</div>
						</div>
						<div class="middle">
							<div id="collection">
								<h3>
									<span>
										<?=DATASUS?>
									</span>
								</h3>
								<div class="content">
									<TABLE border="0" cellpadding="0" cellspacing="2" width="760" align="center">
									<TR>
										<TD colspan="2">
											<h3><span style="font-weight:100;font-size: 70%; background:none;">
											<?php
												include(dirname(__FILE__)."/displayReference.php");
											?>
											<br/><br/>
											</span></h3>
										</TD>
									</TR>									
									<TR>
										<TD colspan="2">
											<div class="articleList">
											<?php
												$serviceUrl = "http://trigramas.bireme.br/cgi-bin/mxlind/cgi=@areasgeo?pid=".$pid;
												$xmlFile = file_get_contents($serviceUrl);
												$xml = '<?xml version="1.0" encoding="ISO-8859-1"?>';
												$xml .='<root>';
												$xml .='<vars>
															<lang>'.$lang.'</lang>
															<applserver>'. $applServer .'</applserver>
														</vars>';
												$xml .= str_replace('<?xml version="1.0" encoding="ISO-8859-1" ?>','',$xmlFile);
												$xml .='</root>';
												if($_REQUEST['debug'] == 'xml'){
													die($xml);
												}
												$transformer = new XSLTransformer();								
												$transformer->setXslBaseUri($defFile["PATH_XSL"]);
												$transformer->setXml($xml);
												$transformer->setXslFile($defFile["PATH_XSL"]."datasus.xsl");
												$transformer->transform();
												$output = $transformer->getOutput();
												$output = str_replace('&amp;','&',$output);
												$output = str_replace('&lt;','<',$output);
												$output = str_replace('&gt;','>',$output);
												$output = str_replace('&quot;','"',$output);
												$output = str_replace('<p>',' ',$output);
												$output = str_replace('</p>',' ',$output);

												echo $output;
												
												?>
											</div>
										</TD>
									</TR>
								</TABLE>
								
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
