<?php

class XSLTransformerPHP5 
{
  var $xsl, $xml, $output, $error, $errorcode, $processor, $uri, $host, $port, $byJava;   

  function __construct()
  {
    $this->XSLTransformerPHP5();
  }

  function XSLTransformerPHP5()
  {
    $this->processor = new XSLTProcessor();
  }

  function setXslBaseUri($uri)
  {
    if ($uri != ""){
            if (strpos(' '.$uri,'file://')==0) $uri = 'file://'.$uri; 
    }
    return true;
  }

  function transform($xml, $xsl, &$error)
  {
    $error = "";

    if(!$this->processor->hasExsltSupport())
    {
      die ('No xslt support');
    }

    $domXml = new DOMDocument("1.0", "ISO-8859-1");
    if (!$domXml->loadXML(trim($xml))) {
      $error = "Invalid XML input";
      return false;
    }

    if (!file_exists($xsl)) {
      $fallback = dirname(__FILE__) . "/xsl/" . basename($xsl);
      if (file_exists($fallback)) {
        $xsl = $fallback;
      }
    }

    $domXsl = new DOMDocument("1.0", "ISO-8859-1");
    if (!$domXsl->load($xsl)) {
      $error = "Could not load XSL file: ".$xsl;
      return false;
    }

    if (!$this->processor->importStylesheet($domXsl)) {
      $error = "Could not import XSL stylesheet";
      return false;
    }

    $result =  $this->processor->transformToXML($domXml);

    if(!$result)
    {
      $error = 'XSL transformation failed.';
      return false;
    }

    return $result;
    
    }
}
?>
