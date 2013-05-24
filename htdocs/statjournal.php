<?php

	function x($s, $TAG){
		if (strpos($s, '<'.$TAG.'>')>0) {
			$r = substr($s, strpos($s,'<'.$TAG.'>'));
			$r = substr($r, strlen('<'.$TAG.'>'));
			$r = substr($r, 0, strpos($r,'</'.$TAG.'>'));
			$r = str_replace('<![CDATA[','',$r);
			$r = str_replace(']]>','',$r);
		}
		return $r;
	}
	$DEF = parse_ini_file("scielo.def.php", true);

	if ($_GET['lang'] != 'en' && $_GET['lang'] != 'es' && $_GET['lang'] != 'pt') $_GET['lang'] = $DEF['SITE_INFO']['STANDARD_LANG']; 

	if ( strpos($DEF['SCIELO']['STAT_SERVER'],$DEF['SCIELO']['SERVER_SCIELO'])>0) {
		$xml = 'xml='.$DEF['SCIELO']['STAT_SERVER'].'/stat_biblio/xml/';
	} else {
		$xml = 'no=';
	}
	$journalInfo = file_get_contents('http://'.$DEF['SCIELO']['SERVER_SCIELO'].'/scielo.php?script=sci_serial&pid='.$_GET['issn'].'&debug=xml');
	$error = x($journalInfo,'CODE');

	if ($error){
		header("Location: ".'http://'.$DEF['SCIELO']['SERVER_SCIELO'].'/scielo.php?script=sci_serial&pid='.$_GET['issn']);
	} 

	$journalInfo = x($journalInfo,'TITLEGROUP');
	$j['title'] = x($journalInfo,'TITLE');
	$j['acron'] = x($journalInfo,'SIGLUM');

	foreach ($_GET as $g){
		$g = str_replace('/','',$g);
		$g = str_replace(':','',$g);
		$g = str_replace('\\','',$g);
		$g = str_replace('*','',$g);
		$g = str_replace('.','',$g);
	}
	switch ($_GET['lang']){
		case "en":
				$LABELS = array('LANG_1'=> 'i',
							'LANG'=>$_GET['lang'],
							'ACRON'=>$j['acron'],
							'PAGE_TITLE'=>'Journal reports',
							'JOURNAL_TITLE' => $j['title'],
							'JOURNAL_ISSN' => $_GET['issn'],
							'REPORTS_SITE_USAGE_GROUP_LABEL' => 'Site usage reports',
							'REPORT_JOURNALS_REQUESTS' => 'Journals requests',
							'REPORT_JOURNAL_REQUESTS' => 'Journal requests',
							'REPORT_JOURNAL_REQUESTS_LANG' => 'Articles requests by language',
							'REPORT_ISSUES_REQUESTS' => 'Issue requests',
							'REPORT_ARTICLES_REQUESTS' => 'Article requests',
							'COAUTHORS_GROUP' => 'Co-authors report',
							'COAUTHORS_REPORT' => 'Co-authors',
							'JOURNAL_CITATION_REPORTS' => 'Journal citation reports',
							'SOURCE_DATA' => 'Source data',
							'IMPACT_FACTOR_2YEARS' => 'Impact factor on a two-year basis',
							'IMPACT_FACTOR_3YEARS' => 'Impact factor on a three-year basis',
							'HALF_LIFE' => 'Half-life',
							'RECEIVED_CITATIONS' => 'Received citations',
							'GRANTED_CITATIONS' => 'Granted citations',
							'SITE_USAGE_PAGES_SERVER' => $DEF['LOG']['SERVER_LOG_PROC'],
							'SITE_USAGE_PAGES_SERVER_PATH' => $DEF['LOG']['SERVER_LOG_PROC_PATH'],
							'COAUTHORS_SERVER' => $DEF['SCIELO']['STAT_SERVER_COAUTH'],
							'JOURNAL_CITATION_SERVER' => $DEF['SCIELO']['STAT_SERVER_CITATION'],
							'xml'=> $xml,
							'APP_NAME'=>$DEF['SITE_INFO']['APP_NAME']);
			break;
		case "es":
				$LABELS = array('LANG_1'=> 'e',
							'LANG'=>$_GET['lang'],
							'ACRON'=>$j['acron'],
							'PAGE_TITLE'=>'Relatórios da revista',
							'JOURNAL_TITLE' => $j['title'],
							'JOURNAL_ISSN' => $_GET['issn'],
							'REPORTS_SITE_USAGE_GROUP_LABEL' => 'Informes de uso del sitio',
							'REPORT_JOURNALS_REQUESTS' => 'Acceso a las revistas',
							'REPORT_JOURNAL_REQUESTS' => 'Acceso a la revista',
							'REPORT_JOURNAL_REQUESTS_LANG' => 'Acceso a los artículos por idioma',
							'REPORT_ISSUES_REQUESTS' => 'Acceso a los números',
							'REPORT_ARTICLES_REQUESTS' => 'Acceso a los artículos',
							'COAUTHORS_GROUP' => 'Informes de coautoría',
							'COAUTHORS_REPORT' => 'Coautoría',
							'JOURNAL_CITATION_REPORTS' => 'Informes de citas de revistas',
							'SOURCE_DATA' => 'Datos fuente',
							'IMPACT_FACTOR_2YEARS' => 'Factor de impacto en un período de dos años',
							'IMPACT_FACTOR_3YEARS' => 'Factor de impacto en un período de tres años',
							'HALF_LIFE' => 'Vida media',
							'RECEIVED_CITATIONS' => 'Citas recibidas',
							'GRANTED_CITATIONS' => 'Citas concedidas',
							'SITE_USAGE_PAGES_SERVER' => $DEF['LOG']['SERVER_LOG_PROC'],
							'SITE_USAGE_PAGES_SERVER_PATH' => $DEF['LOG']['SERVER_LOG_PROC_PATH'],
							'COAUTHORS_SERVER' => $DEF['SCIELO']['STAT_SERVER_COAUTH'],
							'JOURNAL_CITATION_SERVER' => $DEF['SCIELO']['STAT_SERVER_CITATION'],
							'xml'=> $xml,
							'APP_NAME'=>$DEF['SITE_INFO']['APP_NAME']);
			break;
		case "pt":
				$LABELS = array('LANG_1'=> 'p',
							'LANG'=>$_GET['lang'],
							'ACRON'=>$j['acron'],
							'PAGE_TITLE'=>'Relatórios do periódico',
							'JOURNAL_TITLE' => $j['title'],
							'JOURNAL_ISSN' => $_GET['issn'],
							'REPORTS_SITE_USAGE_GROUP_LABEL' => 'Relatórios de uso do site',
							'REPORT_JOURNALS_REQUESTS' => 'Acessos aos periódicos',
							'REPORT_JOURNAL_REQUESTS' => 'Acessos ao periódico',
							'REPORT_JOURNAL_REQUESTS_LANG' => 'Acessos aos artigos por idioma',
							'REPORT_ISSUES_REQUESTS' => 'Acessos aos fascículos',
							'REPORT_ARTICLES_REQUESTS' => 'Acessos aos artigos',
							'COAUTHORS_GROUP' => 'Relatório de co-autoria',
							'COAUTHORS_REPORT' => 'Coautoria',
							'JOURNAL_CITATION_REPORTS' => 'Relatórios de citações de revistas',
							'SOURCE_DATA' => 'Dados fonte',
							'IMPACT_FACTOR_2YEARS' => 'Fator de impacto em um período de dois anos',
							'IMPACT_FACTOR_3YEARS' => 'Fator de impacto em um período de três anos',
							'HALF_LIFE' => 'Vida média',
							'RECEIVED_CITATIONS' => 'Citações recebidas',
							'GRANTED_CITATIONS' => 'Citações concedidas',
							'SITE_USAGE_PAGES_SERVER' => $DEF['LOG']['SERVER_LOG_PROC'],
							'SITE_USAGE_PAGES_SERVER_PATH' => $DEF['LOG']['SERVER_LOG_PROC_PATH'],
							'COAUTHORS_SERVER' => $DEF['SCIELO']['STAT_SERVER_COAUTH'],
							'JOURNAL_CITATION_SERVER' => $DEF['SCIELO']['STAT_SERVER_CITATION'],
							'xml'=> $xml,
							'APP_NAME'=>$DEF['SITE_INFO']['APP_NAME']);
			break;
    
	}

?><html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title><?php echo $LABELS['JOURNAL_TITLE']; ?> - <?php echo $LABELS['PAGE_TITLE']; ?></title>

		<link rel="stylesheet" type="text/css" href="/css/scielo.css"/>
	</head>
	<body>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="20%">
					<p align="center">
						<a href="http://<?echo $DEF['SCIELO']['SERVER_SCIELO'];?>/scielo.php?script=sci_serial&pid=<?echo $LABELS['JOURNAL_ISSN'];?>&lng=<?echo $LABELS['LANG'];?>">
							<img align="bottom" border="0" src="http://<?echo $DEF['SCIELO']['SERVER_SCIELO'];?>/img/revistas/<?echo $LABELS['ACRON'];?>/plogo.gif"/>
						</a>	
					</p>
				</td>
				<td align="center" width="80%">
					<blockquote>
						<p align="left">
							<font size="+1" color="#000080"><?php echo $LABELS['JOURNAL_TITLE']; ?></font>
							<br/>
							<font class="nomodel" color="#000080">ISSN <?php echo $LABELS['JOURNAL_ISSN']; ?></font>
						</p>
					</blockquote>
				</td>
			</tr>
			<tr>
				<td width="20%"> </td>
				<td width="80%">
				<div 
					<?php
						if ($DEF['LOG']['ENABLE_STATISTICS_LINK']=='0'){
							echo 'style="display: none;"' ;

						}
					?>
					>
					<blockquote>	
						<p>
							<font class="nomodel" color="#0000A0">
								<b><?php echo $LABELS['REPORTS_SITE_USAGE_GROUP_LABEL']; ?></b>
							</font>
						</p>
					</blockquote>
					<blockquote>
						<ul>
							<li>
								<a href="http://<?echo $LABELS['SITE_USAGE_PAGES_SERVER'];?>/<?echo $LABELS['SITE_USAGE_PAGES_SERVER_PATH'];?>/scielolog.php?script=sci_journalstat&lng=<?echo $LABELS['LANG'];?>&pid=<?echo $LABELS['JOURNAL_ISSN'];?>&app=<?echo $LABELS['APP_NAME'];?>&server=<?echo $DEF['SCIELO']['SERVER_SCIELO'];?>">
									<?php
									if (strlen($_GET['issn']) == 9) {
									   echo $LABELS['REPORT_JOURNAL_REQUESTS']; 
									} else {
									   echo $LABELS['REPORT_JOURNALS_REQUESTS']; 
									}
									?>
								</a>
							</li>
							<?php
							if ($DEF['LOG']['ENABLE_ARTICLE_LANG_LINK']=='1') {
								echo("<li>");							
								echo("<a href=\"http://");
								echo($LABELS['SITE_USAGE_PAGES_SERVER']."/");
								echo($LABELS['SITE_USAGE_PAGES_SERVER_PATH']);
								echo("/scielolog.php?script=sci_journalstatlang&lng=".$LABELS['LANG']."&pid=".$LABELS['JOURNAL_ISSN']."&app=".$LABELS['APP_NAME']."&server=".$DEF['SCIELO']['SERVER_SCIELO']."\">");
								echo($LABELS['REPORT_JOURNAL_REQUESTS_LANG']);
								echo("</a>");							
								echo("</li>");
							}
							?>
							<li>
								<a href="http://<?echo $LABELS['SITE_USAGE_PAGES_SERVER'];?>/<?echo $LABELS['SITE_USAGE_PAGES_SERVER_PATH'];?>/scielolog.php?script=sci_statiss&lng=<?echo $LABELS['LANG'];?>&pid=<?echo $LABELS['JOURNAL_ISSN'];?>&app=<?echo $LABELS['APP_NAME'];?>&server=<?echo $DEF['SCIELO']['SERVER_SCIELO'];?>">
									<?php echo $LABELS['REPORT_ISSUES_REQUESTS']; ?>
								</a>
							</li>
							<li>
								<a href="http://<?echo $LABELS['SITE_USAGE_PAGES_SERVER'];?>/<?echo $LABELS['SITE_USAGE_PAGES_SERVER_PATH'];?>/scielolog.php?script=sci_statart&lng=<?echo $LABELS['LANG'];?>&pid=<?echo $LABELS['JOURNAL_ISSN'];?>&app=<?echo $LABELS['APP_NAME'];?>&server=<?echo $DEF['SCIELO']['SERVER_SCIELO'];?>&dti=20040101">
									<?php echo $LABELS['REPORT_ARTICLES_REQUESTS']; ?>
								</a>
							</li>
						</ul>
					</blockquote>
				</div>
				<div
					<?php
						if ($DEF['LOG']['ENABLE_COAUTH_REPORTS_LINK']=='0'){
							echo 'style="display: none;"' ;

						}
					?>

				>
					<blockquote>
						<p>
							<font class="nomodel" color="#0000A0"><b><?php echo $LABELS['COAUTHORS_GROUP']; ?></b></font>
						</p>
					</blockquote>
					<blockquote>
						<ul>
							<li>
								<a href="<?echo $LABELS['COAUTHORS_SERVER'];?>/stat_biblio/index.php?state=16&lng=<?echo $LABELS['LANG'];?>&issn=<?echo $LABELS['JOURNAL_ISSN'];?>"><?php echo $LABELS['COAUTHORS_REPORT']; ?></a>
							</li>
						</ul>
					</blockquote>
                    </div>
				<div
					<?php
						if ($DEF['LOG']['ENABLE_CITATION_REPORTS_LINK']=='0'){
							echo 'style="display: none;"' ;

						}
					?>

				>
					<blockquote>	
						<p><font class="nomodel" color="#0000A0"><b><?php echo $LABELS['JOURNAL_CITATION_REPORTS']; ?></b></font></p>
					</blockquote>

					<blockquote>
						<ul>
							<li>
								<a href="<?echo $LABELS['JOURNAL_CITATION_SERVER'];?>/stat_biblio/index.php?<?echo $LABELS['xml'];?>03.xml&state=03&lang=<?echo $LABELS['LANG'];?>&issn=<?echo $LABELS['JOURNAL_ISSN'];?>"><?php echo $LABELS['SOURCE_DATA']; ?></a></li>
							<li>
								<a href="<?echo $LABELS['JOURNAL_CITATION_SERVER'];?>/stat_biblio/index.php?<?echo $LABELS['xml'];?>04.xml&state=04&lang=<?echo $LABELS['LANG'];?>&issn=<?echo $LABELS['JOURNAL_ISSN'];?>"><?php echo $LABELS['IMPACT_FACTOR_2YEARS']; ?></a></li>
							<li>
								<a href="<?echo $LABELS['JOURNAL_CITATION_SERVER'];?>/stat_biblio/index.php?<?echo $LABELS['xml'];?>18.xml&state=18&lang=<?echo $LABELS['LANG'];?>&issn=<?echo $LABELS['JOURNAL_ISSN'];?>"><?php echo $LABELS['IMPACT_FACTOR_3YEARS']; ?></a></li>
							<li>
								<a href="<?echo $LABELS['JOURNAL_CITATION_SERVER'];?>/stat_biblio/index.php?<?echo $LABELS['xml'];?>07.xml&state=07&lang=<?echo $LABELS['LANG'];?>&issn=<?echo $LABELS['JOURNAL_ISSN'];?>"><?php echo $LABELS['HALF_LIFE']; ?></a></li>
							<li>
								<a href="<?echo $LABELS['JOURNAL_CITATION_SERVER'];?>/stat_biblio/index.php?<?echo $LABELS['xml'];?>09.xml&state=09&lang=<?echo $LABELS['LANG'];?>&issn=<?echo $LABELS['JOURNAL_ISSN'];?>"><?php echo $LABELS['RECEIVED_CITATIONS']; ?></a></li>
							<li>
								<a href="<?echo $LABELS['JOURNAL_CITATION_SERVER'];?>/stat_biblio/index.php?<?echo $LABELS['xml'];?>11.xml&state=11&lang=<?echo $LABELS['LANG'];?>&issn=<?echo $LABELS['JOURNAL_ISSN'];?>"><?php echo $LABELS['GRANTED_CITATIONS']; ?></a></li>
						</ul>
					</blockquote>
				</div>
				</td>
			</tr>
		</table>
		<p> </p>
		<hr>
		<p align="center"><font color="#0000A0" size="2"><i><?echo $DEF['SITE_INFO']['SITE_NAME'];?></i></font>
		<br>
		<a href="mailto:<?echo $DEF['SITE_INFO']['E_MAIL'];?>">
		<img align="bottom" border="0" src="http://<?echo $DEF['SCIELO']['SERVER_SCIELO'];?>/img/<?echo $LABELS['LANG'];?>/e-mailt.gif"><br>
		<font size="2" color="#0000A0"><?echo $DEF['SITE_INFO']['E_MAIL'];?></font></a></p>
	</body>
</html>


