<?php 
	/*
	 * Par�metro do Header
	 */
	$ReqId = $_REQUEST['reqid'];
	$Ver = $_REQUEST['ver'];
	$Consumer = $_REQUEST['consumer'];
	$OpaqueInfo = $_REQUEST['opaqueinfo'];
	$LogLevel = $_REQUEST['loglevel'];
	/*
	 * Par�metro do Body
	 */
	$absMetSource = $_REQUEST['absmetsource'];
	$responseStyle = $_REQUEST['responsestyle'];
	$dataReponseStyle = $_REQUEST['dataresponsestyle'];
	/*
	 * Par�metro para requisi��o
	 */
	$PID = $_REQUEST['issn'].$_REQUEST['ano'].$_REQUEST['volume'].$_REQUEST['number'];
	$PID = 'S'.$PID.'$'; 
	$Server = str_replace('http://','',$_REQUEST['url']);
	$posUrl = strpos($Server,'/');
	$Server = substr($Server, 0, $posUrl); 
	/*
	 * Par�metro para header
	 */
	$header = '<?xml version="1.0" encoding="ISO-8859-1"?>
				<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
	$header .= '<EASIReq xmlns="http://webservices.elsevier.com/schemas/easi/headers/types/v1">';
	$header .= '<ReqId xmlns="">'.$ReqId.'</ReqId>';
	$header .= '<Ver xmlns="">'.$Ver.'</Ver>';
	$header .= '<Consumer xmlns="">'.$Consumer.'</Consumer>';
	$header .= '<ConsumerClient xmlns="">SCIELO</ConsumerClient>';
	$header .= '<OpaqueInfo xmlns="">'.$OpaqueInfo.'</OpaqueInfo>';
	$header .= '<LogLevel xmlns="">'.$LogLevel.'</LogLevel>';
	$header .= '</EASIReq>';
	$header .= '<getCitedByCount xmlns="http://webservices.elsevier.com/schemas/metadata/abstracts/types/v7">';
	$header .= '<getCitedByCountReqPayload>';
	$header .= '<dataResponseStyle>'.$dataReponseStyle.'</dataResponseStyle>';
	$header .= '<absMetSource>'.$absMetSource.'</absMetSource>';
	$header .= '<responseStyle>'.$responseStyle.'</responseStyle>';
	/*
	 * Par�metro para body
	 */
	$content= file_get_contents("http://" . $Server . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_scopus_cited_by_count.xis&database=artigo&search=HR=".$PID);
	$contentrp = str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$content);
	/*
	 * Par�metro para footer
	 */
	$footer = '</getCitedByCountReqPayload>';
	$footer .= '</getCitedByCount>';
	$footer .= '</soapenv:Envelope>';
	
	header('Content-type: application/xml');
	
	echo ($header.$contentrp.$footer);
?>