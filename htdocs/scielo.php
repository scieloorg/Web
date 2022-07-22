<?php

  require_once("classScielo.php");
  require_once('applications/scielo-org/sso/header.php');

  // Create new Scielo object
  $host = $_SERVER['HTTP_HOST'];
  $scielo = new Scielo($host);

  // NEW_WEBSITE_URL=www.scielo.br (scielo.def.php)
  $NEW_WEBSITE_URL = $scielo->_def->getKeyValue("NEW_WEBSITE_URL");
  if ($NEW_WEBSITE_URL && $_SERVER['SCRIPT_NAME']=='/scielo.php') {
    header("Location: https://" . $NEW_WEBSITE_URL . $_SERVER['REQUEST_URI']);
  }

  $CACHE_STATUS = $scielo->_def->getKeyValue("CACHE_STATUS");
  $MAX_DAYS = $scielo->_def->getKeyValue("MAX_DAYS");
  $MAX_SIZE = $scielo->_def->getKeyValue("MAX_SIZE");
  $DIVULGA = $scielo->_def->getKeyValue("ENABLE_DIVULGACAO");

  if (($CACHE_STATUS == 'on') && ($MAX_DAYS>0)){
          $filenamePage = $scielo->GetPageFile();
  }

  
  $filenamePage = "";
  $pageContent = "";
  $GRAVA = false;
  
  if ($filenamePage){
    if (file_exists($filenamePage)){
        echo "<!-- EXISTE $filenamePage -->";
        $lastChange = date("F j Y g:i:s", filemtime($filenamePage));
        $diff = dateDiff($interval="d",$lastChange,date("F j Y g:i:s"));
     if ($diff<=$MAX_DAYS){
        echo "<!-- dentro do prazo $time -->";
        $fp = fopen($filenamePage, "r");
      if ($fp){
        $pageContent = fread($fp, filesize($filenamePage));
        $pageContent .= "\n".'<!-- Cache File name: '.$filenamePage.'-->';
        fclose($fp);
      }
     } else {
      echo "<!-- fora do prazo $time -->";
      $GRAVA = true;
     }
    }
  }
  
  if (!$pageContent){
    
  //Generate wxis url and set xml url
  $xml = $scielo->GenerateXmlUrl();
  if ((strpos($xml, '</') == 0) or (strpos($xml, '</CONTROLINFO>') == 0)) {
    $xml = '<ERROR></ERROR>';
  }

  $sxml = simplexml_load_string($xml);

  function xml_tostring($value) {
      return (string)$value;
  }
  function is_requested_language_available($sxml) {
      $availableLanguages = array_merge(
          $sxml->xpath('/root/SERIAL/ISSUE/ARTICLE/@ORIGINALLANG'), 
          $sxml->xpath('/root/SERIAL/ISSUE/ARTICLE/LANGUAGES/ART_TEXT_LANGS/LANG')
      );
      $availableLanguages = array_map('xml_tostring', $availableLanguages);
      $requestedLanguage = array_pop(
          array_map(
              'xml_tostring', 
              $sxml->xpath('/root/SERIAL/ISSUE/ARTICLE/@TEXTLANG')
          )
      );
      
      return in_array($requestedLanguage, $availableLanguages);
  }

  /*
   * Quando o texto não estiver disponível no idioma solicitado o site deve
   * redirecionar (HTTP 302) o cliente para o idioma padrão.
   */
  if ($_REQUEST['script'] == 'sci_arttext') {
      if (!is_requested_language_available($sxml)) {
          $documentPID = array_pop(
              array_map(
                  'xml_tostring', 
                  $sxml->xpath('/root/SERIAL/ISSUE/ARTICLE/@PID')
              )
          );
          header('Location: /scielo.php?script=sci_arttext&pid='.$documentPID, true, 301);
          exit;
      }
  }

  
  if ($sxml != false){
     $error = (($sxml->getName() == 'ERROR') or ($sxml->ERROR->getName() == 'ERROR'));
  }

  if ($error){
    header("HTTP/1.0 404 Not Found - Archive Empty");
    require '404.html';
    exit;
  }

  $scielo->SetXMLUrl ($xml);

  //Generate xsl url and set xsl url
  $xsl = $scielo->GenerateXslUrl();
  $scielo->SetXSLUrl ($xsl);
  
  $pageContent = $scielo->getPage();
  
  $pageContent .= "\n".'<!-- REQUEST URI: '.$REQUEST_URI.'-->';
  $pageContent .= "\n"."<!--SERVER:".$SERVER_ADDR."-->";

  if ($GRAVA && $filenamePage){
    if (!file_exists($filenamePage)){
            include ("mkdir.php");
            $path = substr($filenamePage, 0, strrpos($filenamePage, '/'));
    createDirStructure($path, $s_root, $s_err_msg, $i_err_code, 0777);
    }
    $fp = fopen($filenamePage, "rw");
  if ($fp){
          fwrite($fp, $pageContent);
                  echo "<!-- gravou -->";
          } else {
                  echo "<!-- nao gravou $filenamePage -->";
          }
  fclose($fp);
  chmod($filenamePage, 0774);
    }
  }
  if(isset($_GET['download']))
  {
          require_once(dirname(__FILE__)."/export.php");
          exit;
  }

  if ( !$scielo->_request->getRequestValue ( "lng", $lng ) )
          {
              $lng = $scielo->_def->getKeyValue ( "STANDARD_LANG" );
          }
  if ($DIVULGA){
          $html_divulgacao = showDivulgacao($lng,$scielo->_script);
          if (strlen($html_divulgacao) > 0) {
            $p = strpos(strtolower($pageContent), '<body');
            if ($p > 0) {
              $body = substr($pageContent, $p);
              $p2 = strpos($body, '>');
              if ($p2 > 0) {
                $body = substr($body, 0, $p2+1);
                $p3 = strpos(strtolower($pageContent), strtolower($body));
                if ($p3 > 0) {
                  $p3 = $p3 + strlen($body);
                  $newPageContent = substr($pageContent, 0, $p3).'<!-- start divulgacao -->';
                  $newPageContent .= $html_divulgacao.'<!-- end divulgacao -->';
                  $newPageContent .= substr($pageContent, $p3);
                  $pageContent = $newPageContent;
                }
              }
            }
          }
  }
  if (strpos($pageContent,'<?xml-stylesheet')>0) {
  /* nao retirar isso, senao a conversao de formulas matematicas nao funcionara */
          header("Content-type:text/xml");
  }
  
  echo $pageContent;


function showDivulgacao($lang, $script){
           $pageContent = "";
           $filenamePage = getDivulgacao($lang, $script);
           $fp = fopen($filenamePage, "r");
           if ($fp){
               $pageContent = fread($fp, 9999);
                   fclose($fp);
              $p = strpos($pageContent, '<body');
              if ($p > 0) {
                $body = substr($pageContent, $p);
                $p = strpos($body, '>');
                if ($p > 0) {
                  $body = substr($body, $p+1);
                  $p = strpos($body, '</body>');
                  if ($p > 0){
                    $body = substr($body, 0, $p-1);
                    $pageContent = $body;
                  }
                }
              }
           }
   return $pageContent;
}

function getDivulgacao($lang, $script){
          $html = "";
           if (file_exists("divulgacao.txt")){
           $divulgacao = parse_ini_file("divulgacao.txt",true);
           $html = $divulgacao[$script][$lang];
   }
   return $html;
}

function dir_size($dir, &$older, &$older_accessed){
  $handle = opendir($dir);
  $mas = 0;
  while ($file = readdir($handle)) {
  if ($file != '..' && $file != '.'){
                  if (is_dir($dir.'/'.$file)){
                          $mas += dir_size($dir.'/'.$file, $older, $older_accessed);
                  } else {
                          $mas += filesize($dir.'/'.$file);
                          if ($older!=''){
                                  if (fileatime($dir.'/'.$file)<fileatime($older)){
                                          $older = $dir.'/'.$file;
                                  }
                          } else {
                                  $older = $dir.'/'.$file;
                          }
                          if ($older_accessed!=''){
                                  if (fileatime($dir.'/'.$file)<fileatime($older_accessed)){
                                          $older_accessed = $dir.'/'.$file;
                                  }
                          } else {
                                  $older_accessed = $dir.'/'.$file;
                          }
                  }
          }
}
  return $mas; // bytes
}

function dateDiff($interval="d",$dateTimeBegin,$dateTimeEnd) {
   //Parse about any English textual datetime
   //$dateTimeBegin, $dateTimeEnd

   $dateTimeBegin=strtotime($dateTimeBegin);
   if($dateTimeBegin === -1) {
     return("..begin date Invalid");
   }

   $dateTimeEnd=strtotime($dateTimeEnd);
   if($dateTimeEnd === -1) {
     return("..end date Invalid");
   }

   $dif=$dateTimeEnd - $dateTimeBegin;

   switch($interval) {
     case "s"://seconds
         return($dif);

     case "n"://minutes
         return(floor($dif/60)); //60s=1m

     case "h"://hours
         return(floor($dif/3600)); //3600s=1h

     case "d"://days
         return(floor($dif/86400)); //86400s=1d

     case "ww"://Week
         return(floor($dif/604800)); //604800s=1week=1semana

     case "m": //similar result "m" dateDiff Microsoft
         $monthBegin=(date("Y",$dateTimeBegin)*12)+
           date("n",$dateTimeBegin);
         $monthEnd=(date("Y",$dateTimeEnd)*12)+
           date("n",$dateTimeEnd);
         $monthDiff=$monthEnd-$monthBegin;
         return($monthDiff);

     case "yyyy": //similar result "yyyy" dateDiff Microsoft
         return(date("Y",$dateTimeEnd) - date("Y",$dateTimeBegin));

     default:
         return(floor($dif/86400)); //86400s=1d
   }

 }

function wxis_exe ($url){
  global $wxisServer;
  global $scielo;

  $useCache = $scielo->_def->getKeyValue("ENABLED_CACHE");
  $restrito = false;

  if($_SERVER['SCRIPT_NAME']=='/scielolog.php'){
          $chave = $chaveNula;
          $restrito = true;
  }
  //verificando se usuario esta logado para utilizar o cacke, se estiver logado cache nao pode ser utilizado
  //isso ocorre apenas para sci_arttext e sci_abstract

  if (isset($_COOKIE["userID"]) && $_COOKIE["userID"] != "-2"){
          if ($_REQUEST["script"] == 'sci_arttext' or $_REQUEST["script"] == 'sci_abstract' or $_REQUEST["script"] == 'sci_home'  or $_REQUEST["script"] == ''){
                  $restrito = true;
                  $useCache == '0';
          }
  }

  if(($useCache == '1') && (!$restrito)){
          require_once('cache.php');

          if(strpos($_SERVER['REQUEST_URI'],'deletefromcache')){
                  $key = sha1(substr($_SERVER['REQUEST_URI'],0,strpos($_SERVER['REQUEST_URI'],'deletefromcache')-1));
                  echo 'apagando chave '.$key.'XML resultado :'.deleteFromCache($key.'XML');
                  echo '<hr>';
                  echo 'apagando chave '.$key.'HTML resultado :'.deleteFromCache($key.'HTML');
                  die();
          }

          if(strpos($_SERVER['REQUEST_URI'],'cachestats')){
                  echo getStatsFromCache($_GET['type'], $_GET['slabs'], 10);
                  die();
          }

          $result = "";
          $chave = sha1($_SERVER['REQUEST_URI']).'XML';
          $chaveNula = '42099b4af021e53fd8fd4e056c2568d7c2e3ffa8XML';
          $result = false;
          //a chave pode ver como XML por exemplo na home, quanto não há parametros na
          //URL, para evitar problemas, não colocamos essa chave em cache posis não podemos
          //prever quando essa situação poderá ocorrer novamente
          if($chave != $chaveNula){
                  //pesquisa no cache a chave
                  $result = getFromCache($chave);

                  if($result == false){
                          //se não achou, transforma, coloca no cache e retorna
                          $result = wxis_exe_($url);
                          addToCache($chave,$result);
                  }
          }else{
                  //se chave == XML então retorna o XML, sem passar pelo cache
                  $result = wxis_exe_($url);
          }
  }else{
          //se cache desligado então retorna a transformação, sem passar pelo cache
          $result = wxis_exe_($url);
  }

  return $result;
}

//wxis-line-command
function wxis_exe_ ($url){

  // Criar um novo Objeto Scielo
  $host = $_SERVER['HTTP_HOST'];
  $scielo = new Scielo ($host);

  /************************************************************************************
  * Pegamos o path do htdocs, isso é importante porque deixamos mais configuráveis  *
  * os diferentes scielos não precisando mexer na scielo.php, somente no scielo.def.php *
  ************************************************************************************/
  $PATH_HTDOCS = $scielo->_def->getKeyValue("PATH_HTDOCS");

  $request = $PATH_HTDOCS."../cgi-bin/wxis.exe " ;
  $param = substr($url, strpos($url, "?")+1);
  $param = str_replace("&", " ", $param);
  $request = $request.$param." PATH_TRANSLATED=".$PATH_HTDOCS;

  $r = strstr(shell_exec($request), '<');
  return $r;
}

function wxis_exe_httpd ($url){
  global $wxisServer;
  global $scielo;
  if (strpos($url,'debug=')==false && strpos($url, 'script=sci_verify')==false){

          $fp = fopen($url,"rb");

          $conteudo = "";
          do {
                  $data = fread($fp, 8192);
                  if (strlen($data) == 0) {
                          break;
                  }
                  $conteudo .= $data;
          } while(true);
          fclose ($fp);

          $url = $conteudo;

  }
return $url;
}

/**
* Inclusão do arquivo gerador de log de usuários autenticados somente se o serviço estiver habilitado no scielo.def, e existir o cookie userID
*/
if($scielo->_def->getKeyValue("ENABLE_AUTH_USERS_LOG") == 1){
  if(isset($_COOKIE['userID']) && $_COOKIE['userID']!= -2 ){
          require_once(dirname(_FILE_)."/applications/scielo-org/ajax/AuthupdateLog.php");
  }
}


?>
