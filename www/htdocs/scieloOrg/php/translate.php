<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL ^E_NOTICE);
	$tlang = isset($_REQUEST['tlang'])?($_REQUEST['tlang']):"";
	$lang = isset($_REQUEST['lang'])?($_REQUEST['lang']):"";
	$pid = isset($_REQUEST['pid'])?($_REQUEST['pid']):"";
	$text = isset($_REQUEST['text'])?($_REQUEST['text']):"";

	require_once(dirname(__FILE__)."/../../applications/scielo-org/users/langs.php");
	require_once(dirname(__FILE__)."/../../classDefFile.php");
	//require_once(dirname(__FILE__)."/../../class.XSLTransformer.php");

	//$transformer = new XSLTransformer();
	$defFile = parse_ini_file(dirname(__FILE__)."/../../scielo.def.php");

	$applServer = $defFile["SERVER_SCIELO"];
	$databasePath = $defFile["PATH_DATABASE"];
	$htdocsPath = $defFile["PATH_HTDOCS"];
	//Adicionado para flag de log comentado por Jamil Atta Junior (jamil.atta@bireme.org)
	$flagLog = $defFile['ENABLE_SERVICES_LOG'];
	//geting metadatas from PID
	$tlang = $_REQUEST['tlang'];

    include('translateView.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
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
												include(dirname(__FILE__)."/displayReference.php");
											?>
											<br/><br/>
                                        </span></h3>
                                </TD>
                            </TR>
                            <TR>
                                <TD colspan="2">
                                    <h3><span style="font-weight:normal; font-size:70%; background:none;">
                                      </span></h3>
<?php
    //$source = urlencode(str_replace('&','|','http://'.$_SERVER['HTTP_HOST'].'/scielo.php!script='.$_REQUEST['script'].'&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang']));
    $script = $_REQUEST['script'];
    if (!$script) $script = 'sci_arttext';
    $source = urlencode('http://'.$_SERVER['HTTP_HOST'].'/scielo.php?script='.$_REQUEST['script'].'&pid='.$_REQUEST['pid'].'&lng='.$_REQUEST['lang'].'&nrm=iso&tlng='.$_REQUEST['tlang']);
    $print = str_replace('TEXTSOURCE', $source, $html[$lang]);
    $print = str_replace('TEXTLANG', $tlang, $print);
    $print = str_replace('SCRIPT', $script, $print);
    $print = str_replace('LANG', $_REQUEST['lang'], $print);
    $print = str_replace('PID', $_REQUEST['pid'], $print);
    echo $print;
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
        <script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
        </script>
        <script type="text/javascript">
            _uacct = "<?php echo $deffile['LOG']['GOOGLE_CODE']; ?>";
            urchinTracker();
        </script>
        <?}?>
    </BODY>
</HTML>
