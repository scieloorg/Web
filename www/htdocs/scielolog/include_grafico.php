<?php
$defFile = parse_ini_file(dirname(__FILE__)."/../scielo.def.php","true");
/*
*********** Funções usadas na geração de estatisticas de acesso  ********
************ as paginas da Scielo                                 ********
*/

function lista_titulos() {
	global $defFile;
	$db_issn=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/issn";
	$result=exec($defFile["PATH"]["PATH_PROC"]."/cisis/mx $db_issn lw=0 \"pft=v1,':'v150,'<fim>',\" now");
	$array_linha=split("<fim>",$result);
	for ($i=0;$i < count($array_linha);++$i) {
  	if ($array_linha[$i]!='') {
		$array=explode(":",$array_linha[$i]);
		$lista[]=array("issn"=>$array[0],"title"=>$array[1]);
		}
	}
	return $lista;
}

function get_titulo($pid) {
	global $defFile;
	$db_issn=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/issn";
	for ($i=0;$i < count($pid);$i++) {
		$result=exec($defFile["PATH"]["PATH_PROC"]."/cisis/mx $db_issn \"$pid[$i]\" lw=0 \"pft=v150/\" now");
		$lista[]["title"]=$result;
	}
	return $lista;
}

function monta_proc($access) {
  	if ($access=='') { $access=0; }
  	$proc_access="\"proc=if val(v999) < val('$access') then 'd*' fi\"";
  	return $proc_access;  
}

function total_registros($result) {
	$array_regs=split(" ",$result);
	for ($i=0;$i < count($array_regs);++$i) {
	   if ($array_regs[$i]!='') {
	       $regs=$array_regs[$i]-1;
	   	   $i=count($array_regs);
	   }  
	}
  return $regs;	
}

function primeira_data($db_data) {
	global $defFile;
  	$OP=$defFile["PATH"]["PATH_PROC"]."/cisis/mx $db_data from=\"2\" count=\"1\" \"pft=v1\" now";
	$result=exec($OP);
  	$dti=$result;
	return $dti;
}

function ultima_data($db_data) {
	global $defFile;
  	$OP=$defFile["PATH"]["PATH_PROC"]."/cisis/mx $db_data now +control";
  	$result=exec($OP);
  	$regs=total_registros($result);
  	$OP=$defFile["PATH"]["PATH_PROC"]."/cisis/mx $db_data from=$regs count=\"1\" \"pft=v1\" now";
  	$result=exec($OP);
  	$dtf=$result;
  	return $dtf;	
}

function busca_mfnini($dti,$db_data) {
        global $defFile;
  	$OP=$defFile["PATH"]["PATH_PROC"]."/cisis/mx $db_data \"bool=$dti\" \"pft=v2'/'\" now";
  	$result=exec($OP);
  	$array_mfn=split("/",$result);
  	$mfn_ini=$array_mfn[0];
  	if ($mfn_ini=="Hits=0") {
		$mfn_ini = 0;
  	} 
  	return $mfn_ini;	
}

function busca_mfnfim($dtf,$db_data) {
        global $defFile;
	$OP=$defFile["PATH"]["PATH_PROC"]."/cisis/mx $db_data \"bool=$dtf\" \"pft=v2'/'\" now";
	$result=exec($OP);
	$array_mfn=split("/",$result);
	$mfn_fim=$array_mfn[1];
		if ($mfn_fim=="") {
    		$mfn_fim='99999999';
 		}
	return $mfn_fim;
}	

function arredonda($var1) {
	$len=strlen($var1)-1; 
	$int=substr($var1, 0, 1);
	for($i;$i<$len;$i++) {
	   $int=$int."0";
	}
	return $int; 
}

function calcula_list_box($val) {
	$val01=arredonda($val);
	for ($j=0,$i=1;$i<=5 && $val01>=10;$i++,$j++) {
	    $lista[$j]=arredonda($val01/2);
		$val01=$lista[$j];
	}
	for ($i=0;$i < count($lista);++$i)  {
	    $list_box=$list_box.$lista[$i];
		if ($i!=(count($lista)-1)) {
			$list_box=$list_box.",";
		}
	}
	return $list_box;
}

function calcula_list_box_XML($val) {
	$val01=arredonda($val);
	for ($j=0,$i=1;$i<=5 && $val01>=10;$i++,$j++) {
	    $lista[$j]=arredonda($val01/2);
		$val01=$lista[$j];
	}
	for ($i=0;$i < count($lista);++$i)  {
	    $list_box.="<OPTION>$lista[$i]</OPTION>\n";
	}
	return $list_box;
}

function calcula_from($cpage,$nlines) {
  if ($cpage==1) { 
     $from=1;  }
  else {
     $from=(($cpage-1)*$nlines)+1; }
 
  return $from;
}

function monta_bool($pid,$str) {
   if ($pid=='') {
      $bool="\"bool=$str\"";
   } else {
      $bool="\"bool=$str and $pid\"";
   }
   return $bool;
}

function monta_bool02($pid) {
   if ($pid=='') {
      $bool="\"bool=$\"";
   } else {
      $bool="\"bool=$pid\"";
   }
   return $bool;
}

function monta_bool_array($pid,$str) {
   if ($pid=='') {
      $bool="\"bool=$str\"";
   } else {
   	  $issn="(";
      for ($j=0;$j < count($pid);++$j) {
	  	$issn=$issn.$pid[$j];
		if (count($pid)!="1" && $j!=(count($pid)-1)) {
		  $issn=$issn." or ";		
		}
	  }
	  $issn=$issn.")";
	  $bool="\"bool=$issn and $str\"";
   }
   return $bool;
}

function calcula_next($cpage,$tot_pags) {
        if ($cpage==$tot_pags) {
                $next=$tot_pags;
        } else {
                $next=$cpage+1;
        }
        return $next;
}

function calcula_previous($cpage,$tot_pags) {
        if ($tot_pags=='1') {
                $previous='1';
        } else {
                $previous=$cpage-1;
        }
        return $previous;
}

?>
