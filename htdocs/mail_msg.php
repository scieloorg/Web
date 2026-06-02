<?php
require_once(dirname(__FILE__)."/applications/scielo-org/includes/phpmailer/class.phpmailer.php");
$defFile = parse_ini_file(dirname(__FILE__)."/scielo.def.php");

function scielo_getenv($name, $default = '')
{
	$value = getenv($name);
	return ($value !== false && $value !== '') ? $value : $default;
}

function scielo_xml_error_mailer()
{
	$_mail = new PHPMailer();
	$_mail->From     = scielo_getenv('SCIELO_XML_ERROR_MAIL_FROM', 'scielo@bireme.org');
	$_mail->FromName = scielo_getenv('SCIELO_XML_ERROR_MAIL_FROM_NAME', 'Scielo');
	$_mail->Subject  = "SciELO Error Report";
	$_mail->Host     = scielo_getenv('SCIELO_XML_ERROR_SMTP_HOST', 'esmeralda.bireme.br');
	$_mail->Password = scielo_getenv('SCIELO_XML_ERROR_SMTP_PASSWORD');
	$_mail->Username = scielo_getenv('SCIELO_XML_ERROR_SMTP_USERNAME', 'appscielo');
	$_mail->SMTPAuth = ($_mail->Password !== '');
	$_mail->Mailer   = "smtp";
	$_mail->IsHTML(false);

	return $_mail;
}

function scielo_mask_request_uri($uri)
{
	return preg_replace('/([?&](?:password|passwd|pwd|senha|token|api[_-]?key|secret)=)[^&]*/i', '$1[REDACTED]', $uri);
}

function scielo_safe_xml_preview($xml)
{
	$xml = (string)$xml;
	$preview = substr($xml, 0, 4096);
	if (strlen($xml) > 4096) {
		$preview .= "\n...[TRUNCATED]";
	}
	return $preview;
}

$msg_no_html = "Date: " . date("l dS of F Y h:i:s A") . "\n\n";
$msg_no_html .= "Error: " . $xmlCheck->get_full_error() . "\n\n";
$msg_no_html .= "Server Name: " . $_SERVER['SERVER_NAME'] . "\n";
$msg_no_html .= "Server IP: " . $_SERVER['SERVER_ADDR'] . "\n";
$msg_no_html .= "URL: " . scielo_mask_request_uri($_SERVER['REQUEST_URI']) . "\n\n";
$msg_no_html .= "XML preview: \n" . scielo_safe_xml_preview($xml) . "\n";

if($defFile['ENABLED_MAIL_ALERT'] == '1'){
	//Formato: Ano-Mes-Dia-Hora_Minuto_Segundo
	$fileName = "XMLerror_".date("y-m-d-H_i_s").".xml";

	$_mail = scielo_xml_error_mailer();
	//$_mail->Body = $msg;
	$_mail->AltBody  = $msg_no_html;
	$_mail->AddAddress($defFile['MAILTO_XML_ERROR'],$defFile['NAMETO_XML_ERROR']);
	$_mail->AddStringAttachment($xml,$fileName,"base64","text/xml");
	$send = $_mail->Send();

	if(!$send){
		if(!$fileHandle = fopen($fileName,'w')){
			print "Erro abrindo o arquivo $fileName";
			exit;
		}
		if(!fwrite($fileHandle,$xml)){
				print "Erro escrevendo no arquivo $fileName";
		}else{
				print "Arquivo não pode ser escrito.";
		}

	}
}
if($defFile['ENABLED_LOG_XML_ERROR'] == '1'){
	$logName = $defFile['LOG_XML_ERROR_FILENAME'];

	$logContent = "########################################### \n";
	$logContent .= $msg_no_html;
	$logContent .= "########################################### \n";

	if(is_writable($logName)){
		//Abrindo o arquivo configurado em $logName em modo Append(Acrescimo).
		if(!$handle = fopen($logName,'a')){
			print "Erro abrindo o arquivo $logName .";
			exit;
		}
		//Escrevendo no arquivo configurado em $logName.
		if(!fwrite($handle,$logContent)){
			print "Erro escrevendo no arquivo $logName .";
			exit;
		}
		//Finalizando o handler $handle.
		fclose($handle);
	}else{
		$fileName = "XMLerror_".date("y-m-d-H_i_s").".xml";

		$_mail = scielo_xml_error_mailer();
		//$_mail->Body = $msg;
		$_mail->AltBody  = $msg_no_html;
		$_mail->AddAddress($defFile['MAILTO_XML_ERROR'],$defFile['NAMETO_XML_ERROR']);
		$_mail->AddStringAttachment($xml,$fileName,"base64","text/xml");
		$send = $_mail->Send();
		}

}
?>