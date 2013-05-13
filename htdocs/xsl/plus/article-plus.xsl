<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xlink=""
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 10, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> robertatakenaka</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:param name="PAGE_LANG" select="'en'"/>
    <xsl:param name="INTERFACE_LANG" select="'en'"/>
    <xsl:param name="PID" select="''"/>
    <xsl:param name="COLLECTION_DOMAIN" select="''"/>
    <xsl:variable name="SERVICE_RELATED"/>

    <xsl:template match="@*" mode="DATA-DISPLAY">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*" mode="DATA-DISPLAY">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@* | *|text()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="article-title| subtitle | trans-title | trans-subtitle | corresp">
        <xsl:apply-templates select="*|text()" mode="DATA-DISPLAY"/>
    </xsl:template>

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

    <xsl:template match="article" mode="HTML-HEAD-META">
        <meta name="citation_journal_title" content="{.//journal-meta//journal-title}"/>
        <meta name="citation_journal_title_abbrev" content="{.//journal-meta//abbrev-journal-title}"/>
        <meta name="citation_publisher" content="{.//journal-meta//publisher-name}"/>
        <meta name="citation_title" content="{$ARTICLE_TITLE}"/>

        <meta name="citation_date"
            content="{.//article-meta//pub-date[1]//month}/{.//article-meta//pub-date[1]//year}"/>
        <meta name="citation_volume" content="{.//article-meta//volume}"/>
        <meta name="citation_issue" content="{.//article-meta//issue}"/>
        <meta name="citation_issn" content="{.//journal-meta//issn[1]}"/>
        <meta name="citation_doi" content="{.//article-meta//article-id[@pub-id-type='doi']}"/>
        <!-- adicionar links para os parâmetros abaixo -->
        <meta name="citation_abstract_html_url" content="{$THIS_ABSTRACT_URL}"/>
        <meta name="citation_fulltext_html_url" content="{$THIS_URL}"/>
        <meta name="citation_pdf_url" content="{$THIS_PDF_URL}"/>
        <xsl:apply-templates select=".//article-meta//contrib//name" mode="HTML-HEAD-META"/>
        <xsl:apply-templates select=".//article-meta//collab" mode="HTML-HEAD-META"/>

        <meta name="citation_firstpage" content="{.//article-meta//fpage}"/>
        <meta name="citation_lastpage" content="{.//article-meta//lpage}"/>
        <meta name="citation_id" content="{.//article-meta//article-id[@pub-id-type='doi']}"/>

    </xsl:template>
    <xsl:template match="name" mode="HTML-HEAD-META">
        <meta name="citation_author"
            content="{.//surname}, {.//given-names}, {.//prefix}, {.//suffix}"/>
    </xsl:template>
    <xsl:template match="collab" mode="HTML-HEAD-META">
        <meta name="citation_author" content="{.//text()}"/>
    </xsl:template>
    <xsl:template match="aff" mode="HTML-HEAD-META">
        <meta name="citation_author_institution" content="{.//text()}"/>
    </xsl:template>
    <xsl:template match="*" mode="DATA-publication-title">
        <xsl:value-of select=".//journal-meta//journal-title"/>
    </xsl:template>
    <xsl:template match="*" mode="DATA-DISPLAY-ISSN"> Online version ISSN 1414-431X </xsl:template>
    <xsl:template match="*" mode="DATA-issue-label"> Braz. J. Med. Biol. Res. vol. 46 no. 1 </xsl:template>
    <xsl:template match="*" mode="DATA-article-categories"> Biomedical Sciences </xsl:template>
    <xsl:template match="*" mode="DATA-DISPLAY-article-title">
        <xsl:value-of select="$DISPLAY_ARTICLE_TITLE"/>
    </xsl:template>

    <xsl:template match="*" mode="DATA-statistics-service">
        <xsl:if test="$PID!='' and $COLLECTION_DOMAIN!=''"
                >/applications/scielo-org/pages/services/articleRequestGraphicPage.php?pid=<xsl:value-of
                select="$PID"/>&amp;caller=<xsl:value-of select="$COLLECTION_DOMAIN"
                />&amp;lang=<xsl:value-of select="$INTERFACE_LANG"/></xsl:if>
    </xsl:template>
    <xsl:template match="name" mode="DATA-DISPLAY"><xsl:apply-templates select="surname"/>
        <xsl:apply-templates select="suffix"/> , <xsl:apply-templates select="given-names"/><xsl:if
            test="prefix">, <xsl:value-of select="prefix"/>
        </xsl:if></xsl:template>
    <xsl:template match="aff" mode="DATA-label">
        <xsl:value-of select="label"/>
    </xsl:template>
    <xsl:template match="aff" mode="DATA-DISPLAY">
        <!-- FIXME -->
        <xsl:apply-templates select=".//text()"/>
    </xsl:template>
    <xsl:template match="permissions" mode="DATA-DISPLAY">
        <p>
            <xsl:apply-templates select=".//license-p" mode="DATA-DISPLAY"/>
        </p>
        <!--TRANSLATE-->
        <a href="{license/@xlink:href}" target="_blank">See license permissions</a>

    </xsl:template>
    <xsl:template match="abstract|trans-abstract" mode="DATA-DISPLAY-TITLE">
        <xsl:apply-templates select="title"/>
        <xsl:if test="not(.//title)">Abstract</xsl:if>
        <!-- FIXME -->

    </xsl:template>
    <xsl:template match="person-group" mode="DATA-DISPLAY-ref">
        <xsl:if test="position()!=1">, </xsl:if>
        <xsl:apply-templates select="name" mode="DATA-DISPLAY"/>
    </xsl:template>

    <xsl:template match="pub-id" mode="DATA-DISPLAY">
        <xsl:value-of select="@pub-id-type"/>: <xsl:value-of select="."></xsl:value-of>
    </xsl:template>
    <xsl:template match="pub-id[@pub-id-type='doi']| comment[contains(.,'doi:')]" mode="DATA-DISPLAY">
        http://dx.doi.org/<xsl:value-of select="."></xsl:value-of>
    </xsl:template>
</xsl:stylesheet>
