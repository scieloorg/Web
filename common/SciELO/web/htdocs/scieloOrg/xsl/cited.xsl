<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" 
	omit-xml-declaration="yes"
	indent="no"
	doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

	<xsl:include href="file:///d:/sites/scielo/web/htdocs/applications/scielo-org/xsl/article_output.xsl"/>


	<xsl:variable name="lang" select="//vars/lang"/>
	<xsl:variable name="texts" select="document('file:///d:/sites/scielo/web/htdocs/applications/scielo-org/xml/texts.xml')/texts/language[@id = $lang]"/>
	<xsl:variable name="metaSearchInstances" select="document(concat('d:/sites/scielo/web/htdocs/applications/scielo-org/xml/',$lang,'/metaSearchInstances.xml'))"/>
	<xsl:variable name="links" select="//ARTICLE"/>
	<xsl:variable name="total" select="count(//citinglist/citing)"/>
	<xsl:template match="/">
		<html>
			<head>
				<link rel="stylesheet" href="/applications/scielo-org/css/public/style-{$lang}.css" type="text/css" media="screen"/>
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
										<xsl:value-of select="$texts/text[find='cited_by']/replace"/>
										<xsl:value-of select="concat(' ',$total)"/>
									</span>
								</h3>
								<div class="content">
									<div class="articleList">
										<xsl:choose>
											<xsl:when test="$total &gt; 0">
												<ul>
													<xsl:apply-templates select="//cited/citinglist" mode="pre"/>
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
	
	<xsl:template match="citing" mode="pre">
					<xsl:apply-templates select="." >
							<xsl:with-param name="s" select="@s"/>
							<xsl:with-param name="pos" select="position()"/>
					</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
