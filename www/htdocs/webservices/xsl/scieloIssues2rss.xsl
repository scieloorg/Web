<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes"/>
	
	<xsl:variable name="applServer" select="//vars/applServer"/>
	
	<xsl:template match="/">
		<rss version="0.91">
			<channel>
				<title>SciELO New Issues</title>
				<link>http://<xsl:value-of select="//applServer"/></link>
				<description>new_issues</description>
				<language>pt-br</language>
				<xsl:apply-templates select="//title"/>
			</channel>
		</rss>
	</xsl:template>	
	
	<xsl:template match="title">
		<xsl:variable name="issn" select="../issn/occ"/>
		<xsl:variable name="pubYear" select="../pubYear/occ"/>		
		<xsl:variable name="volume" select="../volume/occ"/>
		<xsl:variable name="numero" select="../numero/occ"/>
		<xsl:variable name="updateDate" select="../updateDate/occ"/>		
		<item>
			<title><xsl:value-of select="concat(.,' vol-',$volume,' num-',$numero)"/></title>
			<link><xsl:value-of select="concat('http://',$applServer,'/scielo.php?script=sci_issuetoc&amp;pid=',$issn,$pubYear,format-number($numero,'0000'),'&amp;nrm=iso&amp;lng=en')"/></link>
			<description><xsl:value-of select="$updateDate"/></description>
		</item>
	</xsl:template>

</xsl:stylesheet>
