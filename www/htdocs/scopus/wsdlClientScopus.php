<?php
	/*
	 *	$Id: wsdlclient3b.php,v 1.1 2004/06/15 15:38:29 snichol Exp $
	 *
	 *	WSDL client sample.
	 *
	 *	Service: WSDL
	 *	Payload: rpc/encoded (params as an XML string; cf. wsdlclient3.php)
	 *	Transport: http
	 *	Authentication: none
	 */
	require_once('nusoap/lib/nusoap.php');
	
	$client = new soapclient('http://306a-xabsmet.lexisnexis.com/XAbsMetSvc/services/AbstractsMetadataServicePort_V7/wsdl/absmet_service_v7.wsdl','wsdl');
	$err = $client->getError();
	if ($err) {
		echo '<h2>Constructor error</h2><pre>' . $err . '</pre>';
	}

	/*
	 *	Mantendo os dados da requisição staticos pois apenas teste.
	*/
	
	
	//$params = file_get_contents("http://teste.scielo.br/scopus/scielo-scopus.php?issn=0102-3306&ano=2007&volume=0001&number=0001&reqid=0001&ver=2&consumer=SCIELO&opaqueinfo=&loglevel=DEFAULT&absmetsource=all&responsestyle=wellDefined&dataresponsestyle=MESSAGE&url=http://teste.scielo.br/scopus/scielo-scopus.php");

	$msgHeader = '<EASIReq xmlns="http://webservices.elsevier.com/schemas/easi/headers/types/v1"><ReqId xmlns="">0001</ReqId><Ver xmlns="">0001</Ver><Consumer xmlns="">SCIELO</Consumer><ConsumerClient xmlns="">SCIELO</ConsumerClient><OpaqueInfo xmlns=""></OpaqueInfo><LogLevel xmlns="">Default</LogLevel></EASIReq>';
	
	$msgBody = '<getCitedByCount xmlns="http://webservices.elsevier.com/schemas/metadata/abstracts/types/v7"><getCitedByCountReqPayload><dataResponseStyle>MESSAGE</dataResponseStyle><absMetSource>all</absMetSource><responseStyle>wellDefined</responseStyle>
				<inputKey>
				<doi xmlns="http://webservices.elsevier.com/schemas/metadata/common/types/v3">10.1016/S0257-8972(99)00448-X</doi>
				<clientCRF xmlns="http://webservices.elsevier.com/schemas/metadata/common/types/v3">0</clientCRF>
				</inputKey>
				</getCitedByCountReqPayload></getCitedByCount>';
	$result = $client->call('getCitedByCount', $msgBody,null,null,$msgHeader);

	// Check for a fault
	if ($client->fault) {
		echo '<h2>Fault</h2><pre>';
		print_r($result);
		echo '</pre>';
	} else {
		// Check for errors
		$err = $client->getError();
		if ($err) {
			// Display the error
			echo '<h2>Error</h2><pre>' . $err . '</pre>';
		} else {
			// Display the result
			echo '<h2>Result</h2><pre>';
			print_r($result);
			echo '</pre>';
		}
	}
	echo '<h2>Request</h2><pre>' . htmlspecialchars($client->request, ENT_QUOTES) . '</pre>';
	echo '<h2>Response</h2><pre>' . htmlspecialchars($client->response, ENT_QUOTES) . '</pre>';
	echo '<h2>Debug</h2><pre>' . htmlspecialchars($client->debug_str, ENT_QUOTES) . '</pre>';
?>
