<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes"/>

	<xsl:variable name="applServer" select="//vars/applServer"/>
	<xsl:variable name="country" select="//vars/country"/>	
	<xsl:variable name="collection" select="//vars/collection"/>
	<xsl:variable name="regionalScielo" select="//vars/regionalScielo"/>

	<xsl:template match="/">
		<rss version="0.91">
			<channel>
				<title>SciELO Get Collection List</title>
				<link>http://<xsl:value-of select="//applServer"/></link>
				<description>get_list_collection</description>
				<language>pt-br</language>
				<item>
					<title><xsl:value-of select="$collection"/></title>
					<link><xsl:value-of select="concat('http://',$regionalScielo,'/webservices/php/get_titles.php?type=collection&amp;param=',$applServer)"/></link>
					<description></description>
				</item>	
			</channel>
		</rss>		
	</xsl:template>
	
</xsl:stylesheet>
