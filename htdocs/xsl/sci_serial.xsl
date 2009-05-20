<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:variable name="forceType" select="//CONTROLINFO/ENABLE_FORCETYPE"/>
	<xsl:variable name="ISSN" select="concat(substring-before(/SERIAL/ISSN,'-'),substring-after(/SERIAL/ISSN,'-'))" />
	<xsl:variable name="show_scimago" select="//show_scimago"/>
	<xsl:variable name="scimago_status" select="//scimago_status"/>
    <xsl:variable name="has_article_pr">
        <xsl:choose>
            <xsl:when test="//PRESSRELEASE/article[@prpid != '']">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="has_issue_pr">
        <xsl:choose>
            <xsl:when test="//PRESSRELEASE/issue[@pid != '']">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

	<xsl:output method="html" indent="no" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<xsl:template match="SERIAL">
        <html>
			<head>
				<title>
				<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/> - <xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='home_page']"/></title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<xsl:if test="//NO_SCI_SERIAL='yes'">
					<xsl:variable name="X">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_artlist&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/><xsl:apply-templates select="." mode="repo_url_param"/></xsl:variable>
					<meta HTTP-EQUIV="REFRESH">
						<xsl:attribute name="Content"><xsl:value-of select="concat('0;URL=',$X)"/></xsl:attribute>
					</meta>
					
				</xsl:if>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/scielo.css"/>
                <link rel="STYLESHEET" TYPE="text/css" href="/css/include_layout.css"/>
                <link rel="STYLESHEET" TYPE="text/css" href="/css/include_styles.css"/>
				<!-- link pro RSS aparecer automaticamente no Browser -->
				<xsl:call-template name="AddRssHeaderLink">
					<xsl:with-param name="pid" select="//CURRENT/@PID"/>
					<xsl:with-param name="lang" select="//LANGUAGE"/>
					<xsl:with-param name="server" select="CONTROLINFO/SCIELO_INFO/SERVER"/>
					<xsl:with-param name="script">rss.php</xsl:with-param>
				</xsl:call-template>
                <script type="text/javascript" src="/applications/scielo-org/js/functions.js"></script>
                <script type="text/javascript" src="/article.js"></script>
			</head>
			<body>
                <xsl:if test="//NO_SCI_SERIAL!='yes' or not(//NO_SCI_SERIAL)">
                    <div class="container">                        
                        <div class="top">
                            <!--
                                monta a barra de navegacao
                            -->
                            <xsl:call-template name="NAVBAR">
                                <xsl:with-param name="bar1">issues</xsl:with-param>
                                <xsl:with-param name="bar2">articlesiah</xsl:with-param>
                                <xsl:with-param name="alpha">
                                    <xsl:choose>
                                        <xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' ">0</xsl:when>
                                        <xsl:otherwise>1</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:with-param>
                                <xsl:with-param name="scope" select="TITLEGROUP/SIGLUM"/>
                            </xsl:call-template>
                        </div>
                        <div class="middle">
                            <!--
                                monta as divs: leftCol e mainContent
                            -->
                            <xsl:apply-templates select="CONTROLINFO">
                                <xsl:with-param name="YEAR" select="substring(@LASTUPDT,1,4)"/>
                                <xsl:with-param name="MONTH" select="substring(@LASTUPDT,5,2)"/>
                                <xsl:with-param name="DAY" select="substring(@LASTUPDT,7,2)"/>
                            </xsl:apply-templates>
                            <!--
                                monta a div: rightCol
                            -->
                            <div class="rightCol">
                                <xsl:if test="($has_issue_pr = 'false') and ($has_article_pr = 'false')">
                                    <xsl:attribute name="style">display: none;</xsl:attribute>
                                </xsl:if>
                                <h2 class="sectionHeading"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='press_releases']"/></h2>

                                <xsl:if test="$has_issue_pr != 'false'">
                                    <strong><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='numbers']"/></strong>
                                    <ul class="pressReleases">
                                        <xsl:apply-templates select="//PRESSRELEASE/issue" mode="pr"/>
                                    </ul>
                                </xsl:if>
                                    
                                <xsl:if test="$has_article_pr != 'false'">
                                    <strong><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='articles']"/></strong>
                                    <ul class="pressReleases">
                                        <xsl:apply-templates select="//PRESSRELEASE/article" mode="pr"/>
                                    </ul>
                                </xsl:if>
                            </div>
                        </div>
                        <div class="spacer">&#160;</div>
                        <!--
                            monta a div: footer
                        -->
                        <xsl:apply-templates select="." mode="footer-journal"/>                        
                    </div>
                </xsl:if>
			</body>
		</html>
	</xsl:template>

<!--
press release do issue
-->
<xsl:template match="issue" mode="pr">
        <xsl:variable name="supl"><xsl:value-of select="string-length(normalize-space(@sup))" /></xsl:variable>
        <xsl:variable name="voll"><xsl:value-of select="string-length(normalize-space(@vol))" /></xsl:variable>
        <xsl:variable name="numl"><xsl:value-of select="string-length(normalize-space(@num))" /></xsl:variable>

	<xsl:variable name="year" select="substring(@data,1,4)"/>
	<xsl:variable name="month" select="substring(@data,5,2)"/>
	<xsl:variable name="day" select="substring(@data,7,2)"/>

	<xsl:variable name="currlang" select="//CONTROLINFO/LANGUAGE"/>

	<li><a href="javascript:void();" onClick="OpenArticleInfoWindow(850,500,'/scielo.php?script=sci_arttext_pr&amp;pid={@pid}&amp;lng={$currlang}&amp;nrm=iso&amp;tlng={@lang}');"><span>
    <xsl:if test="$currlang='pt'">
            <xsl:value-of select="concat($month,'/',$year)"/>
    </xsl:if>
    <xsl:if test="$currlang='es'">
            <xsl:value-of select="concat($month,'/',$year)"/>
    </xsl:if>
    <xsl:if test="$currlang='en'">
            <xsl:value-of select="concat($year,'/',$month)"/>
    </xsl:if>
     -
    <xsl:if test="$voll != 0">v<xsl:value-of select="@vol"/>&#160;</xsl:if>
    <xsl:if test="$numl != 0">n.<xsl:value-of select="@num"/>&#160;</xsl:if>
    <xsl:if test="$supl != 0">s.<xsl:value-of select="@sup"/></xsl:if>
    </span></a></li>
</xsl:template>

<!--
press release do artigo
-->
<xsl:template match="article" mode="pr">
	<xsl:variable name="supl"><xsl:value-of select="string-length(normalize-space(@sup))" /></xsl:variable>
	<xsl:variable name="voll"><xsl:value-of select="string-length(normalize-space(@vol))" /></xsl:variable>
	<xsl:variable name="numl"><xsl:value-of select="string-length(normalize-space(@num))" /></xsl:variable>

        <xsl:variable name="year" select="substring(@data,1,4)"/>
        <xsl:variable name="month" select="substring(@data,5,2)"/>
        <xsl:variable name="day" select="substring(@data,7,2)"/>

	<xsl:variable name="currlang" select="//CONTROLINFO/LANGUAGE"/>

    <li><a href="javascript:void();" onClick="OpenArticleInfoWindow(850,500,'/scielo.php?script=sci_arttext_pr&amp;pid={@prpid}&amp;lng={$currlang}&amp;nrm=iso&amp;tlng={title/@lang}');"><span>
    <xsl:if test="$currlang='pt'">
        <xsl:value-of select="concat($month,'/',$year)"/>
    </xsl:if>
    <xsl:if test="$currlang='es'">
        <xsl:value-of select="concat($month,'/',$year)"/>
    </xsl:if>
    <xsl:if test="$currlang='en'">
        <xsl:value-of select="concat($year,'/',$month)"/>
    </xsl:if>
    -
    <xsl:if test="$voll != 0">v<xsl:value-of select="@vol"/>&#160;</xsl:if>
    <xsl:if test="$numl != 0">n.<xsl:value-of select="@num"/>&#160;</xsl:if>
    <xsl:if test="$supl != 0">s.<xsl:value-of select="@sup"/></xsl:if>

    </span><xsl:value-of select="title"/></a></li>
</xsl:template>


    <!--
        nome do publicador
    -->
	<xsl:template match="PUBLISHER">
		<xsl:value-of select="NAME" disable-output-escaping="yes"/>
		<br/>
	</xsl:template>

    <!--
        missao da revista
    -->
	<xsl:template match="MISSION">
		<font color="#000080">
			<xsl:value-of select="." disable-output-escaping="yes"/>
			<br/>
		</font>
		<br/>
	</xsl:template>
	
	<!--
		links dos idiomas da interface
	-->	
	<xsl:template match="CONTROLINFO" mode="change-language">
        <xsl:if test="//CONTROLINFO/LANGUAGE != 'pt'">
		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="//PAGE_NAME"/>&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=pt&amp;nrm=iso</xsl:attribute>
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='portuguese']"/></font>
		</a><br/>
        </xsl:if>
        <xsl:if test="//CONTROLINFO/LANGUAGE != 'en'">
		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="//PAGE_NAME"/>&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=en&amp;nrm=iso</xsl:attribute>
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='english']"/></font>
		</a><br/>
        </xsl:if>
        <xsl:if test="//CONTROLINFO/LANGUAGE != 'es'">
		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="//PAGE_NAME"/>&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=es&amp;nrm=iso</xsl:attribute>

			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='spanish']"/></font>
		</a><br/>
        </xsl:if>
        <br/>
    </xsl:template>
    
	<!--
		formacao do link de página secundária
	-->	
	<xsl:template match="CONTROLINFO" mode="link">
		<xsl:param name="itemName"/>
		<xsl:param name="itemName2"/>
		<xsl:variable name="pref">
			<xsl:choose>
				<xsl:when test="LANGUAGE='en' ">i</xsl:when>
				<xsl:when test="LANGUAGE='es' ">e</xsl:when>
				<xsl:when test="LANGUAGE='pt' ">p</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<li>
            <a>
                <xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/>
                <xsl:value-of select="SCIELO_INFO/PATH_SERIAL_HTML"/><xsl:value-of select="/SERIAL/TITLEGROUP/SIGLUM"/>/<xsl:value-of select="$pref"/><xsl:if test="$itemName2"><xsl:value-of select="$itemName2"/></xsl:if><xsl:if test="not($itemName2)"><xsl:value-of select="$itemName"/></xsl:if>.htm</xsl:attribute>                
                <xsl:apply-templates select="." mode="link-text">
                    <xsl:with-param name="type" select="$itemName"/>
                </xsl:apply-templates>
            </a>
        </li>		
	</xsl:template>

	<!--
		formacao dos links das páginas secundárias
	-->		
	<xsl:template match="CONTROLINFO" mode="links">
        <ul class="contextMenu">
            <!--link de submissao-->
            <li id="btn_submission"><xsl:apply-templates select="..//link[@type='online-submission']"/></li>
            <xsl:apply-templates select="." mode="link">
                <xsl:with-param name="itemName" select="'aboutj'"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="." mode="link">
                <xsl:with-param name="itemName" select="'edboard'"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="." mode="link">
                <xsl:with-param name="itemName" select="'instruc'"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="." mode="link">
                <xsl:with-param name="itemName" select="'subscri'"/>
                <xsl:with-param name="itemName2" select="'subscrp'"/>
            </xsl:apply-templates>
            <xsl:if test=" ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 ">
                <li>
                    <a href="{SCIELO_INFO/STAT_SERVER}/stat_biblio/index.php?lang={LANGUAGE}&amp;issn={/SERIAL/ISSN}">
                    <xsl:apply-templates select="." mode="link-text">
                        <xsl:with-param name="type" select="'statistic'"/>
                    </xsl:apply-templates>
                    <br/>
                    </a>
                </li>
            </xsl:if>
        </ul>        
    </xsl:template>
	
	<!--
        submissao online
    -->
	<xsl:template match="link">
		<a href="{.}" target="subm">
			<xsl:apply-templates select="../CONTROLINFO" mode="link-text">
				<xsl:with-param name="type" select="'subm'"/>
			</xsl:apply-templates>
		</a>
		<br/>
	</xsl:template>

	<!--
		textos traduzidos
	-->				
	<xsl:template match="CONTROLINFO" mode="text-mission">
        <xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='mission']"/>
	</xsl:template>
	<xsl:template match="CONTROLINFO" mode="text-publication-of">
        <xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='publication_of']"/>
	</xsl:template>
	<xsl:template match="CONTROLINFO" mode="update-date">
        <xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='updated_on']"/>
	</xsl:template>
	<xsl:template match="CONTROLINFO" mode="link-text">
		<xsl:param name="type"/>
		<span>
			<xsl:choose>
				<xsl:when test="$type='aboutj'"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='about_the_journal']"/></xsl:when>
				<xsl:when test="$type='edboard'"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='editorial_board']"/></xsl:when>
				<xsl:when test="$type='instruc'"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='instructions_to_authors']"/></xsl:when>
				<xsl:when test="$type='subscri'"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='subscription']"/></xsl:when>
				<xsl:when test="$type='statistic'"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='statistics']"/></xsl:when>
				<xsl:when test="$type='subm'"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='online_submission']"/></xsl:when>
			</xsl:choose>
		</span>
	</xsl:template>

	<!-- 
	CONTROLINFO
	-->
    <xsl:template match="CONTROLINFO">
		<xsl:param name="YEAR"/>
		<xsl:param name="MONTH"/>
		<xsl:param name="DAY"/>

        <div class="leftCol">
            <small><xsl:apply-templates select="." mode="update-date"/></small>
            <span id="lastUpdate">
                <xsl:call-template name="GET_MONTH_NAME">
                    <xsl:with-param name="LANG" select="LANGUAGE"/>
                    <xsl:with-param name="MONTH" select="$MONTH"/>
                </xsl:call-template>&#160;<xsl:value-of select="$DAY"/>,&#160;<xsl:value-of select="$YEAR"/>
            </span>
            <xsl:apply-templates select="." mode="links"/>

            <!--
                monta o grafico scimago
            -->
            <div class="optionsSubMenu">
                <xsl:variable name="graphMago" select="document('../../bases/scimago/scimago.xml')/SCIMAGOLIST/title[@ISSN = $ISSN]/@SCIMAGO_ID"/>
                <xsl:if test="$show_scimago!=0 and normalize-space($scimago_status) = normalize-space('online')" >
                    <xsl:if test="$graphMago">
                        <div><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='indicators_scimago']"/></div>
                        <a>
                            <xsl:attribute name="href">http://www.scimagojr.com/journalsearch.php?q=<xsl:value-of select="$ISSN"/>&amp;tip=iss&amp;exact=yes></xsl:attribute>
                            <xsl:attribute name="target">_blank</xsl:attribute>
                            <img>
                                <xsl:attribute name="src">http://www.scimagojr.com/journal_img.php?id=<xsl:value-of select="$graphMago"/>&amp;title=false</xsl:attribute>
                                <xsl:attribute name="alt"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='scimago_journal_country_rank']"/></xsl:attribute>
                                <xsl:attribute name="border">0</xsl:attribute>
                            </img>
                        </a>
                    </xsl:if>
                </xsl:if>
            </div>
        </div>

        <div class="mainContent">
        <xsl:if test="($has_issue_pr = 'false') and ($has_article_pr = 'false')">
            <xsl:attribute name="style">border-right: none;</xsl:attribute>
        </xsl:if>
            <div class="journalLogo">
                <xsl:call-template name="ImageLogo">
                    <xsl:with-param name="src">
                        <xsl:value-of select="SCIELO_INFO/PATH_SERIMG"/>
                        <xsl:value-of select="/SERIAL/TITLEGROUP/SIGLUM"/>/glogo.gif</xsl:with-param>
                    <xsl:with-param name="alt">
                        <xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/>
                    </xsl:with-param>
                </xsl:call-template>
            </div>

            <div class="search">
                <h2 class="sectionHeading"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='search']"/></h2>
                <form name="searchForm" action="http://{//SCIELO_INFO/SERVER}/cgi-bin/wxis.exe/iah/" method="post">
                    <input type="hidden" value="iah/iah.xis" name="IsisScript"/>
                    <input type="hidden" value="p" name="lang"/>
                    <input type="hidden" value="article^dlibrary" name="base"/>
                    <input type="hidden" value="extSearch" name="nextAction"/>                    

                    <input id="textEntry1" name="exprSearch" class="expression midium defaultValue" value="{$translations/xslid[@id='sci_serial']/text[@find='enter_search_term']}" onfocus="clearDefault('textEntry1', 'expression midium'); this.value= (this.value=='{$translations/xslid[@id='sci_serial']/text[@find='enter_search_term']}')? '' : this.value" onblur="clearDefault('textEntry1', 'expression midium defaultValue'); this.value= (this.value=='')? '{$translations/xslid[@id='sci_serial']/text[@find='enter_search_term']}' : this.value" type="text" />
                   
                    <select class="inputText mini" name="indexSearch">
                        <option selected="true" value="^nTo^pTodos os índices^eTodos los indices^iAll indexes^d*^xTO ^yFULINV"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='all_indexes']"/></option>
                        <option value="^nTi^pPalavras do título^ePalabras del título^iTitle words^xTI ^yPREINV^uTI_^mTI_"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='title']"/></option>
                        <option value="^nAu^pAutor^eAutor^iAuthor^xAU ^yPREINV^uAU_^mAU_"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='author']"/></option>
                        <option value="^nKw^pAssunto^eMateria^iSubject^xKW ^yPREINV^uKW_^mKW_"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='subject']"/></option>
                    </select>

                    <select class="inputText mini" name="limit">
                        <option value="{/SERIAL/ISSN}"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='this_journal']"/></option>
                        <option value=""><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='scielo_brazil']"/></option>
                    </select>
                    
                    <input value="{$translations/xslid[@id='sci_serial']/text[@find='search']}" name="submit" class="submit" type="submit"/>
                </form>
            </div>

            <div class="journalInfo">
                <small><xsl:apply-templates select="." mode="text-publication-of"/></small>
                <strong class="journalTitle"><xsl:apply-templates select="/SERIAL/PUBLISHERS/PUBLISHER"/></strong>
                <span class="issn">ISSN&#160;<xsl:value-of select="/SERIAL/ISSN"/></span>
                <h2 class="sectionHeading"><xsl:apply-templates select="." mode="text-mission"/></h2>
                <p>
                    <xsl:apply-templates select="/SERIAL/MISSION"/>
                    <xsl:apply-templates select="/SERIAL/CHANGESINFO">
                        <xsl:with-param name="LANG" select="normalize-space(LANGUAGE)"/>
                    </xsl:apply-templates>
                </p>
            </div>            
        </div>
	</xsl:template>
</xsl:stylesheet>

