<?php
$_REQUEST = (isset($_REQUEST) ? $_REQUEST : array_merge($HTTP_GET_VARS, $HTTP_POST_VARS, $HTTP_COOKIE_VARS));
$_SERVER  = (isset($_SERVER) ? $_SERVER : $HTTP_SERVER_VARS);

$server = "http://" . $_SERVER["HTTP_HOST"];
$endPoint = $server . str_replace("client.php","server.php",$_SERVER["PHP_SELF"]);
$wsdl  =  $endPoint . "?wsdl";
?>

<html>
  <head>
    <title>SciELO Client SOAP</title>
    <style type="text/css">
            body  { font-family: arial; font-size: 12pt; color: #000000; background-color: #ffffff; margin: 10px 20px 20px 5px; }
            h3    { color: #990000};
    </style>
  </head>
  <body>
<div style="text-align:center"><img alt="ScieELO.org - Scientific Electronic Library Online" src="http://www.scielo.br/applications/scielo-org/image/public/skins/classic/pt/banner.jpg"></center></div>
<h3>SciELO Client SOAP</h3>
<b>endpoint: &nbsp;</b><a href="<?=$endPoint?>" target="_blank"><?=$endPoint?></a><br/>
<b>wsdl: &nbsp;</b><a href="<?=$wsdl?>" target="_blank"><?=$wsdl?></a>
<br><br>
<h3>Services Examples</h3>
<ul><li>Search: http://<? echo $_SERVER["HTTP_HOST"]?><? echo htmlspecialchars("/webservices/client.php?expression=dengue&from=1&count=10&service=search&lang=p");?></li></ul>
<ul><li>New Titles: http://<? echo $_SERVER["HTTP_HOST"]?><? echo htmlspecialchars("/webservices/client.php?service=new_titles&count=10");?></li></ul>
<ul><li>New Issues: http://<? echo $_SERVER["HTTP_HOST"]?><? echo htmlspecialchars("/webservices/client.php?service=new_issues&count=10");?></li></ul>
<ul><li>Get Titles: http://<? echo $_SERVER["HTTP_HOST"]?><? echo htmlspecialchars("//webservices/client.php?service=get_titles&issn=0102-8650");?></li></ul>
<ul><li>Get Title Indicators: http://<? echo $_SERVER["HTTP_HOST"]?><? echo htmlspecialchars("/webservices/client.php?service=get_title_indicators&issn=0102-8650");?></li></ul>
<h3>Result</h3>
<?
$service = $_REQUEST['service'];

$client = new SoapClient('wsdl/scielo.wsdl', array('encoding'=>'ISO-8859-1'));

switch($service){
    case "search":
        if(!isset($_REQUEST['expression'])){
                die("missing parameter <i>expression</i>");
        }
        if(!isset($_REQUEST['from'])){
                die("missing parameter <i>from</i>");
        }
        if(!isset($_REQUEST['count'])){
                die("missing parameter <i>count</i>");
        }
        if(!isset($_REQUEST['lang'])){
                die("missing parameter <i>lang</i>");
        }
        $param = array('expression' => $_REQUEST['expression'],'from' => $_REQUEST['from'],'count' => $_REQUEST['count'],'lang' => $_REQUEST['lang']);
        $resultado = $client->__call('search',$param);
        break;
    case "new_titles":
        $param = array('count' => $_REQUEST["count"], 'rep' => $_REQUEST["rep"]);
        $resultado = $client->__call('new_titles',$param);
        break;
    case "new_issues":
        $param = array('count' => $_REQUEST["count"], 'rep' => $_REQUEST["rep"]);
        $resultado = $client->__call('new_issues',$param);
        break;
    case "get_titles":
        if(isset($_REQUEST['issn'])){
            if(is_string($_REQUEST['issn'])){
                $issn = explode(',',$_REQUEST['issn']);
            }else if(is_array($_REQUEST['issn'])){
                $issn = $_REQUEST['issn'];
            }else{
                break;
            }
            $param = array('issn' => $_REQUEST["issn"]);
            $resultado = $client->__call('getDetachedTitles', $param);
        }else{
            $param = array('issn' => $_REQUEST["type"], 'rep' => $_REQUEST["rep"]);
            $resultado = $client->__call('get_titles',$param);
        }
        break;
    case "get_title_indicators":
         $param = array('type' => $_REQUEST["type"], 'rep' => $_REQUEST["rep"], 'issn' => $_REQUEST["issn"]);
         $resultado = $client->__call('get_title_indicators', $param);
        break;
    case "":
        $resultado = "No result";
        break;

}
?>
<textarea cols="100" rows="30">
<? echo trim($resultado);?>
</textarea>

<p align="center"><font color="#0000a0" size="-1" class="nomodel">SciELO - Scientific Electronic Library Online<br>FAPESP - BIREME<br>Rua Dr. Diogo de Farias, 1087 conj. 810 - Vila Clementino<br>04037-003 S�o Paulo SP - Brazil - Brasil<br>Phone: +55 11 3369-4080<br>Fax: </font><br><a href="mailto:scielo@scielo.org" class="email"><img border="0" src="/img/e-mailt.gif"><br><font color="#0000a0" size="2">scielo@scielo.org</font></a></p>



