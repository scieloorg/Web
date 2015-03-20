<?
$doi = $_REQUEST['doi'];
$pid = $_REQUEST['pid'];
$pdf_path = $_REQUEST['pdf_path'];
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <!-- #1 Automatic Redirection to the traditional PDF for browsers with JavaScript disabled -->
    <noscript>
        <META HTTP-EQUIV="Refresh" CONTENT="0;URL=/pdf/<?=$pdf_path?>">
    </noscript>
    <!-- #2 Meta Tag containing DOI -->
    <meta name="DOI" content="<?=$doi?>">
    <!-- #3 Meta Tag containing PDF URL used for client side redirection -->
    <meta name="PDF_URL" content="/pdf/<?=$pdf_path?>">
    <!-- #4 ReadCube Embedded PDF Script -->
</head>    
<body>ReadCube Embedded PDF Endpoint</body>
<script src="http://content.readcube.com/scielo/epdf.js" type="text/javascript"></script>
</html>