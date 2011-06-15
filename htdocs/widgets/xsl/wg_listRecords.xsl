<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:dc="http://purl.org/dc/elements/1.1/">
<xsl:output encoding="ISO-8859-1" version="4.0" omit-xml-declaration="yes" method="html" indent="yes"/>
	<xsl:template match="/">
		<ul>
			<xsl:apply-templates select="resources/resource"/>
		</ul>	   
	</xsl:template>
	
	<xsl:template match="resource">
		<li><a href="{dc:identifier}" target="_blank"><xsl:value-of select="dc:title"/></a></li>
	</xsl:template>
	
</xsl:stylesheet>
