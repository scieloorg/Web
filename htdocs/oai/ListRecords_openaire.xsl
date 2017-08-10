<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="oai_openaire_common.xsl"/>
	
	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="ERROR">
		<xsl:choose>
			<xsl:when test=" CODE = '0001' "><error code="noRecordsMatch"/></xsl:when>
			<xsl:when test=" CODE = '0003' "><error code="badResumptionToken"/></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="LIST_RECORDS">
		<xsl:apply-templates select="LIST" />
	</xsl:template>
	
	<xsl:template match="LIST">
		<xsl:choose>
			<xsl:when test="ARTICLE">
				<ListRecords>
					<xsl:apply-templates/>
				</ListRecords>
			</xsl:when>
			<xsl:otherwise>
				<error code="noRecordsMatch"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
		
</xsl:stylesheet>

