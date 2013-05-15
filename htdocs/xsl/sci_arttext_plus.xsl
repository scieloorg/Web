<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd"
    version="3.0">
    
    
    <xsl:import href="plus/layout.xsl"/>
    <xsl:import href="plus/data.xsl"/>
    
    <xsl:output method="html"  indent="yes"/>  
    <xsl:param name="IMAGE_PATH"></xsl:param>
    <xsl:param name="PATH">.</xsl:param>
    <xsl:param name="PAGE_LANG" select="'en'"/>
    <xsl:param name="INTERFACE_LANG" select="'en'"/>
    <xsl:param name="PID" select="''"/>
    <xsl:param name="COLLECTION_DOMAIN" select="''"/>
    <xsl:variable name="SERVICE_RELATED"/>
    
    
    <xsl:variable name="SHORT-LINK"/>
    <xsl:variable name="ref" select=".//ref"/>
    
    <xsl:variable name="DISPLAY_ARTICLE_TITLE">
        <xsl:apply-templates
            select=".//front//article-title[@xml:lang=$PAGE_LANG] | .//front//subtitle[@xml:lang=$PAGE_LANG]"/>
        <xsl:apply-templates
            select=".//front//trans-title-group[@xml:lang=$PAGE_LANG]/trans-title| .//front//trans-title-group[@xml:lang=$PAGE_LANG]/trans-subtitle"/>
        <xsl:apply-templates
            select=".//front-stub//article-title[@xml:lang=$PAGE_LANG] | .//front-stub//subtitle[@xml:lang=$PAGE_LANG]"
        />
    </xsl:variable>
    <xsl:variable name="ARTICLE_TITLE">
        <xsl:apply-templates
            select=".//front//article-title[@xml:lang=$PAGE_LANG]//text() | .//front//subtitle[@xml:lang=$PAGE_LANG]//text()"/>
        <xsl:apply-templates
            select=".//front//trans-title-group[@xml:lang=$PAGE_LANG]/trans-title//text()| .//front//trans-title-group[@xml:lang=$PAGE_LANG]/trans-subtitle//text()"/>
        <xsl:apply-templates
            select=".//front-stub//article-title[@xml:lang=$PAGE_LANG]//text() | .//front-stub//subtitle[@xml:lang=$PAGE_LANG]//text()"
        />
    </xsl:variable>
    <xsl:variable name="THIS_URL"/>
    <xsl:variable name="THIS_ABSTRACT_URL"/>
    <xsl:variable name="THIS_PDF_URL"/>
    <xsl:template match="/">
        <xsl:apply-templates select=".//article" mode="HTML"
            ></xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>
