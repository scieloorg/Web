<?php
require_once(dirname(__FILE__)."/classes/phpmailer/class.phpmailer.php");
$defFile = parse_ini_file(dirname(__FILE__)."/scielo.def");

$msg_no_html = "Date: " . date("l dS of F Y h:i:s A") . "\n\n";
$msg_no_html .= "Error: " . $xmlCheck->get_full_error() . "\n\n";
$msg_no_html .= "Server Name: " . $_SERVER['SERVER_NAME'] . "\n";
$msg_no_html .= "Server IP: " . $_SERVER['SERVER_ADDR'] . "\n";
$msg_no_html .= "URL: " .$_SERVER['REQUEST_URI'] . "\n\n";
//$msg_no_html .= "XML: \n" . $xml . "\n";

//Formato: Ano-Mes-Dia-Hora_Minuto_Segundo
$fileName = "XMLerror_".date("y-m-d-H_i_s").".xml";


$_mail = new PHPMailer();
//$_mail->AddReplyTo($cgi["from"],$cgi["fromName"]);
$_mail->From     = "scielo@bireme.org";
$_mail->FromName = "Scielo";
$_mail->Subject  = "SciELO Error Report";
$_mail->Host     = "esmeralda.bireme.br";
$_mail->Password = "x@07sci@";
$_mail->Username = "appscielo";
$_mail->SMTPAuth =true;
$_mail->Mailer   = "smtp";
$_mail->IsHTML(false);
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
	
?>
