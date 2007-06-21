<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<!--
		Originalmente para atribuir um valor para um atributo.
		Serve também para acrescentar ou atualizar um elemento
	-->
	<xsl:variable name="separator" select="//separator"/>
	<xsl:variable name="xml" select="//xml"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="//xpaths" mode="start">
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="xpaths" mode="start">
		<xsl:apply-templates select="$xml" mode="start">
			<xsl:with-param name="xpath" select="*"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="xml" mode="start">
		<xsl:param name="xpath"/>

		<xsl:variable name="item" select="$xpath[position()=1]"/>
		<xsl:choose>
			<xsl:when test="contains($item,'@')">
				<xsl:variable name="name" select="substring-after($item, '@')"/>
				<xsl:apply-templates select=".//@*[name()=$name]">
					<xsl:with-param name="xpath" select="$xpath"/>
					<xsl:with-param name="position" select="1"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select=".//*[name()=$item]">
					<xsl:with-param name="xpath" select="$xpath"/>
					<xsl:with-param name="position" select="1"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="*" >
		<xsl:param name="xpath"/>
		<xsl:param name="position"/>

		<xsl:choose>
			<xsl:when test="count($xpath)&lt;$position">	
			</xsl:when>
			<xsl:when test="count($xpath)=$position"><xsl:value-of select="."/><xsl:value-of select="$separator"/>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="item" select="$xpath[position() = $position + 1]"/>
				<xsl:choose>
					<xsl:when test="contains($item,'@')">
						<xsl:variable name="name" select="substring-after($item, '@')"/>
						<xsl:apply-templates select="@*[name()=$name]">
							<xsl:with-param name="xpath" select="$xpath"/>
							<xsl:with-param name="position" select="$position + 1"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="*[name()=$item]">
							<xsl:with-param name="xpath" select="$xpath"/>
							<xsl:with-param name="position" select="$position + 1"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@*" >		
		<xsl:value-of select="."/><xsl:value-of select="$separator"			/>
	</xsl:template>
	
</xsl:stylesheet>
