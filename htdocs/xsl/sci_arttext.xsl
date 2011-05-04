<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mml="http://www.w3.org/1998/Math/MathML">
	<xsl:include href="scielo_pmc_main.xsl"/>
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="sci_toolbox.xsl"/>
	<xsl:variable name="LANGUAGE" select="//LANGUAGE"/>
	<xsl:variable name="SCIELO_REGIONAL_DOMAIN" select="//SCIELO_REGIONAL_DOMAIN"/>
	<xsl:variable name="hasPDF" select="//ARTICLE/@PDF"/>
	<xsl:variable name="show_toolbox" select="//toolbox"/>
	<xsl:template match="fulltext-service-list"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//SERIAL"/>
	</xsl:template>
	<xsl:template match="SERIAL">
		<xsl:if test=".//mml:math">
			<xsl:processing-instruction name="xml-stylesheet"> type="text/xsl" href="/xsl/mathml.xsl"</xsl:processing-instruction>
		</xsl:if>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>
					<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/> - <xsl:value-of select="normalize-space(ISSUE/ARTICLE/TITLE)" disable-output-escaping="yes"/>
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<meta Content-math-Type="text/mathml"/>
				<!--Meta Google Scholar-->
				<meta name="citation_journal_title" content="{TITLEGROUP/TITLE}"/>
				<meta name="citation_publisher" content="{normalize-space(COPYRIGHT)}"/>
				<meta name="citation_title" content="{ISSUE/ARTICLE/TITLE}"/>
				<meta name="citation_date" content="{concat(substring(ISSUE/@PUBDATE,5,2),'/',substring(ISSUE/@PUBDATE,1,4))}"/>
				<meta name="citation_volume" content="{ISSUE/@VOL}"/>
				<meta name="citation_issue" content="{ISSUE/@NUM}"/>
				<meta name="citation_issn" content="{ISSN}"/>
				<meta name="citation_doi" content="{ISSUE/ARTICLE/@DOI}"/>
				<meta name="citation_abstract_html_url" content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_abstract&amp;pid=', ISSUE/ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ISSUE/ARTICLE/@TEXTLANG)}"/>
				<meta name="citation_fulltext_html_url" content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_arttext&amp;pid=', ISSUE/ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ISSUE/ARTICLE/@TEXTLANG)}"/>
				<meta name="citation_pdf_url" content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_pdf&amp;pid=', ISSUE/ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ISSUE/ARTICLE/@TEXTLANG)}"/>
				<xsl:apply-templates select=".//AUTHORS" mode="AUTHORS_META"/>
				<meta name="citation_firstpage" content="{ISSUE/ARTICLE/@FPAGE}"/>
				<meta name="citation_lastpage" content="{ISSUE/ARTICLE/@LPAGE}"/>
				<meta name="citation_id" content="{ISSUE/ARTICLE/@DOI}"/>
				<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
				<xsl:apply-templates select="." mode="css"/>
				<script language="javascript" src="applications/scielo-org/js/jquery-1.4.2.min.js"/>
				<script language="javascript" src="applications/scielo-org/js/toolbox.js"/>
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
						<xsl:choose>
							<xsl:when test="//NO_SCI_SERIAL='yes'">
								<h2 id="printISSN">
									<xsl:value-of select="$translations/xslid[@id='sci_arttext']/text[@find='original_version_published_in']"/>
								</h2>
							</xsl:when>
							<xsl:otherwise>
								<h2>
									<xsl:choose>
										<xsl:when test="//CONTROLINFO/NO_SCI_SERIAL='yes'"><xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/>
</xsl:when>
										<xsl:otherwise>
											<a>
												<xsl:call-template name="AddScieloLink">
													<xsl:with-param name="seq" select=".//ISSN_AD_ID"/>
													<xsl:with-param name="script">sci_serial</xsl:with-param>																										</xsl:call-template>
												<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/>
											</a>
										</xsl:otherwise>
									</xsl:choose>
								</h2>
								<h2 id="printISSN">
									<xsl:apply-templates select=".//ISSUE_ISSN">
										<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)"/>
									</xsl:apply-templates>
								</h2>
							</xsl:otherwise>
						</xsl:choose>
						<h3>
							<xsl:if test="TITLEGROUP/SIGLUM != 'bjmbr' ">
								<xsl:apply-templates select="ISSUE/STRIP"/>
							</xsl:if>
							<xsl:if test="TITLEGROUP/SIGLUM = 'bjmbr' ">
								<xsl:apply-templates select="ISSUE/STRIP"/>
								<!--xsl:apply-templates select="ISSUE/ARTICLE" mode="Epub">
									<xsl:with-param name="ahpdate" select="ISSUE/ARTICLE/@ahpdate"/>
									<xsl:with-param name="rvpdate" select="ISSUE/ARTICLE/@rvpdate"/>
								</xsl:apply-templates-->
							</xsl:if>
						</h3>
						<h4 id="doi">
							<xsl:apply-templates select="ISSUE/ARTICLE/@DOI"/>&#160;
						</h4>
						<div class="index,{ISSUE/ARTICLE/@TEXTLANG}">
							<xsl:apply-templates select="ISSUE/ARTICLE/BODY"/>
						</div>
						<xsl:if test="ISSUE/ARTICLE/fulltext">
							<xsl:apply-templates select="ISSUE/ARTICLE[fulltext]"/>
						</xsl:if>
						<xsl:if test="not(ISSUE/ARTICLE/BODY) and not(ISSUE/ARTICLE/fulltext)">
							<xsl:apply-templates select="ISSUE/ARTICLE/EMBARGO/@date">
								<xsl:with-param name="lang" select="$interfaceLang"/>
							</xsl:apply-templates>
						</xsl:if>
						<div align="left"/>
						<div class="spacer">&#160;</div>
					</div>
					<xsl:apply-templates select="." mode="footer-journal"/>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="BODY">
		<xsl:apply-templates select="*|text()" mode="body-content"/>
		<xsl:if test="$isProvisional='1' and $hasPDF='1'">
			<a>
				<xsl:call-template name="AddScieloLink">
					<xsl:with-param name="seq" select="../../ARTICLE/@PID"/>
					<xsl:with-param name="script">sci_pdf</xsl:with-param>
					<xsl:with-param name="txtlang" select="../../ARTICLE/@TEXTLANG"/>
				</xsl:call-template>
				<xsl:value-of select="$translations/xslid[@id='sci_arttext']/text[@find='fulltext_only_in_pdf']"/>
			</a>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*|text()" mode="body-content">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>
	<xsl:template match="STRIP">
		<xsl:call-template name="SHOWSTRIP">
			<xsl:with-param name="SHORTTITLE" select="SHORTTITLE"/>
			<xsl:with-param name="VOL" select="VOL"/>
			<xsl:with-param name="NUM" select="NUM"/>
			<xsl:with-param name="SUPPL" select="SUPPL"/>
			<xsl:with-param name="CITY" select="CITY"/>
			<xsl:with-param name="MONTH" select="MONTH"/>
			<xsl:with-param name="YEAR" select="YEAR"/>
			<xsl:with-param name="reviewType">
				<xsl:if test="../ARTICLE/@hcomment!='1' or not(../ARTICLE/@hcomment)">provisional</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
