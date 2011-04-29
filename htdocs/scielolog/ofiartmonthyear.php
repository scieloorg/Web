<?php 
//	error_reporting(E_ALL);	
	require_once("include_grafico.php");
	require_once("include.php");
        require_once("../class.XSLTransformer.php");

	$lng = $_REQUEST["lng"];
	$pid = $_REQUEST["pid"];
        
// Create new Scielo object
        $host = $_SERVER['HTTP_HOST'];
	
        if ($pid!='') {	
		for ($j=0;$j < count($pid);++$j) {
			$pid2.=$pid[$j];
		}
	}
	
	$ui=date('y').date('z');
	$db_acesso=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/acesso";
	$db_tmp_tab=$defFile["PATH"]["PATH_DATABASE"]."/tmp/".$ui.$pid2.".tab_anomes";
	$db_tmp_tab02=$defFile["PATH"]["PATH_DATABASE"]."/tmp/".$ui.$pid2.".tab_anomes02";
	$db_title=$defFile["PATH"]["PATH_DATABASE"]."/title/title";
	$utl=$defFile["PATH"]["PATH_PROC"]."/cisis";
	
// ***********************************************************
// ********* Tabula revistas por ano  e mes      *************
// ***********************************************************
	
	$db_tmp_ano=$defFile["PATH"]["PATH_DATABASE"]."/tmp/".$ui.".tab_ano".$array_ano[$i];

	$str="artigos";
	$bool=monta_bool_array($pid,$str);
	$proc="\"proc='<200 0>'ref(['$db_title']l(['$db_title'],s(v1*0.9)),v150)'</200>'\"";
	$proc02="\"proc='d32001',if v150='' then 'd*' fi\"";
	if (!file_exists($db_tmp_tab.".mst")) {
		exec("$utl/mxtb $db_acesso create=$db_tmp_tab $bool \"256:v1,'|',v3*0.4,'|',v3*4.2/,\" \"tab=v5\" \"class=120000\"");
		exec("$utl/mx $db_tmp_tab \"join=$db_title,150=s(v1*0.9)\" $proc02 append=$db_tmp_tab02 -all now");
		exec("$utl/msrt $db_tmp_tab02 \"256\" \"v150,v1/\"");
	}
	$result=exec("$utl/mx $db_tmp_tab02 lw=999 \"pft=v150'<ano>'v1*10'<per>'v999'<fim>'\" now");
	$array_linha=split("<fim>",$result);
	$chv_tit=$chv_ano="";
	
	// Formatacao da saida 
	$output="<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n";
	$output=$output."<QUERY_RESULT>\n";
	$output=$output."<CONTROLINFO>\n";
	$output=$output."<LANGUAGE>".$lng."</LANGUAGE>\n";
    $output=$output."<STANDARD>iso</STANDARD>\n";
    $output=$output."<PAGE_NAME>sciofi_artmonthyearstat</PAGE_NAME>\n";
    $output=$output."<APP_NAME>scielo</APP_NAME>\n";
    $output=$output."<ENABLE_STAT_LINK>1</ENABLE_STAT_LINK>\n";
    $output=$output."<ENABLE_CIT_REP_LINK>1</ENABLE_CIT_REP_LINK>\n";
    $output=$output."<SCIELO_INFO>\n";
    $output=$output."<SERVER>".$defFile["SCIELO"]["SERVER_SCIELO"]."</SERVER>\n";
    $output=$output."<PATH_WXIS>/cgi-bin/wxis.exe</PATH_WXIS>\n";
    $output=$output."<PATH_CGI-BIN>/cgi-bin/</PATH_CGI-BIN>\n";
    $output=$output."<PATH_DATA>/</PATH_DATA>\n";
    $output=$output."<PATH_SCRIPTS>ScieloXML/</PATH_SCRIPTS>\n";
    $output=$output."<PATH_SERIAL_HTML>/revistas/</PATH_SERIAL_HTML>\n";
    $output=$output."<PATH_XSL>".$defFile["PATH"]["PATH_XSL"]."</PATH_XSL>\n";
    $output=$output."<PATH_GENIMG>/img/</PATH_GENIMG>\n";
    $output=$output."<PATH_SERIMG>/img/revistas/</PATH_SERIMG>\n";
    $output=$output."<PATH_DATA_IAH>/iah/test/</PATH_DATA_IAH>\n";
    $output=$output."<PATH_CGI_IAH>iah/</PATH_CGI_IAH>\n";
    $output=$output."</SCIELO_INFO>\n";
    $output=$output."</CONTROLINFO>\n";
	
	
	for ($j=0;$j < count($array_linha)-1;++$j) {
	  if  ($array_linha[$j]!='') {
		$tit=str_replace('&','',substr($array_linha[$j], 0, strpos($array_linha[$j],'<ano>')));
		$tot=substr($array_linha[$j], strpos($array_linha[$j],'<per>')+5, 9);
		$per=substr($array_linha[$j], strpos($array_linha[$j],'<ano>')+5, 7);
		$ws=explode("|",$per);
		$ano=$ws[0];
		$mes=$ws[1];
		if ($tit!==$tit_ant) {
			if ($chv_tit=="9") {
				$output=$output."</YEAR>\n";
				$output=$output."</TITLE>\n";
				$output=$output."<TITLE NAME=\"$tit\">\n";
				$output=$output."<YEAR NUMBER=\"$ano\">\n";
				$ano_ant=$ano;
				$tit_ant=$tit;
			} else {
				$tit_ant=$tit;
				$output=$output."<TITLE NAME=\"$tit\">\n";
				$chv_tit="9";
				}
		}
		if ($ano!==$ano_ant) {
			if ($chv_ano=="9") 	$output=$output."</YEAR>\n";
			$ano_ant=$ano;
			$output=$output."<YEAR NUMBER=\"$ano\">\n";
			$chv_ano="9";
		}
		}
		$output=$output."<MONTH NUMBER=\"$mes\">$tot</MONTH>\n";
	  
	}
	$output=$output."</YEAR>\n";
	$output=$output."</TITLE>\n";
	$output=$output."</QUERY_RESULT>\n";	



// ********************************************************************
// *********** Deleta arquivos temporarios  ***************************
// ********************************************************************
	if (!$pid=='') {
		$OP="rm -f $db_tmp_tab.* $db_tmp_tab02.* ";
		$result=exec($OP);
	}

	if ($_REQUEST["debug"]=="xml") {
	   	echo $output;
		exit();	
	}
	
// ********************************************************************
// **********  Aplica XSl no arquivo gerado pelo programa *************
// ********************************************************************


	$xsl = $defFile["PATH"]["PATH_XSL"]."/sciofi_artmonthyearstat.xsl";

        if ($_REQUEST["debug"]=="xsl") {
                echo file_get_contents($xsl);
        }

        $transformer = new XSLTransformer();
        $transformer->setXslBaseUri($defFile["PATH"]["PATH_XSL"]);
	$transformer->setXml($output);
        $transformer->setXslFile($xsl);
        $transformer->transform();
        $output = $transformer->getOutput();
        $output = str_replace('&amp;','&',$output);
        $output = str_replace('&lt;','<',$output);
        $output = str_replace('&gt;','>',$output);
        $output = str_replace('&quot;','"',$output);
        $output = str_replace('<p>',' ',$output);
	$output = str_replace('</p>',' ',$output);
        echo $output;

	exec('rm -f $db_tmp_tab.*');
	exec('rm -f $db_tmp_tab02.*');
	
?> 
<hr>

<p align="center">
&#169;
<font class="nomodel" size="-1">
<?php
echo(date('Y'));
?>
</font>
<i><font class="nomodel" color="#0000A0" size="-1"><?=$defFile["SITE_INFO"]["SHORT_NAME"]?><br></i>
<img src="/img/en/e-mailt.gif" alt="<?=$defFile["SITE_INFO"]["E_MAIL"]?>" border="0"><br>
<a class="email" href="mailto:<?=$defFile["SITE_INFO"]["E_MAIL"]?>"><?=$defFile["SITE_INFO"]["SITE_INFO"]?></a>
</center>
</p>

