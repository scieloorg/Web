<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:include href="file:///scielo/web/htdocs/xsl/sci_navegation.xsl"/>
<xsl:include href="file:///scielo/web/htdocs/xsl/sci_error.xsl" />
<!--xsl:output method="html" encoding="iso-8859-1" /-->

<xsl:variable name="forceType" select="//CONTROLINFO/ENABLE_FORCETYPE"/>

<xsl:template match="/">
	<html>
	<head>
		<title>
			<xsl:choose>
				<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='en']">
					Alphabetic list
				</xsl:when>
				<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='pt']">
					Lista alfabética
				</xsl:when>
				<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='es']">
					Lista alfabética
				</xsl:when>
			</xsl:choose>	
		</title>
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
		<link rel="STYLESHEET" type="text/css" href="/css/scielo.css" />
	</head>
	<body link="#0000ff" vlink="#800080" bgcolor="#ffffff">
		<xsl:call-template name="NAVBAR">
			<xsl:with-param name="bar1">serials</xsl:with-param>
			<xsl:with-param name="bar2">articlesiah</xsl:with-param>
			<xsl:with-param name="scope">library</xsl:with-param>
		</xsl:call-template>
	
		<table cellspacing="0" border="0" cellpadding="7" width="100%">
		<tr>
		<td width="26%">&#160;</td>
		<td width="74%">
		<font class="nomodel" size="+1" color="#000080">
		<xsl:choose>
			<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='en']">
				Library Collection
			</xsl:when>
			<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='pt']">
				Coleção da biblioteca
			</xsl:when>
			<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='es']">
				Colección de la biblioteca
			</xsl:when>
		</xsl:choose>
		</font>
		</td>
		</tr>
		</table><br/><br/>
		<xsl:apply-templates select="//LIST" /><br/>
		<xsl:apply-templates select="SERIALLIST/COPYRIGHT" />
	</body>
	</html>
</xsl:template>

<xsl:template match="LIST">
	<table width="100%">
	<tr>
	<td width="8%">&#160;</td>
	<td width="82%">
		<p align="LEFT">
		<font class="nomodel" color="#800000">
		<xsl:choose>
			<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='en']">
				Alphabetic list - <xsl:value-of select="count(SERIAL)" /> serials listed
			</xsl:when>
			<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='pt']">
				Lista alfabética - <xsl:value-of select="count(SERIAL)" /> periódicos listados				</xsl:when>
			<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='es']">
				Lista alfabética - <xsl:value-of select="count(SERIAL)" /> seriadas listadas
			</xsl:when>
		</xsl:choose>
		</font>
		</p>
		<xsl:apply-templates select="SERIAL" />
		<font class="divisoria">&#160;<br/></font><br/><br/>
	</td>
	<td width="10%">&#160;</td>
	</tr>
	</table>	
</xsl:template>

<xsl:template match="SERIAL">
	<font face="symbol">·</font>&#160;
	<font class="linkado">
		<xsl:choose>
			<xsl:when test="$forceType=0">
				<a>
					<xsl:attribute name="href">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php?script=sci_serial&amp;pid=<xsl:value-of select ="TITLE/@ISSN"/>&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/></xsl:attribute>
					<xsl:value-of select="TITLE" disable-output-escaping="yes" />
				</a> 				
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php/script_sci_serial/pid_<xsl:value-of select ="TITLE/@ISSN"/>/lng_<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>/nrm_<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/></xsl:attribute>
					<xsl:value-of select="TITLE" disable-output-escaping="yes" />
				</a> 								
			</xsl:otherwise>
		</xsl:choose>
		- <xsl:value-of select="@QTYISS" />
		<xsl:choose>
			<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='en']">
				 issue<xsl:if test="@QTYISS > 1">s</xsl:if>
			</xsl:when>
			<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='pt']"> 
				número<xsl:if test="@QTYISS > 1">s</xsl:if>
			</xsl:when>
			<xsl:when test="/SERIALLIST/CONTROLINFO[normalize-space(LANGUAGE)='es']"> 
				número<xsl:if test="@QTYISS > 1">s</xsl:if>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="not(starts-with(normalize-space(following-sibling::node()/TITLE), substring(normalize-space(TITLE), 1, 1)))"><br/></xsl:if>
	</font><br/>
</xsl:template>

<xsl:template match="COPYRIGHT">
	<xsl:call-template name="COPYRIGHTSCIELO"/>
</xsl:template>

</xsl:stylesheet>
