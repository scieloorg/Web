<?php

class XSLTransformerPHP5 {
  var $xsl, $xml, $output, $error, $errorcode, $processor, $uri, $host, $port, $byJava;

  function __construct() {
    $this->XSLTransformerPHP5();
  }

  function XSLTransformerPHP5() {
    $this->processor = new XSLTProcessor();
  }

  function setXslBaseUri($uri){
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
      $error = 'No xslt support';
      return false;
    }

    $domXml = new DOMDocument();
    $xml = trim((string)$xml);
    if ($xml === '') {
      $error = 'Empty XML input';
      return false;
    }
    $prev = libxml_use_internal_errors(true);
    $loadedXml = $domXml->loadXML($xml);
    if (!$loadedXml) {
      $errs = libxml_get_errors();
      $msg = isset($errs[0]) ? trim($errs[0]->message) : 'Invalid XML input';
      libxml_clear_errors();
      libxml_use_internal_errors($prev);
      $error = $msg;
      return false;
    }

    $domXsl = new DOMDocument();
    if (!$domXsl->load($xsl)) {
      libxml_clear_errors();
      libxml_use_internal_errors($prev);
      $error = 'Could not load XSL stylesheet';
      return false;
    }

    if (!$this->processor->importStylesheet($domXsl)) {
      libxml_clear_errors();
      libxml_use_internal_errors($prev);
      $error = 'Could not import XSL stylesheet';
      return false;
    }

    $result =  $this->processor->transformToXML($domXml);
    libxml_clear_errors();
    libxml_use_internal_errors($prev);

    if(!$result)
    {
      $error = 'XSL transformation failed';
      return false;
    }

    return $result;

    }
}
?>
