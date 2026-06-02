<?php
$defFile = parse_ini_file(dirname(__FILE__)."/../scielo.def.php","true");
/*
*********** Funções usadas na geração de estatisticas de acesso  ********
************ as paginas da Scielo                                 ********
*/

function scielolog_shell_arg($value) {
	return escapeshellarg((string)$value);
}

function scielolog_safe_int($value, $default = 0) {
	return is_numeric($value) ? (int)$value : (int)$default;
}

function scielolog_bool_arg($expr) {
	if (!preg_match('/^[A-Za-z0-9_ .:$()\/-]+$/', (string)$expr)) {
		$expr = '';
	}
	return scielolog_shell_arg('bool='.$expr);
}

function scielolog_remove_temp_files($prefix) {
	$files = glob($prefix.'.*');
	if (!is_array($files)) {
		return;
	}
	foreach ($files as $file) {
		if (is_file($file)) {
			unlink($file);
		}
	}
}

function scielolog_safe_file_token($value) {
	return preg_replace('/[^A-Za-z0-9_.-]/', '_', (string)$value);
}

function lista_titulos() {
	global $defFile;
	$db_issn=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/issn";
	$result=exec(scielolog_shell_arg($defFile["PATH"]["PATH_PROC"]."/cisis/mx")." ".scielolog_shell_arg($db_issn)." lw=0 ".scielolog_shell_arg("pft=v1,':'v150,'<fim>',")." now");
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
		$result=exec(scielolog_shell_arg($defFile["PATH"]["PATH_PROC"]."/cisis/mx")." ".scielolog_shell_arg($db_issn)." ".scielolog_shell_arg($pid[$i])." lw=0 ".scielolog_shell_arg("pft=v150/")." now");
		$lista[]["title"]=$result;
	}
	return $lista;
}

function monta_proc($access) {
  	$access = scielolog_safe_int($access, 0);
  	return scielolog_shell_arg("proc=if val(v999) < val('$access') then 'd*' fi");
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
	  	$OP=scielolog_shell_arg($defFile["PATH"]["PATH_PROC"]."/cisis/mx")." ".scielolog_shell_arg($db_data)." from=2 count=1 ".scielolog_shell_arg("pft=v1")." now";
	$result=exec($OP);
  	$dti=$result;
	return $dti;
}

function ultima_data($db_data) {
	global $defFile;
	  	$OP=scielolog_shell_arg($defFile["PATH"]["PATH_PROC"]."/cisis/mx")." ".scielolog_shell_arg($db_data)." now +control";
  	$result=exec($OP);
  	$regs=total_registros($result);
	$regs=scielolog_safe_int($regs, 1);
	  	$OP=scielolog_shell_arg($defFile["PATH"]["PATH_PROC"]."/cisis/mx")." ".scielolog_shell_arg($db_data)." from=".$regs." count=1 ".scielolog_shell_arg("pft=v1")." now";
  	$result=exec($OP);
  	$dtf=$result;
  	return $dtf;
}

function busca_mfnini($dti,$db_data) {
        global $defFile;
	  	$OP=scielolog_shell_arg($defFile["PATH"]["PATH_PROC"]."/cisis/mx")." ".scielolog_shell_arg($db_data)." ".scielolog_bool_arg($dti)." ".scielolog_shell_arg("pft=v2'/'")." now";
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
	$OP=scielolog_shell_arg($defFile["PATH"]["PATH_PROC"]."/cisis/mx")." ".scielolog_shell_arg($db_data)." ".scielolog_bool_arg($dtf)." ".scielolog_shell_arg("pft=v2'/'")." now";
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
      return scielolog_bool_arg($str);
   }
   return scielolog_bool_arg($str." and ".$pid);
}

function monta_bool02($pid) {
   if ($pid=='') {
      return scielolog_bool_arg('$');
   }
   return scielolog_bool_arg($pid);
}

function monta_bool_array($pid,$str) {
   if ($pid=='') {
      return scielolog_bool_arg($str);
   }

   $issn="(";
   for ($j=0;$j < count($pid);++$j) {
      $issn=$issn.$pid[$j];
      if (count($pid)!="1" && $j!=(count($pid)-1)) {
         $issn=$issn." or ";
      }
   }
   $issn=$issn.")";
   return scielolog_bool_arg($issn." and ".$str);
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
