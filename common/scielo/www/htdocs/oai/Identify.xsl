<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="oai_common.xsl"/>
	
	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="LIST_RECORDS">
		<xsl:apply-templates select="LIST/ARTICLE[1]/ISSUEINFO" mode="datestamp"/>
	</xsl:template>

</xsl:stylesheet>
