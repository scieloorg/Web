<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:include href="TextViewer/xsl/common/page.xsl"/>
	<xsl:include href="TextViewer/xsl/common/form.xsl"/>

	<xsl:template match="*" mode="content">
		<xsl:apply-templates select="//html/*"/>
	</xsl:template>
</xsl:stylesheet>
