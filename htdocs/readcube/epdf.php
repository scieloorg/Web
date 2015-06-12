<?
$doi = $_REQUEST['doi'];
$pid = $_REQUEST['pid'];
$pdf_path = $_REQUEST['pdf_path'];
$lang = $_REQUEST['lang'];
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <noscript>
        <META HTTP-EQUIV="Refresh" CONTENT="0;URL=/pdf/<?=$pdf_path?>">
    </noscript>
    <meta name="DOI" content="<?=$doi?>">
    <meta name="PDF_URL" content="/pdf/<?=$pdf_path?>">
    <?if ($lang != '') {?>
        <meta name="LANG" content="<?=$lang?>">
    <?}?>
</head>    
<body/>
<script src="http://content.readcube.com/scielo/epdf.js" type="text/javascript"></script>
</html>