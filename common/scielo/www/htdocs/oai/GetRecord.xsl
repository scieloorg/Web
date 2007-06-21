<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:include href="file:///home/scielo/www/htdocs/oai/oai_common.xsl"/>
	
	<xsl:output method="xml" encoding="utf-8" version="1.0" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:template match="ERROR">
		<error code="idDoesNotExist">No matching identifier</error>
	</xsl:template>
	
	<xsl:template match="SERIAL">
		<GetRecord>
			<xsl:apply-templates select="ARTICLE" />
		</GetRecord>			
	</xsl:template>
			
</xsl:stylesheet>
