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
	$defFile = parse_ini_file(dirname(__FILE__)."/../../scielo.def.php");

	$applServer = $defFile["SERVER_SCIELO"];
	$databasePath = $defFile["PATH_DATABASE"];
	$htdocsPath = $defFile["PATH_HTDOCS"];
	//Adicionado para flag de log comentado por Jamil Atta Junior (jamil.atta@bireme.org)
	$flagLog = $defFile['ENABLE_SERVICES_LOG'];
	//geting metadatas from PID
	$articleService = new ArticleService($applServer);
	$articleService->setParams($pid);
	$article = $articleService->getArticle();
	$tlang = $_REQUEST['tlang'];
?>
 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
        <link rel="stylesheet" href="/applications/scielo-org/css/public/style-<?=$lang?>.css" type="text/css" media="screen"/>
        <!-- Adicionado script para passa a utilizar o serviço de log comentado por Jamil Atta Junior (jamil.atta@bireme.org)-->
        <script language="javascript" src="/../../applications/scielo-org/js/httpAjaxHandler.js">
        </script>
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
                    <h1><span>SciELO - Scientific Electronic Library Online</span></h1>
                </div>
            </div>
            <div class="middle">
                <div id="collection">
                    <h3><span>
                            <?=ARTICLE_TRANSLATION?><br/><span style="font-size:70%; font-weight:normal"><?=ARTICLE_TRANSLATION_WARNING?></span>						
                        </span></h3>
						
						
                    <div class="content">					
                        <TABLE border="0" cellpadding="0" cellspacing="2" width="760" align="center">
                            <TR>
                                <TD colspan="2">
									
                                    <h3><span style="font-weight:100;font-size: 70%; background:none;">											
                                            <?php									
											//print('<p style="font-size:90%">'.ARTICLE_TRANSLATION_WARNING.'</p>');
											
											$author = getAutors($article->getAuthorXML());
											$pos = strrpos($author, ";");
											$author[$pos] = " ";

											echo $author;
											echo '<i><b>';
											echo (getTitle($article->getTitle(), $lang).". ");
											echo ('</b></i>');
											echo ($article->getSerial(). ', '.$article->getYear().', vol.'.$article->getVolume());
											echo (', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'.<br/><br/>'."\n");
											?>
                                        </span></h3>
                                </TD>
                            </TR>
                            <TR>
                                <TD colspan="2">
                                    <h3><span style="font-weight:normal; font-size:70%; background:none;">
                                            <?php										
											switch($tlang){
												case 'pt':
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=pt_en&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.PORTUGUESE_ENGLISH.'</a>');													
													break;
												case 'en':
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_ar&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_ARABIC.'</a><br/>');
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_zh-chs&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_CHINESE_S.'</a><br/>');
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_zh-cht&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_CHINESE_T.'</a><br/>');													
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_nl&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_DUTCH.'</a><br/>');
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_fr&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_FRENCH.'</a><br/>');													
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_de&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_GERMAN.'</a><br/>');
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_it&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_ITALIAN.'</a><br/>');
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_ja&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_JAPANESE.'</a><br/>');
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_ko&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_KOREAN.'</a><br/>');
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_pt&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_PORTUGUESE.'</a><br/>');													
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=en_es&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.ENGLISH_SPANISH.'</a><br/>');													
													break;
												case 'es':
													print('<a href="'.$defFile['windows_live_translator'].'/BV.aspx?ref=AddIn&lp=es_en&a=http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script=sci_arttext&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang'].'" target="_blank"  style="color:black;">'.SPANISH_ENGLISH.'</a><br/>');
													break;		
											}
										?>
                                      </span></h3>
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
        <script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
        </script>
        <script type="text/javascript">
            _uacct = "UA-604844-1";
            urchinTracker();
        </script>
        <?}?>
    </BODY>
</HTML>
