<?php
require_once('../bvs-lib/common/classes/php/nusoap.php');

// Backward compatible array creation
$_REQUEST = (isset($_REQUEST) ? $_REQUEST : array_merge($HTTP_GET_VARS, $HTTP_POST_VARS, $HTTP_COOKIE_VARS));
$_SERVER  = (isset($_SERVER) ? $_SERVER : $HTTP_SERVER_VARS);

$server = "http://" . $_SERVER["HTTP_HOST"];
$endPoint = $server . str_replace("client.php","index.php",$_SERVER["PHP_SELF"]);
$wsdl  =  $endPoint . "?wsdl";
?>

<html>
  <head>
	<title>Client SOAP test</title>
    <style type="text/css">
		body  { font-family: arial; font-size: 8pt; color: #000000; background-color: #ffffff; margin: 10px 20px 20px 5px; }
		h2    { color: navy};		
	</style>
  </head>
  <body>
	<h2>Client SOAP</h2>
	<b>endpoint: </b><a href="<?=$endPoint?>" target="_blank"><?=$endPoint?></a><br/>
	<b>wsdl: </b><a href="<?=$wsdl?>" target="_blank"><?=$wsdl?></a>
	<br><br><br>
	<a href="#parameters">parameters</a>  |  <a href="#result">result</a>  | <a href="#request">request</a>  | <a href="#response">response</a>  | <a href="#debug">debug</a>
	<a name="parameters"></a>
	<h3>Parameters</h3>

<?
// split params
$query = $_SERVER["QUERY_STRING"];
print "<pre>";
$splited1 = split('&', $query);
foreach ($splited1 as $value){
	$splited2 = split("=",$value);
	if ($splited2[0] != "" && $splited2[0] != "service"){
		$param = $splited2[0];
		$value = $splited2[1];
		$params[$param] = $value;
		print $param . "=" . $value . "<br/>";
	}	
}
print "</pre>";

// Create the client instance
$client = new soapclient($wsdl, true);
// Check for an error
$err = $client->getError();
if ($err) {
	// Display the error
	echo '<h2>Constructor error</h2><pre>' . $err . '</pre>';
	// At this point, you know the call that follows will fail
}
// Call the SOAP method


$result = $client->call($_REQUEST["service"], $params);
// Check for a fault
if ($client->fault) {
	echo '<h3>Fault</h3><pre>';
	print_r($result);
	echo '</pre>';
} else {
	// Check for errors
	$err = $client->getError();
	if ($err) {
		// Display the error
		echo '<h3>Error</h3><pre>' . $err . '</pre>';
	} else {
		// Display the result
		echo '<a name="result"></a>';
		echo '<h3>Result</h3><pre>';
		print_r($result);		
	echo '</pre>';
	}
}



// Display the request and response
echo '<a name="request"></a>';
echo '<h3>Request</h3>';
echo '<pre>' . wordwrap( htmlspecialchars($client->request, ENT_QUOTES), 120 ) . '</pre>';
echo '<a name="response"></a>';
echo '<h3>Response</h3>';
echo '<pre>' . wordwrap( htmlspecialchars($client->response, ENT_QUOTES),120 ) . '</pre>';
// Display the debug messages
echo '<a name="debug"></a>';
echo '<h3>Debug</h3>';
echo '<pre>' . wordwrap( htmlspecialchars($client->debug_str, ENT_QUOTES),120 ) . '</pre>';
?>
