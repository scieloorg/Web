<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mml="http://www.w3.org/1998/Math/MathML">
	<xsl:include href="scielo_pmc_main.xsl"/>
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="sci_error.xsl"/>
	<xsl:include href="sci_toolbox.xsl"/>
	<xsl:variable name="LANGUAGE" select="//LANGUAGE"/>
	<xsl:variable name="SCIELO_REGIONAL_DOMAIN" select="//SCIELO_REGIONAL_DOMAIN"/>
	<xsl:variable name="show_toolbox" select="//toolbox"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//SERIAL"/>
	</xsl:template>
		
	<xsl:template match="SERIAL">
		<xsl:if test=".//mml:math">
			<xsl:processing-instruction name="xml-stylesheet"> type="text/xsl" href="/xsl/mathml.xsl"</xsl:processing-instruction>
		</xsl:if>
			<html xmlns="http://www.w3.org/1999/xhtml" >
			<head>
				<title>
					<xsl:value-of select="TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/>&#160;
				
					<xsl:call-template name="GetStrip">
						<xsl:with-param name="vol" select="CONTROLINFO/CURRENTISSUE/@VOL"/>
						<xsl:with-param name="num" select="CONTROLINFO/CURRENTISSUE/@NUM"/>
						<xsl:with-param name="suppl" select="CONTROLINFO/CURRENTISSUE/@SUPPL"/>
						<xsl:with-param name="lang" select="normalize-space(CONTROLINFO/LANGUAGE)"/>
					</xsl:call-template>;
				
					<xsl:call-template name="ABSTR-TR">
						<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)"/>
					</xsl:call-template>:
				
				<xsl:value-of select="CONTROLINFO/PAGE_PID"/>
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
				<script language="javascript" src="applications/scielo-org/js/httpAjaxHandler.js"/>
				<script language="javascript" src="article.js"/>
			</head>
			<body>
				<div class="container">
					<div class="top">
						<div id="issues"/>
						<xsl:call-template name="NAVBAR">
							<xsl:with-param name="bar1">articles</xsl:with-param>
							<xsl:with-param name="bar2">articlesiah</xsl:with-param>
							<xsl:with-param name="home">1</xsl:with-param>
							<xsl:with-param name="alpha">
								<xsl:choose>
									<xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' ">0</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="scope" select="TITLEGROUP/SIGLUM"/>
						</xsl:call-template>
					</div>
					<div class="content">
						<xsl:if test="$show_toolbox = 1">
							<xsl:call-template name="tool_box"/>
						</xsl:if>
						<h2>
							<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/>
						</h2>
						<h2 id="printISSN">
							<xsl:apply-templates select="ISSN">
								<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)"/>
							</xsl:apply-templates>
						</h2>
                                                <div class="index,{ARTICLE/@TEXTLANG}">
						<xsl:apply-templates select="ARTICLE">
							<xsl:with-param name="NORM" select="normalize-space(CONTROLINFO/STANDARD)"/>
							<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)"/>
						</xsl:apply-templates>
						</div>
						<div align="left"/>
						<!--/div>
						<div class="contentRight"-->
						<!--/div-->
						<div class="spacer">&#160;</div>
					</div>
					<xsl:apply-templates select="." mode="footer-journal"/>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="ARTICLE">
		<xsl:param name="NORM"/>
		<xsl:param name="LANG"/>
		<h4>
			<xsl:call-template name="ABSTR-TR">
				<xsl:with-param name="LANG" select="$LANG"/>
			</xsl:call-template>
		</h4>
		<p>
			<xsl:call-template name="PrintAbstractHeaderInformation">
				<xsl:with-param name="FORMAT" select="'short'"/>
				<xsl:with-param name="NORM" select="'iso-e'"/>
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="AUTHLINK">1</xsl:with-param>
			</xsl:call-template>
		</p>
		<p>
			<xsl:variable name="lang" select="ABSTRACT/@xml:lang"/>
			<xsl:if test="$languages//language[@id=$lang]/@view='r2l'">
				<xsl:attribute name="class">r2l</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="ABSTRACT"/>
		</p>
		<xsl:apply-templates select="KEYWORDS">
			<xsl:with-param name="LANG" select="$LANG"/>
		</xsl:apply-templates>
		<p>
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
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="PID" select="//CONTROLINFO/PAGE_PID"/>
			</xsl:apply-templates>
		</p>
		
	</xsl:template>
	<xsl:template match="ABSTRACT">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>
	<xsl:template match="ABSTRACT[*]">
		<xsl:apply-templates select="*|text()"/>
	</xsl:template>
	<!--xsl:template match="ABSTRACT/*">
		<xsl:copy-of select="."/>
	</xsl:template-->
	<xsl:template match="ABSTRACT/text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template name="ABSTR-TR">
		<xsl:param name="LANG"/>
		<xsl:choose>
			<xsl:when test=" $LANG = 'en' ">Abstract</xsl:when>
			<xsl:when test=" $LANG = 'pt' ">Resumo</xsl:when>
			<xsl:when test=" $LANG = 'es' ">Resumen</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="KEYWORDS">
		<xsl:param name="LANG"/>
		<p>
			<strong>
				<xsl:choose>
					<xsl:when test="$LANG='en'">Keywords</xsl:when>
					<xsl:when test="$LANG='pt'">Palavras-chave</xsl:when>
					<xsl:when test="$LANG='es'">Palabras llave</xsl:when>
				</xsl:choose>
		:
		</strong>
			<xsl:apply-templates select="KEYWORD"/>.
	</p>
	</xsl:template>
	<xsl:template match="KEYWORD[position()=1]">
		<xsl:value-of select="KEY" disable-output-escaping="yes"/>
		<xsl:if test="SUBKEY"> [<xsl:value-of select="SUBKEY" disable-output-escaping="yes"/>]</xsl:if>
	</xsl:template>
	<xsl:template match="KEYWORD[position()>1]">; <xsl:value-of select="KEY" disable-output-escaping="yes"/>
		<xsl:if test="SUBKEY"> [<xsl:value-of select="SUBKEY" disable-output-escaping="yes"/>]</xsl:if>
	</xsl:template>
</xsl:stylesheet>
