<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="lang" select="//vars/lang"/>	
	<xsl:variable name="texts" select="document('../xml/texts.xml')/texts/language[@id = $lang]"/>	
	<xsl:template match="/">
		<xsl:variable name="total" select="count(/related/relatedlist/article)"/>
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
				<meta http-equiv="Expires" content="-1"/>
				<meta http-equiv="pragma" content="no-cache"/>
				<meta name="robots" content="all"/>
				<meta name="MSSmartTagsPreventParsing" content="true"/>
				<meta name="generator" content="BVS-Site 4.0-rc4"/>
				<script language="JavaScript">lang = '<xsl:value-of select="$lang"/>';</script>
				<script language="JavaScript" src="/js/functions.js"/>
				<script language="JavaScript" src="/js/showHide.js"/>
				<script language="JavaScript" src="/js/metasearch.js"/>
				<script language="JavaScript" src="http://regional.bvsalud.org/js/showHide.js"/>
				<link rel="stylesheet" href="../../css/screen2.css" type="text/css" media="screen"/>
			</head>
			<body>
				<div class="container">
					<div class="level2">
						<div class="bar">
							<!--div id="otherVersions">
								<span class="español">
									<a href="../php/index.php?lang=es">español</a>
								</span>| 
								<span class="english">
									<a href="../php/index.php?lang=en">english</a>
								</span>
							</div>
							<div id="contact">
								<span><a href="../php/contact.php?lang=pt">	Contato</a>
								</span>
							</div-->
						</div>
						<div class="top">
							<div id="parent">
								<img src="http://test.scielo.org/image/public/skins/classic/pt/banner.jpg" alt="SciELO - Scientific Electronic Librery Online"/>
							</div>
							<div id="identification">
								<h1>
									<span><xsl:value-of select="$texts/text[find='scielo.org']/replace"/></span>
								</h1>
							</div>
						</div>
						<div class="middle">
						<div id="collection">
							<h3>
								<span><xsl:value-of select="$texts/text[find='related_to']/replace"/></span>
							</h3>
							<div class="content">
								<div class="articleList">
									<xsl:choose>
										<xsl:when test="$total &gt; 0">
											<ul>
												<xsl:apply-templates select="/related/relatedlist/article"/>
											</ul>
										</xsl:when>
										<xsl:otherwise><xsl:value-of select="$texts/text[find='doesnt_related']/replace"/></xsl:otherwise>
									</xsl:choose>
								</div>
							</div>
							<div style="clear: both;float: none;width: 100%;">	</div>
						</div>
					</div>
				</div>
			</div>
			<div class="copyright">BVS Site 4.0-rc4 copy <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a></div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="article">
		<xsl:variable name="url" select="concat('/scielo.php?script=sci_arttext&amp;pid=',@pid,'&amp;nrm=iso')"/>	
		<li>
			<a href="{$url}" target="_blank"><xsl:apply-templates select="titles/title[@lang=$lang]"/></a><br/>
			<xsl:apply-templates select="authors/author">
				<xsl:with-param name="total" select="count(authors/author)"/>
			</xsl:apply-templates>		
			<xsl:apply-templates select="serial"/>
			<xsl:apply-templates select="year"/>
			<xsl:apply-templates select="volume"/>
			<xsl:apply-templates select="number"/>
			<xsl:apply-templates select="@pid" mode="issn"/>
		</li>
	</xsl:template>

	<xsl:template match="author">
			<xsl:param name="total"/>
			<xsl:value-of select="."/>
			<xsl:choose>
				<xsl:when test="position() = $total">. </xsl:when>
				<xsl:otherwise>, </xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	<xsl:template match="title">
		<b>
			<xsl:value-of select="."/>
		</b>.
	</xsl:template>
	<xsl:template match="serial">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="year">
		<xsl:value-of select="."/>,
	</xsl:template>
	<xsl:template match="volume">
		vol.<xsl:value-of select="."/>,
	</xsl:template>
	<xsl:template match="number">
		no.<xsl:value-of select="."/>,
	</xsl:template>
	<xsl:template match="@pid" mode="issn">
		ISSN <xsl:value-of select="substring(.,2,10)"/>.
	</xsl:template>
</xsl:stylesheet>
