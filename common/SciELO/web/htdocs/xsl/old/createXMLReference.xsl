<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output indent="yes" method="xml" encoding="ISO-8859-1"/>

	<xsl:template match="/">
		<cit>
			<xsl:copy-of select="SERIAL/TITLEGROUP" />
			<xsl:copy-of select="SERIAL/ISSN" />
			<xsl:copy-of select="SERIAL/COPYRIGHT" />
			<xsl:copy-of select="SERIAL/CONTACT" />
			<xsl:copy-of select="SERIAL/ISSUEINFO" />
			<xsl:copy-of select="SERIAL/ARTICLE" />
		</cit>
	</xsl:template>

	
</xsl:stylesheet>