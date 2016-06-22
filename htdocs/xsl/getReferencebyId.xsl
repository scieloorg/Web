<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:xlink="http://www.w3.org/1999/xlink">
	
	<xsl:output method="text" omit-xml-declaration="yes" encoding="iso-8859-1"/>
	
	<xsl:variable name="refId" select="//vars/refId"/>
	
	<xsl:template match="/">
		
		<xsl:choose>
			<xsl:when test="//wxis-modules/record">
				<xsl:value-of select="//wxis-modules/record[field[@tag = 888]/occ = $refId]/field[@tag=704]/occ"/>
			</xsl:when>
			<xsl:when test="//references-from-xml/@file">
				<xsl:apply-templates select="document(concat('../../bases/xml/',//references-from-xml//@file))//ref[position()=$refId]/mixed-citation"/>
			</xsl:when>
			<xsl:otherwise>
				Reference <xsl:value-of select="$refId"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	<xsl:template match="mixed-citation">
		<xsl:apply-templates select="*|text()"/>
	</xsl:template>
	<xsl:template match="italic">
		<i><xsl:apply-templates/></i>
	</xsl:template>
	<xsl:template match="bold">
		<em><xsl:apply-templates/></em>
	</xsl:template>
	<xsl:template match="ext-link/@xlink:href">
		<xsl:attribute name="href">
			<xsl:apply-templates></xsl:apply-templates>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="ext-link">
		<a><xsl:apply-templates/></a>
	</xsl:template>
	
</xsl:stylesheet>
