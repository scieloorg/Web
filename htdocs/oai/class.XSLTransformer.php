<?php

include_once (dirname(__FILE__)."/../classes/class_xml_check/class_xml_check.php"); //classe para verificacao de XML
include_once (dirname(__FILE__)."/class.XSLTransformerJava.php");
include_once (dirname(__FILE__)."/class.XSLTransformerPHP5.php");

function xml_utf8_decode($xml){
  $xml = utf8_decode($xml);
  $xml = str_replace('utf-8','iso-8859-1',$xml);
  $xml = str_replace('UTF-8','iso-8859-1',$xml);
  return $xml;
}



class XSLTransformer
{

  function XSLTransformer()
  {
      $this->defFile = parse_ini_file(dirname(__FILE__)."/../scielo.def.php",true);
      $this->tPHP = new XSLTransformerPHP5();
      $this->tJava = new XSLTransformerJava($_SERVER["SERVER_ADDR"],$this->defFile["SOCKET"]["SOCK_PORT"]);

      $this->socket_log_file = $this->defFile['SOCKET']['ACCESS_LOG_FILE'];
      $this->enable_socket_log = $this->defFile['SOCKET']['ENABLE_ACCESS_LOG'];

      $this->redirectURL = $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];

  }

  function validateXML($xml)
  {
    $validXML = true;
    if ($this->defFile['XML_ERROR']['ENABLED_XML_ERROR'] == '1'){
            $xmlCheck = new XML_check();
            $xml1 = $xml;
            $validXML = $xmlCheck->check_string($xml1); // verifica se o XML é bem formado
    }
    return $validXML;
  }

  function setXslBaseUri($uri)
  {
    return $this->tPHP->setXslBaseUri($uri);;
  }
  
  /* Destructor */
  function destroy()
  {
   $this->tPHP->destroy();
  }

  /* output methods */
  function setOutput ($string)
  {
    $this->output = $string;
  }

  function getOutput()
  {
    return $this->output;
  }

  /* set methods */
  function setXml($xml)
  {
    if ($this->isXmlContent($xml))
    {
            $this->xml = $xml;
            return true;
    }
    elseif ($doc = new docReader($xml))
    {
            $this->xml = $doc->getString();
            return true;
    }
    else
    {
            $this->setError("Could not open $xml");
            return false;
    }
  }

  function setXslFile($xslFile)
  {
    $this->xslFile = $xslFile;
  }

  function returnXslKey()
  {
    if ($this->xslFile){
            $pos_ini = strrpos($this->xslFile,"/")+1;
            $pos_ini = strrpos($this->xslFile,"/")+1;
            $pos_len = strrpos($this->xslFile,".")-$pos_ini;
            $r = strtoupper(substr($this->xslFile,$pos_ini,$pos_len));
    } else {
            if (strpos($this->xsl,".xsl")==0 && strpos(" ".$this->xsl,"/")==0){
                    $r = $this->xsl;
            }
    }
    return $r;
  }

  function returnXslContent(){
    if ($this->xslFile){
            $r = file_get_contents($this->xslFile);
    } else {
            if (strpos("x".$this->xsl," ")>0){
                    $r = $this->xsl;
            }
    }
    return $r;
  }

  function getXsl($type) {
    switch ($type){
      case "key":
              $r = $this->returnXslKey();
              break;
      case "filecontent":
              $r = $this->returnXslContent();
              break;
      }
      if (!$r){
              die('Anteriormente, para a transformação java, era feito $this->xsl = o apelido da XSL. Atualmente, dev usar o metodo $this->setXslFile passando o caminho completo do arquivo XSL. Essa mudança tem o objetivo de padronizar o ato de instanciar a XSL, servindo tanto para transformação java, quanto php. Pois caso o java não esteja operando, a transformação php pode ser usada.');
      }
    return $r;
  }

  function setXsl($uri) {
    $this->xsl = $uri;
  }

  function isXmlContent($xml)
  {
    if (strcmp(substr($xml,0,5), "<?xml") == 0)
    {
            return true;
    }
    else
    {
            return false;
    }
  }

function transform()
{
          $err = "";
          $result = "";
          $tryByPHP = false;
          $tryRedirect = false;

          $this->xml = str_replace("&#","MY_ENT_",$this->xml);
          //$this->xml = xmlspecialchars  ($this->xml);

          if ($this->validateXML($this->xml)){
                  if ($this->tJava->checkSocketOpen()) {
                          $result = $this->tJava->transform($this->getXsl("key"), $this->xml);
                          switch ($result){
                                  case "NO_SOCKET":
                                          $tryPHP = true;
                                          $this->setError($result);
                                          break;
                                  case "ERROR_1":
                                          $tryPHP = true;
                                          $this->setError($result);
                                          break;
                                  case "ERROR_2":
                                          $tryPHP = true;
                                          $this->setError($result);
                                          break;
                                  default:
                                          $this->transformedBy = "JAVA";
                                          break;
                          }
                  } else {
                          $tryPHP = true;
                  }
                  if ($tryPHP){
                          //$result = $this->tPHP->transform($this->xml, $this->getXsl("filecontent"), $error);
                          $result = $this->tPHP->transform($this->xml, $this->xslFile, $error);
                          if ($error){
                                  $this->setError($error);
                                  $result = "ERROR_PHP";
                                  $tryRedirect = true;
                          } else {
                                  $this->transformedBy = "PHP";
                          }
                  }
                  if ($tryRedirect){
                          header('Location: http://'.$this->redirectURL);
                  } else {
                          $result = str_replace("MY_ENT_","&#",$result);
                          $this->setOutput ($result."<!--transformed by $this->transformedBy ".date("h:m:s d-m-Y")."-->");
                          $this->writeLog ();
                  }
          } else {
                  include_once (dirname(__FILE__)."/mail_msg.php");
                  $url = "http://".$_SERVER['SERVER_NAME']."/php/xmlError.php?lang=".$_REQUEST['lng'];
          }
}


  /* Error Handling */
  function setError ($string) {
    $this->error = $string;
  }

  function getError() {
    return $this->error;
  }

  function writeLog(){
    if ($this->enable_socket_log){
            $this->writeFile($_SERVER["SERVER_ADDR"]." ".$this->redirectURL." $this->transformedBy \n",$this->socket_log_file);
    }
  }
  function writeFile($content,$filename){
    $content = date("h:m:s d-m-Y")." ".$content;
    if (!$handle = fopen($filename, 'x+')) {
      if (!$handle = fopen($filename, 'a+')) {
              exit;
      }
    }
    if ($handle){
      chmod($filename, 0766);
      if (fwrite($handle, $content) === FALSE) {
              exit;
      }
      fclose($handle);
      }
    }
}

/* docReader -- read a file or URL as a string */
class docReader
{
	var $string;	// public string representation of file
	var $type;		// private URI type: 'file','url'
	var $bignum		= 3500000;

	/* public constructor */
	function docReader ($uri) {  // returns integer
		$this->setUri ($uri);
		$this->setType();
		$fp = fopen ($this->getUri(),"r");

		if ($fp) {
 			// get length
			if ( $this->getType() == 'file' ) {
				$length = filesize ($this->getUri());
			}
            else {
				$length = $this->bignum;
 			}
			$acumulado = "";
			while (!feof($fp)){
				$acumulado .= fread ($fp, $length);
			}
			$this->setString ($acumulado);

			/* $this->setString (fread ($fp, $length)); */
			fclose($fp);

			return 1;
		}
        else {
			return 0;
		}
	}

	/* determine if a URI is a filename or URL */
	function isFile ($uri) { 	// returns boolean
		if (strstr ($uri,'http://') == $uri) {
			return false;
		}
        else {
			return true;
		}
	}

	/* set and get methods */
	function setUri ($string) {
		$this->uri = $string;
	}

	function getUri() {
		return $this->uri;
	}

	function setString ($string) {
		$this->string = $string;
	}

	function getString() {
		return $this->string;
	}

	function setType() {
		if ( $this->isFile ($this->uri) ) {
			$this->type = 'file';
		}
        else {
			$this->type = 'url';
		}
	}

	function getType()
        {
		return $this->type;
	}
}

function xmlspecialchars($s)
{
        $s = utf8_decode($s);
	$s = str_replace("<", "NO_CHANGE_LT", $s);
	$s = str_replace(">", "NO_CHANGE_GT", $s);
	$s = str_replace('"', "NO_CHANGE_QUOTE", $s);
	$s = htmlentities($s);
	$s = entityname2number($s);
	$s = str_replace("NO_CHANGE_LT", "<", $s);
	$s = str_replace("NO_CHANGE_GT", ">", $s);
	$s = str_replace("NO_CHANGE_QUOTE", '"', $s);
	return $s;
}
function entityname2number($s)
{

	$f = file_get_contents("../bases/gizmo/entname2number.ini");

	$a = explode("\r\n",$f);
	foreach ($a as  $valor){
		$x = explode("=", $valor);
		$t1[] = $x[0];
		$t2[] = $x[1];
	}
	$s = str_replace($t1, $t2, $s);
	return $s;
}

?>
