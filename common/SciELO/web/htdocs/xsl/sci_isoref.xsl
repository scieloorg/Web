<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:include href="file:///scielo/web/htdocs/xsl/sci_common.xsl" />
<xsl:include href="file:///scielo/web/htdocs/xsl/sci_error.xsl" />

<xsl:variable name="LANG" select="normalize-space(/ARTICLE_INFO/CONTROLINFO/LANGUAGE)" />

<xsl:template match="ARTICLE_INFO">
	<html>		
		<head>
			<link rel="STYLESHEET" type="text/css" href="/css/scielo.css" />							
			<meta http-equiv="Pragma" content="no-cache" />
			<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
			<title>
				<xsl:value-of select="TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/>&#160;
				
				<xsl:call-template name="GetStrip">
					<xsl:with-param name="vol" select="ARTICLE/ISSUEINFO/@VOL" />
					<xsl:with-param name="num" select="ARTICLE/ISSUEINFO/@NUM" />
					<xsl:with-param name="suppl" select="ARTICLE/ISSUEINFO/@SUPPL" />
					<xsl:with-param name="lang" select="$LANG" />
				</xsl:call-template>;
				
				<xsl:value-of select="CONTROLINFO/PAGE_PID" />
			</title>
		</head>
		<body class="isoref" link="#0000ff" vlink="#800080" bgcolor="#ffffff">
			<xsl:apply-templates select="ARTICLE" />
		</body>
	</html>
</xsl:template>

<xsl:template match="ARTICLE">
	<table width="600" border="0" align="center">
  		<tr>
	  		<td width="560">
		  		<font class="title" color="#800000">
		  			<b>
			  			<xsl:call-template name="PrintPageTitle" />:
	  				</b>
	  			</font>
		  	</td>
		  	<td width="40" align="right">
		  		<a href="javascript:void(0)" onclick="self.close();">
		  		<xsl:choose>
					<xsl:when test=" $LANG = 'en' ">Close</xsl:when>
					<xsl:when test=" $LANG = 'es' ">Cerrar</xsl:when>
					<xsl:when test=" $LANG = 'pt' ">Fechar</xsl:when>
				</xsl:choose>
				</a>
		  	</td>
		  </tr>
	</table>
	<br/>
	<table width="600" border="0" align="center">
		  <tr>
		  	<td width="600">
		  		<font class="subtitle" color="#800000">
		  			<b>
						<xsl:choose>
							<xsl:when test=" $LANG = 'en' ">ISO Format</xsl:when>
							<xsl:when test=" $LANG = 'es' ">Formato ISO</xsl:when>
							<xsl:when test=" $LANG = 'pt' ">Formato ISO</xsl:when>
						</xsl:choose>
		  			</b>
		  		</font>
		  	</td>
		  </tr>				  
		  <tr>
		  	<td class="isoref" colspan="2" width="600">
				<xsl:call-template name="PrintArticleReferenceISO">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK">0</xsl:with-param>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL" />
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM" />
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL" />
					<xsl:with-param name="MONTH" select="ISSUEINFO/STRIP/MONTH" />
					<xsl:with-param name="YEAR" select="ISSUEINFO/STRIP/YEAR" />
					<xsl:with-param name="ISSN" select="ISSUEINFO/ISSN"/>
					<xsl:with-param name="FPAGE" select="@FPAGE"/>
					<xsl:with-param name="LPAGE" select="@LPAGE"/>
					<xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE" />
<!--					<xsl:with-param name="BOLD">0</xsl:with-param> -->
				</xsl:call-template>
			</td>
		</tr>
		<tr>
			<td colspan="2" width="600">
				<br/>
				<font class="subtitle" color="#800000">
					<b>
						<xsl:choose>
							<xsl:when test=" $LANG = 'en' ">Electronic Document Format (ISO)</xsl:when>
							<xsl:when test=" $LANG = 'es' ">Formato Documento Electrónico (ISO)  
</xsl:when>
							<xsl:when test=" $LANG = 'pt' ">Formato Documento Eletrônico (ISO)</xsl:when>
						</xsl:choose>
					</b>
				</font>
			</td>
		</tr>
		<tr>
			<td class="isoref" colspan="2" width="600">
				<xsl:call-template name="PrintArticleReferenceElectronicISO">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK">0</xsl:with-param>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL" />
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM" />
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL" />
					<xsl:with-param name="MONTH" select="ISSUEINFO/STRIP/MONTH" />
					<xsl:with-param name="YEAR" select="ISSUEINFO/STRIP/YEAR" />
					<xsl:with-param name="CURR_DATE" select="@CURR_DATE"/>
					<xsl:with-param name="PID" select="../CONTROLINFO/PAGE_PID"/>
					<xsl:with-param name="ISSN" select="../ISSN"/>
					<xsl:with-param name="FPAGE" select="@FPAGE"/>
					<xsl:with-param name="LPAGE" select="@LPAGE"/>
					<xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE" />
				</xsl:call-template>
		  	</td>
		  </tr>		  
	</table>
</xsl:template>

<xsl:template name="PrintPageTitle">	
	<xsl:choose>
		<xsl:when test=" $LANG = 'en' ">How to cite this article</xsl:when>
		<xsl:when test=" $LANG = 'es' ">Como citar este artículo</xsl:when>
		<xsl:when test=" $LANG = 'pt' ">Como citar este artigo</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
