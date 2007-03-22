<?php	    
    //error_reporting(E_ALL ^ E_NOTICE);
    include ("classScielo.php");

    // Create new Scielo object
	$host = $HTTP_HOST;    
    $scielo = new Scielo ($host);
	putenv("ENV_SOCKET=false"); //socket
	$CACHE_STATUS = $scielo->_def->getKeyValue("CACHE_STATUS");
	$MAX_DAYS = $scielo->_def->getKeyValue("MAX_DAYS");
	$MAX_SIZE = $scielo->_def->getKeyValue("MAX_SIZE");

	if (($CACHE_STATUS == 'on') && ($MAX_DAYS>0)){
		$filenamePage = $scielo->GetPageFile();
	}

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
                	fclose($fp);
				}
			} else {
				echo "<!-- fora do prazo $time -->";
                $GRAVA = true;
            }
        } else {
			/*
				tratar quando não existe espaço:
				apagar
				gravar novo
				MAX_SIZE
			*/
		}
	}
	if (!$pageContent){
    // Generate wxis url and set xml url
        $xml = $scielo->GenerateXmlUrl();
        $scielo->SetXMLUrl ($xml);

    // Generate xsl url and set xsl url
        $xsl = $scielo->GenerateXslUrl();
        $scielo->SetXSLUrl ($xsl);

        $pageContent = $scielo->getPage().'<!-- '.$filenamePage.'-->'.'<!-- '.$REQUEST_URI.'-->';
        //$valid = false;
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
    echo showDivulgacao($lng, $script);
	echo $pageContent;
	

 function showDivulgacao($lang, $script){
         echo '<!--';
         var_dump($lang);
         echo '-->';
         /*switch ($script){
                 case "sci_arttext":
                 case "sci_abstract":
                         $permission = true;
                         break;
         }
         if ($permission){
         */
         $filenamePage = getDivulgacao($lang, $script);
                 $fp = fopen($filenamePage, "r");
                 if ($fp){
//echo '<!--fp -->';
//echo '<!--'.filesize($filenamePage).'-->';
                         $pageContent = fread($fp, 9999);
                         //$pageContent = '<!--'.$pageContent.'-->';
                 fclose($fp);
                 }
         //}
         return $pageContent;
 }
 function getDivulgacao($lang, $script){
         if (file_exists("divulgacao.txt")){
//              echo '<!--existe-->';
                 $divulgacao = parse_ini_file("divulgacao.txt",true);
/*              echo '<!--';
         var_dump($divulgacao);
         echo '-->';
*/
                 $html = $divulgacao[$script][$lang];
/*              echo '<!--';
         var_dump($html);
         echo '-->';
*/
         }
         return $html;
 }

function dir_size($dir, &$older, &$older_accessed)
{
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



function wxis_exe ( $url )
{
        if (strpos($url,'debug=')==0){
                $request = "/home/scielo/www/cgi-bin/wxis.exe " ;
                $param = substr($url, strpos($url, "?")+1);
                $param = str_replace("&", " ", $param);
                $request = $request.$param." PATH_TRANSLATED=/home/scielo/www/htdocs/ ";
                $r = shell_exec($request);
//$PID = shell_exec("nohup $request);
//echo $PID;
        } else {
                $r = $url;
        }
        return $r;
}


?>

