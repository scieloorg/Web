<?php 
$hojeAno=date("y");
$hojeMes=date("m");
$hojeDia=date("d");
$hojeHora=date("H");
$hojeMin=date("i");

$pid=$_REQUEST['pid'];
$app=$_REQUEST['app'];
$page=$_REQUEST['page'];
$issn=$_REQUEST['issn'];
$lang=$_REQUEST['lang'];
$norm=$_REQUEST['norm'];
$tlng=$_REQUEST['tlng'];
$doctopic=$_REQUEST['doctopic'];
$doctype=$_REQUEST['doctype'];

$ip = getenv("REMOTE_ADDR"); 

$defFile = parse_ini_file(dirname(__FILE__)."/../scielo.def.php","true");
$base="\$TRAB/log".$hojeAno.$hojeMes.$hojeDia;
$filename=$defFile["LOG"]["ACCESSSTAT_LOG_DIRECTORY"]."/program_log".$hojeAno.$hojeMes.$hojeDia.".txt";
   
// Split PID into ISSN and ORD

$pidUP=strtoupper($pid);

$init_pos = ($pidUP[0]=="S")? 1:0;
$issn = substr($pidUP,$init_pos,9);

$init_pos = ($pidUP[0]=="S")? 10:9;
$ord  = substr($pidUP,$init_pos);

// Cria arquivos no diretorio de log
$data=date("Y").$hojeMes.$hojeDia.$hojeHora.$hojeMin;
$hostname = gethostbyaddr($ip);
$prc="\"proc='<1 0>$app</1><2 0>$page</2><3 0>$issn</3><4 0>$lang</4><5 0>$norm</5>";
$prc=$prc."<6 0>$data</6><7 0>$ip</7><8 0>$ord</8><9 0>$hostname</9><10 0>$doctopic</10><11 0>$doctype</11><12 0>$tlng</0>',\"";
$OP1="\$UTL/mx null count=1 append=$base $prc";

$handle = fopen($filename, 'a');
$err=$OP1." \n";  
fwrite($handle, $err);
fclose($handle);

?> 


