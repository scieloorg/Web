<?php
$defFile = parse_ini_file(dirname(__FILE__)."/../scielo.def.php","true");
?>
<html>
<head>
<title>SciELO - Scientific electronic library online</title>
<link rel="STYLESHEET" type="text/css" href="/css/scielo.css">

<script language="javascript" src="someFunctions.js">
</script>
<script>


<!--
function myWindow(year)
{
	img = "GraphPlotArticleYear.php?year=" + year;
	CreateWindowHeader("SciELO Statistics",img,"en");
	CreateWindowFooter();
	OpenWindow();
	return true;
}
-->

</script>
</head>
<body link="#000080" vlink="#800080" bgcolor="#ffffff">
<p align="center">
<a href="/">
<img alt="Scientific Electronic Library Online" border="0" src="/img/es/scielobre.gif">
</a>
<br>
<img src="/img/assinat.gif" border="0">
</p>
      
<a name="topten"><h2>Ranking de revistas mas visitadas</a>
<table border="0" align="center" width="600">
<tr><td width="500">
<img src="scielograph20.php"/>
</td>  </tr></table>
<hr>

<p align="center">
&#169;
<font class="nomodel" size="-1">
<?php
echo(date('Y')); 
?>
</font>
<i><font class="nomodel" color="#0000A0" size="-1"><?=$defFile["SITE_INFO"]["SHORT_NAME"]?><br></i>
<img src="/img/en/e-mailt.gif" alt="<?=$defFile["SITE_INFO"]["E_MAIL"]?>" border="0"><br>
<a class="email" href="<?=$defFile["SITE_INFO"]["E_MAIL"]?>"><?=$defFile["SITE_INFO"]["SHORTE_MAIL"]?></a>
</center>

</body>
</html>
