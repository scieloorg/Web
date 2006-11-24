<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:include href="file:///scielo/web/htdocs/xsl/sci_navegation.xsl"/>
<xsl:include href="file:///scielo/web/htdocs/xsl/sci_error.xsl" />


<!--xsl:include href="file:///httpd/htdocs/teste/sci_navegation.xsl" />
<xsl:include href="file:///httpd/htdocs/teste/sci_error.xsl" /-->

<!--xsl:output method="html" encoding="iso-8859-1" /-->

<xsl:template match="SERIAL">
	<html>
		<head>
			<title>
				<xsl:value-of select="TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/>&#160;
				
				<xsl:call-template name="GetStrip">
					<xsl:with-param name="vol" select="CONTROLINFO/CURRENTISSUE/@VOL" />
					<xsl:with-param name="num" select="CONTROLINFO/CURRENTISSUE/@NUM" />
					<xsl:with-param name="suppl" select="CONTROLINFO/CURRENTISSUE/@SUPPL" />
					<xsl:with-param name="lang" select="normalize-space(CONTROLINFO/LANGUAGE)" />
				</xsl:call-template>;
				
				<xsl:call-template name="ABSTR-TR">
					<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)" />
				</xsl:call-template>:
				
				<xsl:value-of select="CONTROLINFO/PAGE_PID" />
			</title>
			<meta http-equiv="Pragma" content="no-cache" />
			<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
			<link rel="STYLESHEET" type="text/css" href="/css/scielo.css" />			
			<script language="javascript" src="article.js"></script>			
		</head>
		<body link="#0000ff" vlink="#800080" bgcolor="#ffffff"  onunload="CloseLattesWindow();">

			<xsl:call-template name="NAVBAR">
				<xsl:with-param name="bar1">articles</xsl:with-param>
				<xsl:with-param name="bar2">articlesiah</xsl:with-param>
				<xsl:with-param name="home" select="1" />
				<xsl:with-param name="alpha">
					<xsl:choose>
						<xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' ">0</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="scope" select="TITLEGROUP/SIGLUM"/>
			</xsl:call-template>
		
			<p class="nomodel" align="CENTER">
				<font class="nomodel" size="+1" color="#000080"><xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes" /></font>
				<br/>
				<font class="nomodel" color="#000080" size="-1">
					<xsl:apply-templates select="ISSN">
						<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)" />						</xsl:apply-templates>
				</font>
			</p>

			<xsl:apply-templates select="ARTICLE">
				<xsl:with-param name="NORM" select="normalize-space(CONTROLINFO/STANDARD)" />
				<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)" />
			</xsl:apply-templates>
		<hr/>
		<p align="center">	
			<xsl:apply-templates select="/SERIAL/COPYRIGHT" />
			<xsl:apply-templates select="/SERIAL/CONTACT" />
		</p>
		</body>
	</html>
</xsl:template>

<xsl:template match="ARTICLE">
	<xsl:param name="NORM" />
	<xsl:param name="LANG" />
	
	<table border="0" width="100%">
	<tr>
	<td width="8%">&#160;</td>
	<td width="82%">
		<xsl:call-template name="PrintArticleInformationArea">
			<xsl:with-param name="LATTES" select="LATTES" />
		</xsl:call-template>
	</td>
	<td width="10%">&#160;</td>
	</tr>
	<tr>
	<td width="8%">&#160;</td><td width="82%">
		<p align="LEFT">
		<font class="nomodel" color="#800000">
			<xsl:call-template name="ABSTR-TR">
				<xsl:with-param name="LANG" select="$LANG" />
			</xsl:call-template>			
		</font><br/>
		</p>			
	<p>	
	<xsl:call-template name="PrintAbstractHeaderInformation">
		<xsl:with-param name="NORM" select="$NORM" />
		<xsl:with-param name="LANG" select="$LANG" />
		<xsl:with-param name="AUTHLINK">1</xsl:with-param>
	</xsl:call-template>
	</p>
			
      <p><xsl:value-of select="ABSTRACT" disable-output-escaping="yes" /></p>

	<xsl:apply-templates select="KEYWORDS">
		<xsl:with-param name="LANG" select="$LANG" />
	</xsl:apply-templates>			

	<p align="CENTER">
		<!--xsl:call-template name="CREATE_ARTICLE_LINK">
			<xsl:with-param name="TYPE">full</xsl:with-param>
			<xsl:with-param name="INTLANG" select="$LANG"/>
			<xsl:with-param name="TXTLANG" select="@TEXT_LANG"/>
			<xsl:with-param name="PID" select="//CONTROLINFO/PAGE_PID"/>
		</xsl:call-template>
		<xsl:if test="@PDF='1'">
			<xsl:call-template name="CREATE_ARTICLE_LINK">
				<xsl:with-param name="TYPE">pdf</xsl:with-param>
				<xsl:with-param name="INTLANG" select="$LANG"/>
				<xsl:with-param name="TXTLANG" select="@TEXT_LANG"/>
				<xsl:with-param name="PID" select="//CONTROLINFO/PAGE_PID"/>
			</xsl:call-template>
		</xsl:if-->
		<xsl:apply-templates select="LANGUAGES">
			<xsl:with-param name="LANG" select="$LANG" />
			<xsl:with-param name="PID" select="//CONTROLINFO/PAGE_PID" />
		</xsl:apply-templates>		
	</p>
	<p align="CENTER"><br/></p>
	</td>
	<td width="10%">&#160;</td>
	</tr>
	</table>
</xsl:template>

<xsl:template name="ABSTR-TR">
	<xsl:param name="LANG" />
	<xsl:choose>
		<xsl:when test=" $LANG = 'en' ">Abstract</xsl:when>
		<xsl:when test=" $LANG = 'pt' ">Resumo</xsl:when>
		<xsl:when test=" $LANG = 'es' ">Resumen</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="KEYWORDS">
<xsl:param name="LANG" />
	<p class="nomodel">
		<font class="negrito">
			<xsl:choose>
				<xsl:when test="$LANG='en'">Keywords</xsl:when>
				<xsl:when test="$LANG='pt'">Palavras-chave</xsl:when>
				<xsl:when test="$LANG='es'">Palabras llave</xsl:when>
			</xsl:choose>
		</font>: 
			<xsl:apply-templates select="KEYWORD" />.
	</p>
</xsl:template>

<xsl:template match="KEYWORD[position()=1]"><xsl:value-of select="KEY" 
	disable-output-escaping="yes" /><xsl:if test="SUBKEY"> [<xsl:value-of 
	select="SUBKEY" disable-output-escaping="yes" />]</xsl:if></xsl:template>

<xsl:template match="KEYWORD[position()>1]">; <xsl:value-of select="KEY" 
	disable-output-escaping="yes" /><xsl:if test="SUBKEY"> [<xsl:value-of select="SUBKEY"
	 disable-output-escaping="yes" />]</xsl:if></xsl:template>

</xsl:stylesheet>