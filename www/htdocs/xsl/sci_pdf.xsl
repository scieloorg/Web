<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:include href="sci_navegation.xsl"/>

<xsl:output method="html" indent="no" />


<xsl:template match="SERIAL">
	<html>
		<head>
			<title>
				<xsl:value-of select="TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/> - PDF Download - Art. ID <xsl:value-of select="ARTICLE/@PID" />
			</title>
			<meta http-equiv="Pragma" content="no-cache" />
			<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
			
			<meta>
				<xsl:attribute name="name">added</xsl:attribute>
				<xsl:attribute name="content">7;URL=<xsl:value-of select="CONTROLINFO/PDF" /></xsl:attribute>
				<xsl:attribute name="http-equiv">refresh</xsl:attribute>
			</meta>

			<link rel="STYLESHEET" type="text/css" href="/css/scielo.css" />
			<style type="text/css">
				a { text-decoration: none; }
			</style>
		</head>
		<body bgColor="#ffffff">
			<table cellspacing="0" border="0" cellpadding="7" width="100%">
			<tr>
			<td width="26%" valign="TOP">
				<p align="CENTER">
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php/lng_<xsl:value-of 
							select="CONTROLINFO/LANGUAGE" /></xsl:attribute>

						<img>
							<xsl:attribute name="src"><xsl:value-of select="CONTROLINFO/SCIELO_INFO/PATH_GENIMG" />fbpelogp.gif</xsl:attribute>
							<xsl:attribute name="border">0</xsl:attribute>
							<xsl:attribute name="alt">Scientific Electronic Library Online</xsl:attribute>
						</img>
					</a><br/>
				</p>
				<p>&#160;</p>
			</td>
			<td width="74%" valign="TOP">
				<p>
					<font size="4" color="#000080"><b><xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes" /></b></font><br/>
					
					<font size="2" color="#000080">
						<xsl:apply-templates select="ISSN">
							<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)" />											</xsl:apply-templates>
					</font>
					
				</p>
				<p align="LEFT">
					<font size="3" color="#800000"><b>PDF Download</b></font>
				</p>
			</td>
			</tr>
			</table>
			<table border="0" width="100%">
			<tr>
			<td width="10%">&#160;</td>
			<td width="80%">
				<p align="LEFT">
					<font size="3" color="#000080"><b>Initiating download of PDF file in 10 seconds. Please wait!</b></font>
				</p>
				
				<xsl:apply-templates select="ARTICLE">
					<xsl:with-param name="NORM" select="normalize-space(CONTROLINFO/STANDARD)" />
					<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)" />
				</xsl:apply-templates>
				
				<p align="CENTER"><br/></p>
			</td>
			<td width="10%">&#160;</td>
			</tr>
			</table>
			<xsl:apply-templates select="." mode="footer-journal"/>
			
		</body>
	</html>
</xsl:template>

<xsl:template match="ARTICLE">
	<xsl:param name="NORM" />
	<xsl:param name="LANG" />
	
	<table border="0" width="100%">
	<tr>
	<td width="8%">&#160;</td><td width="82%">
    <p align="LEFT">&#160;<br/></p>			
	<p>	
	
	<!--xsl:apply-templates select="AUTHORS">
		<xsl:with-param name="NORM" select="$NORM" />
		<xsl:with-param name="LANG" select="$LANG" />
		<xsl:with-param name="FORMAT" select="'pdf'" />
	</xsl:apply-templates><xsl:text> </xsl:text>
	
	<xsl:apply-templates select="ISSUEINFO">
		<xsl:with-param name="NORM" select="$NORM" />
		<xsl:with-param name="LANG" select="$LANG" />
	</xsl:apply-templates-->
	<xsl:call-template name="PrintAbstractHeaderInformation">
		<xsl:with-param name="FORMAT" select="'short'" />
		<xsl:with-param name="NORM" select="'iso-e'" />
		<xsl:with-param name="LANG" select="$LANG" />
		<xsl:with-param name="LINK">0</xsl:with-param>
	</xsl:call-template>
	
	</p>

	<p align="CENTER"><br/></p>
	</td>
	<td width="10%">&#160;</td>
	</tr>
	</table>
</xsl:template>

</xsl:stylesheet>
