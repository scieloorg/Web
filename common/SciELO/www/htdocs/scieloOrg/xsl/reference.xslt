<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<div class="articleList">
			<ul>
				<xsl:apply-templates select="//record"/>
			</ul>
		</div>
	</xsl:template>
	<xsl:template match="record">
		<li>
			<div style="clear: both; height: 1px; margin: 0px; padding: 0px;"/>
			<xsl:apply-templates select="field[@tag = 10]/occ"/>.<b>
				<xsl:value-of select="field[@tag = 12]"/>
			</b>. <xsl:value-of select="field[@tag = 30]"/> ,<xsl:value-of select="substring(field[@tag = 65],1,4)"/>, vol.<xsl:value-of select="field[@tag = 882]/occ/@v"/>, no.<xsl:value-of select="field[@tag = 882]/occ/@n"/>
			<xsl:apply-templates select="field[@tag = 35]" mode="ISSN"/>.<br/>
		</li>
	</xsl:template>
	<xsl:template match="occ">
		<xsl:if test="position()!=1">, </xsl:if>
		<xsl:value-of select="@s"/>,  <xsl:value-of select="@n"/>
	</xsl:template>
	<xsl:template match="field" mode="ISSN">
		, ISSN: <xsl:value-of select="occ"/>
	</xsl:template>
</xsl:stylesheet>
