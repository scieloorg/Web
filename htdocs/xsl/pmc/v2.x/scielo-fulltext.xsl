<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:template match="ISSUE/ARTICLE[fulltext]">     
        <xsl:apply-templates select="fulltext" mode="MAIN"/>
    </xsl:template>

    <xsl:template match="fulltext" mode="MAIN">
        <xsl:variable name="this-article">
            <xsl:apply-templates select="." mode="id"/>
        </xsl:variable>
        <div id="{$this-article}-front" class="front">
            <xsl:apply-templates select="front-stub | front"/>
        </div>
        <div id="{$this-article}-body" class="body">
            <xsl:apply-templates select="body"/>
        </div>
        
        <xsl:choose>
            <xsl:when test="back | $loose-footnotes">
                <div id="{$this-article}-back" class="back">
                    <xsl:apply-templates select="back"/>
                </div>
            </xsl:when>
        </xsl:choose>
        
        <xsl:for-each select="floats-group">
            <div id="{$this-article}-floats" class="back">
                <xsl:call-template name="main-title">
                    <xsl:with-param name="contents">
                        <span class="generated">Floating objects</span>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>
        <div class="foot-notes">
            <xsl:choose>
                <xsl:when test=".//front//history">
                    <xsl:apply-templates select=".//front//history"/>
                </xsl:when>
                <xsl:when test=".//history">
                    <xsl:apply-templates select=".//front//history"/>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test=".//front//author-notes">
                    <xsl:apply-templates select=".//front//author-notes"/>
                </xsl:when>
                <xsl:when test=".//author-notes">
                    <xsl:apply-templates select=".//author-notes"/>
                </xsl:when>
                
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="alt-title"></xsl:template>
    
    <xsl:template match="fulltext//aff/label"><sup><xsl:apply-templates></xsl:apply-templates></sup>
    </xsl:template>
    <xsl:template match="fulltext//aff">
            <p>
        <xsl:apply-templates select="label"></xsl:apply-templates>
            <xsl:apply-templates select="*[name()!='label']"></xsl:apply-templates>
        </p>
    </xsl:template>
    <xsl:template match="fulltext//aff/*">
        <xsl:if test="position()!=1">, </xsl:if><xsl:apply-templates></xsl:apply-templates>
    </xsl:template>
    
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