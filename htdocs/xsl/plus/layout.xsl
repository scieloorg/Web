<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:mml="http://www.w3.org/1998/Math/MathML"
    version="3.0">
    <xsl:variable name="translated"
        select="document(concat('../../xml/',$PAGE_LANG,'/translation.xml'))/translations"/>
    
    <xsl:variable name="xref" select="//xref"></xsl:variable>
    <xsl:template match="*[@xlink:href] | *[@href]" mode="fix_img_extension">
        <xsl:variable name="href"><xsl:choose>
            <xsl:when test="@xlink:href"><xsl:value-of select="@xlink:href"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="@href"/></xsl:otherwise>
        </xsl:choose></xsl:variable>
        <xsl:variable name="size" select="string-length($href)"/>
        <xsl:variable name="c1" select="substring($href,$size - 4)"/>
        <xsl:variable name="c2" select="substring($href,$size - 3)"/>
        <xsl:choose>
            <xsl:when test="substring($c1,1,1)='.'">
                <xsl:choose>
                    <xsl:when test="contains($c1,'.tif')"><xsl:value-of select="substring-before($href,'.tif')"/>.jpg</xsl:when>
                    <xsl:otherwise><xsl:value-of select="$href"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="substring($c2,1,1)='.'">
                <xsl:choose>
                    <xsl:when test="contains($c2,'.tif')"><xsl:value-of select="substring-before($href,'.tif')"/>.jpg</xsl:when>
                    <xsl:otherwise><xsl:value-of select="$href"/></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$href"/>.jpg</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@*" mode="HTML-TEXT">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="xref" mode="HTML-TEXT">
        <span class="xref">
            <a href="#{@rid}">
                <xsl:value-of select="."/>
            </a>
        </span>
    </xsl:template>
    <xsl:template match="*" mode="HTML">
        <html class="no-js" lang="{$PAGE_LANG}">
            <xsl:apply-templates select="." mode="HTML-HEAD"/>
            <xsl:apply-templates select="." mode="HTML-BODY"/>
        </html>
    </xsl:template>
    <xsl:template match="*" mode="HTML-HEAD">
        <head>
            <meta charset="utf-8"/>
            <meta Content-math-Type="text/mathml"/>

            <title>
                <xsl:value-of select="$ARTICLE_TITLE"/>
            </title>
            <!-- adicionar o link da versão antiga no rel=canonical -->
            <link rel="canonical" href="{$THIS_ARTICLE_URL}"/>

            <xsl:apply-templates select="." mode="HTML-HEAD-META"/>

            <link rel="shortcut icon" href="{$PATH}/static/img/favicon.ico"/>
            <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no"/>

            <link href="{$PATH}/static/css/bootstrap.min.css" rel="stylesheet"/>
            <link href="{$PATH}/static/css/responsive.css" rel="stylesheet"/>
            <link href="{$PATH}/static/css/style.css" rel="stylesheet"/>
            
            <style>
                .inline-formula {
                display: inline;
                max-height: 16px;
                }
                .inline-formula-graphic {
                display: inline;
                max-height: 16px;
                }
                
                .disp-formula {
                display: block;
                vertical-align: top;
                text-align: center;
                }
                .disp-formula .label {
                padding: 10px;
                display: inline;
                vertical-align: top;
                }
                .disp-formula .formula {
                padding: 10px;
                text-align: center;
                }
                .disp-formula .formula-labeled {
                padding: 10px;
                max-width: 80%;
                }
                .disp-formula-graphic {
                padding: 25px;
                height: auto;
                max-width: 100%;
                max-height: 45px;
                }
                .graphic {
                padding: 25px;
                height: auto;
                max-width: 100%;
                max-height: 300px;
                }
                .inline-graphic {
                display: inline;
                max-height: 100%;
                max-width: 100%;
                }
                
                .product {
                margin: 5px 5px 5px 5px;
                padding: 15px 15px 15px 15px;
                background-color: #DADFE5;
                }
                
                .product-text {
                font-family: Book Antiqua;
                font-size: 10pt;
                background-color: #DADFE5;
                }
                
                .product-graphic {
                width: 10%;
                float: left;
                padding-right: 30px;
                background-color: #DADFE5;
                }
                .disclaimer {
                background-color: #F8FAE4;
                font-family: Arial;
                font-size: 8pt;
                padding: 5px 5px 5px 5px;
                /*border-radius: 10px;*/
                border: 2px solid #F5D431;
                
                }
                .disclaimer p {
                padding-left: 10px;
                line-height: normal;
                }
            </style>
            <xsl:if test=".//math or .//mml:math">
                <script type="text/javascript"
                    src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
                </script>
            </xsl:if>
        </head>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY">
        <body class="skin-soft-contrast">
            <xsl:apply-templates select="." mode="HTML-BODY-HEADER"/>
            <section class="sec">
                <div class="container">
                    <xsl:apply-templates select="." mode="HTML-BODY-SECTION-HEADER"/>
                    <xsl:apply-templates select="." mode="HTML-BODY-SECTION-ARTICLE"/>
                </div>
            </section>
            <xsl:apply-templates select="." mode="HTML-BODY-FOOTER"/>
            <xsl:apply-templates select="." mode="HTML-BODY-FLOAT-MENU"/>
            <xsl:apply-templates select="." mode="HTML-BODY-IFRAME-MODAL"/>
        </body>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-HEADER">
        <header id="top">
            <!-- ALERT BETA VERSION -->
            <div id="topmessage">
                <div class="container">
                    <div class="span10">
                        <div class="row link-group">
                            <div class="infoContainer message ">								
                                <a href="javascript:void(0);" class="close pull-right"><small>THIS IS A TRIAL VERSION OF ARTICLE PAGE FOR THE NEW VERSION OF SciELO Site
                                </small>×</a>
                                
                            </div>
                        </div>
                    </div>
                </div>
            </div><!-- ALERT OF BETA VERSION -->
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
        <header class="row header">
            <div class="span8">
                <xsl:apply-templates select="." mode="text-disclaimer"/>
                <h2 class="article-categories">
                    <xsl:apply-templates select="." mode="DATA-article-categories"/>
                </h2>
                <h1 class="article-title">
                    <xsl:apply-templates select="." mode="DATA-DISPLAY-article-title"/>
                </h1>
                <xsl:for-each select="$original//front//trans-title">
                    <h2 class="article-title">
                        <xsl:apply-templates select="."/>
                    </h2>
                </xsl:for-each>
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
                data-toggle="tooltip" title="Click to copy URL to clipboard"> </input>

        </xsl:if>
    </xsl:template>
    <xsl:template match="*" mode="HTML-short-link-and-statistics">
        <div class="row link-group">
            <!-- FIXME HTML-NEW -->
            <xsl:apply-templates select="." mode="HTML-short-link-and-statistics-PARAM"/>
        </div>
    </xsl:template>
    <xsl:template match="*" mode="HTML-short-link-and-statistics-FAKE">
        <div class="span3">
            <input type="text" name="link-share" class="trans bIcon link"
                value="http://ref.scielo.org/y4qccf" data-toggle="tooltip"
                title="Click to copy URL to clipboard"/>
        </div>
        <div class="dropdown span5">
            <a href="javascript:void(0);" class="bIcon stats">Article Indicators</a>
            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                <!--<li><a tabindex="-1" href="#">Cited by SciELO</a></li>-->
                <li>
                    <a tabindex="-1"
                        href="/applications/scielo-org/pages/services/articleRequestGraphicPage.php?pid=S0100-879X2013000100058&amp;caller=www.scielo.br&amp;lang=en"
                        class="iframeModal">Access Statistics</a>
                </li>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="*" mode="HTML-short-link-and-statistics-PARAM">

        <div class="span3">
            <xsl:apply-templates select="." mode="HTML-SHORT-LINK"/>
        </div>
        <div class="dropdown span5">
            <xsl:variable name="href">
                <xsl:value-of select="$SERVICE_ARTICLE_STATISTICS"/>
            </xsl:variable>
            <xsl:if test="$href!=''">
                <!--TRANSLATE-->
                <a href="javascript:void(0);" class="bIcon stats">Article Indicators</a>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                    <!--<li><a tabindex="-1" href="#">Cited by SciELO</a></li>-->
                    <li>
                        <a tabindex="-1" href="{$href}" class="iframeModal">Access Statistics</a>
                        <!--TRANSLATE-->
                    </li>
                </ul>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="contrib-group" mode="HTML">
        <div class="contrib-group">
            <xsl:apply-templates select="contrib[@contrib-type='author' or not(@contrib-type)]//name" mode="HTML"/>
        </div>
            <xsl:if test="not(role) and contrib[@contrib-type!='author']">
                <p>
                <xsl:variable name="contribtype" select=".//contrib[@contrib-type!='author']/@contrib-type"/>
                    <xsl:variable name="lang"><xsl:value-of select="$PAGE_LANG"/><xsl:if test="not(contains('en es pt',$PAGE_LANG))">en</xsl:if></xsl:variable>
                <xsl:variable name="label"><xsl:value-of select="document(concat('../../xml/',$lang,'/translation.xml'))/translations//text[@find=$contribtype]"/></xsl:variable>
                <xsl:if test="$label!=''"><xsl:value-of select="$label"/>: </xsl:if>
                    <xsl:apply-templates select="contrib[@contrib-type!='author']//name" mode="HTML"/>
                </p>
            </xsl:if>
    </xsl:template>
    <xsl:template match="name" mode="HTML">
        <span>
            <xsl:apply-templates select="." mode="DATA-DISPLAY"/>
            <xsl:apply-templates select="..//xref" mode="HTML-author"/>
        </span>
        <xsl:text>
            <!-- manter esta quebra de linha -->
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="xref" mode="HTML-author">
        <sup class="xref">
            <a href="#{@rid}">
                <xsl:value-of select="."/>
            </a>
        </sup>
    </xsl:template>
    <xsl:template match="*" mode="HTML-aff-list">
        <div class="span3">
            <a href="javascript:void(0);" class="bIcon author">Author affiliation</a>
            <div class="infoContainer author-affiliation hide">
                <a href="javascript:void(0);" class="close pull-right">×</a>
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
        <a href="mailto:{.}">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    <xsl:template match="permissions" mode="HTML">
        <div class="span5">
            <!-- TRANSLATE -->
            <a href="javascript:void(0);" class="bIcon copyright">Permissions</a>
            <div class="infoContainer permissions hide">
                <a href="javascript:void(0);" class="close pull-right">×</a>
                <xsl:apply-templates select="." mode="DATA-DISPLAY"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="*" mode="dates">
        <xsl:choose>
            <xsl:when test="$trans//front-stub//pub-date">
                <xsl:apply-templates select="$trans//front-stub//pub-date" mode="HTML-DATES"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$original/front//pub-date" mode="HTML-DATES"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="pub-date" mode="HTML-DATES">
        <p>
            <strong>
                <xsl:apply-templates select="." mode="text"/>
            </strong>
            <br/>
            <xsl:choose>
                <xsl:when test="@pub-type='epub'">Electronic publication (usually web, but also
                    includes CD-ROM or other electronic only distribution) </xsl:when>
                <xsl:when test="@pub-type='print'">Print</xsl:when>
            </xsl:choose>
        </p>
    </xsl:template>
    <xsl:template match="pub-date" mode="text">
        <xsl:choose>
            <xsl:when test="$PAGE_LANG='es'">
                <xsl:value-of select="day"/>&#160; <xsl:apply-templates select="season| month"
                    mode="HTML-label-es"/>
            </xsl:when>
            <xsl:when test="$PAGE_LANG='pt'">
                <xsl:value-of select="day"/>&#160; <xsl:apply-templates select="season| month"
                    mode="HTML-label-pt"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="season|month" mode="HTML-label-en"/>&#160;
                    <xsl:apply-templates select="day"/>,</xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="concat(' ', year)"/>
    </xsl:template>
    <xsl:template match="*" mode="HTML-toolbox">
        <!-- FIXME -->
        <ul class="rMenu">
            <li>
                <a href="javascript:void(0);" class="yIcon calendar fold">Publication dates<!-- TRANSLATE -->
                    <span>-</span></a>

                <div>
                    <xsl:apply-templates select="." mode="dates"/>
                </div>
            </li>
            <li>
                <a href="{$THIS_PDF_URL}" class="yIcon pdf" target="_blank">Article in PDF</a>
            </li>
            <li>
                <a href="{$SERVICE_ARTICLE_XML}" target="_blank" class="yIcon xml">Article in
                    XML</a>
            </li>
            <!--li>
                <a href="{$SERVICE_ARTICLE_REFERENCES}" class="yIcon refs iframeModal">Article
                    references</a->
                
            </li-->
            <li>
                <a href="{$SERVICE_ARTICLE_AUTO_TRANSLATION}" class="yIcon translate iframeModal"
                    >Automatic translation</a>
            </li>
            <li>
                <a href="{$SERVICE_ARTICLE_SEND_EMAIL}" class="yIcon send iframeModal">Send this
                    article by e-mail</a>
            </li>
            <li>
                <a href="javascript:void(0);" class="yIcon social fold">Share this article
                        <span>+</span></a>
                <div class="hide">
                    <a
                        href="http://www.addthis.com/bookmark.php?v=250&amp;username=xa-4c347ee4422c56df"
                        class="addthis_button_expanded"> Bookmarks </a>
                </div>
            </li>
        </ul>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-SECTION-ARTICLE">
        <xsl:apply-templates select="." mode="HTML-PRODUCT"/>
        <xsl:apply-templates select="." mode="HTML-BODY-SECTION-ARTICLE-ABSTRACT"/>
        <xsl:apply-templates select="." mode="HTML-BODY-SECTION-ARTICLE-CONTENT"/>
    </xsl:template>
    <xsl:template match="*" mode="HTML-PRODUCT">
        <article id="content" class="article">
            <div class="row paragraph">
                <div class="span8">
                    <p><xsl:apply-templates select=".//article-meta//product"></xsl:apply-templates></p>
                </div>
            </div>
        </article>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-SECTION-ARTICLE-ABSTRACT">
        <xsl:if test="$trans//abstract or $original//abstract or $original//trans-abstract">
            <article id="abstract" class="article">
                <xsl:choose>
                    <xsl:when test="$trans//abstract">
                        <xsl:apply-templates select="$trans" mode="ABSTR-AND-SECTIONS"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$original" mode="ABSTR-AND-SECTIONS"/>
                    </xsl:otherwise>
                </xsl:choose>
            </article>
        </xsl:if>      
    </xsl:template>
    <xsl:template match="@id" mode="HTML-TEXT">
        <a name="{.}"/>
    </xsl:template>
    <xsl:template match="article|sub-article" mode="ABSTR-AND-SECTIONS">
        <xsl:variable name="lang" select="@xml:lang"/>
        <h1>
            <xsl:choose>
                <xsl:when test="front-stub//abstract">
                    <xsl:apply-templates select="front-stub//abstract" mode="DATA-DISPLAY-TITLE">
                        <xsl:with-param name="lang" select="$lang"></xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="front//trans-abstract[@xml:lang=$lang]">
                    <xsl:apply-templates select="front//trans-abstract[@xml:lang=$lang]" mode="DATA-DISPLAY-TITLE">
                        <xsl:with-param name="lang" select="$lang"></xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="front//abstract" mode="DATA-DISPLAY-TITLE">
                        <xsl:with-param name="lang" select="$lang"></xsl:with-param>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </h1>
        <div class="row">
            <div class="span8">
                <xsl:choose>
                    <xsl:when test="front-stub//abstract">
                        <xsl:apply-templates select="front-stub//abstract/*[name()!='title'] | front-stub//abstract/text()" mode="HTML-TEXT"/>
                    </xsl:when>
                    <xsl:when test="front//trans-abstract[@xml:lang=$lang]">
                        <xsl:apply-templates select="front//trans-abstract[@xml:lang=$lang]/*[name()!='title'] | front//trans-abstract[@xml:lang=$lang]/text()" mode="HTML-TEXT"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="front//abstract/*[name()!='title'] | front//abstract/text()" mode="HTML-TEXT"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="front-stub//kwd-group">
                        <xsl:apply-templates select="front-stub//kwd-group" mode="HTML"/>
                    </xsl:when>
                    <xsl:when test="front//kwd-group[@xml:lang=$lang]">
                        <xsl:apply-templates select="front//kwd-group[@xml:lang=$lang]" mode="HTML"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="front//kwd-group" mode="HTML"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <xsl:apply-templates select="." mode="HTML-SECTIONS"/>
        </div>
    </xsl:template>
    <xsl:template match="kwd-group" mode="HTML">
        <p class="kwd-group"><strong>
                <xsl:apply-templates select="." mode="DATA-DISPLAY-TITLE"/></strong>:<br/>
            <xsl:apply-templates select=".//kwd" mode="HTML"/></p>
    </xsl:template>
    <xsl:template match="kwd" mode="HTML">
        <xsl:if test="position()!=1">, </xsl:if>
        <xsl:apply-templates select="." mode="DATA-DISPLAY"/>

    </xsl:template>
    <xsl:template match="*" mode="HTML-FLOAT-SECTIONS">
        <div class="drop-container">
            <a href="javascript:void(0);" class="main gIcon sections" title="Sections">Sections</a>
            <ul class="drop menu">
                <xsl:choose>
                    <xsl:when test="$trans">
                        <xsl:apply-templates select="$trans//sec[@sec-type]"
                            mode="HTML-FLOAT-SECTION"/>
                        <xsl:apply-templates select="$trans//ack" mode="HTML-FLOAT-SECTION"/>
                        <xsl:apply-templates select="$original/back/ref-list"
                            mode="HTML-FLOAT-SECTION"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$original/body//sec[@sec-type]"
                            mode="HTML-FLOAT-SECTION"/>
                        <xsl:apply-templates select="$original/back/ack" mode="HTML-FLOAT-SECTION"/>
                        <xsl:apply-templates select="$original/back/ref-list"
                            mode="HTML-FLOAT-SECTION"/>
                    </xsl:otherwise>
                </xsl:choose>
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="article | sub-article | response" mode="HTML-SECTIONS">
        <div class="span4">
            <ul class="rMenu">
                <li>
                    <a href="javascript:void(0);" class="yIcon section fold">Sections<!-- TRANSLATE -->
                        <span>-</span></a>
                    <div class="link-list">
                        <xsl:apply-templates select="body//sec[@sec-type]" mode="HTML-SECTION"/>
                        <xsl:apply-templates select="back//ack" mode="HTML-SECTION"/>
                        <xsl:apply-templates select="$original/back/ref-list" mode="HTML-SECTION"/>
                    </div>
                </li>
                <li>
                    <xsl:if test="$SERVICE_RELATED='YES'">
                        <!-- FIXME -->
                        <a href="javascript:void(0);" class="yIcon related fold">Related links
                                <span>-</span></a>
                        <div class="link-list">
                            <!--<a href="#">Similar on SciELO</a><br/>-->

                            <a href="javascript:void(0);">
                                <xsl:attribute name="onclick"> window.open('<xsl:value-of
                                        select="$SERVICE_UBIO"/>') </xsl:attribute>
                                <img src="http://www.scielo.br/img/btubio.png" border="0"
                                    width="21px" heigth="21px"/> uBio </a>
                            <br/>
                        </div>
                    </xsl:if>
                </li>
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="ref-list|ack" mode="goto">
        <a>
            <xsl:attribute name="href">#<xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:attribute name="class">goto</xsl:attribute>
            <xsl:apply-templates select="title"/>
        </a>
    </xsl:template>
    <xsl:template match="sec[@sec-type]" mode="goto">
        <a>
            <xsl:attribute name="href">#<xsl:value-of select="translate(@sec-type,'|','-')"/>
            </xsl:attribute>
            <xsl:attribute name="class">goto</xsl:attribute>
            <xsl:apply-templates select="title"/>
        </a>
    </xsl:template>
    <xsl:template match="sec[@sec-type]|ref-list|ack" mode="HTML-SECTION">
        <xsl:apply-templates select="." mode="goto"/>
        <br/>

    </xsl:template>
    <xsl:template match="sec[@sec-type]|ref-list|ack" mode="HTML-FLOAT-SECTION">
        <li>
            <xsl:apply-templates select="." mode="goto"/>
        </li>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-SECTION-ARTICLE-CONTENT">
        <xsl:choose>
            <xsl:when test="$trans">
                <xsl:apply-templates select="$trans" mode="HTML-BODY-BACK"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$original" mode="HTML-BODY-BACK"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="article | sub-article | response" mode="HTML-BODY-BACK">
        <article id="content" class="article">
            <xsl:apply-templates select="body" mode="HTML-TEXT"/>
            <xsl:choose>
                <xsl:when test="back">
                    <xsl:apply-templates select="back" mode="HTML-TEXT"/>
                </xsl:when>
                <xsl:when test="name()='sub-article' and @article-type='translation'">
                    <xsl:apply-templates select="$original/back" mode="HTML-TEXT"/>
                </xsl:when>
                <xsl:when test="name()='response'">
                    <xsl:apply-templates select="$original/response/back" mode="HTML-TEXT"/>
                </xsl:when>
                <xsl:otherwise>
                    
                </xsl:otherwise>
            </xsl:choose>
        </article>
        <xsl:apply-templates select="sub-article[@article-type!='translation'] | response" mode="HTML-BODY-BACK"></xsl:apply-templates>
    </xsl:template>
    <xsl:template match="body| back " mode="HTML-TEXT">
        <xsl:apply-templates select="*[name()!='fn-group']|text()" mode="HTML-TEXT"/>
    </xsl:template>
    
    <xsl:template match="sub-article[@article-type='translation']/back " mode="HTML-TEXT">
        <xsl:apply-templates select="ack" mode="HTML-TEXT"/>
        <xsl:if test="not(ref-list)">
            <xsl:apply-templates select="$original/back/ref-list" mode="HTML-TEXT"/>
        </xsl:if>
        <xsl:apply-templates select="*[name()!='fn-group' and name()!='ack']|text()" mode="HTML-TEXT"/>
    </xsl:template>
    
    <xsl:template match="response/back" mode="HTML-TEXT">
        <xsl:if test="not(ref-list)">
            <xsl:apply-templates select="$original/response/back/ref-list" mode="HTML-TEXT"/>
        </xsl:if>
        <xsl:apply-templates select="*[name()!='fn-group']|text()" mode="HTML-TEXT"/>       
    </xsl:template>
    
    <xsl:template match="article/back/*" mode="choose">
        <xsl:variable name="name" select="name()"/>
        <xsl:choose>
            <xsl:when test="$trans/back/*[name()=$name]">
                <xsl:apply-templates select="$trans/back/*[name()=$name]" mode="HTML-TEXT"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="HTML-TEXT"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="app-group|app" mode="HTML-TEXT">
        <xsl:apply-templates select="@*|*|text()" mode="HTML-TEXT"/>
    </xsl:template>
    
    <xsl:template match="app/@id" mode="HTML-TEXT">
        <a name="{.}"/>
    </xsl:template>
    
    <xsl:template match="app[title]/label" mode="HTML-TEXT">
    </xsl:template>
    <xsl:template match="app[not(title)]/label" mode="HTML-TEXT">
        <h1><xsl:value-of select="."></xsl:value-of></h1>
    </xsl:template>
    <xsl:template match="app/title" mode="HTML-TEXT">
        <h1><xsl:value-of select="../label"/> <xsl:value-of select="."/></h1>
    </xsl:template>
    
    <xsl:template match="fn-group" mode="HTML-TEXT">
        <xsl:apply-templates select="label | title | fn" mode="HTML-TEXT"/>
    </xsl:template>
    <xsl:template match="fn-group/label | fn-group/title" mode="HTML-TEXT">
        <xsl:apply-templates select=" *|text()" mode="HTML-TEXT"/>
    </xsl:template>
    <xsl:template match="fn-group/fn" mode="HTML-TEXT">
        <xsl:if test="(not(label) or (label='')) and $xref[@rid=$id]!=''">
            <xsl:variable name="id" select="@id"/>
            <sup class="xref">
                <a href="#back_{../@id}"><xsl:apply-templates select="$xref[@rid=$id]"/></a>
            </sup>
        </xsl:if>
        <xsl:apply-templates select="@id| *|text()" mode="HTML-TEXT"/>
    </xsl:template>
    <xsl:template match="fn-group/fn/label[.!='']" mode="HTML-TEXT">
        <xsl:choose>
            <xsl:when test="number(.)=.">
                <sup class="xref">
                    <a href="#back_{../@id}">
                        <xsl:value-of select="."/>
                    </a>
                </sup>
            </xsl:when>
            <xsl:otherwise>
                <strong>
                    <a href="#back_{../@id}">
                        <xsl:value-of select="."/>
                    </a>
                </strong>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="fn-group/fn/p" mode="HTML-TEXT">
        <p>
            <xsl:apply-templates select="*|text()" mode="HTML-TEXT"/>
        </p>
    </xsl:template>

    <xsl:template match="ack" mode="HTML-TEXT">
        <h1 id="ack">
            <xsl:apply-templates select="." mode="DATA-DISPLAY-TITLE"/>
        </h1>
        <div class="row paragraph">
            <div class="span12">
                <xsl:apply-templates select="p" mode="HTML-TEXT"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="ref-list" mode="HTML-TEXT">
        <h1 id="ref-list">
            <xsl:apply-templates select="." mode="DATA-DISPLAY-TITLE"/>
        </h1>
        <div class="ref-list">
            <ul class="refList">
                <xsl:apply-templates select="ref" mode="HTML-TEXT"/>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="ref" mode="REFERENCE-LINKS">
        <xsl:param name="position"/>
        <xsl:variable name="pos">00000<xsl:value-of select="$position"/></xsl:variable>
        <xsl:variable name="p">
            <xsl:value-of select="substring($pos,string-length($pos)-4)"/>
        </xsl:variable>
        <xsl:value-of
            select="concat(substring-before($SERVICE_REFERENCE_LINKS,'REFERENCE_ID'),$p,substring-after($SERVICE_REFERENCE_LINKS,'REFERENCE_ID'))"
        />
    </xsl:template>
    <xsl:template match="ref" mode="HTML-TEXT">
        <xsl:variable name="link">
            <xsl:apply-templates select="." mode="REFERENCE-LINKS">
                <xsl:with-param name="position">
                    <xsl:value-of select="position()"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:variable>
        <a name="{@id}"/>
        <li class="clearfix">
            <xsl:if test="label">
                <sup class="xref big pull-left" onclick="window.history.back();">
                    <xsl:value-of select="label"/>
                </sup>
            </xsl:if>
            <div class="pull-right">
                <xsl:choose>
                    <xsl:when test="mixed-citation">
                        <xsl:apply-templates select="mixed-citation" mode="HTML-TEXT"/>
                    </xsl:when>
                    <xsl:when test="citation">
                        <xsl:apply-templates select="citation"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="element-citation" mode="DATA-DISPLAY"/>
                    </xsl:otherwise>
                </xsl:choose>
                <a href="javascript:void(0);" class="bIcon miniLink" target="_blank">
                    <xsl:attribute name="onclick">javascript: window.open('<xsl:value-of
                            select="normalize-space($link)"
                        />','','width=640,height=500,resizable=yes,scrollbars=1,menubar=yes,');</xsl:attribute>
                    Links</a>
            </div>
        </li>
    </xsl:template>
    <xsl:template match="p//italic" mode="HTML-TEXT">
        <xsl:param name="parag_id"/>
        <em>
            <xsl:apply-templates select="*|text()" mode="HTML-TEXT">
                <xsl:with-param name="parag_id">
                    <xsl:value-of select="$parag_id"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </em>
    </xsl:template>
    <xsl:template match="p//bold" mode="HTML-TEXT">
        <xsl:param name="parag_id"/>
        <strong>
            <xsl:apply-templates select="*|text()" mode="HTML-TEXT">
                <xsl:with-param name="parag_id">
                    <xsl:value-of select="$parag_id"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </strong>
    </xsl:template>
   <xsl:template match="table | table//* " mode="HTML-TEXT">
        <xsl:element name="{name()}">
                    <xsl:apply-templates select="@*|*|text()" mode="HTML-TEXT"/>
                </xsl:element>
            
    </xsl:template>
    <xsl:template match="sup |sub" mode="HTML-TEXT">
        <xsl:param name="parag_id"/>
        <xsl:element name="{name()}">
            <xsl:apply-templates select="*|text()" mode="HTML-TEXT">
                <xsl:with-param name="parag_id">
                    <xsl:value-of select="$parag_id"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <xsl:template match="sec" mode="HTML-TEXT">

        <xsl:apply-templates select="*" mode="HTML-TEXT"/>
    </xsl:template>
    <xsl:template match="sec[title]/label" mode="HTML-TEXT"></xsl:template>
    <xsl:template match="sec/title" mode="HTML-TEXT">
        <xsl:choose>
            <xsl:when test="../@sec-type">
                <h1>
                    <xsl:attribute name="id">
                        <xsl:value-of select="translate(../@sec-type,'|', '-')"/>
                    </xsl:attribute>
                    <xsl:value-of select="../label"/>
                    <xsl:apply-templates select="." mode="DATA-DISPLAY"/>
                </h1>
            </xsl:when>
            <xsl:otherwise>
                <h2>
                    <xsl:value-of select="../label"/>
                    <xsl:apply-templates select="." mode="DATA-DISPLAY"/>
                </h2>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="p" mode="HTML-TEXT">
        <xsl:param name="parag_id">
            <xsl:value-of select="../sec/@sec-type"/>
            <xsl:value-of select="position()"/>
        </xsl:param>
        <xsl:choose>
            <xsl:when test=".//fig-group">
                <xsl:apply-templates select=".//fig-group" mode="HTML-TEXT"/>
            </xsl:when>
            <xsl:when test=".//fig or .//table-wrap[.//graphic]">
                <xsl:apply-templates select=".//fig|.//table-wrap" mode="HTML-TEXT"/>
            </xsl:when>
            <xsl:otherwise>
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

                            <ul class="refList">
                                <xsl:apply-templates select=".//xref[@ref-type='bibr']"
                                    mode="HTML-ref"/>
                            </ul>
                        </xsl:if>
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template match="p//xref[@ref-type='fn']" mode="HTML-TEXT">
        <xsl:param name="parag_id"/>
        <xsl:variable name="id">
            <xsl:value-of select="$parag_id"/>-<xsl:value-of select="@rid"/></xsl:variable>
        <a name="back_{@rid}"/>
        <sup class="xref {$id}">
            <a href="#{@rid}">
                <xsl:apply-templates/>
                <xsl:if test=".=''">
                    <xsl:value-of select="substring(@rid,2)"/>
                </xsl:if>
            </a>
        </sup>
    </xsl:template>
    <xsl:template match="p//xref[@ref-type='bibr']" mode="HTML-TEXT">
        <xsl:param name="parag_id"/>
        <xsl:variable name="id">
            <xsl:value-of select="$parag_id"/>-<xsl:value-of select="@rid"/></xsl:variable>

        <sup class="xref {$id}">
            <xsl:apply-templates/>
            <xsl:if test=".=''">
                <xsl:value-of select="substring(@rid,2)"/>
            </xsl:if>
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
                <xsl:if test=".=''">
                    <xsl:value-of select="substring(@rid,2)"/>
                </xsl:if>
            </sup>
            <xsl:apply-templates select="$ref[@id=$rid]" mode="HTML-ref"/>

        </li>

    </xsl:template>
    <xsl:template match="ref" mode="HTML-ref">
        <xsl:variable name="link">
            <xsl:apply-templates select="." mode="REFERENCE-LINKS">
                <xsl:with-param name="position" select="substring(@id,2)"/>
            </xsl:apply-templates>
        </xsl:variable>
        <!-- FIXME -->
        <div class="closed pull-right">
            <xsl:apply-templates select=".//chapter-title | .//article-title"/>
            <div class="source"><xsl:apply-templates select=".//source"/>, <xsl:apply-templates
                    select=".//year"/></div>

        </div>
        <div class="opened pull-right hide">
            <a href="#{@id}">
                <!-- Monographs:
Lominandze, DG. Cyclotron waves in plasma. Translated by AN. Dellis; edited by SM. Hamberger. 1st ed. Oxford : Pergamon Press, 1981. 206 p. International series in natural philosophy. Translation of: Ciklotronnye volny v plazme. ISBN 0-08-021680-3.
Parts of a monograph:
Parker, TJ. and Haswell, WD. A Text-book of zoology. 5th ed., vol 1. revised by WD. Lang. London : Macmillan 1930. Section 12, Phyllum Mollusca, pp. 663-782.
Contributions in a monograph:
Wringley, EA. Parish registers and the historian. In Steel, DJ. National index of parish registers. London : Society of Genealogists, 1968, vol. 1, pp. 155-167.
Serials:
Communication equipment manufacturers. Manufacturing a Primary Industries Division, Statistics Canada. Preliminary Edition, 1970- .Ottawa : Statistics Canada, 1971- . Annual census of manufacturers. (English), (French). ISSN 0700-0758.
Articles in a serial:
Weaver, William. The Collectors: command performances. Photography by Robert Emmet Bright. Architectural Digest, December 1985, vol. 42, no. 12, pp. 126-133. -->
                <!--strong><xsl:apply-templates select=".//mixed-citation"></xsl:apply-templates></strong-->
                <xsl:choose>
                    <xsl:when test=".//article-title">
                        <xsl:value-of select="substring-before(.//mixed-citation,.//article-title)"/>
                        <strong>
                            <xsl:value-of select=".//article-title"/>
                        </strong>
                        <xsl:value-of select="substring-after(.//mixed-citation,.//article-title)"/>

                    </xsl:when>
                    <xsl:when test=".//chapter-title">
                        <xsl:value-of select="substring-before(.//mixed-citation,.//chapter-title)"/>
                        <strong>
                            <xsl:value-of select=".//chapter-title"/>
                        </strong>
                        <xsl:value-of select="substring-after(.//mixed-citation,.//chapter-title)"/>


                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before(.//mixed-citation,.//source)"/>
                        <strong>
                            <xsl:value-of select=".//source"/>
                        </strong>
                        <xsl:value-of select="substring-after(.//mixed-citation,.//source)"/>

                    </xsl:otherwise>
                </xsl:choose>

            </a>
        </div>
    </xsl:template>
    <xsl:template match="table//inline-graphic|inline-graphic" mode="HTML-TEXT">
        <img class="inline-graphic">
            <xsl:attribute name="src"><xsl:value-of select="concat($IMAGE_PATH,'/')"/><xsl:apply-templates select="." mode="fix_img_extension"/></xsl:attribute>
        </img>
    </xsl:template>
    <xsl:template match="disp-formula/graphic" mode="HTML-TEXT">
        <img class="disp-formula-graphic">
            <xsl:attribute name="src"><xsl:value-of select="concat($IMAGE_PATH,'/')"/><xsl:apply-templates select="." mode="fix_img_extension"/></xsl:attribute>
        </img>
    </xsl:template>
    
    <xsl:template match="inline-formula/graphic" mode="HTML-TEXT">
        <img class="inline-formula-graphic">
            <xsl:attribute name="src"><xsl:value-of select="concat($IMAGE_PATH,'/')"/><xsl:apply-templates select="." mode="fix_img_extension"/></xsl:attribute>
        </img>
    </xsl:template>
    
    <xsl:template match="inline-formula" mode="HTML-TEXT">
        <span class="inline-formula">
            <xsl:apply-templates select="@id"/>
            <xsl:apply-templates select="*" mode="HTML-TEXT"/>
        </span>
    </xsl:template>
    <xsl:template match="disp-formula/label" mode="HTML-TEXT">
        <span class="label"><xsl:value-of select="."/></span>
    </xsl:template>
    <xsl:template match="disp-formula" mode="HTML-TEXT">
        <div class="disp-formula">
            <xsl:apply-templates select="@id"/>
            <span>
                <xsl:attribute name="class"><xsl:choose>
                    <xsl:when test="label">formula-labeled</xsl:when><xsl:otherwise>formula</xsl:otherwise>
                </xsl:choose></xsl:attribute>
                <xsl:apply-templates select="*[name()!='label']" mode="HTML-TEXT"/></span>
            <xsl:apply-templates select="label" mode="HTML-TEXT"/>
        </div>
    </xsl:template>
    <xsl:template match="alternatives" mode="HTML-TEXT">
        <xsl:choose>
            <xsl:when test="mml:math">
                <xsl:apply-templates select="mml:math" mode="HTML-TEXT"/>
            </xsl:when>
            <xsl:when test="graphic">
                <xsl:apply-templates select="graphic" mode="HTML-TEXT"/>
            </xsl:when>
            <xsl:when test="tex-math">
                <xsl:apply-templates select="tex-math"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="p//xref[@ref-type='fig' or @ref-type='table']" mode="HTML-TEXT">
        <a href="#{@rid}" class="bIcon figref goto">
            <xsl:apply-templates select="*|text()"/>
        </a>
    </xsl:template>
    
    <xsl:template match="fig[graphic]" mode="HTML-TEXT">
        <div class="row fig" id="{@id}">
            <div class="span3">
                <xsl:variable name="img_filename"><xsl:value-of select="concat($IMAGE_PATH,'/')"/><xsl:apply-templates select=".//graphic" mode="fix_img_extension"/></xsl:variable>
                <div class="thumb">
                    <xsl:attribute name="style"> background-image: url(<xsl:value-of
                            select="$img_filename"/>); </xsl:attribute> Thumbnail</div>
                <!-- FIXME -->
                <div class="preview span9 hide">
                    <img src="{$img_filename}" alt="{caption}"/>
                    <xsl:apply-templates select="attrib"/>
                </div>
            </div>
            <div class="span5">
                <strong>
                    <xsl:value-of select="label"/>
                </strong>
                <br/>
                <xsl:apply-templates select="caption"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="fig[not(graphic)]" mode="HTML-TEXT">
        <div class="span5">
            <strong>
                <xsl:value-of select="label"/>
            </strong>
            <br/>
            <xsl:apply-templates select="caption"/>
        </div>
    </xsl:template>
    <xsl:template match="fig-group" mode="HTML-TEXT">
        <div class="row fig" id="{@id}">
            <div class="span3">
                <xsl:variable name="img_filename"><xsl:value-of select="concat($IMAGE_PATH,'/')"/><xsl:apply-templates select=".//graphic" mode="fix_img_extension"/></xsl:variable>
                <div class="thumb">
                    <xsl:attribute name="style"> background-image: url(<xsl:value-of
                        select="$img_filename"/>); </xsl:attribute> Thumbnail</div>
                <!-- FIXME -->
                <div class="preview span9 hide">
                    <img src="{$img_filename}" alt="{caption}"/>
                    <xsl:apply-templates select="attrib"/>
                </div>
            </div>
            <xsl:choose>
                <xsl:when test="fig[@xml:lang=$PAGE_LANG] and $trans">
                    <xsl:apply-templates select="fig[@xml:lang=$PAGE_LANG]" mode="HTML-TEXT"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="fig" mode="HTML-TEXT"/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="table-wrap-group" mode="HTML-TEXT">
        <div class="row table" id="{@id}">
            <xsl:choose>
                <xsl:when test="table-wrap[@xml:lang=$PAGE_LANG] and $trans">
                    <xsl:apply-templates select="table-wrap[@xml:lang=$PAGE_LANG]" mode="HTML-TEXT"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="table-wrap" mode="HTML-TEXT"/>
                </xsl:otherwise>
            </xsl:choose>
            <div class="span8">
                <xsl:apply-templates select="*[name()!='table-wrap']|text()"
                    mode="HTML-TEXT"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="table-wrap[not(graphic) and not(table)]" mode="HTML-TEXT">
        <div class="row table" id="{@id}">
            <div class="span5">
                <strong>
                    <xsl:value-of select="label"/>
                </strong>
                <br/>
                <xsl:apply-templates select="caption"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="table-wrap[table]" mode="HTML-TEXT">
        <div class="row table" id="{@id}">
            <div class="span8">
                <strong>
                    <xsl:value-of select="label"/>
                </strong>
                <br/>
                <xsl:apply-templates select="caption"/>
            </div>
            <div class="span8">
                <xsl:apply-templates select="*[name()!='label' and name()!='caption']|text()"
                    mode="HTML-TEXT"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="table-wrap[graphic]" mode="HTML-TEXT">
        <div class="row table" id="{@id}">
            <div class="span3">
                <xsl:variable name="img_filename"><xsl:value-of select="concat($IMAGE_PATH,'/')"/><xsl:apply-templates select=".//graphic" mode="fix_img_extension"/></xsl:variable>
                
                <div class="thumb">
                    <xsl:attribute name="style"> background-image: url(<xsl:value-of
                        select="$img_filename"/>); </xsl:attribute> Thumbnail</div>
                <!-- FIXME -->
                <div class="preview span9 hide">
                    <img src="{$img_filename}" alt="{caption}"/>
                    <xsl:apply-templates select="attrib"/>
                </div>
            </div>
            <div class="span5">
                <strong>
                    <xsl:value-of select="label"/>
                </strong>
                <br/>
                <xsl:apply-templates select="caption"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-FOOTER">
        <footer>
            <div class="container">
                <div class="row metaInfo">
                    <div class="span10">
                        <!--p> This article was received in May 05, 2012 and accepted in September 03,
                            2012.<br/> First published online January 11, 2013. </p>
                        <small> This is an Open Access article distributed under the terms of the
                            Creative Commons Attribution Non-Commercial License, which permits
                            unrestricted non-commercial use, distribution, and reproduction in any
                            medium, provided the original work is properly cited. </small-->
                        <xsl:choose>
                            <xsl:when test="$trans">
                                <xsl:apply-templates select="$trans//fn-group" mode="HTML-TEXT"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="$original/back//fn-group" mode="HTML-TEXT"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:comment>history</xsl:comment>
                        <xsl:apply-templates select=".//history" mode="HTML-BODY-FOOTER"/>
                        <xsl:comment>authors fn</xsl:comment>
                        <xsl:apply-templates select=".//authors-notes" mode="HTML-BODY-FOOTER"/>
                        <xsl:comment>permissions</xsl:comment>
                        <xsl:apply-templates select=".//permissions" mode="HTML-BODY-FOOTER"/>
                    </div>
                    <div class="span2 logo"> </div>
                </div>
                <p> End of document </p>
            </div>
        </footer>
    </xsl:template>
    <xsl:template match="history" mode="HTML-BODY-FOOTER">
        <p>
            <xsl:apply-templates select="*" mode="HTML-BODY-FOOTER"/>
        </p>
    </xsl:template>


    <xsl:template match="permissions" mode="HTML-BODY-FOOTER">
        <small>
            <xsl:apply-templates select="." mode="HTML-TEXT"/>
        </small>
    </xsl:template>
    <xsl:template match="fn" mode="HTML-BODY-FOOTER">

        <xsl:apply-templates select="." mode="HTML-TEXT"/>

    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-FLOAT-MENU">
        <div class="floatMenu">
            <div class="container">
                <div class="row">
                    <div class="span2 logo">SciELO</div>
                    <div class="span4 article-data drop-container">
                        <a href="#" class="title">
                            <xsl:apply-templates select="." mode="DATA-DISPLAY-article-title"/>
                        </a>
                        <ul class="drop">
                            <li>
                                <strong>
                                    <xsl:apply-templates select="." mode="DATA-issue-label"/>
                                </strong>
                                <span class="title">
                                    <xsl:apply-templates select="."
                                        mode="DATA-DISPLAY-article-title"/>
                                </span>
                                <span class="author">
                                    <xsl:apply-templates select=".//front//contrib"
                                        mode="DISPLAY-DATA"/>
                                </span>
                                <a href="javascript:void(0);" class="contrib-trigger author-aff"
                                    >Author affiliation<!-- TRANSLATE --></a>
                                <a href="javascript:void(0);" class="contrib-trigger permission"
                                    >Permissions<!-- TRANSLATE --></a>
                            </li>
                        </ul>
                    </div>
                    <div class="span6">
                        <xsl:apply-templates select="." mode="HTML-FLOAT-SECTIONS"/>
                        <xsl:apply-templates select="." mode="HTML-FLOAT-toolbox"/>
                        <xsl:apply-templates select="." mode="HTML-CONTRAST"/>
                        <a href="#top" class="main gIcon top goto" title="Go to top">Top</a>
                        <!-- TRANSLATE -->
                    </div>
                </div>
            </div>
        </div>

    </xsl:template>
    <xsl:template match="*" mode="HTML-CONTRAST">
        <div class="drop-container color-contrast">
            <a href="javascript:void(0);" class="main gIcon soft-contrast"
                title="Choose your color contrast">Choose your color contrast<!-- TRANSLATE --></a>
            <ul class="drop menu">
                <li>
                    <a href="#soft-contrast" class="changeSkin"><span class="gIcon soft-contrast"
                            >&#160;</span> Soft contrast<!-- TRANSLATE --></a>
                </li>
                <li>
                    <a href="#high-contrast" class="changeSkin"><span class="gIcon high-contrast"
                            >&#160;</span> High contrast<!-- TRANSLATE --></a>
                </li>
                <li>
                    <a href="#inversed-high-contrast" class="changeSkin"><span
                            class="gIcon ihigh-contrast">&#160;</span> Inversed high
                        contrast<!-- TRANSLATE --></a>
                </li>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="*" mode="HTML-BODY-IFRAME-MODAL">
        <div id="iframeModal" class="modal hide fade" tabindex="-1" role="dialog"
            aria-labelledby="iframeModal" aria-hidden="true">
            <div class="modal-header">
                <span/>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"
                    >×</button>
            </div>
            <div class="modal-body">
                <iframe width="100%" height="480" frameborder="0" allowfullscreen=""
                    scrolling="auto"/>
            </div>
        </div>
        <script type="text/javascript" src="{$PATH}/static/js/modernizr.custom.js"/>
        <script type="text/javascript" src="{$PATH}/static/js/jquery.1.9.1.min.js"/>
        <script type="text/javascript" src="{$PATH}/static/js/bootstrap.min.js"/>
        <script type="text/javascript" src="{$PATH}/static/js/scielo-article.js"/>
    </xsl:template>

    <xsl:template match="list" mode="HTML-TEXT">
        <a name="{@id}"/>
        <ul>
            <xsl:apply-templates select="@*[name()!='id'] | *|text()" mode="HTML-TEXT"/>
        </ul>
    </xsl:template>
    <xsl:template match="list[@list-type='simple']" mode="HTML-TEXT">
        <a name="{@id}"/>
        <ul style="list-style-type: none">
            <xsl:apply-templates select="@*[name()!='id'] | *|text()" mode="HTML-TEXT"/>
        </ul>
    </xsl:template>
    <xsl:template match="list[@list-type='alpha-lower' or @list-type='alpha-upper' or @list-type='roman-lower' or @list-type='roman-upper' or @list-type='order']" mode="HTML-TEXT">
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="@list-type='alpha-lower'">a</xsl:when>
                <xsl:when test="@list-type='alpha-upper'">A</xsl:when>
                <xsl:when test="@list-type='roman-lower'">i</xsl:when>
                <xsl:when test="@list-type='roman-upper'">I</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <a name="{@id}"/>
        <ol type="{$type}">
            <xsl:apply-templates select="@*[name()!='id'] | *|text()" mode="HTML-TEXT"/>
        </ol>
    </xsl:template>
    <xsl:template match="list-item" mode="HTML-TEXT">
        <li>
            <xsl:apply-templates select="@* | *|text()" mode="HTML-TEXT"/>
        </li>
    </xsl:template>
    
    <xsl:template match="list-item[label and p]" mode="HTML-TEXT">
        <xsl:apply-templates select="p" mode="HTML-TEXT"/>
    </xsl:template>
    
    <xsl:template match="list-item/p | sup | sub " mode="HTML-TEXT">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@* | *|text()" mode="HTML-TEXT"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="list-item[label]/p" mode="HTML-TEXT">
        <p>
            <xsl:value-of select="../label"/>.  
            <xsl:apply-templates select="*|text()" mode="HTML-TEXT"/>
        </p>
    </xsl:template>
    
    <xsl:template match="italic" mode="HTML-TEXT">
        <em>
            <xsl:apply-templates select="@* | *|text()" mode="HTML-TEXT"/>
        </em>
    </xsl:template>
    <xsl:template match="bold" mode="HTML-TEXT">
        <strong>
            <xsl:apply-templates select="@* | *|text()" mode="HTML-TEXT"/>
        </strong>
    </xsl:template>
    <xsl:template match="*" mode="HTML-FLOAT-RELATED">

        <xsl:if test="$SERVICE_RELATED='YES'">
            <div class="drop-container">
                <a href="javascript:void(0);" class="main gIcon related" title="Related links"
                    >Related links</a>
                <ul class="drop menu">
                    <!--
								<li>
									<a href="#">Similar on SciELO</a>
								</li>
								-->
                    <li>
                        <a href="javascript:void(0);">
                            <xsl:attribute name="onclick"> window.open('<xsl:value-of
                                    select="$SERVICE_UBIO"/>') </xsl:attribute>
                            <img src="http://www.scielo.br/img/btubio.png" border="0" width="21px"
                                heigth="21px"/> uBio </a>

                    </li>
                </ul>
            </div>

        </xsl:if>


    </xsl:template>
    <xsl:template match="*" mode="HTML-FLOAT-toolbox">
        <!-- FIXME -->
        <a href="{$THIS_PDF_URL}" class="main gIcon pdf" title="Article in PDF" target="_blank"
            >Article in PDF</a>
        <a href="{$SERVICE_ARTICLE_XML}" class="main gIcon xml" title="Article in XML"
            target="_blank">Article in XML</a>
        <!--a href="#ref-list" class="main gIcon refs iframeModal" title="Article references">Article
            references</a-->
        <a href="{$SERVICE_ARTICLE_AUTO_TRANSLATION}" class="main gIcon translate iframeModal"
            title="Article translate">Automatic translation</a>
        <a href="{$SERVICE_ARTICLE_SEND_EMAIL}" class="main gIcon send iframeModal"
            title="Send this article by email">Send this article by email</a>

        <div class="drop-container social">
            <a href="javascript:void(0);" class="main gIcon social" title="Share this article">Share
                this article<!-- TRANSLATE --></a>
            <ul class="drop menu">
                <li>
                    <a
                        href="http://www.addthis.com/bookmark.php?v=250&amp;username=xa-4c347ee4422c56df"
                        class="addthis_button_expanded"> Bookmarks </a>

                    <!-- AddThis Button END -->
                </li>
            </ul>
        </div>
    </xsl:template>

    <xsl:template match="history/date/@date-type" mode="HTML-label-en">
        <xsl:choose>
            <xsl:when test=". = 'rev-recd'">Revised</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate(substring(.,1,1), 'ar', 'AR')"/>
                <xsl:value-of select="substring(.,2)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="history/date/@date-type" mode="HTML-label-pt">
        <xsl:choose>
            <xsl:when test=". = 'rev-recd'">Revisado</xsl:when>
            <xsl:when test=". = 'accepted'">Aceito</xsl:when>
            <xsl:when test=". = 'received'">Recebido</xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="history/date/@date-type" mode="HTML-label-es">
        <xsl:choose>
            <xsl:when test=". = 'rev-recd'">Revisado</xsl:when>
            <xsl:when test=". = 'accepted'">Aprobado</xsl:when>
            <xsl:when test=". = 'received'">Recibido</xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="history/date" mode="HTML-BODY-FOOTER">
        <xsl:choose>
            <xsl:when test="$PAGE_LANG='pt'">
                <xsl:apply-templates select="@date-type" mode="HTML-label-pt"/>:
                <xsl:value-of select="concat(day,' de ')"/><xsl:apply-templates
                    select="month" mode="HTML-label-pt"/> de <xsl:value-of select="year"/>
            </xsl:when>
            <xsl:when test="$PAGE_LANG='es'">
                <xsl:apply-templates select="@date-type" mode="HTML-label-es"/>:
                <xsl:value-of select="concat(day,' de ')"/><xsl:apply-templates
                    select="month" mode="HTML-label-es"/> de <xsl:value-of select="year"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="@date-type" mode="HTML-label-en"/>:
                <xsl:apply-templates select="month" mode="HTML-label-en"/><xsl:if test="day"><xsl:value-of select="concat(' ',day,',')"/></xsl:if><xsl:value-of select="concat(' ',year)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position()!=last()">; </xsl:if>
    </xsl:template>

    <xsl:template match="table-wrap//fn" mode="HTML-TEXT">
        <a name="{@id}">
            <xsl:apply-templates select="*"/>
        </a>
    </xsl:template>
    <xsl:template match="table//xref" mode="HTML-TEXT">
        <a href="#{@rid}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="disp-quote" mode="HTML-TEXT">

        <div class="row paragraph">
            <div class="span8">
                <p>
                    <blockquote>
                        <xsl:apply-templates select="*|text()" mode="HTML-TEXT"/>
                    </blockquote>
                </p>
            </div>


            <div class="span4"> </div>
        </div>

    </xsl:template>
    <xsl:template match="disp-quote/p" mode="HTML-TEXT">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@* | *|text()" mode="HTML-TEXT"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="ext-link|uri" mode="HTML-TEXT">
        <a href="{@xlink:href}" target="_blank">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    
    <xsl:template match="mixed-citation[*]" mode="HTML-TEXT">
        <xsl:apply-templates select="text()|*" mode="HTML-TEXT"/>
    </xsl:template>
    <xsl:template match="mixed-citation[*]/*/text()" mode="HTML-TEXT">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="mixed-citation/text()" mode="HTML-TEXT">
        <xsl:variable name="text">
            <xsl:choose>
                <xsl:when test="../../label">
                    <xsl:choose>
                        <xsl:when test="position()=1 and starts-with(.,'.')">
                            <xsl:value-of select="substring-after(.,'.')"/>
                        </xsl:when>
                        <xsl:when test="position()=1 and starts-with(., concat(../../label,'.'))">
                            <xsl:value-of select="substring-after(.,concat(../../label,'.'))"/>
                        </xsl:when>
                        <xsl:when test="position()=1 and starts-with(., ../../label)">
                            <xsl:value-of select="substring-after(.,../../label)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="position()=1 and starts-with(.,'.')">
                    <xsl:value-of select="substring-after(.,'.')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
 
        <xsl:choose>
            <xsl:when test="../element-citation/*[@xlink:href]">
                <xsl:apply-templates select="../element-citation/*[@xlink:href]" mode="insert_link_in_text">
                    <xsl:with-param name="text" select="$text"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[@xlink:href]" mode="insert_link_in_text">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text,text())">
                <xsl:value-of select="substring-before($text,text())"/>
                <xsl:apply-templates select="." mode="HTML-TEXT"/>
                <xsl:value-of select="substring-after($text,text())"/>
            </xsl:when>
            <xsl:when test="contains($text,@xlink:href)">
                <xsl:value-of select="substring-before($text,@xlink:href)"/>
                <xsl:apply-templates select="." mode="HTML-TEXT"/>
                <xsl:value-of select="substring-after($text,@xlink:href)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="supplementary-material" mode="HTML-TEXT">
        <a name="{@id}"/>
        <xsl:choose>
            <xsl:when test="media">
                <h1><xsl:value-of select="label"/></h1>
                
                <xsl:apply-templates select="media" mode="HTML-TEXT"/>
            </xsl:when>
            <xsl:when test="@xlink:href">
                <xsl:variable name="src"><xsl:choose>
                    <xsl:when test="contains(@xlink:href,':')"><xsl:value-of select="@xlink:href"/></xsl:when><xsl:otherwise><xsl:value-of select="$PDF_PATH"/><xsl:value-of select="@xlink:href"/></xsl:otherwise>
                </xsl:choose></xsl:variable>
                <a target="_blank">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$src"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="not(*) and normalize-space(text())=''">
                            <xsl:value-of select="@xlink:href"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="*|text()" mode="HTML-TEXT"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="supplementary-material/label" mode="HTML-TEXT">
        <h1><xsl:value-of select="."></xsl:value-of></h1>
    </xsl:template>
    <xsl:template match="supplementary-material/caption" mode="HTML-TEXT">
        <p><xsl:apply-templates select="*|text()"/></p>
    </xsl:template>
    
    <xsl:template match="media" mode="HTML-TEXT">
        <xsl:variable name="src"><xsl:choose>
            <xsl:when test="contains(@xlink:href,':')"><xsl:value-of select="@xlink:href"/></xsl:when><xsl:otherwise><xsl:value-of select="$IMAGE_PATH"/><xsl:value-of select="@xlink:href"/></xsl:otherwise>
        </xsl:choose></xsl:variable>
        
        <xsl:choose>
            <xsl:when test="contains(@xlink:href,'.pdf')">
                <a target="_blank">
                    <xsl:attribute name="href"><xsl:value-of select="$src"/></xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="normalize-space(text())=''"><xsl:value-of select="@xlink:href"/></xsl:when>
                        <xsl:otherwise><xsl:apply-templates select="*|text()"></xsl:apply-templates></xsl:otherwise>
                    </xsl:choose>
                </a>
            </xsl:when>
            <xsl:when test="@mimetype='video'">
                <video width="100%" controls="1">
                    <source src="{$src}" type="{@mimetype}/{@mime-subtype}"/>
                    Your browser does not support the video element.
                </video>
            </xsl:when>
            <xsl:when test="@mimetype='audio'">
                <audio width="100%" controls="1">
                    <source src="{$src}" type="{@mimetype}/{@mime-subtype}"/>
                    Your browser does not support the audio element.
                </audio>
            </xsl:when>
            <xsl:otherwise>
                <a target="_blank">
                    <xsl:attribute name="href"><xsl:value-of select="$src"/></xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="normalize-space(text())=''"><xsl:value-of select="@xlink:href"/></xsl:when>
                        <xsl:otherwise><xsl:apply-templates select="*|text()"></xsl:apply-templates></xsl:otherwise>
                    </xsl:choose>
                </a>
                <embed width="100%" height="400" >
                    <xsl:attribute name="type"><xsl:value-of select="@mimetype"/>/<xsl:value-of select="@mime-subtype"/></xsl:attribute>
                    <xsl:attribute name="src"><xsl:value-of select="$src"/></xsl:attribute> 
                </embed>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="media[@mime-subtype='pdf']" mode="HTML-TEXT">
        <xsl:variable name="src"><xsl:choose>
            <xsl:when test="contains(@xlink:href,':')"><xsl:value-of select="@xlink:href"/></xsl:when><xsl:otherwise><xsl:value-of select="$PDF_PATH"/><xsl:value-of select="@xlink:href"/></xsl:otherwise>
        </xsl:choose></xsl:variable>
        <a target="_blank">
            <xsl:attribute name="href"><xsl:value-of select="$src"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="normalize-space(text())=''"><xsl:value-of select="@xlink:href"/></xsl:when>
                <xsl:otherwise><xsl:apply-templates select="*|text()"></xsl:apply-templates></xsl:otherwise>
            </xsl:choose>
        </a>
    </xsl:template>
    
    <xsl:template match="mml:math|math" mode="HTML-TEXT">
        <xsl:copy-of select="."/>
    </xsl:template>   
    <xsl:template match="article-meta//product">
        <p class="product">
            <xsl:apply-templates select="person-group"/>. <xsl:apply-templates select="source"/>. <xsl:apply-templates select="year"/>. 
            <xsl:apply-templates select="publisher-name"/> (<xsl:apply-templates select="publisher-loc"/>). <xsl:apply-templates select="size"/>. </p>	
    </xsl:template>
    <xsl:template match="product[@product-type='book']">
        <div class="product">
            <xsl:if test="inline-graphic or graphic">
                <div><xsl:apply-templates select="inline-graphic | graphic"/></div>
            </xsl:if>
            <div class="product-text">
                <xsl:apply-templates select="source"/>. <xsl:apply-templates select="person-group"/>. (<xsl:apply-templates select="year"/>). <xsl:apply-templates select="publisher-loc"/>: 
                <xsl:apply-templates select="publisher-name"/>, <xsl:apply-templates select="year"/>, <xsl:apply-templates select="size"/>. <xsl:apply-templates select="isbn"/>		
            </div>
        </div>
    </xsl:template>
    <xsl:template match="product/inline-graphic | product/graphic">
        <a target="_blank">
            <xsl:attribute name="href"><xsl:value-of select="concat($IMAGE_PATH,'/')"/><xsl:apply-templates select="." mode="fix_img_extension"/></xsl:attribute>
            <img class="product-graphic">
                <xsl:attribute name="src"><xsl:value-of select="concat($IMAGE_PATH,'/')"/><xsl:apply-templates select="." mode="fix_img_extension"/></xsl:attribute>
            </img>
        </a>
    </xsl:template>
    <xsl:template match="article-meta//product/person-group">
        <xsl:apply-templates select="name"/>
    </xsl:template>
    <xsl:template match="article-meta//product/person-group/name">
        <xsl:if test="position()!=1">; </xsl:if><xsl:apply-templates select="surname"/>, <xsl:apply-templates select="given-names"/>
    </xsl:template>
    <xsl:template match="size">
        <xsl:value-of select="."/>
        <xsl:choose>
            <xsl:when test="@units='pages'">p</xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="article-meta//product/isbn">
        ISBN: <xsl:value-of select="."/>.
    </xsl:template>
    <xsl:template match="article-meta//product[comment]">
        <p class="product">
            <xsl:apply-templates select="*|text()"/> 
        </p>
    </xsl:template>
    <xsl:template match="article-meta//product[comment]/*">
        <xsl:variable name="last_char"><xsl:value-of select="substring(.,string-length(.))"/></xsl:variable>
        <xsl:comment><xsl:value-of select="$last_char"/></xsl:comment>
        <xsl:value-of select="."/><xsl:if test="position()!=last() and $last_char!='.'">. </xsl:if> 
    </xsl:template>
    <xsl:template match="article-meta//product[comment]/person-group">
        <xsl:apply-templates select="name"/>.
    </xsl:template>

    <xsl:template match="*" mode="text-disclaimer">
        <xsl:if test="$RELATED-DOC[@TYPE='correction'] or $RELATED-DOC[@TYPE='corrected-article']">
            <div class="disclaimer">
                <xsl:if test="$RELATED-DOC[@TYPE='correction']">
                    <xsl:apply-templates select="$RELATED-DOC[@TYPE='correction']"/>			
                </xsl:if>
                <xsl:if test="$RELATED-DOC[@TYPE='corrected-article']">
                    <xsl:apply-templates select="$RELATED-DOC[@TYPE='corrected-article']"/>
                </xsl:if>
            </div>
        </xsl:if>
        <!--xsl:if test=".//ARTICLE/RELATED-DOC[@TYPE='correction']">
			<div class="fixed-disclaimer">			
				<xsl:apply-templates select=".//ARTICLE/RELATED-DOC[@TYPE='correction']"/>			
			</div>
		</xsl:if-->
    </xsl:template>
    
    <xsl:template match="RELATED-DOC[@TYPE='correction']">
        <p>
            <strong><xsl:value-of
                select="$translated/xslid[@id='sci_arttext']/text[@find='this_article_has_been_corrected']"
            />: </strong>
            <a>
                <xsl:call-template name="AddScieloLink">
                    <xsl:with-param name="seq" select="@PID"/>
                    <xsl:with-param name="script">sci_arttext_plus</xsl:with-param>
                    <xsl:with-param name="txtlang" select="$PAGE_LANG"/>
                </xsl:call-template><xsl:value-of select="ISSUE"/>
            </a>
        </p>
    </xsl:template>
    
    <xsl:template match="RELATED-DOC[@TYPE='corrected-article']">
        <p>
            <strong><xsl:value-of
                select="$translated/xslid[@id='sci_arttext']/text[@find='this_corrects']"
            /></strong>
            <a>
                <xsl:call-template name="AddScieloLink">
                    <xsl:with-param name="seq" select="@PID"/>
                    <xsl:with-param name="script">sci_arttext_plus</xsl:with-param>
                    <xsl:with-param name="txtlang" select="$PAGE_LANG"/>
                </xsl:call-template><xsl:value-of select="DOCTITLE"/>. <xsl:value-of select="ISSUE"/>
            </a>
        </p>
    </xsl:template>
</xsl:stylesheet>
