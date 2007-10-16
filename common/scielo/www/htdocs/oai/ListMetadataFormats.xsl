<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" encoding="utf-8" version="1.0" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:template match="ERROR">
		<error code="idDoesNotExist">No matching identifier</error>
	</xsl:template>

	<xsl:template match="*"></xsl:template>
</xsl:stylesheet>
