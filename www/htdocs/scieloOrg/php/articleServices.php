<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL ^E_NOTICE);
	$tlang = isset($_REQUEST['tlang'])?($_REQUEST['tlang']):"";
	$lang = isset($_REQUEST['lang'])?($_REQUEST['lang']):"";
	$pid = isset($_REQUEST['pid'])?($_REQUEST['pid']):"";
	$text = isset($_REQUEST['text'])?($_REQUEST['text']):"";

	require_once(dirname(__FILE__)."/../../applications/scielo-org/users/langs.php");
	//require_once(dirname(__FILE__)."/../../classDefFile.php");

	//$transformer = new XSLTransformer();
	$defFile = parse_ini_file(dirname(__FILE__)."/../../scielo.def.php");

?>

<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
				<link rel="stylesheet" href="/applications/scielo-org/css/public/style-<?=$lang?>.css" type="text/css" media="screen"/>
				<?php
				/* Adicionado script para passa a utilizar o serviço de log comentado por Jamil Atta Junior (jamil.atta@bireme.org) */
				if ($service == 'related') { 
					echo '<script language="javascript" src="/../../applications/scielo-org/js/httpAjaxHandler.js"></script>';
				}
				?>
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
										<?php 
											switch($service){
												case 'related': echo SIMILARYS_IN; break;
												case 'cited': echo CITED_BY; break;
											}
										?>
										<?=" SciELO"?>
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
										<?php
											
											include_once("common.php");
										?>
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