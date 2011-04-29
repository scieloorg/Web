<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="../applications/scielo-org/xsl/article_output.xsl"/>
	<xsl:include href="sci_common.xsl"/>

	<xsl:output method="html"
						omit-xml-declaration="yes"
						indent="yes"
						doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
						doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

	<xsl:variable name="lang" select="//vars/lang"/>
	<xsl:variable name="texts" select="document('../applications/scielo-org/xml/texts.xml')/texts/language[@id = $lang]"/>
	<xsl:variable name="metaSearchInstances" select="document(concat('../applications/scielo-org/xml/',$lang,'/metaSearchInstances.xml'))"/>
	<xsl:variable name="links" select="//ARTICLE"/>
	<xsl:variable name="total" select="count(//similarlist/similar/article)"/>

	<xsl:template match="/">
		<html>
			<head>
				<link rel="stylesheet" href="/applications/scielo-org/css/public/style-{$lang}.css" type="text/css" media="screen"/>
			<title><xsl:value-of select="$translations/xslid[@id='similar']/text[@find = 'scientific_electronic_library_online']"/></title>
			</head>
			<body>
				<div class="container">
					<div class="level2">
						<div class="bar">
						</div>
						<div class="top">
							<div id="parent">
								<img src="{concat('/img/',$lang,'/scielobre.gif')}" alt="{$translations/xslid[@id='similar']/text[@find = 'scientific_electronic_library_online']}"/>
							</div>
							<div id="identification">
								<h1>
									<span>
										<xsl:value-of select="$translations/xslid[@id='similar']/text[@find = 'scientific_electronic_library_online']"/>
									</span>
								</h1>
							</div>
						</div>
						<div class="middle">
							<div id="collection">
								<h3>
									<span>
                                        <xsl:value-of select="$translations/xslid[@id='similar']/text[@find = 'related_to']"/>
										<xsl:value-of select="concat(' ',$total)"/>
									</span>
								</h3>
								<div class="content">
									<div class="articleList">
										<xsl:choose>
											<xsl:when test="$total &gt; 0">
												<ul>
													<xsl:apply-templates select="//similarlist/similar"/>
												</ul>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$translations/xslid[@id='similar']/text[@find = 'doesnt_related']"/>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</div>
								<div style="clear: both;float: none;width: 100%;"/>
							</div>
						</div>
					</div>
				</div>
				<xsl:call-template name="UpdateLog"/>
			</body>
		</html>
	</xsl:template>
	
		<xsl:template match="similar">
		<xsl:apply-templates select="article">
			<xsl:with-param name="s" select="@s"/>
			<xsl:with-param name="pos" select="position()"/>
		</xsl:apply-templates>
	</xsl:template>
	
</xsl:stylesheet>
