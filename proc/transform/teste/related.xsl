<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" 
	omit-xml-declaration="yes"
	indent="no"
	doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

	<xsl:variable name="lang" select="//vars/lang"/>
	<xsl:variable name="texts" select="document('texts.xml')/texts/language[@id = $lang]"/>
	<xsl:variable name="links" select="//ARTICLE"/>
	<xsl:variable name="total" select="count(//related/relatedlist/article)"/>
	<xsl:template match="/">

		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
				<link rel="stylesheet" href="/css/screen2.css" type="text/css" media="screen"/>
			</head>
			<body>
				<div class="container">
					<div class="level2">
						<div class="bar">
						</div>
						<div class="top">
							<div id="parent">
								<img src="{concat('/img/',$lang,'/scielobre.gif')}" alt="SciELO - Scientific Electronic Librery Online"/>
							</div>
							<div id="identification">
								<h1>
									<span>
										<xsl:value-of select="$texts/text[find='scielo.org']/replace"/>
									</span>
								</h1>
							</div>
						</div>
						<div class="middle">
							<div id="collection">
								<h3>
									<span>
										<xsl:value-of select="$texts/text[find='related_to']/replace"/>
										<xsl:value-of select="concat(' ',$total)"/>
									</span>
								</h3>
								<div class="content">
									<div class="articleList">
										<xsl:choose>
											<xsl:when test="$total &gt; 0">
												<ul>
													<xsl:apply-templates select="//related/relatedlist/article"/>
												</ul>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$texts/text[find='doesnt_related']/replace"/>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</div>
								<div style="clear: both;float: none;width: 100%;"/>
							</div>
						</div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="article">
		<xsl:variable name="country" select="@country"/>
		<xsl:variable name="nameCountry" select="$texts/text[find=$country]/replace"/>
		<xsl:variable name="domainCountry" select="$texts/text[find=$country]/url"/>

		<xsl:variable name="url" select="concat('/scielo.php?script=sci_arttext&amp;pid=',@pid,'&amp;nrm=iso')"/>
		<li>
			<div>
				<a href="{$url}" target="_blank"><xsl:apply-templates select="titles/title[@lang=$lang]"/>
				<xsl:if test="not(titles/title[@lang=$lang])">
					<xsl:apply-templates select="titles/title[1]"/>
				</xsl:if>
				</a> - <xsl:value-of select="$nameCountry" />
				<br/>
				<xsl:apply-templates select="authors/author">
					<xsl:with-param name="total" select="count(authors/author)"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="serial"/>
				<xsl:value-of select="' . '" />
				<xsl:apply-templates select="year"/>
				<xsl:apply-templates select="volume"/>
				<xsl:apply-templates select="number"/>
				<xsl:apply-templates select="@pid" mode="issn"/>
				<xsl:variable name="pid" select="@pid"/>
			</div>
		</li>
	</xsl:template>
	<xsl:template match="ABSTRACT_LANGS">
		<xsl:param name="LANG"/>
		<xsl:param name="PID"/>
		<xsl:choose>
			<xsl:when test="$LANG='pt'">resumo 
					</xsl:when>
			<xsl:when test="$LANG='es'">resumen
					</xsl:when>
			<xsl:when test="$LANG='en'">abstract
					</xsl:when>
		</xsl:choose>&#160;
		<xsl:apply-templates select="LANG">
			<xsl:with-param name="PID" select="$PID"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="script" select="'sci_abstract'"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="LANG">
		<xsl:param name="PID"/>
		<xsl:param name="LANG"/>
		<xsl:param name="script"/>
		<xsl:if test="position()&gt;1">&#160;|&#160;</xsl:if>
		<a href="/scielo.php?script={$script}&amp;pid={$PID}&amp;lng={$LANG}&amp;nrm=&amp;tlng={.}" target="_blank">
			<xsl:call-template name="inLanguage">
				<xsl:with-param name="langInterface" select="$LANG"/>
				<xsl:with-param name="langData" select="."/>
			</xsl:call-template>
		</a>
	</xsl:template>
	<xsl:template match="ART_TEXT_LANGS">
		<xsl:param name="LANG"/>
		<xsl:param name="PID"/>
		<xsl:choose>
			<xsl:when test="$LANG='pt'">texto 
					</xsl:when>
			<xsl:when test="$LANG='es'">texto
					</xsl:when>
			<xsl:when test="$LANG='en'">text
					</xsl:when>
		</xsl:choose>&#160;
		<xsl:apply-templates select="LANG">
			<xsl:with-param name="PID" select="$PID"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="script" select="'sci_arttext'"/>
		</xsl:apply-templates>
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
	<xsl:template name="inLanguage">
		<xsl:param name="langInterface"/>
		<xsl:param name="langData"/>
		<xsl:choose>
			<xsl:when test="$langInterface='pt'">
				<xsl:choose>
					<xsl:when test="$langData='pt'">em português		
					</xsl:when>
					<xsl:when test="$langData='es'">em español
					</xsl:when>
					<xsl:when test="$langData='en'">em inglês
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$langInterface='es'">
				<xsl:choose>
					<xsl:when test="$langData='pt'">en portugués		
					</xsl:when>
					<xsl:when test="$langData='es'">en español
					</xsl:when>
					<xsl:when test="$langData='en'">en inglés
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$langInterface='en'">
				<xsl:choose>
					<xsl:when test="$langData='pt'">in Portuguese		
					</xsl:when>
					<xsl:when test="$langData='es'">in Spanish
					</xsl:when>
					<xsl:when test="$langData='en'">in English
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
