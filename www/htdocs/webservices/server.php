<?php


/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Class of WebService of Scielo
 *
 * @author jamilatta
 */
 
require_once('common.php');
require_once("../classDefFile.php");
require_once("../class.XSLTransformer.php");

class scieloWS {

  public $output = "xml";
  private $defFile;
  private $applServer;
  private $regionalScielo;
  private $collection;
  private $country;
  private $databasePath;

  private function getVariableFromDef()
  {

    $transformer = new XSLTransformer();
    $defFile = new DefFile("../scielo.def.php");
    
    $this->applServer = $defFile->getKeyValue("SERVER_SCIELO");
    $this->regionalScielo = $defFile->getKeyValue("SCIELO_REGIONAL_DOMAIN");
    $this->collection = $defFile->getKeyValue("SHORT_NAME");
    $this->country = $defFile->getKeyValue("COUNTRY");
    $this->databasePath = $defFile->getKeyValue("PATH_DATABASE");

  }


  /**
   *
   * @param $expression String
   * @param $from Int
   * @param $count int
   * @param $lang String
   * 
   */
  public function search($expression, $from, $count, $lang)
  {
    $this->getVariableFromDef();
    global $applServer, $output;

    $from = ($from  != "" ? $from  : "1");
    $count= ($count != "" ? $count : "10");

    if ($lang == "es"){
            $iahLang = "e";
    }else{
            if ($lang == "en"){
                    $iahLang = "i";
            }else{
                    $iahLang = "p";
            }
    }

    $serviceUrl   = "http://" . $this->applServer . "/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^dlibrary&exprSearch=" . $expression . "&nextAction=xml&isisFrom=" . $from . "&count=" . $count . "&fmt=citation&lang=" . $iahLang;
    $redirectHtml = "http://" . $this->applServer . "/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^dlibrary&exprSearch=" . $expression . "&lang=" . $iahLang . "&nextAction=lnk&isisFrom=" . $from . "&count=" . $count;
    
    $response = process($serviceUrl, $redirectHtml);
    return $response;
  }
  
  /**
   *
   * @param $count int
   * @param $lang String
   *
   */
  public function new_titles($count, $rep)
  {
    $this->getVariableFromDef();
    global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath ;
    global $colname;
    $count= ($count != "" ? $count : "50");
    $serviceUrl = "http://" . $this->applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=listNewTitles.xis&database=".$this->databasePath ."title/title&gizmo=GIZMO_XML&count=" . $count;
    if ($rep){
            $serviceUrl .="&rep=".$rep;

    }
    $XML = readData($serviceUrl,true);
    $serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
    $serviceXML .= $XML;
    $serviceXML .= '</collection>';
    if ($output == "xml"){
            header("Content-type: text/xml");
            return envelopeXml($serviceXML, $serviceRoot);
    }else{
            return utf8_encode($serviceXML);
    }
    return $serviceXML;
  }
  
  /**
   *
   * @param $count int
   * @param $issn String
   *
   */
  public function new_issues($count, $issn = null)
  {
    $this->getVariableFromDef();
    global $country, $applServer, $output, $transformer, $serviceRoot,$databasePath ;
    global $colname;

    $count= ($count != "" ? $count : "50");
    $serviceUrl = "http://" . $this->applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=listNewIssues.xis&database=".$this->databasePath."issue/issue&gizmo=GIZMO_XML&count=" . $count;
    if(!empty($issn)){
      $serviceUrl .= '&issn=' . $issn;
    }

    $XML = readData($serviceUrl,true);
    $serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
    $serviceXML .= $XML;
    $serviceXML .= '</collection>';
    if ($output == "xml"){
            header("Content-type: text/xml");
            return envelopeXml($serviceXML, $serviceRoot);
    }else{
            return utf8_encode($serviceXML);
    }
    return $serviceXML;
  }

  /**
   *
   * @param $count String
   * @param $rep String
   *
   */
  public function get_titles($type, $rep)
  {
    $this->getVariableFromDef();
    global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath ;
    global $colname;
    $xslName = '';

    $serviceUrl = "http://" . $this->applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=list.xis&database=".$this->databasePath."title/title&gizmo=GIZMO_XML";
    if ($rep){
            $serviceUrl .= "&rep=".$rep;
    }
    $XML = readData($serviceUrl,true);
    if ($rep) {
      $serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
      $serviceXML .= $XML;
      $serviceXML .= '</collection>';
    } else {
      $serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
      $serviceXML .= '<indicators>';
      $serviceXML .= '<journalTotal>'.getIndicators("journalTotal").'</journalTotal>';
      $serviceXML .= '<articleTotal>'.getIndicators("articleTotal").'</articleTotal>';
      $serviceXML .= '<issueTotal>'.getIndicators("issueTotal").'</issueTotal>';
      $serviceXML .= '<citationTotal>'.getIndicators("citationTotal").'</citationTotal>';
      $serviceXML .= '</indicators>';
      $serviceXML .= $XML;
      $serviceXML .= '</collection>';
    }
    if ($output == "xml"){
            header("Content-type: text/xml");
            return envelopeXml($serviceXML, $serviceRoot);
    }else{
            return $serviceXML;
    }
    return $serviceXML;
  }
  
  /**
   *
   * @param $type String
   * @param $rep String
   * @param $issn String
   *
   */
  public function get_title_indicators($type, $rep, $issn)
  {
    $this->getVariableFromDef();
    global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath;
    global $colname;
    $xslName = '';

    $serviceUrl = "http://" . $this->applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=search.xis&database=".$this->databasePath."/title/title&search=LOC=".$issn."$&gizmo=GIZMO_XML&count=1";
    if ($rep){
      $serviceUrl .= "&rep=".$rep;
    }
    $XML = readData($serviceUrl,true);

    $serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
    $serviceXML .= '<journalIndicators>';
    $serviceXML .= '<articleTotal>'.getIndicators("journalArticleTotal",$issn).'</articleTotal>';
    $serviceXML .= '<issueTotal>'.getIndicators("journalIssueTotal",$issn).'</issueTotal>';
    $serviceXML .= '<citationTotal>'.getIndicators("journalCitationTotal",$issn).'</citationTotal>';
    $serviceXML .= '</journalIndicators>';
    $serviceXML .= $XML;
    $serviceXML .= '</collection>';

    if ($output == "xml"){
      header("Content-type: text/xml");
      return envelopeXml($serviceXML, $serviceRoot);
    }else{
      return utf8_encode($serviceXML);
    }
    return $serviceXML;
  }

  /**
   * Get all titles contained at the issn array
   * @param $issn array
   */
  public function getDetachedTitles($issn)
  {
    $this->getVariableFromDef();
    global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath ;
    global $colname;

    if(is_array($issn)){
      $issnTmp='';
      foreach($issn as $key => $value){
          if($key > 0){
              $issnTmp .= ' or ';
          }
          $issnTmp .= 'LOC='.$value;
      }
      $issnString = $issnTmp;
    }else{
        $issnString = 'LOC='.$issn;
    }

    $serviceUrl = "http://" . $this->applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=detached.xis&database=".$this->databasePath."title/title&gizmo=GIZMO_XML&search=".$issnString;
    $XML = readData($serviceUrl,true);
    $journalTotal=getElementValue(getElementValue(str_replace("<hr>","<hr />",$XML) , "Isis_Total"),"occ");

    $serviceXML .= '<?xml version="1.0" encoding="ISO-8859-1"?>';
    $serviceXML .= '<SciELOWebService version="1.0">';
    $serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
    $serviceXML .= '<indicators>';
    $serviceXML .= '<journalTotal>'.$journalTotal.'</journalTotal>';
    $serviceXML .= '<articleTotal>'.getIndicators("articleTotal",$issn).'</articleTotal>';
    $serviceXML .= '<issueTotal>'.getIndicators("issueTotal",$issn).'</issueTotal>';
    $serviceXML .= '<citationTotal>'.getIndicators("citationTotal",$issn).'</citationTotal>';
    $serviceXML .= '</indicators>';
    $serviceXML .= $XML;
    $serviceXML .= '</collection>';
    $serviceXML .= '</SciELOWebService>';

    return $serviceXML;
  }
}

  $server = new SoapServer("wsdl/scielo.wsdl");
  $server->setClass("scieloWS");
  $server->handle();

?>
