<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:variable name="translations" select="//locale"/>
	<xsl:template match="@*">
		<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	<xsl:template match="*">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="message">
		<xsl:variable name="label" select="."/>
		<p>
			<xsl:value-of select="$translations//message[@key=$label]"/>
		</p>
		<xsl:if test="not($translations//message[@key=$label])">
			<xsl:value-of select="$label"/>
			<xsl:copy-of select="$translations"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="label | @label ">
		<xsl:variable name="label" select="."/>
		<xsl:value-of select="$translations//message[@key=$label]"/>
		<xsl:if test="not($translations//message[@key=$label])">
			NÃO ENCONTROU A TRADUÇÃO PARA 
			<xsl:value-of select="$label"/>
			EM
			<xsl:copy-of select="$translations"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/">
		<html>
			<head>
				<xsl:apply-templates select="." mode="css"/>
			</head>
			<body>
				<div id="container">
					<div id="header">
						<div id="headerTitle">
							<xsl:apply-templates select="." mode="page-header"/>
						</div>
					</div>
					<div id="body">
						<div id="main">
							<a href="/TextViewer">home</a> &gt; <xsl:apply-templates select=".//page" mode="page-title"/>
<h2><xsl:apply-templates select=".//page" mode="page-title"/></h2>
							<div id="content">
								<div>
									<xsl:apply-templates select="." mode="content"/>
								</div>
							</div>
							<!-- content -->
						</div>
						<!-- main -->
					</div>
					<!-- body -->
				</div>
				<!-- container -->
			</body>
		</html>
	</xsl:template>
	<xsl:template match="*" mode="css">
		<link rel="stylesheet" type="text/css" href="/TextViewer/css/common.css"/>
	</xsl:template>
	<xsl:template match="*" mode="page-header">
		<div id="header">
			<div id="headerTitle">				

				<h1><IMG src="http://www.scielo.br/img/en/fbpelogp.gif" border="0" alt="Scientific Electronic Library Online"/> 
						Visualizador do texto</h1>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="page" mode="page-title">
		<xsl:variable name="label" select="title"/>
		<xsl:value-of select="$translations//message[@key=$label]"/>
	</xsl:template>
</xsl:stylesheet>
