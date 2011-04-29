<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output indent="yes" method="text" />

	<xsl:template match="/">
		<xsl:value-of select="'@article{'"/>
		<xsl:apply-templates select="." mode="createKey"/>
		<xsl:value-of select="'
		'"/>
		<xsl:apply-templates select="." mode="createFields"/>
<xsl:value-of select="'}'"/>
	</xsl:template>
	
	<xsl:template match="*" mode="createKey">
		<xsl:value-of select="concat(//UPP_SURNAME,//YEAR,'|')"/>
	</xsl:template>
	
	<xsl:template match="*" mode="createFields">
		<xsl:call-template name="getTitle" />
		<xsl:call-template name="getJournal" />
		<xsl:call-template name="getAutors" />
		<xsl:call-template name="getISSN" />
		<xsl:call-template name="getArticleLang" />
		<xsl:call-template name="getURL" />
		<xsl:call-template name="getVol" />
		<xsl:call-template name="getYear" />
		<xsl:call-template name="getMonth" />
		<xsl:call-template name="getPages" />
		<xsl:call-template name="getPublisher" />
		<xsl:call-template name="getDOI" />
	</xsl:template>
	
	<xsl:template name="space">
		<xsl:value-of select="'
		'"/>	
	</xsl:template>

	<xsl:template name="getTitle">
		<xsl:if test="/SERIAL/ARTICLE/TITLES/TITLE != '' ">
			<xsl:value-of select="'title = {{'" disable-output-escaping="yes"/>
			<xsl:value-of select="/SERIAL/ARTICLE/TITLES/TITLE" />
			<xsl:value-of select="'}}|'"/>
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="getJournal">
		<xsl:if test="/SERIAL/TITLEGROUP/TITLE != '' ">
			<xsl:value-of select="'journal = {{'" disable-output-escaping="yes"/>
			<xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" />
			<xsl:value-of select="'}}|'"/>
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="getAutors">
		<xsl:variable name="total" select="count(/SERIAL/ARTICLE/AUTHORS/AUTH_PERS/AUTHOR)" />
		<xsl:value-of select="'author={'" />
		<xsl:for-each select="/SERIAL/ARTICLE/AUTHORS/AUTH_PERS/AUTHOR">
			<xsl:value-of select="SURNAME" disable-output-escaping="no"/>, <xsl:value-of select="NAME" disable-output-escaping="no"/>
			<xsl:if test="position() != $total"> AND </xsl:if>
		</xsl:for-each>
		<xsl:value-of select="'}'" />
		<xsl:value-of select="'|'" />
		<xsl:call-template name="space" />
	</xsl:template>

	<xsl:template name="getISSN">
		<xsl:if test="/SERIAL/ISSN != ''">
			<xsl:value-of select="concat('ISSN = {', /SERIAL/ISSN,'}|')"/>
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>


	<xsl:template name="getArticleLang">
		<xsl:if test="/SERIAL/ARTICLE/@TEXT_LANG != ''">
			<xsl:value-of select="concat('language = {',/SERIAL/ARTICLE/@TEXT_LANG,'}|','')"/>
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="getURL">
		<xsl:if test="/SERIAL/CONTROLINFO/SCIELO_INFO/SERVER != ''">
			<xsl:value-of select="concat('URL = {http://',/SERIAL/CONTROLINFO/SCIELO_INFO/SERVER,'/scielo.php?script=sci_arttext&amp;pid=',//SERIAL/CONTROLINFO/PAGE_PID,'&amp;nrm=iso}|')"/>
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>


	<xsl:template name="getVol">
		<xsl:if test="/SERIAL/ISSUEINFO/@VOL != ''">
			<xsl:value-of select="concat('volume = {',/SERIAL/ISSUEINFO/@VOL,'}|')" />
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="getYear">
		<xsl:if test="/SERIAL/ISSUEINFO/@YEAR != '' ">
			<xsl:value-of select="concat('year = {',/SERIAL/ISSUEINFO/@YEAR,'}|')" />
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="getMonth">
		<xsl:if test="/SERIAL/ISSUEINFO/@MONTH != ''">
			<xsl:value-of select="concat('month = {',/SERIAL/ISSUEINFO/@MONTH,'}|')" />
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="getPages">
		<xsl:if test="/SERIAL/ARTICLE/@FPAGE != ''">
			<xsl:value-of select="concat('pages = {', /SERIAL/ARTICLE/@FPAGE,' - ',/SERIAL/ARTICLE/@LPAGE,'}|')" />
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="getPublisher">
		<xsl:if test="/SERIAL/CONTROLINFO/APP_NAME != ''">
			<xsl:value-of select="concat('publisher = {',/SERIAL/CONTROLINFO/APP_NAME,'}|')" />
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="getDOI">
		<xsl:if test="/SERIAL/ARTICLE/@DOI != ''">
			<xsl:value-of select="concat('crossref = {',/SERIAL/ARTICLE/@DOI,'}|')" />
			<xsl:call-template name="space" />
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>