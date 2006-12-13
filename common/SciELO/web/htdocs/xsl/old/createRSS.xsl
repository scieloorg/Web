<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output indent="yes" encoding="ISO-8859-1"/>

<xsl:variable name="lang" select="/SERIAL/CONTROLINFO/LANGUAGE" />
<xsl:variable name="server" select="SERIAL/CONTROLINFO/SCIELO_INFO/SERVER" />

<xsl:template match="/">
<xsl:element name="rss">
	<xsl:attribute name="version">2.0</xsl:attribute>

	<xsl:element name="channel">
		<xsl:element name="generator">Scielo RSS</xsl:element>
		
		<xsl:element name="title"><xsl:value-of select="SERIAL/TITLEGROUP/TITLE" /></xsl:element>
		
		<xsl:element name="link">http://<xsl:value-of select="$server"/>/rss.php?pid=<xsl:value-of select="SERIAL/CONTROLINFO/PAGE_PID"/>&amp;lang=<xsl:value-of select="$lang"/></xsl:element>
		
		<xsl:element name="language">
			<xsl:value-of select="SERIAL/CONTROLINFO/LANGUAGE" />
		</xsl:element>
		
		<xsl:element name="image">
			<xsl:element name="title">SciELO Logo</xsl:element>
			<xsl:element name="url">http://<xsl:value-of select="$server"/>/img/en/fbpelogp.gif</xsl:element>
			<xsl:element name="link">http://<xsl:value-of select="$server"/></xsl:element>
		</xsl:element>
		<xsl:apply-templates select="SERIAL/CONTROLINFO" />
		<xsl:apply-templates select="SERIAL/ISSUE" />
	</xsl:element>
</xsl:element>
</xsl:template>


<xsl:template match="ISSUE">
<xsl:for-each select="SECTION">
	<xsl:element name="item">
		<xsl:element name="title">
			<xsl:choose>
				<xsl:when test="ARTICLE[@TEXT_LANG = $lang]"><xsl:value-of select="ARTICLE[@TEXT_LANG = $lang]/TITLE" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="ARTICLE/TITLE" /></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:element name="link">http://<xsl:value-of select="$server"/>/scielo.php?script=sci_arttext&amp;pid=<xsl:value-of select="ARTICLE/@PID" />&amp;lng=<xsl:value-of select="$lang" />&amp;nrm=iso&amp;tlng=<xsl:value-of select="$lang" /></xsl:element>
	</xsl:element>
	</xsl:for-each>
</xsl:template>

<xsl:template match="CONTROLINFO">
</xsl:template>

<xsl:template match="STRIP">
</xsl:template>

</xsl:stylesheet>