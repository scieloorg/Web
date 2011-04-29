<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes"/>

	<xsl:variable name="applServer" select="//vars/applServer"/>
	<xsl:variable name="country" select="//vars/country"/>	
	<xsl:variable name="letter" select="//vars/letter"/>	

	<xsl:template match="/">
		<rss version="0.91">
			<channel>
				<title>SciELO Get Titles</title>
				<link>http://<xsl:value-of select="//applServer"/></link>
				<description>get_titles</description>
				<language>pt-br</language>
				<xsl:choose>
					<xsl:when test="$letter != ''"><xsl:apply-templates select="//publicationTitle/occ[substring(.,1,1)=$letter]" mode="getItem"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="//publicationTitle/occ" mode="getItem"/></xsl:otherwise>
				</xsl:choose>
			</channel>
		</rss>		
	</xsl:template>

	<xsl:template match="*" mode="getItem">
		<xsl:variable name="pid" select="../../issn/occ"/>
		<xsl:variable name="sta" select="../../publicationStatus/occ"/>		
		<xsl:if test="$sta = 'C'">
			<item>
				<title><xsl:value-of select="concat(.,' (',$country,')')"/></title>
				<link><xsl:value-of select="concat('http://',$applServer,'/scielo.php?script=sci_serial&amp;pid=',$pid,'&amp;lng=en&amp;nrm=iso')"/></link>
				<description><xsl:value-of select="$country"/></description>
				<!--date><xsl:value-of select="date"/></date-->
			</item>	
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>