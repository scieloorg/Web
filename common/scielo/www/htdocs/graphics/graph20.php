<?php
    include_once ("classLogDatabaseQueryTitle.php");
    
    define ("LOGDEF", "../scielo.def.php");
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
<a href="http://www.scielo.org">
<img alt="Scientific Electronic Library Online" border="0" src="/img/en/scielobre
.gif">
</a>
<br>
<img src="/img/assinat.gif" border="0">
</p>
      
<a name="topten"><h2>Top Ten Titles</h2></a>
<table border="0" align="center" width="600">
<tr><td width="500">
<img src="/graphics/GraphTopTenTitles.php"/>
</td>
</tr></table>



<hr>
<p align="center">
<font class="nomodel" color="#0000A0" size="-2">SciELO - Scientific Electronic L
ibrary Online<br>FAPESP - BIREME<br>Rua Botucatu, 862 - Vila Clementino<br>04023
-901 São Paulo SP - Brasil<br>
                        Tel.: (55 11) 5576-9863<br>
                        Fax: (55 11) 5575-8868</font>
<br>
<a class="email" href="mailto:scielo@bireme.br">
<img src="/img/e-mailt.gif" border="0">
<br>
<font color="#0000A0" size="2">scielo@bireme.br</font>
</a>
</p>
</body>
</html>
