<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output indent="yes" method="text" />

	<xsl:template match="/">
		<xsl:value-of select="'sid=scielo|genre=article|oi=citation'"/>
		<xsl:apply-templates select="." mode="createFields"/>
	</xsl:template>

	<xsl:template match="*" mode="createFields">
		<xsl:call-template name="getTitle" />
		<xsl:call-template name="getJournal" />
		<xsl:call-template name="getAutors" />
		<xsl:call-template name="getVol" />
		<xsl:call-template name="getNumber" />
		<xsl:call-template name="getYear" />
		<xsl:call-template name="getPages" />
	</xsl:template>
	
	<xsl:template name="getTitle">
		<xsl:if test="/SERIAL/ARTICLE/TITLES/TITLE != '' ">
			<xsl:value-of select="'|atitle='" disable-output-escaping="yes"/>
			<xsl:value-of select="/SERIAL/ARTICLE/TITLES/TITLE" />

		</xsl:if>
	</xsl:template>

	<xsl:template name="getJournal">
		<xsl:if test="/SERIAL/TITLEGROUP/TITLE != '' ">
			<xsl:value-of select="'|title='" disable-output-escaping="yes"/>
			<xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="getAutors">
		<xsl:variable name="total" select="count(/SERIAL/ARTICLE/AUTHORS/AUTH_PERS/AUTHOR)" />

		<xsl:for-each select="/SERIAL/ARTICLE/AUTHORS/AUTH_PERS/AUTHOR">
			<xsl:value-of select="'|au='" /><xsl:value-of select="SURNAME" disable-output-escaping="no"/>, <xsl:value-of select="NAME" disable-output-escaping="no"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getVol">
		<xsl:if test="/SERIAL/ISSUEINFO/@VOL != ''">
			<xsl:value-of select="concat('|volume=',/SERIAL/ISSUEINFO/@VOL,'')" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="getNumber">
		<xsl:if test="/SERIAL/ISSUEINFO/@VOL != ''">
			<xsl:value-of select="concat('|issue=',/SERIAL/ISSUEINFO/@NUM,'')" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="getYear">
		<xsl:if test="/SERIAL/ISSUEINFO/@YEAR != '' ">
			<xsl:value-of select="concat('|date=',/SERIAL/ISSUEINFO/@YEAR,'')" />

		</xsl:if>
	</xsl:template>

	<xsl:template name="getPages">
		<xsl:if test="/SERIAL/ARTICLE/@FPAGE != ''">
			<xsl:value-of select="concat('|pages=', /SERIAL/ARTICLE/@FPAGE)" />
			<xsl:value-of select="concat('-', /SERIAL/ARTICLE/@LPAGE)" />

		</xsl:if>
	</xsl:template>

</xsl:stylesheet>