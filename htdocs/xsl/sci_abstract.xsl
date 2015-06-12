<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mml="http://www.w3.org/1998/Math/MathML">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="sci_toolbox.xsl"/>
	<xsl:variable name="languages" select="document('../xml/pt/language.xml')"/><xsl:variable name="LANGUAGE" select="//LANGUAGE"/>
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
						<xsl:with-param name="reviewType"><xsl:if test=".//ARTICLE/@hcomment!='1' or not(.//ARTICLE/@hcomment)">provisional</xsl:if></xsl:with-param>
					</xsl:call-template>;
				
					<xsl:call-template name="ABSTR-TR">
						<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)"/>
					</xsl:call-template>:
				
				<xsl:value-of select="CONTROLINFO/PAGE_PID"/>
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/> 
                <!--Meta Google Scholar-->
                <meta name="citation_journal_title" content="{TITLEGROUP/TITLE}"/>
                <meta name="citation_publisher" content="{normalize-space(substring-after(COPYRIGHT,'-'))}"/>
                <meta name="citation_title" content="{ARTICLE/NOHTML-TITLE}"/>                                
                <meta name="citation_date" content="{concat(ARTICLE/ISSUEINFO/@MONTH,'/',ARTICLE/ISSUEINFO/@YEAR)}"/>
                <meta name="citation_volume" content="{ARTICLE/ISSUEINFO/@VOL}"/>
                <meta name="citation_issue" content="{ARTICLE/ISSUEINFO/@NUM}"/>
                <meta name="citation_issn" content="{ISSN}"/>
                <meta name="citation_doi" content="{ARTICLE/@DOI}"/>
                <meta name="citation_abstract_html_url" content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_abstract&amp;pid=', ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ARTICLE/@TEXT_LANG)}"/>
                <meta name="citation_fulltext_html_url" content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_arttext&amp;pid=', ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ARTICLE/@TEXT_LANG)}"/>
                <xsl:apply-templates select=".//AUTHORS//AUTHOR" mode="AUTHORS_META"/>
                <meta name="citation_firstpage" content="{ARTICLE/@FPAGE}"/>
                <meta name="citation_lastpage" content="{ARTICLE/@LPAGE}"/>
                <meta name="citation_id" content="{ARTICLE/@DOI}"/>
				<xsl:apply-templates select="ARTICLE/LANGUAGES/PDF_LANGS/LANG" name="meta_citation_pdf_url">
					<xsl:with-param name="orig_lang" select="ARTICLE/@TEXT_LANG" />
				</xsl:apply-templates>
				<link rel="stylesheet" type="text/css" href="/css/screen/general.css"/>
				<link rel="stylesheet" type="text/css" href="/css/screen/layout.css"/>
				<link rel="stylesheet" type="text/css" href="/css/screen/styles.css"/>
				<link rel="stylesheet" type="text/css" href="/xsl/pmc/v3.0/xml.css"/>
				<script language="javascript" src="applications/scielo-org/js/jquery-1.4.2.min.js"/>
				<script language="javascript" src="applications/scielo-org/js/toolbox.js"/>
	            <xsl:if test="//show_readcube_epdf = '1'">
	                <script src="http://content.readcube.com/scielo/epdf_linker.js" type="text/javascript" async="true"></script>
	            </xsl:if>
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
							<xsl:apply-templates select="ISSUE_ISSN">
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

	<xsl:template match="LANG" name="meta_citation_pdf_url">
		<xsl:param name="orig_lang" />
		<xsl:variable name="lang" select="." />
		<meta>
			<xsl:attribute name="name">citation_pdf_url</xsl:attribute>
			<xsl:attribute name="language"><xsl:value-of select="$orig_lang" /></xsl:attribute>
			<xsl:if test="$orig_lang = $lang">
				<xsl:attribute name="default">true</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="content"><xsl:value-of select="concat('http://',//CONTROLINFO/SCIELO_INFO/SERVER,'/pdf/',@TRANSLATION)" /></xsl:attribute>
		</meta>
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
			<xsl:with-param name="reviewType"><xsl:if test="@hcomment!='1' or not(@hcomment)">provisional</xsl:if></xsl:with-param>
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
		<xsl:choose>
			<xsl:when test="*">
				<xsl:apply-templates select="*|text()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="." disable-output-escaping="yes"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	<!--xsl:template match="ABSTRACT/*">
		<xsl:copy-of select="."/>
	</xsl:template-->
	<xsl:template match="ABSTRACT/text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="ABSTRACT//*">
		<xsl:apply-templates select="*|text()"/>
	</xsl:template>
	<xsl:template match="ABSTRACT/sec/title"><p class="subsec">
		<xsl:apply-templates select="*|text()"/></p>
	</xsl:template>
	<xsl:template match="ABSTRACT/sec"><div>
		<xsl:apply-templates select="*|text()"/></div>
	</xsl:template>
	<xsl:template name="ABSTR-TR">
        <xsl:value-of select="$translations/xslid[@id='sci_abstract']/text[@find='abstract']"/>
	</xsl:template>
	<xsl:template match="KEYWORDS">
		<xsl:param name="LANG"/>
		<p>
			<strong>
                <xsl:value-of select="$translations/xslid[@id='sci_abstract']/text[@find='keywords']"/>
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
