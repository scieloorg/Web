<?php

class XSLTransformerPHP5 {
  var $xsl, $xml, $output, $error, $errorcode, $processor, $uri, $host, $port, $byJava;

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

    if(!$this->processor->hasExsltSupport())
    {
      die ('No xslt support');
    }

    $domXml = new DOMDocument();
    $domXml->loadXML(trim($xml));

    $domXsl = new DOMDocument();
    $domXsl->load($xsl);

    $this->processor->importStylesheet($domXsl);

    $result =  $this->processor->transformToXML($domXml);

    if(!$result)
    {
      trigger_error('XSL transformation failed.', E_USER_ERROR);
    }

    return $result;

    }
}
?>