<?php

require_once(dirname(__FILE__)."/../../../../security.php");
$lang = scielo_validate_language(isset($_REQUEST['lang']) ? $_REQUEST['lang'] : '', 'pt');
$_REQUEST['lang'] = $lang;
scielo_start_secure_session();
require_once(dirname(__FILE__)."/../../users/functions.php");
require_once(dirname(__FILE__)."/../../users/langs.php");
require_once(dirname(__FILE__)."/../../includes/phpmailer/class.phpmailer.php");
require_once(dirname(__FILE__)."/../../classes/services/ArticleServices.php");
require_once(dirname(__FILE__)."/../../../../php/include.php");

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
$requestMethod = isset($_SERVER['REQUEST_METHOD']) ? strtoupper($_SERVER['REQUEST_METHOD']) : 'GET';
$acao = isset($_POST['acao']) ? $_POST['acao'] : '';
$pidValue = isset($_POST['pid']) ? $_POST['pid'] : (isset($_GET['pid']) ? $_GET['pid'] : '');
$pid = scielo_validate_article_pid($pidValue);
if ($pid === false) {
	http_response_code(400);
	exit('Invalid request');
}
$csrfToken = scielo_csrf_token();
$requestedCaller = isset($_REQUEST['caller']) ? $_REQUEST['caller'] : '';
$caller = scielo_internal_host_from_config($mainscielodef);
if ($requestedCaller !== '' && $requestedCaller !== $caller) {
	scielo_audit_event(
		'access.denied',
		'unauthorized',
		'service.article_metadata',
		null,
		array('reason' => 'caller_override_ignored')
	);
}

if ($acao === 'send') {
	if ($requestMethod !== 'POST') {
		header('Allow: POST');
		http_response_code(405);
		exit('Method not allowed');
	}

	if (!scielo_csrf_token_is_valid(isset($_POST['csrf_token']) ? $_POST['csrf_token'] : '')) {
		scielo_audit_event('access.denied', 'unauthorized', 'service.article_email', $pid, array(
			'reason' => 'invalid_csrf_token',
		));
		http_response_code(403);
		exit('Request denied');
	}

	$fromEmail = scielo_validate_email_address(isset($_POST['from']) ? $_POST['from'] : '');
	$toEmail = scielo_validate_email_address(isset($_POST['to']) ? $_POST['to'] : '');
	$fromName = scielo_validate_person_name(isset($_POST['fromName']) ? $_POST['fromName'] : '');
	$toName = scielo_validate_person_name(isset($_POST['toName']) ? $_POST['toName'] : '');
	$comment = scielo_validate_comment(isset($_POST['comment']) ? $_POST['comment'] : '');
	if ($fromEmail === false || $toEmail === false || $fromName === false
		|| $toName === false || $comment === false) {
		scielo_audit_event('article.email_send', 'failure', 'article', $pid, array(
			'reason' => 'invalid_input',
		));
		http_response_code(400);
		exit('Invalid request');
	}

	$rateLimit = scielo_rate_limit('article.email_send', 5, 3600);
	if (!$rateLimit['allowed']) {
		scielo_audit_event('access.denied', 'unauthorized', 'service.article_email', $pid, array(
			'reason' => 'rate_limit_exceeded',
			'retry_after' => $rateLimit['retry_after'],
		));
		header('Retry-After: ' . $rateLimit['retry_after']);
		http_response_code(429);
		exit('Too many requests');
	}
}

//geting metadatas from PID
$articleService = new ArticleService($caller);
$articleService->setParams($pid);
$article = $articleService->getArticle();
switch($acao){
	case "send":
		$articleURL = 'http://' . $caller . '/scielo.php?' . http_build_query(array(
			'script' => 'sci_abstract',
			'pid' => $pid,
			'lng' => 'en',
			'nrm' => 'iso',
			'tlng' => 'en',
		));
		$link = '<a href="' . scielo_escape_html($articleURL) . '">'
			. scielo_escape_html(getTitle($article->getTitle())) . '</a>';

		$msg = file_get_contents(dirname(__FILE__)."/../../html/".$lang."/send_mail_msg.html");

		$msg = str_replace("[toName]", scielo_escape_html($toName), $msg);
		$msg = str_replace("[fromName]", scielo_escape_html($fromName), $msg);
		$msg = str_replace("[serialName]", scielo_escape_html($article->getSerial()), $msg);
		$msg = str_replace("[articleTitleURL]",$link,$msg);
		$msg = str_replace("[articleURL]", scielo_escape_html($articleURL), $msg);
		$msg = str_replace("[commentary]", nl2br(scielo_escape_html($comment)), $msg);
		$msg_no_html = trim(strip_tags(html_entity_decode($msg, ENT_QUOTES | ENT_HTML5, 'UTF-8')));

		$_mail = new PHPMailer();
		$_mail->isSMTP();
		$_mail->SMTPAuth = true;
		$_mail->SMTPSecure = $mailcredentials['secure'];
		$_mail->Username = $mailcredentials['username'];
		$_mail->Password = $mailcredentials['password'];
		$_mail->SetLanguage('en',dirname(__FILE__) . '/../../includes/phpmailer/language/');
		$_mail->AddReplyTo($fromEmail, $fromName);
		$_mail->From     = $mailcredentials['sender'];
		$_mail->FromName = "SciELO";
		$_mail->Subject  = ARTICLE_SUGGESTION." ".$fromName;
		$_mail->Host     = $mailcredentials['host'];
		$_mail->Port     = $mailcredentials['port'];
		$_mail->Mailer   = 'mail';
		$_mail->IsHTML(true);
		$_mail->Body = $msg;
		$_mail->AltBody  = $msg_no_html;
		$_mail->AddAddress($toEmail, $toName);
		$send = $_mail->Send();
		if(!$send){
			$acao = "message";
			$message = 'Unable to send the message.';
			scielo_audit_event('article.email_send', 'failure', 'article', $pid, array(
				'reason' => 'mailer_failure',
			));
		}else{
			$acao = "message";
			$message = ARTICLE_SUBMITED_WITH_SUCCESS;
			scielo_audit_event('article.email_send', 'success', 'article', $pid);
		}
	break;
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?=scielo_escape_html($site['title'])?>
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
							<center><?=scielo_escape_html($message)?></center>
							<INPUT type="button" class="submit" value="<?=CLOSE?>" onclick="window.close();">
						<?
						}else{?>
							<INPUT type="hidden" name="acao" value="send">
							<INPUT type="hidden" name="pid" value="<?=scielo_escape_html($pid)?>">
							<INPUT type="hidden" name="lang" value="<?=scielo_escape_html($lang)?>">
							<INPUT type="hidden" name="csrf_token" value="<?=scielo_escape_html($csrfToken)?>">
							<TABLE border="0" cellpadding="0" cellspacing="2" width="550" align="center">
								<TR>
									<TD class="emailFormLabel" align="right" width="30%" valign="top">
										<?=ARTICLE_TITLE?>
									</TD>
									<TD><?=scielo_escape_html(getTitle($article->getTitle()));?></TD>
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
