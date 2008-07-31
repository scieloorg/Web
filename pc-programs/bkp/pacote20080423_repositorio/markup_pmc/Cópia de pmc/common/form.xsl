<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:variable name="parameter-values" select="//parameter-values"/>
	<xsl:template match="form">
		<xsl:comment>form</xsl:comment>
		<form method="post">
			<xsl:apply-templates select="@*[name()!='method']"/>
			<xsl:apply-templates select="*|text()"/>
		</form>
	</xsl:template>
	<xsl:template match="input[@type='submit' or @type='button']">
		<xsl:copy>
			<xsl:apply-templates select="@*|text()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="parameters">
		<xsl:apply-templates select="parameter"/>
	</xsl:template>
	<xsl:template match="parameter">
		<xsl:variable name="name" select="@name"/>
		<xsl:comment>parameter</xsl:comment>

		<xsl:apply-templates select="$parameter-values/parameter-value[@name=$name]">
			<xsl:with-param name="parameter" select="."/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="parameter-value">
		<xsl:param name="parameter"/>
		<xsl:comment>parameter-value</xsl:comment>
		<p>
		<xsl:apply-templates select="$parameter/*|$parameter/text()">
			<xsl:with-param name="parameter-value" select="."/>
		</xsl:apply-templates>
		</p>
	</xsl:template>
	<xsl:template match="input[@type='submit']/@value | input[@type='button']/@value">
		<xsl:variable name="label" select="."/>
		<xsl:attribute name="{name()}"><xsl:value-of select="$translations//message[@key=$label]"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="input[@*[contains(.,'parameter-id')]]">
		<xsl:param name="parameter-value"/>
		<input>
			<xsl:apply-templates select="@*|text()|*">
				<xsl:with-param name="parameter-value" select="$parameter-value"/>
			</xsl:apply-templates>
		</input>
	</xsl:template>
	<xsl:template match="input/@*[contains(.,'parameter-id')]"><xsl:param name="parameter-value"/><xsl:attribute name="{name()}"><xsl:value-of select="substring-before(.,'parameter-id')"/><xsl:value-of select="$parameter-value"/><xsl:value-of select="substring-after(.,'parameter-id')"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="parameter-id"><xsl:param name="parameter-value"/><xsl:text> </xsl:text> 
	<xsl:value-of select="$parameter-value"/>
	</xsl:template>
	
</xsl:stylesheet>
