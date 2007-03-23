<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes"/>
	
	<xsl:variable name="applServer" select="//vars/applServer"/>
	<xsl:variable name="country" select="//vars/country"/>	
	
	<xsl:template match="/">
		<rss version="0.91">
			<channel>
				<title>SciELO New Titles</title>
				<link>http://<xsl:value-of select="$applServer"/></link>
				<description>new_titles</description>
				<language>pt-br</language>
				<xsl:apply-templates select="//record" mode="getItem"/>
			</channel>
		</rss>		
	</xsl:template>

	<xsl:template match="*" mode="getItem">
		<xsl:variable name="pid" select="issn"/>
		<item>
			<title><xsl:value-of select="concat(title,' (',$country,')')"/></title>
			<link><xsl:value-of select="concat('http://',$applServer,'/scielo.php?script=sci_serial&amp;pid=',$pid,'&amp;lng=en&amp;nrm=iso')"/></link>
			<description><xsl:value-of select="updateDate"/></description>
			<!--date><xsl:value-of select="date"/></date-->
		</item>	
	</xsl:template>
	
</xsl:stylesheet>
