<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output indent="yes" method="text" />

	<xsl:template match="/">
		<xsl:apply-templates select="." mode="createFields"/>
	</xsl:template>
	
	<xsl:template match="*" mode="createFields">
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:call-template name="getAutors" />
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:call-template name="getTitle" />
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:call-template name="getJournal" />
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:value-of select="'&quot;&quot;,'" disable-output-escaping="yes"/>
		<xsl:call-template name="getISSN" />
		<xsl:call-template name="getURL" />
		<xsl:call-template name="getVol" />
		<xsl:call-template name="getYear" />
		<xsl:call-template name="getPages" />
		<xsl:call-template name="getPublisher" />
	</xsl:template>
	
	<xsl:template name="getTitle">
		<xsl:if test="/SERIAL/ARTICLE/TITLES/TITLE != '' ">
			<xsl:value-of select="'&quot;'" disable-output-escaping="yes"/>
			<xsl:value-of select="/SERIAL/ARTICLE/TITLES/TITLE" />
			<xsl:value-of select="'&quot;,'" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getJournal">
		<xsl:if test="/SERIAL/TITLEGROUP/TITLE != '' ">
			<xsl:value-of select="'&quot;'" disable-output-escaping="yes"/>
			<xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" />
			<xsl:value-of select="'&quot;,'" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getAutors">
		<xsl:variable name="total" select="count(/SERIAL/ARTICLE/AUTHORS/AUTH_PERS/AUTHOR)" />

		<xsl:value-of select="'&quot;'" disable-output-escaping="yes"/>
		
		<xsl:for-each select="/SERIAL/ARTICLE/AUTHORS/AUTH_PERS/AUTHOR">
			<xsl:value-of select="SURNAME" disable-output-escaping="no"/>, <xsl:value-of select="NAME" disable-output-escaping="no"/>
			<xsl:if test="position() != $total">,</xsl:if>
		</xsl:for-each>
			<xsl:value-of select="'&quot;,'" disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template name="getISSN">
		<xsl:if test="/SERIAL/ISSN != ''">
			<xsl:value-of select="'&quot;'" disable-output-escaping="yes"/>
				<xsl:value-of select="/SERIAL/ISSN"/>
			<xsl:value-of select="'&quot;,'" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getURL">
		<xsl:if test="/SERIAL/CONTROLINFO/SCIELO_INFO/SERVER != ''">
			<xsl:value-of select="'&quot;'" disable-output-escaping="yes"/>
				<xsl:value-of select="concat(' http://',/SERIAL/CONTROLINFO/SCIELO_INFO/SERVER,'/scielo.php?script=sci_arttext&amp;pid=',//SERIAL/CONTROLINFO/PAGE_PID,'&amp;nrm=iso')"/>
			<xsl:value-of select="'&quot;,'" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>


	<xsl:template name="getVol">
		<xsl:if test="/SERIAL/ISSUEINFO/@VOL != ''">
			<xsl:value-of select="'&quot;'" disable-output-escaping="yes"/>
				<xsl:value-of select="/SERIAL/ISSUEINFO/@VOL" />
			<xsl:value-of select="'&quot;,'" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getYear">
		<xsl:if test="/SERIAL/ISSUEINFO/@YEAR != '' ">
			<xsl:value-of select="'&quot;'" disable-output-escaping="yes"/>
				<xsl:value-of select="/SERIAL/ISSUEINFO/@YEAR" />
			<xsl:value-of select="'&quot;,'" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getPages">
		<xsl:if test="/SERIAL/ARTICLE/@FPAGE != ''">
			<xsl:value-of select="'&quot;'" disable-output-escaping="yes"/>
				<xsl:value-of select="/SERIAL/ARTICLE/@FPAGE" />
				<xsl:value-of select="concat('-', /SERIAL/ARTICLE/@LPAGE)" />
			<xsl:value-of select="'&quot;,'" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getPublisher">
		<xsl:if test="/SERIAL/CONTROLINFO/APP_NAME != ''">
			<xsl:value-of select="'&quot;'" disable-output-escaping="yes"/>
				<xsl:value-of select="/SERIAL/CONTROLINFO/APP_NAME" />
			<xsl:value-of select="'&quot;,'" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>