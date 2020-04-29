<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:include href="oai_common.xsl"/>
	
	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:template match="SERIALLIST">
		<xsl:apply-templates select="LIST" />
	</xsl:template>
	
	<xsl:template match="LIST">
		<ListSets>
			<set>
				<setSpec>openaire</setSpec>
				<setName>OpenAIRE</setName>
			</set>
			<xsl:apply-templates/>
		</ListSets>
	</xsl:template>

	<xsl:template match="SERIAL">
		<set>
			<xsl:apply-templates/>
		</set>
	</xsl:template>
	
	<xsl:template match="TITLE">
		<setSpec><xsl:value-of select="@ISSN" /></setSpec>
		<setName><xsl:apply-templates select="text()" mode="cdata"/></setName>
	</xsl:template>
</xsl:stylesheet>
