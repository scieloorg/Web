<?php 
	/*
	 * Parâmetro do Header
	 */
	$ReqId = $_REQUEST['reqid'];
	$Ver = $_REQUEST['ver'];
	$Consumer = $_REQUEST['consumer'];
	$OpaqueInfo = $_REQUEST['opaqueinfo'];
	$LogLevel = $_REQUEST['loglevel'];
	/*
	 * Parâmetro do Body
	 */
	$absMetSource = $_REQUEST['absmetsource'];
	$responseStyle = $_REQUEST['responsestyle'];
	$dataReponseStyle = $_REQUEST['dataresponsestyle'];
	/*
	 * Parâmetro para requisição
	 */
	$PID = $_REQUEST['issn'].$_REQUEST['ano'].$_REQUEST['volume'].$_REQUEST['number'];
	$PID = 'S'.$PID.'$'; 
	$Server = str_replace('http://','',$_REQUEST['url']);
	$posUrl = strpos($Server,'/');
	$Server = substr($Server, 0, $posUrl); 
	/*
	 * Parâmetro para header
	 */
	$header = '<?xml version="1.0" encoding="ISO-8859-1"?>
				<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
	$header .= '<soapenv:Header>';
	$header .= '<EASIReq xmlns="http://webservices.elsevier.com/schemas/easi/headers/types/v1">';
	$header .= '<ReqId xmlns="">'.$ReqId.'</ReqId>';
	$header .= '<Ver xmlns="">'.$Ver.'</Ver>';
	$header .= '<Consumer xmlns="">'.$Consumer.'</Consumer>';
	$header .= '<ConsumerClient xmlns="">tester_client</ConsumerClient>';
	$header .= '<OpaqueInfo xmlns="">'.$OpaqueInfo.'</OpaqueInfo>';
	$header .= '<LogLevel xmlns="">'.$LogLevel.'</LogLevel>';
	$header .= '</EASIReq>';
	$header .= '</soapenv:Header>';
	$header .= '<soapenv:Body>';
	$header .= '<getCitedByCount xmlns="http://webservices.elsevier.com/schemas/metadata/abstracts/types/v7">';
	$header .= '<getCitedByCountReqPayload>';
	$header .= '<dataResponseStyle>'.$dataReponseStyle.'</dataResponseStyle>';
	$header .= '<absMetSource>'.$absMetSource.'</absMetSource>';
	$header .= '<responseStyle>'.$responseStyle.'</responseStyle>';
	/*
	 * Parâmetro para body
	 */
	$content= file_get_contents("http://" . $Server . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_scopus_cited_by_count.xis&database=artigo&search=HR=".$PID);
	$contentrp = str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$content);
	/*
	 * Parâmetro para footer
	 */
	$footer = '</getCitedByCountReqPayload>';
	$footer .= '</getCitedByCount>';
	$footer .= '</soapenv:Body>';
	$footer .= '</soapenv:Envelope>';
	
	header('Content-type: application/xml');
	
	echo ($header.$contentrp.$footer);
?>