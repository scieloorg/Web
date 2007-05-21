<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:variable name="lang" select="/root/vars/lang"/>
	<xsl:variable name="applserver" select="/root/vars/applserver"/>
	<xsl:variable name="texts" select="document('file:///home/scielo/www/htdocs/applications/scielo-org/xml/texts.xml')/texts/language[@id = $lang]"/>



	<xsl:template match="/">
		<div class="articleList">
			<ul>
				<xsl:apply-templates select="//record"/>
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="record">
		<li>
			<div style="clear: both; height: 1px; margin: 0px; padding: 0px;" />
			<xsl:apply-templates select="field[(@tag = 10) or (@tag = 16)]" mode="author"/>
			<xsl:apply-templates select="field[@tag = 64]" mode="date"/>
			<xsl:apply-templates select="field[(@tag = 12) or (@tag = 18)]" mode="title"/>
			<xsl:apply-templates select="field[@tag = 30]" mode="serTitle"/>
			<xsl:apply-templates select="field[@tag = 882]" mode="volume"/>
			<xsl:apply-templates select="field[@tag = 882]" mode="number"/>
			<xsl:apply-templates select="field[@tag = 35]" mode="ISSN"/>. [ <a href="http://{$applserver}/scielo.php?pid={field[@tag = 880]/occ}&amp;lng={$lang}&amp;script=sci_reflinks"><xsl:value-of select="$texts/text[find='findReferenceOnLine']/replace"/></a> ]<br/>
			
		</li>
	</xsl:template>


	<xsl:template match="occ">
		<xsl:if test="position()!=1">, </xsl:if>
		<xsl:value-of select="@s"/>,  <xsl:value-of select="@n"/>
	</xsl:template>

	<xsl:template match="field" mode="author">
		<xsl:value-of select="occ/@s"/>, <xsl:value-of select="occ/@n"/> 
	</xsl:template>

	<xsl:template match="field" mode="date">
		. <xsl:value-of select="occ"/>
	</xsl:template>

	<xsl:template match="field" mode="title">
		. <b><xsl:value-of select="occ"/></b>
	</xsl:template>

	<xsl:template match="field" mode="serTitle">
		, <i><xsl:value-of select="occ"/></i>
	</xsl:template>

	<xsl:template match="field" mode="volume">
		vol.<xsl:value-of select="occ/@v"/>.
	</xsl:template>

	<xsl:template match="field" mode="number">
		no.<xsl:value-of select="occ/@n"/>
	</xsl:template>
	
	<xsl:template match="field" mode="ISSN">
		; ISSN: <xsl:value-of select="occ"/>
	</xsl:template>

</xsl:stylesheet>
