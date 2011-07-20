<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8" omit-xml-declaration="yes" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<xsl:variable name="lang" select="//CONTROLINFO/LANGUAGE"/>
	<xsl:variable name="texts" select="document('file:///var/www/scielo_br/htdocs/applications/scielo-org/xml/texts.xml')/texts/language[@id = $lang]"/>
	<xsl:variable name="page_title">
		<xsl:value-of select="//CONTROLINFO/SITE_NAME"/> - <xsl:value-of select="//CONTROLINFO//SCIELO_INFO/SERVER"/>
	</xsl:variable>
	<xsl:variable name="service_log" select="//CONTROLINFO//SERVER_LOG"/>
	<xsl:template match="/">
		<!-- start html -->
		<html>
			<head>
				<link rel="stylesheet" href="/applications/scielo-org/css/public/style-{$lang}.css" type="text/css" media="screen"/>
				<!-- Adicionado script para passa a utilizar o serviço de log comentado por Jamil Atta Junior (jamil.atta@bireme.org)-->
				<script language="javascript" src="/../../applications/scielo-org/js/httpAjaxHandler.js"/>
				<title>
					<xsl:value-of select="$page_title"/>
				</title>
			</head>
			<body>
				<div class="container">
					<div class="level2">
						<div class="bar">
						</div>
						<div class="top">
							<div id="parent">
								<img src="{concat('/img/',$lang,'/scielobre.gif')}" alt="{$page_title}"/>
							</div>
							<div id="identification">
								<h1>
									<span>
										<xsl:value-of select="$page_title"/>
									</span>
								</h1>
							</div>
						</div>
						<div class="middle">
							<div id="collection">
								<h3>
									<span>
										<xsl:value-of select="$texts/text[find='findReferenceOnLine']/replace"/>
									</span>
								</h3>
								<h3>
									<span style="font-size: 70%; font-weight:normal;">
										<xsl:value-of select="//REFERENCE/TEXT" disable-output-escaping="yes"/>
									</span>
								</h3>
								<div class="content">
									<div class="articleList">
										<xsl:apply-templates select=".//group"/>
										
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
	<xsl:template match="group">
		<xsl:variable name="id" select="@id"/>
		
		<xsl:value-of select="$texts/text[find=$id]/replace"/>
		<ul>
			<li>
				<xsl:apply-templates select="link"/>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="link"><b>
		<a>				<xsl:attribute name="href"><xsl:value-of select="url" disable-output-escaping="no"/></xsl:attribute>

			<xsl:if test="target">
				<xsl:attribute name="target"><xsl:value-of select="target"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$service_log = '1' and log">
				<xsl:attribute name="onClick">callUpdateArticleLog('{log}');</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="label"/>
			<xsl:if test="label-id">
				<xsl:variable name="label_id" select="label-id"/>
				<xsl:value-of select="$texts/text[find=$label_id]/replace"/>
			</xsl:if>
		</a></b>&#160;&#160;&#160;&#160;		
	</xsl:template>
</xsl:stylesheet>
