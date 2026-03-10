	<?php

require_once(dirname(__FILE__)."/../../users/functions.php");
require_once(dirname(__FILE__)."/../../includes/phpmailer/class.phpmailer.php");
require_once(dirname(__FILE__)."/../../classes/services/ArticleServices.php");
require_once(dirname(__FILE__)."/../../../../php/include.php");

$cgi = array_merge($_GET,$_POST);
$lang = isset($cgi["lang"]) ? $cgi["lang"] : "pt";
require_once(dirname(__FILE__)."/../../users/langs.php");	

$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../../bvs-site-conf.php",true);

$baseDir = "";

if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
	$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
}else{
	$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
}

$scielodef = parse_ini_file(dirname(__FILE__)."/../../scielo.def.php", true);
$mainscielodef = parse_ini_file(dirname(__FILE__)."/../../../../scielo.def.php", true);
$site = parse_ini_file(dirname(__FILE__)."/../../../ini/" . $lang . "/bvs.ini", true);
$home = $scielodef['this']['url'];
$mailcredentials = $mainscielodef['MAIL_CREDENTIALS'];

$acao = isset($cgi["acao"]) ? $cgi["acao"] : "";
$pid = isset($cgi["pid"]) ? $cgi["pid"] : "";
$caller = isset($cgi["caller"]) ? $cgi["caller"] : "";
$serviceCaller = preg_replace('/:8080$/', '', $caller);
if (!$serviceCaller) {
	$serviceCaller = $caller;
}

//geting metadatas from PID
$articleService = new ArticleService($serviceCaller);
$articleService->setParams($pid);
$article = $articleService->getArticle();

if ($pid) {
	$fallbackLang = "en";
	$fallbackUrl = "http://127.0.0.1/scielo.php?script=sci_arttext&pid=" . urlencode($pid) . "&lng=" . urlencode($fallbackLang) . "&nrm=iso&tlng=" . urlencode($fallbackLang) . "&debug=xml";
	$fallbackXmlText = @file_get_contents($fallbackUrl);
	if ($fallbackXmlText) {
		$serialTitle = '';
		$articleTitle = '';
		$fallbackXml = @simplexml_load_string($fallbackXmlText);
		if ($fallbackXml && isset($fallbackXml->SERIAL)) {
			$serialTitle = trim((string)$fallbackXml->SERIAL->TITLEGROUP->TITLE);
			if ($serialTitle && !$article->getSerial()) {
				$article->setSerial($serialTitle);
			}

			$articleTitle = trim((string)$fallbackXml->SERIAL->ISSUE->ARTICLE->TITLE);
			if (!$articleTitle) {
				$articleTitle = trim((string)$fallbackXml->SERIAL->ISSUE->ARTICLE->citation_title);
			}
		}

		// When XML cannot be parsed due legacy mixed content, recover key fields by regex.
		if (!$serialTitle && preg_match('/<TITLEGROUP>.*?<TITLE><!\\[CDATA\\[(.*?)\\]\\]><\\/TITLE>/is', $fallbackXmlText, $mSerial)) {
			$serialTitle = trim($mSerial[1]);
		}
		if (!$articleTitle && preg_match('/<ARTICLE\\b[^>]*>.*?<TITLE><!\\[CDATA\\[(.*?)\\]\\]><\\/TITLE>/is', $fallbackXmlText, $mTitle)) {
			$articleTitle = trim($mTitle[1]);
		}

		if ($serialTitle) {
			$article->setSerial($serialTitle);
		}
		if ($articleTitle) {
			$safeLang = strtoupper($fallbackLang);
			$safeTitle = str_replace("]]>", "]]]]><![CDATA[>", $articleTitle);
			$article->setTitle('<TITLES><TITLE LANG="' . $safeLang . '"><![CDATA[' . $safeTitle . ']]></TITLE></TITLES>');
		}
	}
}

$articleTitleXml = $article->getTitle();
$articleTitleText = '';
if ($articleTitleXml) {
	if (preg_match('/<TITLE[^>]*>(?:<!\\[CDATA\\[)?(.*?)(?:\\]\\]>)?<\\/TITLE>/is', $articleTitleXml, $m)) {
		$articleTitleText = trim(html_entity_decode(strip_tags($m[1]), ENT_QUOTES | ENT_HTML5, 'UTF-8'));
	} else {
		$articleTitleText = trim(html_entity_decode(strip_tags($articleTitleXml), ENT_QUOTES | ENT_HTML5, 'UTF-8'));
	}
}
if (!$articleTitleText) {
	$articleTitleText = $pid;
}

switch($acao){
	case "send":
		$articleURL = 'http://'.$caller.'/scielo.php?script=sci_abstract&pid='.$pid.'&lng=en&nrm=iso&tlng=en';
		$link = '<a href="'.$articleURL.'">'.htmlspecialchars($articleTitleText, ENT_QUOTES, 'UTF-8').'</a>';

		$msg = file_get_contents(dirname(__FILE__)."/../../html/".$lang."/send_mail_msg.html");

		$msg = str_replace("[toName]",$cgi["toName"],$msg);
		$msg = str_replace("[fromName]",$cgi["fromName"],$msg);
		$msg = str_replace("[serialName]",$article->getSerial(),$msg);
		$msg = str_replace("[articleTitleURL]",$link,$msg);
		$msg = str_replace("[articleURL]",$articleURL,$msg);
		$msg = str_replace("[commentary]",$cgi["comment"],$msg);

		$msg_no_html = html_entity_decode(strip_tags($msg), ENT_QUOTES | ENT_HTML5, 'UTF-8');


		$_mail = new PHPMailer();
		$_mail->isSMTP();
		$_mail->SMTPAuth = true;
		$_mail->SMTPSecure = $mailcredentials['secure'];
		$_mail->Username = $mailcredentials['username'];
		$_mail->Password = $mailcredentials['password'];
		$_mail->SetLanguage('en',dirname(__FILE__) . '/../../includes/phpmailer/language/');
		$_mail->AddReplyTo($cgi["from"],$cgi["fromName"]);
		$_mail->From     = $mailcredentials['sender'];
		$_mail->FromName = "SciELO";
		$_mail->Subject  = ARTICLE_SUGGESTION." ".$cgi["fromName"];
		$_mail->Host     = $mailcredentials['host'];
		$_mail->Port     = $mailcredentials['port'];
		$_mail->Mailer   = 'mail';
		$_mail->IsHTML(true);
		$_mail->Body = $msg;
		$_mail->AltBody  = $msg_no_html;
		$_mail->AddAddress($cgi["to"], $cgi['toName']);
		$send = $_mail->Send();
		if(!$send){
			$acao = "message";
			$message = $_mail->ErrorInfo;
		}else{
			$acao = "message";
			$message = ARTICLE_SUBMITED_WITH_SUCCESS;
		}
	break;
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?= $site['title']?>
		</title>
		<? include(dirname(__FILE__)."/../../../../php/head.php"); ?>
		<script language="JavaScript" src="../../js/script.js"></script>
		<script language="JavaScript" src="../../js/validator.js"></script>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<style>
			/* classes for validator */
			.tfvHighlight
				{font-weight: bold; color: red; display:inline;}
			.tfvNormal
				{font-weight: normal;	color: black; display: inline;}
		</style>
	</head>
	<body>
		<div class="container">	
			<div class="level2">
					<? require_once(dirname(__FILE__)."/../../html/" . $lang . "/headerInstancesServices.html"); ?>
					<div class="middle">				
						<div class="content">
						<h3>
							<span>
								<?=ENVIAR_ARTIGO_POR_EMAIL?>
							</span>
						</h3>					
						<FORM action="" method="post" name="sendMail" onsubmit="return v.exec()">
						<?
						if ($acao == "message") {
						?>
							<center><?=$message?></center>
							<INPUT type="button" class="submit" value="<?=CLOSE?>" onclick="window.close();">
						<?
						}else{?>
							<INPUT type="hidden" name="acao" value="send">
							<INPUT type="hidden" name="pid" value="<?=$pid?>">							
							<INPUT type="hidden" name="caller" value="<?=$caller?>">														
							<TABLE border="0" cellpadding="0" cellspacing="2" width="550" align="center">
								<TR>
									<TD class="emailFormLabel" align="right" width="30%" valign="top">
										<?=ARTICLE_TITLE?>
									</TD>
									<TD><?=htmlspecialchars($articleTitleText, ENT_QUOTES, 'UTF-8');?></TD>
								</TR>
								<TR>
									<TD height="15">
									</TD>
								</TR>
								<TR>
									<TD class="emailFormLabel" align="right" width="30%">
										<?=FIELD_PROFILE_NAME?>:
										<span id="fromNameLabel" class="tfvNormal">
											<?=FIELD_LAST_NAME_ERROR_DESCRIPTION?>
										</span>
									</TD>
									<TD>
										<INPUT type="text" name="fromName" size="40">
									</TD>
								</TR>
								<TR>
									<TD class="emailFormLabel" align="right">
										<?=FIELD_EMAIL?>:
										<span id="fromLabel" class="tfvNormal">
											<?=FIELD_EMAIL_ERROR_DESCRIPTION?>
										</span>
									</TD>
									<TD>										
										<INPUT type="text" name="from" size="40">
									</TD>
								</TR>
								<TR>
									<TD class="emailFormLabel" align="right">
										<?=TO_NAME?>
										<span id="toNameLabel" class="tfvNormal">
											<?=FIELD_LAST_NAME_ERROR_DESCRIPTION?>
										</span>
									</TD>
									<TD>

										<INPUT type="text" name="toName" size="40">
									</TD>
								</TR>
								<TR>
									<TD class="emailFormLabel" align="right">
										<?=TO_EMAIL?>
										<span id="toLabel" class="tfvNormal">
											<?=FIELD_LAST_NAME_ERROR_DESCRIPTION?>
										</span>
									</TD>
									<TD>										
										<INPUT type="text" name="to" size="40">
									</TD>
								</TR>
								<TR>
									<TD class="emailFormLabel" align="right" valign="top">
										<?=COMMENTS?>
									</TD>
									<TD>
										<TEXTAREA rows="4" cols="40" name="comment"></TEXTAREA>
									</TD>
								</TR>
								<TR>
									<TD height="10">
									</TD>
								</TR>
								<TR align="center">
									<TD colspan="2">										
										<INPUT type="submit" class="submit" value="<?=SEND?>">										
										<INPUT type="button" class="submit" value="<?=CLOSE?>" onclick="window.close();">
									</TD>
								</TR>								
								<INPUT type="hidden" name="form" value="1">								
								<INPUT type="hidden" name="id" value="24039">								
								<INPUT type="hidden" name="titulo" value="Resolução RE-20060922-3169-">
							</TABLE>
						<?}?>
						</FORM>
					</div>
					<div style="clear: both;float: none;width: 100%;">
					</div>
				</div>
			</div>
		</div>
			<script>
			var a_fields = {
				'fromName': {
					'l': 'fromName',  // label
					'r': true,    // required
					'f': 'text',  // format (see below)
					't': 'fromNameLabel',// id of the element to highlight if input not validated
					'm': null,     // must match specified form field
					'mn': 3,       // minimum length
					'mx': 100       // maximum length
				},
				'from': {
					'l': 'from',  // label
					'r': true,    // required
					'f': 'email',  // format (see below)
					't': 'fromLabel',// id of the element to highlight if input not validated
					'm': null,     // must match specified form field
					'mn': 3,       // minimum length
					'mx': 100       // maximum length
				},
				'toName': {
					'l': 'toName',  // label
					'r': true,    // required
					'f': 'text',  // format (see below)
					't': 'toNameLabel',// id of the element to highlight if input not validated
					'm': null,     // must match specified form field
					'mn': 3,       // minimum length
					'mx': 100       // maximum length
				},
				'to': {
					'l': 'to',  // label
					'r': true,    // required
					'f': 'email',  // format (see below)
					't': 'toLabel',// id of the element to highlight if input not validated
					'm': null,     // must match specified form field
					'mn': 3,       // minimum length
					'mx': 100       // maximum length
				}

			};

			o_config = {
				'to_disable' : [],
				'alert' : false
			};

			// validator constructor call
			var v = new validator('sendMail', a_fields, o_config);

			</script>
			<? 
				$def = parse_ini_file('../../../../scielo.def.php',true);
				if($def['LOG']['ACTIVATE_LOG'] == '1') {
			?>
				<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
				<script type="text/javascript">
						_uacct = "UA-604844-1";
						urchinTracker();
				</script>
			<?}?>
	</BODY>
</HTML>
