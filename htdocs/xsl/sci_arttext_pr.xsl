<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mml="http://www.w3.org/1998/Math/MathML">
	<!--xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes"/-->
	<xsl:import href="sci_arttext.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	
	<xsl:variable name="display">no</xsl:variable>
	
	<xsl:template match="/">
		
		<xsl:apply-templates select=".//SERIAL" mode="merged"/>
	</xsl:template>
	<xsl:template match="SERIAL" mode="merged">
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
				<!--link rel="stylesheet" type="text/css" href="/css/screen.css"/>
				<xsl:apply-templates select="." mode="css"/-->
				<link rel="stylesheet" href="/applications/scielo-org/css/public/style-en.css" type="text/css" media="screen"/>
				<xsl:apply-templates select="." mode="version-css"/>
				
				
			</head>
			<body>
				<div class="container">
					<div class="level2">
						<div class="top">
							<div id="parent">
								<img src="/img/en/scielobre.gif" alt="SciELO - Scientific Electronic Library Online"/>
							</div>
							<div id="identification">
								<h1>
									<span>
										SciELO - Scientific Electronic Library Online
									</span>
								</h1>
							</div>
						</div>
						<div class="middle">
							<div id="collection">
								<h3>
									<span><xsl:value-of select="$translations/xslid[@id='sci_arttext_pr']/text[@find='press_release']"/></span>
								</h3>
								<div class="content">
									<TABLE border="0" cellpadding="0" cellspacing="2" width="760" align="center">
										<TR>
											<TD colspan="2">
												<h3>
													<span style="font-weight:100;font-size: 70%; background:none;">
														<xsl:choose>
															<xsl:when test="ISSUE/ARTICLE/related[@type='art']">
																<xsl:apply-templates select=".//DOCUMENT-RELATED/ARTICLE" mode="subtitle"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:apply-templates select="ISSUE/STRIP"/>
															</xsl:otherwise>
														</xsl:choose>
														<br/>
														<br/>
													</span>
												</h3>
											</TD>
										</TR>
										<TR>
											<TD colspan="2">
												<div id="toolBox">
													<xsl:apply-templates select="ISSUE/ARTICLE/related[@type='art' or @type='issue']" mode="link"/>
												</div>
												<h4 id="doi">
													<xsl:apply-templates select="ISSUE/ARTICLE/@DOI" mode="display"/>&#160;
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
												<xsl:if test="$xml_article">
													<xsl:apply-templates select="document($xml_article)" mode="text-content"/>
												</xsl:if>
												<div align="left"/>
												<div class="spacer">&#160;</div>
											</TD>
										</TR>
									</TABLE>
								</div>
							</div>
						</div>
					</div>
				</div>
				<script language="javascript" src="applications/scielo-org/js/httpAjaxHandler.js"/>
				
				<xsl:apply-templates select="." mode="version-js"/>
				
			</body>
		</html>
	</xsl:template>
	<xsl:template match="ARTICLE" mode="subtitle">
		<xsl:call-template name="PrintAbstractHeaderInformation">
			<xsl:with-param name="FORMAT" select="'short'"/>
			<xsl:with-param name="NORM" select="'iso-e'"/>
			<xsl:with-param name="LANG" select="$LANGUAGE"/>
			<xsl:with-param name="AUTHLINK">0</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
