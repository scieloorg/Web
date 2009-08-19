<?php

function monta_xml_statparam($first_date,$last_date,$order,$dti,$dtf,$pid) {
	$xml.="<STATPARAM>\n";
 	$xml.="<START_DATE>$first_date</START_DATE>\n";
 	$xml.="<CURRENT_DATE>$last_date</CURRENT_DATE>\n";
 	$xml.="<FILTER>\n";
 	$xml.="<ORDER>$order</ORDER>\n";
 	$xml.="<INITIAL_DATE>$dti</INITIAL_DATE>\n";
 	$xml.="<FINAL_DATE>$dtf</FINAL_DATE>\n";
 	$xml.="</FILTER>\n";
 	$xml.="</STATPARAM>\n";
	$xml.="\n<ISSN TYPE=\"PRINT\">$pid</ISSN>\n";
	return $xml;
}

function monta_pft_journalstat($pid,$script,$db_tmp_home,$db_tmp_sumario,$db_tmp_artigo,$db_tmp_outros) {
	if ($pid=='') {
		$pft_show="\"pft='<JOURNAL STARTDATE=<aspas>',v942,'<aspas>>'";
		$pft_show.="'<TITLE><![CDATA[',v150,']]></TITLE><line>'";
	  	$pft_show.="'<HOMEPAGE>',ref(['$db_tmp_home']l(['$db_tmp_home'],s(v1,'@home')),v999)'</HOMEPAGE><line>'";
		$pft_show.="'<ISSUETOC>',ref(['$db_tmp_sumario']l(['$db_tmp_sumario'],s(v1,'@sumario')),v999)'</ISSUETOC><line>'";
		$pft_show.="'<ARTICLES>',ref(['$db_tmp_artigo']l(['$db_tmp_artigo'],s(v1,'@artigos')),v999),'</ARTICLES><line>'";
		$pft_show.="'<OTHERS>',ref(['$db_tmp_outros']l(['$db_tmp_outros'],s(v1,'@outros')),v999),'</OTHERS><line>'";
		$pft_show.="'</JOURNAL><line>'\"";
	} else {
		$pft_show="\"pft='<JOURNAL STARTDATE=<aspas>',v942,'<aspas>>'";
		$pft_show.="'<TITLEGROUP><line>'";
		$pft_show.="'<TITLE><![CDATA[',v100,']]></TITLE><line>'";
    	$pft_show.="'<SHORTTITLE><![CDATA[ ',v150,' ]]></SHORTTITLE><line>'";
		$pft_show.="'<SIGLUM>',v68,'</SIGLUM><line>'";
		$pft_show.="'</TITLEGROUP><line>'";
		$pft_show.="'<ISSN TYPE=<aspas>PRINT<aspas>>'v1'</ISSN><line>'";
		$pft_show.="'<HOMEPAGE>',ref(['$db_tmp_home']l(['$db_tmp_home'],s(v1,'@home')),v999)'</HOMEPAGE><line>'";
		$pft_show.="'<ISSUETOC>',ref(['$db_tmp_sumario']l(['$db_tmp_sumario'],s(v1,'@sumario')),v999)'</ISSUETOC><line>'";
		$pft_show.="'<ARTICLES>',ref(['$db_tmp_artigo']l(['$db_tmp_artigo'],s(v1,'@artigos')),v999),'</ARTICLES><line>'";
		$pft_show.="'<OTHERS>',ref(['$db_tmp_outros']l(['$db_tmp_outros'],s(v1,'@outros')),v999),'</OTHERS><line>'";
		$pft_show.="'</JOURNAL><line>'\"";
	}
	
	return $pft_show;
}

function monta_pft_statiss($pid,$lng,$db_issn) {

	if ($pid=='') {
  	    $pft_show="\"pft='<ISSUE REQUESTS=<aspas>'v999'<aspas> '";
		$pft_show.="'SEQ=<aspas>',replace(v1,',',''),'<aspas> '";	
		$pft_show.="'VOL=<aspas>',(if v43^l='$lng' then v43^v fi),'<aspas> '";
		$pft_show.="' NUM=<aspas>',(if v43^l='$lng' then v43^n,' ',v43^s fi),'<aspas> '";
		$pft_show.="' MONTH=<aspas>',(if v43^l='$lng' then v43^m fi),'<aspas> '";
		$pft_show.="'YEAR=<aspas>',(if v43^l='$lng' then v43^a fi),'<aspas>><line>'";
        $pft_show.="'<SHORTTITLE>'";
		$pft_show.="'<![CDATA[',ref(['$db_issn']l(['$db_issn'],left(v1,instr(v1,',')-1)),v150),']]>'";
		$pft_show.="'</SHORTTITLE><line>'";
	    $pft_show.="'</ISSUE><line>'\"";
	} else {
  		$pft_show="\"pft='<TITLEGROUP><line>'";
		$pft_show.="'<TITLE><![CDATA[',ref(['$db_issn']l(['$db_issn'],left(v1,instr(v1,',')-1)),v100),']]></TITLE><line>'";
    	$pft_show.="'<SHORTTITLE><![CDATA[ ',ref(['$db_issn']l(['$db_issn'],left(v1,instr(v1,',')-1)),v150),' ]]></SHORTTITLE><line>'";
		$pft_show.="'<SIGLUM>',ref(['$db_issn']l(['$db_issn'],left(v1,instr(v1,',')-1)),v68),'</SIGLUM><line>'";
		$pft_show.="'</TITLEGROUP><line>'";
		$pft_show.="'<ISSN TYPE=<aspas>PRINT<aspas>>$pid</ISSN><line>'";		
		$pft_show.="'<ISSUE REQUESTS=<aspas>'v999'<aspas> '";
		$pft_show.="'SEQ=<aspas>',replace(v1,',',''),'<aspas> '";	
		$pft_show.="'VOL=<aspas>',(if v43^l='$lng' then v43^v fi),'<aspas> '";
		$pft_show.="' NUM=<aspas>',(if v43^l='$lng' then v43^n,' ',v43^s fi),'<aspas> '";
		$pft_show.="' MONTH=<aspas>',(if v43^l='$lng' then v43^m fi),'<aspas> '";
		$pft_show.="'YEAR=<aspas>',(if v43^l='$lng' then v43^a fi),'<aspas>><line>'";
	    $pft_show.="'</ISSUE><line>'\"";
	}
	return $pft_show;
}

function monta_pft_statart($pid,$lng,$db_issn) {

	$pft_show.="\"pft='<ARTICLE TEXT_LANG=<aspas>',v40,'<aspas> FPAGE=<aspas>',v14^f,'<aspas> LPAGE=<aspas>',v14^l,'<aspas> PID=<aspas>',v880,'<aspas> REQUESTS=<aspas>',v999,'<aspas>><line> '";
	$pft_show.="'<LANGUAGES MAXLINES=<aspas><aspas>><line>'";
  	$pft_show.=",if p(v83) then '<ABSTRACT_LANGS><line>'";
	$pft_show.=",('<LANG>',v83^l,'</LANG><line>'),";
    $pft_show.="'</ABSTRACT_LANGS><line>',fi";
    $pft_show.="'<ART_TEXT_LANGS><line>'";
    $pft_show.="'<LANG>',v40,'</LANG><line>'";
    $pft_show.="'</ART_TEXT_LANGS><line>'";
 	$pft_show.="'</LANGUAGES><line>'";
    $pft_show.="'<ISSUEINFO VOL=<aspas>',v31,'<aspas> NUM=<aspas>',v32,'<aspas> YEAR=<aspas>',v65*0.4,'<aspas> MONTH=<aspas>',v65*4.2,'<aspas>><line>'";
	$pft_show.="'<STRIP><line>'";
	$pft_show.="'<SHORTTITLE><![CDATA[',v30,']]></SHORTTITLE><line>'";
	$pft_show.="'<VOL>',v43[1]^v,'</VOL><line><NUM>',v43[1]^n,'</NUM><line><CITY>',v43[1]^c,'</CITY><line><YEAR>',v43[1]^a,'</YEAR><line>'";
	$pft_show.="'</STRIP><line>'";
	$pft_show.="'<ISSN>',v936^i,'</ISSN><line>'";
	$pft_show.="'</ISSUEINFO><line>'";
	$pft_show.="'<TITLE><![CDATA[<B>'";
	$pft_show.="if v12^l:'".$lng."' then (if v12^l='".$lng."' then v12^* fi) else v12^*[1] fi";
	$pft_show.="'</B>]]></TITLE><line>'";
	$pft_show.="'<AUTHORS><line>'";
  	$pft_show.="'<AUTH_PERS><line>'";
	$pft_show.="(,'<AUTHOR SEARCH=<aspas>',v10^s,','v10^n,'<aspas>><line>'";
    $pft_show.="'<NAME><![CDATA[',v10^n,']]></NAME><line>'";
    $pft_show.="'<SURNAME><![CDATA[',v10^s,']]></SURNAME><line>'";
    $pft_show.="'<UPP_NAME><![CDATA[',s(mhu,v10^n,mpl),']]></UPP_NAME><line>'";
    $pft_show.="'<UPP_SURNAME><![CDATA[',s(mhu,v10^s,mpl),']]></UPP_SURNAME><line>'";
    $pft_show.="'</AUTHOR><line>',)";
	$pft_show.="'</AUTH_PERS><line>'";
 	$pft_show.="'</AUTHORS><line>'";
 	$pft_show.="'</ARTICLE><line>'\"";
	return $pft_show;
}

?>
