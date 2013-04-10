<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:template match="ISSUE/ARTICLE[fulltext]">
        
        <xsl:apply-templates select="fulltext" mode="text-content"></xsl:apply-templates>
    </xsl:template>
    <xsl:template match="fulltext" mode="text-content">
        <xsl:call-template name="scift-make-article"/>		
    </xsl:template>
    
    
    <xsl:template match="alt-title"></xsl:template>
    
    
    <xsl:template match="citation//@*"/>
    
    <xsl:template match="citation | citation//*">
         <xsl:apply-templates select="@* | text() | *"/>
    </xsl:template>
    
    <xsl:template match="citation/person-group">
        <xsl:apply-templates select="name" mode="author"></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="citation/person-group/name" mode="author"><xsl:if test="position()!=1">, </xsl:if>       
        <xsl:apply-templates select="surname"></xsl:apply-templates>&#160;
        <xsl:apply-templates select="given-names"></xsl:apply-templates></xsl:template>
    
    <xsl:template match="citation//year">
        (<xsl:value-of select="."/>)       
    </xsl:template>
    
    <xsl:template match="citation//volume">
        &#160;<xsl:value-of select="."/>:</xsl:template>
    <xsl:template match="citation//lpage">-<xsl:value-of select="."/>.  
    </xsl:template>
    
    <xsl:template match="citation//article-title">
        <xsl:value-of select="."/>.       
    </xsl:template>
    
    
</xsl:stylesheet>