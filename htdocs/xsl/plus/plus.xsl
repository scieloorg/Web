<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd"
    version="3.0">
    <xsl:output method="html" encoding="UTF-8"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 10, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> robertatakenaka</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:param name="PATH" select="'.'"/>
    <xsl:param name="PAGE_LANG" select="'en'"/>
    <xsl:variable name="SHORT-LINK"/>
    <xsl:variable name="ref//element-citation" select=".//ref"/>
    <xsl:template match="*" mode="HTML">
        <html class="no-js" lang="{$PAGE_LANG}">
            <xsl:apply-templates select="." mode="HTML-HEAD"/>
            <xsl:apply-templates select="." mode="HTML-BODY"/>
        </html>
    </xsl:template>
    <xsl:template match="*" mode="HTML-HEAD">
        <xsl:apply-templates select="." mode="HTML-HEAD-META"/>

        <link rel="shortcut icon" href="{$PATH}/static/img/favicon.ico"/>
        <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no"/>

        <link href="{$PATH}/static/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="{$PATH}/static/css/responsive.css" rel="stylesheet"/>
        <link href="{$PATH}/static/css/style.css" rel="stylesheet"/>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY">
        <body class="skin-soft-contrast">
            <xsl:apply-templates select="." mode="HTML-BODY-HEADER"/>
            <section>
                <div class="container">
                    <xsl:apply-templates select="." mode="HTML-BODY-SECTION-HEADER"/>
                    <xsl:apply-templates select="." mode="HTML-BODY-SECTION-ARTICLE"/>
                </div>
            </section>
        </body>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-HEADER">
        <header id="top">
            <div class="mainHeader">
                <div class="container">
                    <div class="row">
                        <h2 class="span2">SciELO</h2>
                        <h1 class="span6 offset2">
                            <xsl:apply-templates select="." mode="DATA-publication-title"/>
                        </h1>
                        <div class="span4 epub-issn hidden-phone">
                            <xsl:apply-templates select="." mode="DATA-DISPLAY-ISSN"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="row publish-version">
                    <div class="span6 offset2">
                        <xsl:apply-templates select="." mode="DATA-issue-label"/>
                    </div>
                    <div class="span4 doi-url hidden-tablet hidden-phone">
                            http://dx.doi.org/<xsl:apply-templates
                            select=".//article-meta//*[@pub-id-type='doi']"/>
                    </div>
                </div>
            </div>
        </header>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-SECTION-HEADER">
        <header class="row">
            <div class="span8">
                <h2 class="article-categories">
                    <xsl:apply-templates select="." mode="DATA-article-categories"/>
                </h2>
                <h1 class="article-title">
                    <xsl:apply-templates select="." mode="DATA-DISPLAY-article-title"/>
                </h1>
                <xsl:apply-templates select="." mode="HTML-short-link-and-statistics"/>
                <xsl:apply-templates select=".//front//contrib-group" mode="HTML"/>
                <div class="row link-group">
                    <xsl:apply-templates select=".//front" mode="HTML-aff-list"/>
                    <xsl:apply-templates select=".//front//permissions" mode="HTML"/>
                </div>
            </div>
            <div class="span4">
                <xsl:apply-templates select="." mode="HTML-toolbox"/>
            </div>
        </header>
    </xsl:template>
    <xsl:template match="*" mode="HTML-SHORT-LINK">
        <xsl:if test="$SHORT-LINK!=''">
            <!--TRANSLATE-->
            <input type="text" name="link-share" class="trans bIcon link" value="{$SHORT-LINK}"
                data-toggle="tooltip" title="Click to copy URL to clipboard"/>

        </xsl:if>
    </xsl:template>
    <xsl:template match="." mode="HTML-short-link-and-statistics">
        <div class="row link-group">
            <div class="span3">
                <xsl:apply-templates select="." mode="HTML-SHORT-LINK"/>
            </div>
            <div class="dropdown span5">
                <xsl:variable name="href">
                    <xsl:apply-templates select="." mode="DATA-statistics-service"/>
                </xsl:variable>
                <xsl:if test="$href!=''">
                    <!--TRANSLATE-->
                    <a href="javascript:void(0);" class="bIcon stats">Article Indicators</a>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                        <!--<li><a tabindex="-1" href="#">Cited by SciELO</a></li>-->
                        <li>
                            <a tabindex="-1" href="{$href}" class="iframeModal">Access
                                Statistics</a>
                            <!--TRANSLATE-->
                        </li>
                    </ul>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="contrib-group" mode="HTML">
        <div class="contrib-group">
            <xsl:apply-templates select=".//name" mode="HTML"/>
        </div>
    </xsl:template>
    <xsl:template match="name" mode="HTML">
        <span>
            <xsl:apply-templates select="." mode="DATA-DISPLAY"/>
            <xsl:apply-templates select="..//xref" mode="HTML-author"/>
        </span>
    </xsl:template>
    <xsl:template match="xref" mode="HTML-author">
        <sup class="xref">
            <xsl:value-of select="."/>
        </sup>
    </xsl:template>
    <xsl:template match="*" mode="HTML-aff-list">
        <div class="span3">
            <a href="javascript:void(0);" class="bIcon author">Author affiliation</a>
            <div class="infoContainer author-affiliation hide">
                <a href="javascript:void(0);" class="close pull-right">&times;</a>
                <ul class="clearfix">
                    <xsl:apply-templates select=".//aff" mode="HTML"/>
                </ul>
                <xsl:apply-templates select=".//author-notes" mode="HTML"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="aff" mode="HTML">
        <li>
            <sup class="xref big">
                <xsl:apply-templates select="." mode="DATA-label"/>
            </sup>
            <xsl:apply-templates select="." mode="DATA-DISPLAY"/>
        </li>
    </xsl:template>
    <xsl:template match="author-notes" mode="HTML">
        <div class="author-notes">
            <!--TRANSLATE-->
            <!-- FIXME -->
            <strong>Author notes</strong>
            <br/>
            <xsl:apply-templates select="*"/>
        </div>
    </xsl:template>
    <xsl:template match="email">
        <a href="mailto:">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    <xsl:template match="permissions" mode="HTML">
        <div class="span5">
            <!-- TRANSLATE -->
            <a href="javascript:void(0);" class="bIcon copyright">Permissions</a>
            <div class="infoContainer permissions hide">
                <a href="javascript:void(0);" class="close pull-right">&times;</a>
                <xsl:apply-templates select="." mode="DATA-DISPLAY"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="*" mode="HTML-toolbox">
        <!-- FIXME -->
        <ul class="rMenu">
            <li>
                <a href="javascript:void(0);" class="yIcon calendar fold">Publication dates
                        <span>-</span></a>
                <!-- TRANSLATE -->
                <div>
                    <p>
                        <strong>October 23, 2013</strong><br/> Electronic publication (usually web,
                        but also includes CD-ROM or other electronic only distribution) </p>
                    <p>
                        <strong>January, 2013</strong><br/> Collection </p>
                </div>
            </li>
            <li>
                <a
                    href="http://www.scielo.br/scielo.php?script=sci_pdf&amp;pid=S0100-879X2013000100058&amp;lng=en&amp;nrm=iso&amp;tlng=en"
                    class="yIcon pdf" target="_blank">Article in PDF</a>
            </li>
            <li>
                <a
                    href="http://www.scielo.br/scieloOrg/php/articleXML.php?pid=S0100-879X2013000100058&amp;lang=en"
                    target="_blank" class="yIcon xml">Article in XML</a>
            </li>
            <li>
                <a
                    href="http://www.scielo.br/scieloOrg/php/reference.php?pid=S0100-879X2013000100058&amp;caller=www.scielo.br&amp;lang=en"
                    class="yIcon refs iframeModal">Article references</a>
            </li>
            <li>
                <a
                    href="http://www.scielo.br/scieloOrg/php/translate.php?pid=S102-879X2013000100058&amp;caller=www.scielo.br&amp;lang=en&amp;tlang=en&amp;script=sci_arttext"
                    class="yIcon translate iframeModal">Automatic translation</a>
            </li>
            <li>
                <a
                    href="http://www.scielo.br/applications/scielo-org/pages/services/sendMail.php?pid=S0100-879X2013000100058&amp;caller=www.scielo.br&amp;lang=en"
                    class="yIcon send iframeModal">Send this article by e-mail</a>
            </li>
            <li>
                <a href="javascript:void(0);" class="yIcon social fold">Share this article
                        <span>+</span></a>
                <div class="hide"> links </div>
            </li>
        </ul>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-SECTION-ARTICLE">
        <xsl:apply-templates select="." mode="HTML-BODY-SECTION-ARTICLE-ABSTRACT"/>
        <xsl:apply-templates select="." mode="HTML-BODY-SECTION-ARTICLE-CONTENT"/>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-SECTION-ARTICLE-ABSTRACT">
        <article id="abstract">
            <xsl:apply-templates
                select=".//front//abstract| .//front//trans-abstract | .//front-stub//abstract"/>
        </article>
    </xsl:template>

    <xsl:template match="abstract|trans-abstract" mode="HTML-BODY-SECTION-ARTICLE-ABSTRACT">
        <xsl:variable name="lang" select="@xml:lang"/>
        <h1>
            <xsl:apply-templates select="." mode="DATA-DISPLAY-TITLE"/>
        </h1>
        <div class="row">
            <div class="span8">
                <xsl:apply-templates select="." mode="DATA-DISPLAY"/>
                <xsl:choose>
                    <xsl:when test="$lang=''">
                        <xsl:apply-templates select="../kwd-group" mode="HTML"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="../kwd-group[@xml:lang=$lang]" mode="HTML"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <xsl:if test="position()=1">
                <xsl:apply-templates select="../../../article" mode="HTML-SECTIONS"/>
            </xsl:if>

        </div>
    </xsl:template>
    <xsl:template match="kwd-group">
        <p class="kwd-group"><strong>
                <xsl:apply-templates select="." mode="DATA-DISPLAY-TITLE"/></strong>:<br/>
            <xsl:apply-templates select=".//kwd" mode="HTML"/></p>
    </xsl:template>
    <xsl:template match="kwd">
        <xsl:if test="position()!=1">, </xsl:if>
        <xsl:apply-templates select="." mode="DATA-DISPLAY"/>
    </xsl:template>
    <xsl:template match="*" mode="HTML-SECTIONS">
        <div class="span4">
            <ul class="rMenu">
                <li>
                    <a href="javascript:void(0);" class="yIcon section fold">Sections<!-- TRANSLATE -->
                        <span>-</span></a>
                    <div class="link-list">
                        <xsl:choose>
                            <xsl:when
                                test=".//sub-article[@article-type='translation' and @xml:lang=$PAGE_LANG]">
                                <xsl:apply-templates
                                    select=".//sub-article[@article-type='translation' and @xml:lang=$PAGE_LANG]//sec[@sec-type]"
                                    mode="HTML-SECTION"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select=".//body//sec[@sec-type]"
                                    mode="HTML-SECTION"/>
                            </xsl:otherwise>
                        </xsl:choose>

                    </div>
                </li>
                <li>
                    <xsl:if test="$SERVICE_RELATED='YES'">
                        <!-- FIXME -->
                        <a href="javascript:void(0);" class="yIcon related fold">Related links
                                <span>-</span></a>
                        <div class="link-list">
                            <!--<a href="#">Similar on SciELO</a><br/>-->
                            <a
                                href="http://www.ubio.org/tools/linkit.php?url=http://www.scielo.br/scielo.php?script=sci_arttext&amp;pid=S0100-879X2013000100058&lng=en&nrm=iso&tlng=en"
                                target="_blank">uBio</a>
                            <br/>
                        </div>
                    </xsl:if>
                </li>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="sec[@sec-type]" mode="HTML-section">
        <a href="#{@sec-type}" class="goto">
            <xsl:apply-templates select="title"/>
        </a>
        <br/>

    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-SECTION-ARTICLE-CONTENT">
        <xsl:choose>
            <xsl:when test=".//sub-article[@article-type='translation' and @xml:lang=$PAGE_LANG]">
                <xsl:apply-templates
                    select=".//sub-article[@article-type='translation' and @xml:lang=$PAGE_LANG]/body"
                    mode="HTML"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select=".//body" mode="HTML"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="body" mode="HTML">
        <xsl:apply-templates select="*|text()" mode="HTML-TEXT"/>
    </xsl:template>

    <xsl:template match="p//*" mode="HTML-TEXT">
        <xsl:param name="parag_id"/>
        <xsl:apply-templates select="*|text()">
            <xsl:with-param name="parag_id">
                <xsl:value-of select="$parag_id"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="sec[@sec-type]" mode="HTML-TEXT">
        <h1 id="{@sec-type}">
            <xsl:apply-templates select="title|label" mode="DATA-DISPLAY"/>
        </h1>
        <xsl:apply-templates select="p|sec" mode="HTML-TEXT"/>
    </xsl:template>

    <xsl:template match="sec[not(@sec-type)]" mode="HTML-TEXT">
        <h2>
            <xsl:apply-templates select="title|label" mode="DATA-DISPLAY"/>
        </h2>
        <xsl:apply-templates select="p|sec" mode="HTML-TEXT"/>
    </xsl:template>
    <xsl:template match="p" mode="HTML-TEXT">
        <xsl:param name="$parag_id">
            <xsl:value-of select="../sec/@sec-type"/>
            <xsl:value-of select="position()"/>
        </xsl:param>

        <div class="row paragraph">
            <div class="span8">
                <p>
                    <xsl:apply-templates select="*|text()" mode="HTML-TEXT">
                        <xsl:with-param name="param_p">
                            <xsl:value-of select="$parag_id"/>
                            <xsl:value-of select="position()"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </p>
            </div>


            <div class="span4">
                <xsl:if test=".//xref[@ref-type='bibr']">
                    <xsl:apply-templates/>
                    <ul class="refList">
                        <xsl:apply-templates select=".//xref[@ref-type='bibr']" mode="HTML-ref"/>
                    </ul>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="p//xref[@ref-type='bibr']" mode="HTML-TEXT">
        <xsl:param name="parag_id"/>
        <xsl:variable name="id">
            <xsl:value-of select="$parag_id">-<xsl:value-of select="@rid"/></xsl:value-of>
        </xsl:variable>
        <sup class="xref {$id}">
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    <xsl:template match="bold" mode="HTML-TEXT">
        <xsl:param name="parag_id"/>
        <em>
            <xsl:apply-templates select="*|text()">
                <xsl:with-param name="parag_id">
                    <xsl:value-of select="$parag_id"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </em>
    </xsl:template>

    <xsl:template match="p//xref[@ref-type='bibr']" mode="HTML-ref">
        <xsl:param name="parag_id"/>
        <xsl:variable name="rid" select="@rid"/>

        <li class="clearfix {$parag_id}-{@rid}">
            <sup class="xref big pull-left">
                <xsl:value-of select="."/>
            </sup>
            <xsl:apply-templates select="$ref[@id=$rid]" mode="HTML-ref"/>

        </li>

    </xsl:template>
    <xsl:template match="ref" mode="HTML-ref">
        <!-- FIXME -->
        <div class="closed pull-right">
            <xsl:apply-templates select=".//chapter-title" mode="DATA-DISPLAY"/>
            <xsl:apply-templates select=".//article-title" mode="DATA-DISPLAY"/>
            <div class="source"><xsl:apply-templates select=".//source" mode="DATA-DISPLAY"/>,
                    <xsl:apply-templates select=".//year"/></div>

        </div>
        <div class="opened pull-right hide">
            <strong>
                <xsl:apply-templates select=".//chapter-title" mode="DATA-DISPLAY"/>
                <xsl:apply-templates select=".//article-title" mode="DATA-DISPLAY"/>.</strong>
            <xsl:apply-templates select=".//person-group[1]|.//collab" mode="DATA-DISPLAY-ref"/>.
                <div class="source"><xsl:apply-templates select=".//source" mode="DATA-DISPLAY"/>
                <xsl:apply-templates select=".//year"/>; <xsl:apply-templates select=".//volume"/>:
                    <xsl:apply-templates select="fpage"/>-<xsl:apply-templates select="lpage"/>
                <xsl:apply-templates select=".//pub-id" mode="DATA-DISPLAY"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="inline-formula" mode="HTML">
        <span class="formula" id="{.//graphic/@id}">
            <img src="{$IMAGE_PATH}/{.//graphic/@href}.jpg" alt=""/>
            <!-- FIXME -->
        </span>
    </xsl:template>
    <xsl:template match="xref"><a href="#{@rid}" class="bIcon figref goto"><xsl:apply-templates select="."></xsl:apply-templates></a></xsl:template>
</xsl:stylesheet>
