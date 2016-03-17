<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:variable name="journal_manager" select="//journal_manager"/>
    <xsl:variable name="control_info" select="//CONTROLINFO"/>
    <xsl:variable name="HOME_URL">http://<xsl:value-of select="$control_info/SCIELO_INFO/SERVER"/>
        <xsl:value-of select="$control_info/SCIELO_INFO/PATH_DATA"/>scielo.php</xsl:variable>
    <xsl:variable name="interfaceLang" select="$control_info/LANGUAGE"/>
    <xsl:variable name="articleLang" select="//ARTICLE/@TEXTLANG"/>

    <xsl:variable name="SITE_NAME" select="$control_info/SITE_NAME"/>
    <xsl:variable name="translations"
        select="document(concat('../xml/',$interfaceLang,'/translation.xml'))/translations"/>
    <xsl:variable name="ARTICLE_LICENSE" select="//article-meta/permissions"/>
    <xsl:variable name="GENERAL_LICENSE" select="//PERMISSIONS/permissions"/>
    <xsl:variable name="show_readcube_epdf" select="//varScieloOrg/show_readcube_epdf"/>
    <xsl:variable name="isProvisional">
        <xsl:if test="//ISSUE/@NUM='REVIEW'">1</xsl:if>
    </xsl:variable>
    <xsl:variable name="langtext">
        <xsl:choose>
            <xsl:when test="$control_info/PAGE_NAME='sci_arttext'">
                <xsl:value-of select="//ISSUE/ARTICLE/@TEXTLANG"/>
            </xsl:when>
            <xsl:when test="$control_info/PAGE_NAME='sci_abstract'">
                <xsl:value-of select="//ARTICLE/ABSTRACT/@xml:lang"/>
            </xsl:when>
            <xsl:when test="$control_info/PAGE_NAME='sci_pdf'">
                <xsl:value-of select="//ARTICLE/@PDF_LANG"/>
            </xsl:when>
        </xsl:choose>
    </xsl:variable>
    <xsl:include href="sci_artref.xsl"/>
    <xsl:template name="AddRssHeaderLink">
        <xsl:param name="pid"/>
        <xsl:param name="lang"/>
        <xsl:param name="server"/>
        <xsl:param name="script"/>
        <xsl:element name="link">
            <xsl:attribute name="rel">alternate</xsl:attribute>
            <xsl:attribute name="type">application/rss+xml</xsl:attribute>
            <xsl:attribute name="title">SciELO</xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of
                    select="concat('http://',$server,'/',$script,'?pid=',$pid,'&amp;lang=',$lang)"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <!-- Variável de Flag utilizada para log utilizada também no arquivo sci_toolbox -->
    <xsl:variable name="service_log" select="//services_log"/>

    <xsl:variable name="services" select="document('../xml/services_log.xml')"/>

    <!--xsl:if test="$service_log = 1">
                <services>
                        <service>
                                <name>minhaColecao</name>
                                <call>callUpdateArticleLog('adicionar_a_minha_colecao');</call>
                        </service>
                        <service>
                                <name>aviseMeCitado</name>
                                <call>callUpdateArticleLog('avise-me_quando_for_citado');</call>
                        </service>
                        <service>
                                <name>envieMeEstatisticaAcesso</name>
                                <call>callUpdateArticleLog('envie-me_estatisticas_de_acesso');</call>
                        </service>
                        <service>
                                <name>comentarios</name>
                                <call>callUpdateArticleLog('comentarios');</call>
                        </service>
                        <service>
                                <name>indicadoresSaude</name>
                                <call>callUpdateArticleLog('indicadores_de_saude');</call>
                        </service>
                        <service>
                                <name>referenciasArtigo</name>
                                <call>callUpdateArticleLog('referencias_do_artigo');</call>
                        </service>
                        <service>
                                <name>servicosCustomizados</name>
                                <call>callUpdateArticleLog('servicos_customizados');</call>
                        </service>
                        <service>
                                <name>curriculumScienTI</name>
                                <call>callUpdateArticleLog('curriculum_scienTI');</call>
                        </service>
                </services>
        </xsl:if-->

    <!--Exibe caixa para exportação da citacao para "Reference Managers"-->
    <xsl:template name="PrintExportCitationForRefecenceManagers">
        <xsl:param name="LANGUAGE"/>
        <xsl:param name="pid"/>
        <div class="serviceColumn">
            <div class="webServices">
                <form name="exportCitation" action="/export.php" method="post" target="download">
                    <input type="hidden" name="PID" value="{$pid}"/>
                    <input type="hidden" name="format"/>
                </form>
                <h3>
                    <span>
                        <xsl:value-of
                            select="$translations/xslid[@id='sci_common']/text[@find = 'reference_manager']"
                        />
                    </span>
                </h3>
                <ul>
                    <li>
                        <a href="?download&amp;format=BibTex&amp;pid={$pid}">
                            <xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'export_to_bibtex']"
                            />
                        </a>
                    </li>
                    <li>
                        <a href="?download&amp;format=RefMan&amp;pid={$pid}">
                            <xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'export_to_reference_manager']"
                            />
                        </a>
                    </li>
                    <li>
                        <a href="?download&amp;format=ProCite&amp;pid={$pid}">
                            <xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'export_to_procite']"
                            />
                        </a>
                    </li>
                    <li>
                        <a href="?download&amp;format=EndNote&amp;pid={$pid}">
                            <xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'export_to_endnote']"
                            />
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)"
                            onclick="javascript:w =  window.open('','download', '');document.exportCitation.format.value='RefWorks';document.exportCitation.submit();">
                            <xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'export_to_refworks']"
                            />
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="AddScieloLinkEPDF">
        <xsl:param name="seq"/>
        <xsl:param name="script"/>
        <xsl:param name="txtlang"/>
        <xsl:param name="file"/>
        <xsl:param name="date"/>
        <xsl:param name="page"/>
        <xsl:attribute name="href">/readcube/epdf.php<xsl:value-of select="concat('?doi=',//ARTICLE[@PID=$seq]/@DOI,'&amp;pid=',$seq,'&amp;pdf_path=',//ARTICLE[@PID=$seq]/LANGUAGES/PDF_LANGS/LANG[.=$txtlang]/@TRANSLATION,'&amp;lang=',$txtlang)"/></xsl:attribute>
    </xsl:template>
    <!-- Adds a link to a SciELO page 
        Parameters: seq - Issue PID
                             script - Name of the script to be called -->
    <xsl:template name="AddScieloLink">
        <xsl:param name="seq"/>
        <xsl:param name="script"/>
        <xsl:param name="txtlang"/>
        <xsl:param name="file"/>
        <xsl:param name="date"/>
        <xsl:param name="page"/>
        <xsl:choose>
            <xsl:when test="$script = 'sci_pdf' ">
                <xsl:attribute name="href">
                    <xsl:value-of select="$control_info/SCIELO_INFO/PATH_DATA"/>pdf/<xsl:value-of select="//ARTICLE[@PID=$seq]/LANGUAGES/PDF_LANGS/LANG[.=$txtlang]/@TRANSLATION"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="href">
                    <xsl:call-template name="getScieloLink">
                        <xsl:with-param name="seq" select="$seq"/>
                        <xsl:with-param name="script" select="$script"/>
                        <xsl:with-param name="txtlang" select="$txtlang"/>
                        <xsl:with-param name="file" select="$file"/>
                        <xsl:with-param name="date" select="$date"/>
                        <xsl:with-param name="page" select="$page"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getScieloLink">
        <xsl:param name="seq"/>
        <xsl:param name="script"/>
        <xsl:param name="txtlang"/>
        <xsl:param name="file"/>
        <xsl:param name="date"/>
        <xsl:param name="page"/>
        <xsl:value-of select="$HOME_URL"/>?script=<xsl:value-of select="$script"/>&amp;<xsl:if
            test="$seq">pid=<xsl:value-of select="$seq"/>&amp;</xsl:if>lng=<xsl:value-of
            select="normalize-space($interfaceLang)"/>&amp;nrm=<xsl:value-of
            select="normalize-space($control_info/STANDARD)"/>
        <xsl:if test="$txtlang">&amp;tlng=<xsl:value-of select="normalize-space($txtlang)"/>
        </xsl:if>
        <xsl:if test="$file">&amp;file=<xsl:value-of select="$file"/>
        </xsl:if>
        <xsl:apply-templates select="." mode="repo_url_param_scielo"/>
        <xsl:if test="$date!=''">&amp;date=<xsl:value-of select="$date"/>
        </xsl:if>
        <xsl:if test="$page!=''">&amp;page=<xsl:value-of select="$page"/>
        </xsl:if>
    </xsl:template>
    <!-- Adds a LINK to the IAH search interface
        Parameters:
           index - AU,etc
           scope - library | siglum  -->
    <xsl:template name="AddIAHLink">
        <xsl:param name="index"/>
        <xsl:param name="scope"/>
        <xsl:param name="base">article</xsl:param>
        <!-- DIFF REPO X PADRAO -->
        <xsl:attribute name="href">http://<xsl:value-of select="$control_info/SCIELO_INFO/SERVER"
                /><xsl:value-of select="$control_info/SCIELO_INFO/PATH_WXIS"/><xsl:value-of
                select="$control_info/SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of
                select="$control_info/SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=<xsl:value-of
                select="$base"/><xsl:if test="$scope">^d<xsl:apply-templates select="."
                    mode="repo_database"><xsl:with-param name="scope" select="$scope"
                    /></xsl:apply-templates></xsl:if>&amp;<xsl:if test="$index">index=<xsl:value-of
                    select="$index"/>&amp;</xsl:if>format=<xsl:value-of
                select="$control_info/STANDARD"/>.pft&amp;lang=<xsl:choose><xsl:when
                    test="$control_info/LANGUAGE='en'">i</xsl:when><xsl:when
                    test="$control_info/LANGUAGE='es'">e</xsl:when><xsl:when
                    test="$control_info/LANGUAGE='pt'">p</xsl:when></xsl:choose><xsl:if
                test="$scope and $scope!='library'">&amp;limit=<xsl:apply-templates select="."
                    mode="repo_limit"/></xsl:if></xsl:attribute>
    </xsl:template>
    <!-- Shows Title Group -->
    <xsl:template match="TITLEGROUP">
        <CENTER>
            <FONT class="nomodel" color="#000080" size="+1">
                <xsl:value-of select="TITLE" disable-output-escaping="yes"/>
            </FONT>
            <br/>
        </CENTER>
    </xsl:template>
    <!-- Shows copyright information -->
    <xsl:template match="COPYRIGHT">
        <p>
            &#169;&#160; <xsl:value-of select="@YEAR"/>&#160; 
            <i>
                <xsl:value-of select="." disable-output-escaping="yes"/>
            </i>
        </p>
        <xsl:apply-templates select="../CONTACT"></xsl:apply-templates>
    </xsl:template>
    <!-- Shows contact information -->
    <xsl:template match="CONTACT">
        <xsl:apply-templates select="LINES"/>
        <xsl:apply-templates select="EMAILS"/>
        <xsl:call-template name="UpdateLog"/>
    </xsl:template>
    <!-- Shows lines from contact information -->
    <xsl:template match="LINES">
        <xsl:apply-templates select="LINE"/>
    </xsl:template>
    <xsl:template match="LINE">
        <xsl:value-of select="." disable-output-escaping="yes"/>
        <br/>
    </xsl:template>
    <!-- Shows e-mail links -->
    <xsl:template match="EMAILS">
        <IMG>
            <xsl:attribute name="src"><xsl:value-of select="$control_info/SCIELO_INFO/PATH_GENIMG"
                    /><xsl:value-of select="$control_info/LANGUAGE"/>/e-mailt.gif</xsl:attribute>
            <xsl:attribute name="border">0</xsl:attribute>
        </IMG>
        <br/>
        <xsl:apply-templates select="EMAIL"/>
    </xsl:template>
    <!-- Show E-Mail -->
    <xsl:template match="EMAIL">
        <A class="email">
            <xsl:attribute name="href">mailto:<xsl:value-of select="."/></xsl:attribute>
            <xsl:value-of select="."/>
        </A>
    </xsl:template>
    <!-- Gets the type of the ISSN
         Parameters:
           TYPE - Type Code (PRINT | CDROM | DISKE | ONLIN)  
           LANG - language code   -->
    <xsl:template name="GET_ISSN_TYPE">
        <xsl:param name="TYPE"/>
        <xsl:param name="LANG"/>
        <xsl:comment><xsl:value-of select="$TYPE"/><xsl:value-of select="$LANG"/></xsl:comment>
        <xsl:choose>
            <xsl:when test="($LANG = 'pt') or ($LANG = 'es')">
                <em>
                    <xsl:value-of
                        select="$translations/xslid[@id='sci_common']/text[@find = 'version']"/>
                    <xsl:choose>
                        <xsl:when test=" $TYPE = 'PRINT' ">&#160;<xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'print']"
                            />
                        </xsl:when>
                        <xsl:when test=" $TYPE = 'CDROM' ">&#160;<xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'cdrom']"
                            />
                        </xsl:when>
                        <xsl:when test=" $TYPE = 'DISKE' ">&#160;<xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'diskette']"
                            />
                        </xsl:when>
                        <xsl:when test=" $TYPE = 'ONLIN' ">&#160;<xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'online']"
                            />
                        </xsl:when>
                    </xsl:choose>
                </em>
            </xsl:when>
            <xsl:when test="$LANG = 'en'">
                <em>
                    <xsl:choose>
                        <xsl:when test=" $TYPE = 'PRINT' ">
                            <xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'print']"
                            />&#160;</xsl:when>
                        <xsl:when test=" $TYPE = 'CDROM' ">
                            <xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'cdrom']"
                            />&#160;</xsl:when>
                        <xsl:when test=" $TYPE = 'DISKE' ">
                            <xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'diskette']"
                            />&#160;</xsl:when>
                        <xsl:when test=" $TYPE = 'ONLIN' ">
                            <xsl:value-of
                                select="$translations/xslid[@id='sci_common']/text[@find = 'online']"
                            />&#160;</xsl:when>
                    </xsl:choose>
                    <xsl:value-of
                        select="$translations/xslid[@id='sci_common']/text[@find = 'version']"/>
                </em>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- Displays former title and new title
         Parameter:
           LANG - language code   -->
    <xsl:template match="CHANGESINFO">
        <xsl:param name="LANG"/>
        <xsl:if test="FORMERTITLE/TITLE">
            <br/>
            <small>
                <xsl:value-of
                    select="$translations/xslid[@id='sci_common']/text[@find = 'former_title']"/>: </small>
            <br/>
            <font color="#000080">
                <em>
                    <xsl:apply-templates select="FORMERTITLE"/>
                </em>
            </font>
        </xsl:if>
        <xsl:if test="NEWTITLE/TITLE">
            <br/>
            <small>
                <xsl:value-of
                    select="$translations/xslid[@id='sci_common']/text[@find = 'new_title']"/>: </small>
            <br/>
            <font color="#000080">
                <em>
                    <xsl:apply-templates select="NEWTITLE"/>
                    <br/>
                </em>
            </font>
        </xsl:if>
    </xsl:template>
    <!-- Gets the former title -->
    <xsl:template match="FORMERTITLE">
        <xsl:choose>
            <xsl:when test="TITLE/@ISSN">
                <a>
                    <xsl:call-template name="AddScieloLink">
                        <xsl:with-param name="seq" select="TITLE/@ISSN"/>
                        <xsl:with-param name="script">
                            <xsl:apply-templates select="." mode="sci_serial"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="normalize-space(TITLE)" disable-output-escaping="yes"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(TITLE)" disable-output-escaping="yes"/>
            </xsl:otherwise>
        </xsl:choose>
        <br/>
    </xsl:template>
    <!-- Gets the New title -->
    <xsl:template match="NEWTITLE">
        <xsl:choose>
            <xsl:when test="TITLE/@ISSN">
                <a>
                    <xsl:call-template name="AddScieloLink">
                        <xsl:with-param name="seq" select="TITLE/@ISSN"/>
                        <xsl:with-param name="script">
                            <xsl:apply-templates select="." mode="sci_serial"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="normalize-space(TITLE)" disable-output-escaping="yes"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(TITLE)" disable-output-escaping="yes"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Prints the issn and its type
         Parameters:
           LANG: language code
           SERIAL: 1 - serial home page style (Optional)
                         otherwise - all other pages style        -->
    <xsl:template match="TITLE_ISSN | ISSUE_ISSN">
        <xsl:param name="LANG"/>
        <xsl:param name="SERIAL"/>
        <font class="nomodel" color="#000080">
            <xsl:choose>
                <xsl:when test=" $LANG='en' ">
                    <xsl:choose>
                        <xsl:when test="$SERIAL">
                            <font color="#000000">
                                <xsl:call-template name="GET_ISSN_TYPE">
                                    <xsl:with-param name="TYPE" select="@TYPE"/>
                                    <xsl:with-param name="LANG" select="$LANG"/>
                                </xsl:call-template>&#160;ISSN</font>&#160;<xsl:value-of
                                select="normalize-space(.)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="GET_ISSN_TYPE">
                                <xsl:with-param name="TYPE" select="@TYPE"/>
                                <xsl:with-param name="LANG" select="$LANG"/>
                            </xsl:call-template>&#160;ISSN&#160;<xsl:value-of
                                select="normalize-space(.)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test=" $LANG='pt' ">
                    <xsl:choose>
                        <xsl:when test="$SERIAL">
                            <font color="#000000">ISSN</font>
                        </xsl:when>
                        <xsl:otherwise>ISSN</xsl:otherwise>
                    </xsl:choose>&#160;<xsl:value-of select="normalize-space(.)"/>&#160;<xsl:if
                        test="$SERIAL">
                        <br/>
                    </xsl:if>
                    <xsl:call-template name="GET_ISSN_TYPE">
                        <xsl:with-param name="TYPE" select="@TYPE"/>
                        <xsl:with-param name="LANG" select="$LANG"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test=" $LANG='es' ">
                    <xsl:choose>
                        <xsl:when test="$SERIAL">
                            <font color="#000000">ISSN</font>
                        </xsl:when>
                        <xsl:otherwise>ISSN</xsl:otherwise>
                    </xsl:choose>&#160;<xsl:value-of select="normalize-space(.)"/>&#160;<xsl:if
                        test="$SERIAL">
                        <br/>
                    </xsl:if>
                    <xsl:call-template name="GET_ISSN_TYPE">
                        <xsl:with-param name="TYPE" select="@TYPE"/>
                        <xsl:with-param name="LANG" select="$LANG"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </font>
    </xsl:template>
    <!-- Creates Links for abstract, full-text or pdf file
          Parameters:
              TYPE: (abstract | full | pdf)
              INTLANG: interface language code
              TXTLANG: text language code
              PID: Article's pid
-->
    <xsl:template name="CREATE_ARTICLE_LINK">
        <xsl:param name="TYPE"/>
        <xsl:param name="INTLANG"/>
        <xsl:param name="TXTLANG"/>
        <xsl:param name="PID"/>
        <xsl:param name="FIRST_LABEL">0</xsl:param>
        <xsl:param name="file"/>
        <xsl:variable name="script">
            <xsl:choose>
                <xsl:when test=" $TYPE='abstract' ">sci_abstract</xsl:when>
                <xsl:when test=" $TYPE='full'">sci_arttext</xsl:when>
                <xsl:when test=" $TYPE='pr'">sci_arttext_pr</xsl:when>
                <xsl:when test=" $TYPE='pdf' ">sci_pdf</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:if test="$FIRST_LABEL='1'">
                <xsl:choose>
                    <xsl:when test="$isProvisional='1' and  $TYPE='full' ">
                        <xsl:value-of
                            select="$translations//xslid[@id='sci_issuetoc']//text[@find='abstract']"
                        />
                    </xsl:when>
                    <xsl:when test="$TYPE='pdf' "></xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="$translations//xslid[@id='sci_issuetoc']//text[@find=$TYPE]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:variable name="languages"
                select="document(concat('../xml/',$INTLANG,'/language.xml'))//language"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$languages[@id=$TXTLANG]"/>
        </xsl:variable>
        <xsl:variable name="origlang" select="../../../@TEXT_LANG" />
        <xsl:choose>
            <xsl:when test="$TYPE='pr'">
                <xsl:variable name="url">
                    <xsl:call-template name="getScieloLink">
                        <xsl:with-param name="seq" select="$PID"/>
                        <xsl:with-param name="script" select="$script"/>
                        <xsl:with-param name="txtlang" select="$TXTLANG"/>
                        <xsl:with-param name="file" select="$file"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="CREATE_ARTICLE_SERVICE_LINK">
                    <xsl:with-param name="URL" select="$url"/>
                    <xsl:with-param name="LABEL" select="$label"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$TYPE='pdf'">
                <xsl:value-of select="$label"/>
                (
                <a>
                    <xsl:call-template name="AddScieloLink">
                        <xsl:with-param name="seq" select="$PID"/>
                        <xsl:with-param name="script" select="$script"/>
                        <xsl:with-param name="txtlang" select="$TXTLANG"/>
                        <xsl:with-param name="file" select="$file"/>
                    </xsl:call-template>
                    <!-- o texto do link é o idioma do texto como no sumário -->
                    <img src="/img/en/iconPDFDocument.gif" width="14px"/>pdf
                </a>
                <xsl:if test="$show_readcube_epdf='1'">
                    <a>
                        <xsl:call-template name="AddScieloLinkEPDF">
                            <xsl:with-param name="seq" select="$PID"/>
                            <xsl:with-param name="script" select="$script"/>
                            <xsl:with-param name="txtlang" select="$TXTLANG"/>
                            <xsl:with-param name="file" select="$file"/>
                        </xsl:call-template>
                        <!-- o texto do link é o idioma do texto como no sumário -->
                        <img src="/img/readcube.png" width="14px"/>epdf
                    </a>
                </xsl:if>
                )
            </xsl:when>
            <xsl:otherwise>
                <a>
                    <xsl:call-template name="AddScieloLink">
                        <xsl:with-param name="seq" select="$PID"/>
                        <xsl:with-param name="script" select="$script"/>
                        <xsl:with-param name="txtlang" select="$TXTLANG"/>
                        <xsl:with-param name="file" select="$file"/>
                    </xsl:call-template>
                    <!-- o texto do link é o idioma do texto como no sumário -->
                    <xsl:value-of select="$label"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>

        <!-- &#160;&#160;&#160; -->
    </xsl:template>
    <!-- Invisible Image To Update Log File -->
    <xsl:template name="CREATE_ARTICLE_SERVICE_LINK">
        <xsl:param name="SERVICE_ID" select="''"/>
        <xsl:param name="LABEL"/>
        <xsl:param name="IMG"/>
        <xsl:param name="URL"/>
        <xsl:if test="$IMG">
            <a href="javascript:void(0);" class="nomodel" style="text-decoration: none;"
                rel="nofollow" onmouseout="status='';" onmouseover="status='{$LABEL}'; return true;">
                <xsl:attribute name="onclick">OpenArticleInfoWindow ( 850, 500, '<xsl:value-of
                        select="$URL"/>');<xsl:if test="$SERVICE_ID!=''"
                            >callUpdateArticleLog('<xsl:value-of select="$SERVICE_ID"
                    />');</xsl:if></xsl:attribute>
                <img border="0" align="middle" src="{$IMG}"/>
            </a>
        </xsl:if>
        <xsl:if test="$LABEL">
            <a href="javascript:void(0);" class="nomodel" style="text-decoration: none;"
                rel="nofollow" onmouseout="status='';" onmouseover="status='{$LABEL}'; return true;">
                <xsl:attribute name="onclick">OpenArticleInfoWindow ( 850, 500, '<xsl:value-of
                        select="$URL"/>');<xsl:if test="$SERVICE_ID!=''"
                            >callUpdateArticleLog('<xsl:value-of select="$SERVICE_ID"
                    />');</xsl:if></xsl:attribute>
                <xsl:value-of select="$LABEL"/>
            </a>
        </xsl:if>
    </xsl:template>
    <!-- Invisible Image To Update Log File -->
    <xsl:template name="UpdateLog">
        <xsl:if test="$control_info/SCIELO_INFO/SERVER_LOG!=''">
            <img>
                <xsl:attribute name="src">http://<xsl:value-of
                        select="$control_info/SCIELO_INFO/SERVER_LOG"/>/<xsl:value-of
                        select="$control_info/SCIELO_INFO/SCRIPT_LOG_NAME"/>?app=<xsl:value-of
                        select="normalize-space($control_info/APP_NAME)"/>&amp;page=<xsl:value-of
                        select="$control_info/PAGE_NAME"/>&amp;<xsl:if test="$control_info/PAGE_PID"
                            >pid=<xsl:value-of select="$control_info/PAGE_PID"
                        />&amp;</xsl:if>lang=<xsl:value-of
                        select="normalize-space($control_info/LANGUAGE)"/>&amp;norm=<xsl:value-of
                        select="normalize-space($control_info/STANDARD)"
                        />&amp;doctopic=<xsl:value-of select="//ARTICLE/@DOCTOPIC"
                        />&amp;doctype=<xsl:value-of select="//ARTICLE/@DOCTYPE"/><xsl:if
                        test="$langtext">&amp;tlng=<xsl:value-of select="normalize-space($langtext)"
                        /></xsl:if></xsl:attribute>
                <xsl:attribute name="border">0</xsl:attribute>
                <xsl:attribute name="height">1</xsl:attribute>
                <xsl:attribute name="width">1</xsl:attribute>
            </img>
        </xsl:if>

        <!-- Piwik -->
        <xsl:if test="//show_piwik = '1'">
            <script type="text/javascript">
              var _paq = _paq || [];
              _paq.push(["setDocumentTitle", document.domain + "/" + document.title]);
              _paq.push(["setCookieDomain", "*.www.scielo.br"]);
              _paq.push(['trackPageView']);
              _paq.push(['enableLinkTracking']);
              (function() {
                var u="//webanalytics.scielo.org/";
                _paq.push(['setTrackerUrl', u+'piwik.php']);
                _paq.push(['setSiteId', 2]);
                var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
                g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
              })();
            </script>
            <noscript><p><img src="//webanalytics.scielo.org/piwik.php?idsite=2" style="border:0;" alt="" /></p></noscript>
        </xsl:if>
        <!-- End Piwik Code -->

        <!-- to use Google Analytics -->
        <xsl:if test="//varScieloOrg/GOOGLE_CODE != ''">
            <script type="text/javascript">
              var _gaq = _gaq || [];
              _gaq.push(['_setAccount', '<xsl:value-of select="//varScieloOrg/GOOGLE_CODE"/>']);
              _gaq.push(['_trackPageview']);
              _gaq.push(['_setSampleRate', '<xsl:value-of select="//varScieloOrg/GOOGLE_SAMPLE_RATE"/>']);

              (function() {
                var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
              })();

            </script>
        </xsl:if>
        <xsl:if test="//varScieloOrg/PINGDOM_CODE != ''">
            <script>
                var _prum = [['id', '<xsl:value-of select="//varScieloOrg/PINGDOM_CODE"/>'],
                        ['mark', 'firstbyte', (new Date()).getTime()]];
                (function() {
                        var s = document.getElementsByTagName('script')[0]
                        , p = document.createElement('script');
                        p.async = 'async';
                        p.src = '//rum-static.pingdom.net/prum.min.js';
                        s.parentNode.insertBefore(p, s);
                })();
            </script>
        </xsl:if>
        <xsl:if test="//show_flacso_survey = '1'">
            <script type="text/javascript">
            $(document).ready(function() {
                var lng;
                var browserlanguage = (navigator.language || navigator.systemLanguage || navigator.userLanguage || 'en').substr(0, 2).toLowerCase();
                var expected_languages = Array('pt', 'es', 'en');
                if ( $.inArray(browserlanguage, expected_languages) != -1 ){
                    lng = browserlanguage;
                }else if ('<xsl:value-of select="//tlng" />' in expected_languages){
                    lng = '<xsl:value-of select="//tlng" />';
                }else{
                    lng = '<xsl:value-of select="//lng" />';
               }

               var options = {
                   language: lng, // en|es|pt
                   popup_absolute_path: '/popup/', // change to absolute path where you've placed this code
                   get_ip_path: '/popup/whatismyip.php'
                }

                $.getScript(options.popup_absolute_path + 'jquery-1.9.1.min.js', function() {
                    // Assign the last inserted JQuery version to a new variable, to avoid
                    // conflicts with the current version in $ variable.
                    options.jQuery = $;
                    $.getScript(options.popup_absolute_path + 'pkp_flacso_popup.v2.js', function() {
                        pkp_flacso_popup(options);
                        jQuery.noConflict(true);
                    });
                });
            });
            </script>
        </xsl:if>
    </xsl:template>
    <xsl:template name="ImageLogo">
        <xsl:param name="src"/>
        <xsl:param name="alt"/>
        <img>
            <xsl:attribute name="src">
                <xsl:value-of select="$src"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:value-of select="$alt"/>
            </xsl:attribute>
            <xsl:attribute name="border">0</xsl:attribute>
        </img>
    </xsl:template>
    <xsl:template name="COPYRIGHTSCIELO">
        <xsl:apply-templates select="." mode="license"/>
        <center>
            <i>
                <font color="#000080">
                    <xsl:choose>
                        <xsl:when test="OWNER-FULLNAME">
                            <xsl:value-of select="OWNER-FULLNAME"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="OWNER"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </font>
                <br/>
            </i>
            <img>
                <xsl:attribute name="src"><xsl:value-of select="//PATH_GENIMG"/><xsl:value-of
                        select="normalize-space($control_info/LANGUAGE)"
                    />/e-mailt.gif</xsl:attribute>
                <xsl:attribute name="alt"><xsl:value-of select="CONTACT"/></xsl:attribute>
                <xsl:attribute name="border">0</xsl:attribute>
            </img>
            <br/>
            <xsl:call-template name="UpdateLog"/>
            <a class="email">
                <xsl:attribute name="href">mailto:<xsl:value-of select="CONTACT"/></xsl:attribute>
                <xsl:value-of select="CONTACT"/>
            </a>
        </center>
    </xsl:template>
    <!-- Adds a link to a SciELO Log page 
     Parameters: pid - PID
                 script - Name of the script to be called -->
    <xsl:template name="AddScieloLogLink">
        <xsl:param name="pid"/>
        <xsl:param name="script"/>
        <xsl:param name="order"/>
        <xsl:param name="dti"/>
        <xsl:param name="dtf"/>
        <xsl:param name="access"/>
        <xsl:param name="cpage"/>
        <xsl:param name="nlines"/>
        <xsl:param name="tpages"/>
        <xsl:param name="maccess"/>
        <xsl:param name="app"/>
        <xsl:param name="server"/>
        <xsl:attribute name="href">http://<xsl:value-of
                select="$control_info/SCIELO_INFO/SERVER_LOG_PROC"/>/<xsl:value-of
                select="$control_info/SCIELO_INFO/SERVER_LOG_PROC_PATH"
                />/scielolog.php?script=<xsl:value-of select="$script"/>&amp;lng=<xsl:value-of
                select="normalize-space($control_info/LANGUAGE)"/>&amp;nrm=<xsl:value-of
                select="normalize-space($control_info/STANDARD)"/><xsl:if test="$pid"
                    >&amp;pid=<xsl:value-of select="$pid"/></xsl:if><xsl:if test="$order"
                    >&amp;order=<xsl:value-of select="$order"/></xsl:if><xsl:if test="$dti"
                    >&amp;dti=<xsl:value-of select="$dti"/></xsl:if><xsl:if test="$dtf"
                    >&amp;dtf=<xsl:value-of select="$dtf"/></xsl:if><xsl:if test="$access"
                    >&amp;access=<xsl:value-of select="$access"/></xsl:if><xsl:if test="$cpage"
                    >&amp;cpage=<xsl:value-of select="$cpage"/></xsl:if><xsl:if test="$nlines"
                    >&amp;nlines=<xsl:value-of select="$nlines"/></xsl:if><xsl:if test="$tpages"
                    >&amp;tpages=<xsl:value-of select="$tpages"/></xsl:if><xsl:if test="$maccess"
                    >&amp;maccess=<xsl:value-of select="$maccess"/></xsl:if><xsl:if test="$app"
                    >&amp;app=<xsl:value-of select="$app"/></xsl:if><xsl:if test="$server"
                    >&amp;server=<xsl:value-of select="$server"/></xsl:if></xsl:attribute>
    </xsl:template>
    <!-- Prints message with the log start date (count started at..) 
     Parameters: date - log start date
-->
    <xsl:template name="PrintLogStartDate">
        <xsl:param name="date"/> * &#160;<xsl:value-of
            select="$translations/xslid[@id='sci_common']/text[@find = 'count_started_in']"/>:
            <xsl:call-template name="ShowDate">
            <xsl:with-param name="DATEISO" select="$date"/>
            <xsl:with-param name="LANG">
                <xsl:value-of select="$control_info/LANGUAGE"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <!-- Inserts javascript code in header
-->
    <xsl:template name="SetLogJavascriptCode">
        <script>
            <xsl:attribute name="language">JavaScript</xsl:attribute>
            <xsl:attribute name="src">stat.js</xsl:attribute>
        </script>
    </xsl:template>
    <!-- Generates the main_form Form
    Parameters:
        script - php script to be called
        pid    - issn
-->
    <xsl:template name="GenerateLogForm">
        <xsl:param name="script"/>
        <xsl:param name="pid"/>
        <xsl:attribute name="name">main_form</xsl:attribute>
        <xsl:attribute name="action">http://<xsl:value-of select="$control_info/SCIELO_INFO/SERVER"
                /><xsl:value-of select="$control_info/SCIELO_INFO/PATH_DATA"
            />scielolog.php</xsl:attribute>
        <xsl:attribute name="method">GET</xsl:attribute>
        <xsl:attribute name="onSubmit">return validate();</xsl:attribute>
        <input type="hidden" name="script">
            <xsl:attribute name="value">
                <xsl:value-of select="$script"/>
            </xsl:attribute>
        </input>
        <input type="hidden" name="pid">
            <xsl:attribute name="value">
                <xsl:value-of select="$pid"/>
            </xsl:attribute>
        </input>
        <input type="hidden" name="lng">
            <xsl:attribute name="value">
                <xsl:value-of select="$control_info/LANGUAGE"/>
            </xsl:attribute>
        </input>
        <input type="hidden" name="nrm">
            <xsl:attribute name="value">
                <xsl:value-of select="$control_info/STANDARD"/>
            </xsl:attribute>
        </input>
        <input type="hidden" name="order">
            <xsl:attribute name="value">
                <xsl:value-of select="//STATPARAM/FILTER/ORDER"/>
            </xsl:attribute>
        </input>
        <input type="hidden" name="dti">
            <xsl:attribute name="value">
                <xsl:value-of select="//STATPARAM/FILTER/INITIAL_DATE"/>
            </xsl:attribute>
        </input>
        <input type="hidden" name="dtf">
            <xsl:attribute name="value">
                <xsl:value-of select="//STATPARAM/FILTER/FINAL_DATE"/>
            </xsl:attribute>
        </input>
    </xsl:template>
    <!-- Prints the Date Selection TextBoxes
-->
    <xsl:template name="PrintDateRangeSelection">
        <script language="javascript">
            <xsl:comment>
      setLanguage('<xsl:value-of select="normalize-space($control_info/LANGUAGE)"/>');
      setStartDate('<xsl:value-of select="normalize-space(//STATPARAM/START_DATE)"/>');
      setLastDate('<xsl:value-of select="normalize-space(//STATPARAM/CURRENT_DATE)"/>')

      CreateForm('<xsl:value-of select="//STATPARAM/FILTER/INITIAL_DATE"/>', '<xsl:value-of select="//STATPARAM/FILTER/FINAL_DATE"/>');
    // </xsl:comment>
        </script>
    </xsl:template>
    <!-- Prints the submit button (reload button)
-->
    <xsl:template name="PutSubmitButton">
        <input type="submit" value="{$translations/xslid[@id='sci_common']/text[@find = 'reload']}"
        />
    </xsl:template>
    <!-- Shows empty query message -->
    <xsl:template name="ShowEmptyQueryResult">
        <hr/>
        <p>
            <center>
                <font color="blue">
                    <xsl:value-of
                        select="$translations/xslid[@id='sci_common']/text[@find = 'there_are_no_statistics_forthat_period']"
                    />
                </font>
            </center>
        </p>
        <hr/>
    </xsl:template>
    <xsl:template match="LANGUAGES">
        <xsl:param name="LANG" select="$control_info/LANGUAGE"/>
        <xsl:param name="PID"/>
        <xsl:param name="VERIFY"/>
        <div align="left"> &#160;&#160;&#160; <xsl:apply-templates select="*[LANG]">
                <xsl:with-param name="LANG" select="$LANG"/>
                <xsl:with-param name="PID" select="$PID"/>
            </xsl:apply-templates>
            <xsl:if test="$VERIFY"> &#160;&#160;&#160;&#160; <xsl:call-template
                    name="CREATE_VERIFY_LINK">
                    <xsl:with-param name="PID" select="$PID"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="../EMBARGO/@text='no'"> &#160;&#160;&#160;&#160;<font face="Symbol"
                    color="#000080">&#183; </font>
                <xsl:apply-templates select="../EMBARGO/@date">
                    <xsl:with-param name="lang" select="$interfaceLang"/>
                </xsl:apply-templates>
            </xsl:if>
            <xsl:if test="$journal_manager=1">
                <span id="{concat('pr_',$PID)}" style="display: none;"/>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="LANGUAGES/*">
        <xsl:param name="LANG"/>
        <xsl:param name="PID"/>
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="contains(name(),'ABSTRACT')">abstract</xsl:when>
                <xsl:when test="contains(name(),'ART_TEXT')">full</xsl:when>
                <xsl:when test="contains(name(),'PDF')">pdf</xsl:when>
                <xsl:when test="contains(name(),'PRESS')">pr</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->
        <xsl:choose>
            <xsl:when test="$journal_manager=1">
                <xsl:if test="$type != 'pr'"> &#160;&#160;&#160;&#160;<font face="Symbol"
                    color="#000080">&#183; </font>
                    <xsl:apply-templates select="LANG[.=$LANG]" mode="issuetoc">
                        <xsl:with-param name="LANG" select="$LANG"/>
                        <xsl:with-param name="PID" select="$PID"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="LANG[.!=$LANG]" mode="issuetoc">
                        <xsl:with-param name="LANG" select="$LANG"/>
                        <xsl:with-param name="PID" select="$PID"/>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="CONTINUATION" select="(LANG[.=$LANG]!='')"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                &#160;&#160;&#160;&#160;<font face="Symbol"
                    color="#000080">&#183; </font>
                <xsl:apply-templates select="LANG[.=$LANG]" mode="issuetoc">
                    <xsl:with-param name="LANG" select="$LANG"/>
                    <xsl:with-param name="PID" select="$PID"/>
                    <xsl:with-param name="type" select="$type"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="LANG[.!=$LANG]" mode="issuetoc">
                    <xsl:with-param name="LANG" select="$LANG"/>
                    <xsl:with-param name="PID" select="$PID"/>
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="CONTINUATION" select="(LANG[.=$LANG]!='')"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <xsl:template match="LANG" mode="issuetoc">
        <xsl:param name="LANG"/>
        <xsl:param name="PID"/>
        <xsl:param name="type"/>
        <!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->
        <xsl:param name="CONTINUATION"/>
        <xsl:if test="$CONTINUATION or (not($CONTINUATION) and position()>1)"> |</xsl:if>
        <xsl:call-template name="CREATE_ARTICLE_LINK">
            <xsl:with-param name="TYPE" select="$type"/>
            <xsl:with-param name="INTLANG" select="$LANG"/>
            <xsl:with-param name="TXTLANG" select="text()"/>
            <xsl:with-param name="PID">
                <xsl:choose>
                    <xsl:when test="@pid">
                        <xsl:value-of select="@pid"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$PID"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="FIRST_LABEL">
                <xsl:choose>
                    <xsl:when test="$CONTINUATION">0</xsl:when>
                    <xsl:when test="not($CONTINUATION) and position()>1">0</xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="file" select="@xml"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="CREATE_VERIFY_LINK">
        <xsl:param name="PID"/>
        <font face="Symbol" color="#800000">Ñ </font>
        <a>
            <xsl:attribute name="href">http://<xsl:value-of
                    select="$control_info/SCIELO_INFO/SERVER"/><xsl:value-of
                    select="$control_info/SCIELO_INFO/PATH_DATA"
                    />scielo.php?script=sci_verify&amp;pid=<xsl:value-of select="$PID"
                /></xsl:attribute>see mst o/h/f records</a>
    </xsl:template>
    <!-- Prints Information about authors, title and strip 
   Parameters:
             NORM - (abn | iso | van)
             LANG - language code
          LINK = 1 - prints authors with link
          SHORTTITLE - Opcional
-->
    <xsl:template name="PrintArticleInformationArea">
        <xsl:param name="LATTES"/>
        <table width="100%" border="0">
            <tr align="right">
                <td>
                    <table>
                        <xsl:apply-templates select="$LATTES"/>
                        <xsl:call-template name="PrintArticleInformationLink"/>
                    </table>
                </td>
            </tr>
        </table>
    </xsl:template>
    <xsl:template match="AUTHOR" mode="LATTES"> InsertAuthor("<xsl:value-of select="."/>",
            "<xsl:value-of select="@HREF"/>"); </xsl:template>
    <xsl:template name="PrintArticleInformationLink">
        <xsl:variable name="PATH_GENIMG" select="$control_info/SCIELO_INFO/PATH_GENIMG"/>

        <xsl:variable name="LANGUAGE" select="$control_info/LANGUAGE"/>
        <xsl:variable name="textLang">
            <xsl:choose>
                <xsl:when test="$control_info[PAGE_NAME='sci_arttext']">
                    <xsl:value-of select="//ARTICLE/@TEXTLANG"/>
                </xsl:when>
                <xsl:when test="$control_info[PAGE_NAME='sci_abstract']">
                    <xsl:variable name="abstractLang" select=".//ABSTRACT/@xml:lang"/>
                    <xsl:if
                        test="//ART_TEXT_LANGS[LANG=$abstractLang] or //PDF_LANGS[LANG=$abstractLang]">
                        <xsl:value-of select="$abstractLang"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="tlng">
            <xsl:value-of select="normalize-space($textLang)"/>
        </xsl:variable>
        <xsl:variable name="INFOPAGE">http://<xsl:value-of select="$control_info/SCIELO_INFO/SERVER"/>
            <xsl:value-of select="$control_info/SCIELO_INFO/PATH_DATA"
                />scielo.php?script=sci_isoref&amp;pid=<xsl:value-of select="$control_info/PAGE_PID"
                />&amp;lng=<xsl:value-of select="$LANGUAGE"/>
            <xsl:if test="string-length($tlng)&gt;0">&amp;tlng=<xsl:value-of select="$tlng"/>
            </xsl:if>
        </xsl:variable>
        <td valign="middle">
            <a href="javascript:void(0);" onmouseout="status='';" class="nomodel"
                style="text-decoration: none;">
                <xsl:attribute name="onclick">OpenArticleInfoWindow ( 780, 450, "<xsl:value-of
                        select="$INFOPAGE"/>"); <xsl:if test="$service_log  = 1"
                        >callUpdateArticleLog('como_citar_este_artigo');</xsl:if></xsl:attribute>
                <xsl:attribute name="rel">nofollow</xsl:attribute>
                <xsl:attribute name="onmouseover"> status='<xsl:call-template
                        name="PrintArticleInformationLabel"><xsl:with-param name="LANGUAGE"
                            select="$LANGUAGE"/></xsl:call-template>'; return true; </xsl:attribute>
                <img border="0" align="middle" src="{$PATH_GENIMG}{$LANGUAGE}/fulltxt.gif"/>
            </a>
        </td>
        <td>
            <a href="javascript:void(0);" onmouseout="status='';" class="nomodel"
                style="text-decoration: none;">
                <xsl:attribute name="onclick">OpenArticleInfoWindow ( 780, 450, "<xsl:value-of
                        select="$INFOPAGE"/>");<xsl:if test="$service_log = 1"
                        >callUpdateArticleLog('como_citar_este_artigo');</xsl:if></xsl:attribute>
                <xsl:attribute name="rel">nofollow</xsl:attribute>
                <xsl:attribute name="onmouseover"> status='<xsl:call-template
                        name="PrintArticleInformationLabel"><xsl:with-param name="LANGUAGE"
                            select="$LANGUAGE"/></xsl:call-template>'; return true; </xsl:attribute>
                <xsl:call-template name="PrintArticleInformationLabel">
                    <xsl:with-param name="LANGUAGE" select="$LANGUAGE"/>
                </xsl:call-template>
            </a>
        </td>
    </xsl:template>
    <xsl:template name="PrintArticleInformationLabel">
        <xsl:param name="LANGUAGE"/>
        <xsl:value-of
            select="$translations/xslid[@id='sci_common']/text[@find = 'how_to_cite_this_article']"
        />
    </xsl:template>
    <xsl:template match="@DOI" mode="number">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="@DOI" mode="display"> http://dx.doi.org/<xsl:value-of
            select="translate(.,' ','')"/>
    </xsl:template>

    <!--

tem esses dois templates "vazios" para nao aparecer o conteudo nos rodapes . . .

-->
    <xsl:template match="SCIELO_REGIONAL_DOMAIN"/>
    <xsl:template match="USERINFO"/>
    <xsl:template match="fulltext-service-list"/>
    <xsl:template match="EMBARGO/@date">
        <xsl:param name="lang"/>
        <xsl:value-of
            select="$translations/xslid[@id='sci_common']/text[@find = 'text_available_after']"
        />&#160; <xsl:call-template name="ShowDate">
            <xsl:with-param name="DATEISO" select="."/>
            <xsl:with-param name="LANG" select="$lang"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="*" mode="license">
        <xsl:comment>mode=license</xsl:comment>
        <xsl:if test="../..//LICENSE='cc' or .//LICENSE='cc'">
            <xsl:choose>
                <xsl:when test="$ARTICLE_LICENSE">
                    <xsl:comment>ARTICLE_LICENSE</xsl:comment>
                    <xsl:apply-templates select="$ARTICLE_LICENSE"/>
                </xsl:when>
                <xsl:when test="$GENERAL_LICENSE">
                    <xsl:comment>GENERAL_LICENSE</xsl:comment>
                    <xsl:apply-templates select="$GENERAL_LICENSE"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="PERMISSIONS/permissions">
        <xsl:apply-templates select="." mode="permissions-disclaimer"/>
    </xsl:template>
    
    <xsl:template match="*" mode="license-disclaimer">
        <xsl:param name="lang"/>
        <xsl:param name="license_href_with_lang"/>
        <xsl:param name="object"/>
        <xsl:comment><xsl:value-of select="$object"/></xsl:comment>
        <xsl:choose>
            <xsl:when test="$object='journal' or $object='issue'">
                <xsl:choose>
                    <xsl:when test="$lang='es'">Todo el contenido de esta revista, excepto dónde está identificado, está bajo una </xsl:when>
                    <xsl:when test="$lang='pt'">Todo o conteúdo deste periódico, exceto onde está identificado, está licenciado sob uma </xsl:when>
                    <xsl:otherwise>All the contents of this journal, except where otherwise noted, is licensed under a </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$object='article'">
                <xsl:choose>
                    <xsl:when test="$lang='es'">Todo el contenido de este artículo, excepto dónde está identificado, está bajo una </xsl:when>
                    <xsl:when test="$lang='pt'">Todo o conteúdo deste artigo, exceto onde está identificado, está licenciado sob uma </xsl:when>
                    <xsl:otherwise>All the contents of this article, except where otherwise noted, is licensed under a </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$object='site'">
                <xsl:choose>
                    <xsl:when test="$control_info/SCIELO_INFO/SERVER!=''">
                        <xsl:choose>
                            <xsl:when test="$lang='es'">Todo el contenido de <xsl:value-of select="$control_info/SCIELO_INFO/SERVER"/>, excepto dónde está identificado, está bajo una </xsl:when>
                            <xsl:when test="$lang='pt'">Todo o conteúdo de <xsl:value-of select="$control_info/SCIELO_INFO/SERVER"/>, exceto onde está identificado, está licenciado sob uma </xsl:when>
                            <xsl:otherwise>All the contents of <xsl:value-of select="$control_info/SCIELO_INFO/SERVER"/>, except where otherwise noted, is licensed under a </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$lang='es'">Todo el contenido de este sitio, excepto dónde está identificado, está bajo una </xsl:when>
                            <xsl:when test="$lang='pt'">Todo o conteúdo deste Website, exceto onde está identificado, está licenciado sob uma </xsl:when>
                            <xsl:otherwise>All the contents of this Website, except where otherwise noted, is licensed under a </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>            
        </xsl:choose>
        
        <a href="{$license_href_with_lang}">
            <xsl:choose>
                <xsl:when test="$lang='es'">Licencia Creative Commons</xsl:when>
                <xsl:when test="$lang='pt'">Licença Creative Commons</xsl:when>
                <xsl:otherwise>Creative Commons Attribution License</xsl:otherwise>
            </xsl:choose>
        </a>
    </xsl:template>
    
    <xsl:template match="permissions" mode="permissions-disclaimer">
        <xsl:variable name="object"><xsl:choose>
            <xsl:when test="../@source"><xsl:value-of select="../@source"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="name(../node())"/></xsl:otherwise>
        </xsl:choose></xsl:variable>
        
        <xsl:if test="copyright-statement or (copyright-year and copyright-holder)">
            <div class="copyright">
                <xsl:apply-templates select="copyright-statement" mode="permissions-disclaimer"/>
                <xsl:if test="not(copyright-statement) and copyright-holder and copyright-holder">
                    <xsl:apply-templates select="copyright-year" mode="permissions-disclaimer"/>
                    <xsl:apply-templates select="copyright-holder" mode="permissions-disclaimer"/>
                </xsl:if>
            </div>
        </xsl:if>
        <div class="license">
            <xsl:choose>
                <xsl:when test="license[@xml:lang=$articleLang]">
                    <xsl:apply-templates select="license[@xml:lang=$articleLang]" mode="permissions-disclaimer">
                        <xsl:with-param name="lang" select="$articleLang"/>
                        <xsl:with-param name="object" select="$object"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="license[@xml:lang=$interfaceLang]">
                    <xsl:apply-templates select="license[@xml:lang=$interfaceLang]" mode="permissions-disclaimer">
                        <xsl:with-param name="lang" select="$interfaceLang"/>
                        <xsl:with-param name="object" select="$object"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="license[@xml:lang='en']">
                    <xsl:apply-templates select="license[@xml:lang='en']" mode="permissions-disclaimer">
                        <xsl:with-param name="lang" select="'en'"/>
                        <xsl:with-param name="object" select="$object"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="license[1]" mode="permissions-disclaimer">
                        <xsl:with-param name="lang" select="$interfaceLang"/>
                        <xsl:with-param name="object" select="$object"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <xsl:template match="permissions/license" mode="permissions-disclaimer">
        <xsl:param name="lang"/>
        <xsl:param name="object"/>
        <xsl:variable name="license_href"><xsl:choose>
            <xsl:when test="contains(@xlink:href,'://creativecommons.org/licenses/')"><xsl:value-of select="@xlink:href"/></xsl:when>
            <xsl:when test="contains(@href,'://creativecommons.org/licenses/')"><xsl:value-of select="@href"/></xsl:when>
            <xsl:when test="@href"><xsl:value-of select="@href"/></xsl:when>
            <xsl:when test="@xlink:href"><xsl:value-of select="@xlink:href"/></xsl:when>
            <xsl:otherwise>invalid</xsl:otherwise>
        </xsl:choose></xsl:variable>
        <xsl:if test="$license_href='invalid'">
            <xsl:comment>url de license eh invalida</xsl:comment>
            <xsl:comment><xsl:value-of select="@xlink:href"/></xsl:comment>
            <xsl:comment><xsl:value-of select="@href"/></xsl:comment>
        </xsl:if>
        
        <xsl:if test="$license_href!='invalid'">
            <xsl:variable name="main_license_href"><xsl:choose><xsl:when test="contains($license_href,'/deed')"><xsl:value-of select="substring-before($license_href,'/deed')"/></xsl:when>
                <xsl:when test="substring($license_href,string-length($license_href))='/'"><xsl:value-of select="substring($license_href,1,string-length($license_href)-1)"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$license_href"/></xsl:otherwise>
            </xsl:choose></xsl:variable>
            <xsl:variable name="license_img_src"><xsl:choose>
                <xsl:when test=".//graphic/@xlink:href"><xsl:value-of select=".//graphic/@xlink:href"/></xsl:when>
                <xsl:when test=".//img/@src"><xsl:value-of select=".//img/@src"/></xsl:when>
                <xsl:when test="contains($license_href,'://creativecommons.org/licenses/')">http://i.creativecommons.org/l<xsl:value-of select="substring-after($main_license_href,'licenses')"/>/80x15.png</xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose></xsl:variable>
            <xsl:variable name="license_href_with_lang"><xsl:value-of select="$main_license_href"/><xsl:if test="$lang!='' and contains($main_license_href,'://creativecommons.org/licenses/')">/deed.<xsl:value-of select="$lang"/></xsl:if></xsl:variable>
            <xsl:if test="$license_href_with_lang!=''">
                <p>
                    <xsl:if test="$license_img_src!=''">
                        <a rel="license" href="{$license_href_with_lang}">
                            <img src="{$license_img_src}" alt="Creative Commons License" style="border-width:0"/>
                        </a>
                        <xsl:text>&#160;</xsl:text>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="license-p[not(.//a)] and $license_img_src=''">
                            <a rel="license" href="{$license_href_with_lang}">
                                <xsl:apply-templates select="license-p" mode="license-disclaimer"/>
                            </a>
                        </xsl:when>
                        <xsl:when test="license-p">
                            <xsl:apply-templates select="license-p" mode="license-disclaimer"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="." mode="license-disclaimer">
                                <xsl:with-param name="license_href_with_lang" select="$license_href_with_lang"/>
                                <xsl:with-param name="lang" select="$lang"/>
                                <xsl:with-param name="object" select="$object"/>
                            </xsl:apply-templates>
                        </xsl:otherwise>
                    </xsl:choose>
                </p> 
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="license-p" mode="license-disclaimer">
        <xsl:apply-templates select="*|text()"/>
    </xsl:template>
    <xsl:template match="*" mode="footer-journal">
        <xsl:choose>
            <xsl:when test="../..//LICENSE='cc' or .//LICENSE='cc'">
                <xsl:comment>cc</xsl:comment>
                <xsl:apply-templates select="." mode="license"/>
                <div class="footer">
                <xsl:apply-templates select=".//CONTACT"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>COPYRIGHT</xsl:comment>
                <div class="footer">
                <xsl:apply-templates select=".//COPYRIGHT"/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*" mode="repo_url_param_scielo"/>
    <xsl:template match="*" mode="issuetoc">sci_issuetoc<xsl:value-of select="//NAVEGATION_TYPE"/>
    </xsl:template>
    <xsl:template match="*" mode="issues">sci_issues<xsl:value-of select="//NAVEGATION_TYPE"/>
    </xsl:template>
    <xsl:template match="*" mode="sci_serial">
        <xsl:choose>
            <xsl:when test="$control_info/NO_SCI_SERIAL='yes'">sci_artlist</xsl:when>
            <xsl:otherwise>sci_serial</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*" mode="repo_database">
        <xsl:param name="scope"/>
        <xsl:choose>
            <xsl:when test="//PAGINATION">
                <xsl:apply-templates select="//PAGINATION/@rep" mode="rep3"/>
                <xsl:if test="//PAGINATION/@journal=//ISSN_AS_ID">
                    <xsl:value-of select="$scope"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$scope"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@rep" mode="rep3">r<xsl:value-of select="substring(.,4)"/>
    </xsl:template>
    <xsl:template match="*" mode="repo_limit">
        <xsl:choose>
            <xsl:when test="//PAGINATION">
                <xsl:choose>
                    <xsl:when test="//PAGINATION/@rep and //PAGINATION/@journal">
                        <xsl:value-of select="//PAGINATION/@journal"/> and rep=<xsl:value-of
                            select="//PAGINATION/@rep"/>
                    </xsl:when>
                    <xsl:when test="//PAGINATION/@rep">rep=<xsl:value-of select="//PAGINATION/@rep"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="//PAGINATION/@journal"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="//ISSN_AS_ID"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*" mode="repo_url_param">
        <xsl:apply-templates select="//PAGINATION/@rep" mode="repo_url_param"/>
    </xsl:template>
    <xsl:template match="@rep" mode="repo_url_param">&amp;rep=<xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="*" mode="repo_url_param_scielo">
        <xsl:apply-templates select="//PAGINATION/@*" mode="repo_url_param_scielo"/>
    </xsl:template>
    <xsl:template match="@*" mode="repo_url_param_scielo">&amp;<xsl:value-of select="name()"
            />=<xsl:value-of select="."/>
    </xsl:template>
    <xsl:template name="HeadStatJournal">
        <HEAD>
            <META http-equiv="Pragma" content="no-cache"/>
            <META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT"/>
            <TITLE>
                <xsl:choose>
                    <xsl:when test="//TITLEGROUP">
                        <xsl:value-of select="//TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"
                        /> - <xsl:value-of
                            select="$translations/xslid[@id='sci_statcommon']/text[@find='most_visited']"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="$translations/xslid[@id='sci_statcommon']/text[@find='most_visited']"
                        />
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='issue']"
                />
            </TITLE>
            <style type="text/css">
                a{
                    text-decoration:none;
                }
                a.email{
                    text-decoration:underline;
                }
                a.issue{
                    text-decoration:underline;
                }
                a.page{
                    text-decoration:underline;
                }
                a.page:visited{
                    color:blue;
                }</style>
            <xsl:call-template name="SetLogJavascriptCode"/>
        </HEAD>
    </xsl:template>
    <xsl:template name="FormStatJournal">
        <xsl:param name="table_perc"/>
        <TABLE cellpadding="0" cellspacing="0" width="100%">
            <TR>
                <TD width="20%">
                    <P align="center">
                        <A>
                            <xsl:choose>
                                <xsl:when test="//TITLEGROUP">
                                    <xsl:call-template name="AddScieloLink">
                                        <xsl:with-param name="seq" select="ISSN_AS_ID"/>
                                        <xsl:with-param name="script">sci_serial</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="AddScieloLink">
                                        <xsl:with-param name="script">sci_home</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                            <IMG border="0">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$control_info/SCIELO_INFO/PATH_SERIMG"/>
                                    <xsl:choose>
                                        <xsl:when test="//TITLEGROUP"><xsl:value-of
                                                select="//TITLEGROUP/SIGLUM"/>/plogo.gif</xsl:when>
                                        <xsl:otherwise>fbpelogp.gif</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:choose>
                                        <xsl:when test="//TITLEGROUP">
                                            <xsl:value-of select="//TITLEGROUP/SHORTTITLE "/>
                                        </xsl:when>
                                        <xsl:otherwise>Scientific Electronic Library
                                            Online</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </IMG>
                        </A>
                    </P>
                </TD>
                <TD align="center" width="80%">
                    <BLOCKQUOTE>
                        <P align="left">
                            <xsl:call-template name="PAGETITLE">
                                <xsl:with-param name="text">
                                    <xsl:choose>
                                        <xsl:when test="//TITLEGROUP">
                                            <xsl:value-of select="//TITLEGROUP/TITLE "
                                                disable-output-escaping="yes"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="$translations/xslid[@id='sci_statcommon']/text[@find='library_collection']"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:apply-templates select="TITLE_ISSN"/>
                            <xsl:comment>AQUI ISSN</xsl:comment>
                        </P>
                    </BLOCKQUOTE>
                </TD>
            </TR>
            <TR>
                <TD/>
                <TD>
                    <BLOCKQUOTE>
                        <FONT face="Verdana" size="2" color="#800000">
                            <xsl:value-of
                                select="$translations/xslid[@id='sci_statcommon']/text[@find='most_visited_issue']"
                            />
                        </FONT>
                        <BR/>
                        <P>
                            <FONT face="Verdana" size="2">
                                <xsl:copy-of
                                    select="$translations/xslid[@id='sci_statcommon']/text[@find='sentence1']"
                                />
                            </FONT>
                        </P>
                    </BLOCKQUOTE>
                </TD>
            </TR>
        </TABLE>
        <TABLE border="0" align="center" cellpadding="2" cellspacing="2">
            <xsl:attribute name="width">
                <xsl:value-of select="$table_perc"/>
            </xsl:attribute>
            <TR>
                <xsl:attribute name="width">
                    <xsl:value-of select="$table_perc"/>
                </xsl:attribute>
                <TD align="left" colspan="2">
                    <xsl:attribute name="width">
                        <xsl:value-of select="$table_perc"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="STATPARAM"/>
                </TD>
            </TR>
        </TABLE>
        <TABLE border="0" align="center" cellpadding="2" cellspacing="2">
            <xsl:attribute name="width">
                <xsl:value-of select="$table_perc"/>
            </xsl:attribute>
            <TR>
                <xsl:attribute name="width">
                    <xsl:value-of select="$table_perc"/>
                </xsl:attribute>
                <TD align="left" colspan="2">
                    <xsl:attribute name="width">
                        <xsl:value-of select="$table_perc"/>
                    </xsl:attribute>
                    <BR/>
                    <xsl:call-template name="PrintLogForm"/>
                </TD>
            </TR>
        </TABLE>
    </xsl:template>
    <xsl:template name="PAGETITLE">
        <xsl:param name="text"/>
        <FONT face="Verdana" size="4" color="#000080">
            <xsl:value-of select="$text"/>
        </FONT>
        <BR/>
    </xsl:template>
    <xsl:template match="ISSN  | ISSUE_ISSN | TITLE_ISSN">
        <FONT color="#0000A0">
            <xsl:call-template name="GET_ISSN_TYPE">
                <xsl:with-param name="TYPE" select="@TYPE"/>
                <xsl:with-param name="LANG" select="$control_info/LANGUAGE"/>
            </xsl:call-template>&#160;ISSN </FONT>
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <xsl:template match="STATPARAM">
        <P>
            <FONT face="Verdana" size="2">
                <xsl:call-template name="PrintLogStartDate">
                    <xsl:with-param name="date" select="START_DATE"/>
                </xsl:call-template>. </FONT>
        </P>
    </xsl:template>
    <xsl:template name="PrintLogForm">
        <FONT face="Verdana" size="2">
            <xsl:call-template name="PrintDateRangeSelection"/>
        </FONT>
        <FORM>
            <xsl:call-template name="GenerateLogForm">
                <xsl:with-param name="script" select="$control_info/PAGE_NAME"/>
                <xsl:with-param name="pid" select="ISSN_AS_ID"/>
            </xsl:call-template>
            <xsl:apply-templates select="POSSIBLE_NO_ACCESS"/> &#160;&#160;&#160; <xsl:call-template
                name="PutSubmitButton"/>
        </FORM>
    </xsl:template>
    <xsl:template match="POSSIBLE_NO_ACCESS">
        <FONT face="Verdana" size="2">
            <xsl:value-of
                select="$translations/xslid[@id='sci_statcommon']/text[@find='display_issue_visited']"/>
            <SELECT NAME="access">
                <xsl:apply-templates select="OPTION"/>
                <OPTION>
                    <xsl:if
                        test="not(//STATPARAM/FILTER/NUM_ACCESS) or //STATPARAM/FILTER/NUM_ACCESS=1">
                        <xsl:attribute name="selected">1</xsl:attribute>
                    </xsl:if> 1</OPTION>
            </SELECT>
            <xsl:value-of
                select="$translations/xslid[@id='sci_statcommon']/text[@find='times_or_more']"/>.
        </FONT>
    </xsl:template>
    <xsl:template match="OPTION">
        <xsl:variable name="number" select="."/>
        <OPTION>
            <xsl:if test="//STATPARAM/FILTER/NUM_ACCESS=$number">
                <xsl:attribute name="selected">1</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="$number"/>
        </OPTION>
    </xsl:template>
    <!--
<xsl:template match="COPYRIGHT">
   <BR/>
   <br/>
   <xsl:call-template name="COPYRIGHTSCIELO">
       <xsl:with-param name="txtlang"/>
   </xsl:call-template>
</xsl:template>
-->
    <xsl:template match="QUERY_RESULT_PAGES">
        <xsl:param name="table_perc"/>
        <TABLE align="center" cellpadding="0" cellspacing="0">
            <xsl:attribute name="width">
                <xsl:value-of select="$table_perc"/>
            </xsl:attribute>
            <TR>
                <TD width="25%">
                    <B>
                        <xsl:if test="@TOTAL>1">
                            <FONT face="Arial" size="2">
                                <xsl:value-of
                                    select="$translations/xslid[@id='sci_statcommon']/text[@find='page']"/>
                                <xsl:value-of select="@CURRENT"/>
                                <xsl:value-of
                                    select="$translations/xslid[@id='sci_statcommon']/text[@find='of']"/>
                                <xsl:value-of select="@TOTAL"/>
                            </FONT>
                        </xsl:if>
                    </B>
                </TD>
                <TD align="right" width="75%">
                    <xsl:call-template name="ShowQueryResultPageLink"/>
                </TD>
            </TR>
        </TABLE>
    </xsl:template>
    <xsl:template name="ShowQueryResultPageLink">
        <FONT face="Arial" size="2"> [<xsl:choose>
                <xsl:when test="@CURRENT!=1">
                    <xsl:call-template name="LinkFirst"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="TextFirst"/>
                </xsl:otherwise>
            </xsl:choose>]&#160; [<xsl:choose>
                <xsl:when test="@CURRENT!=1">
                    <xsl:call-template name="LinkPrevious"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="TextPrevious"/>
                </xsl:otherwise>
            </xsl:choose>]&#160; [<xsl:choose>
                <xsl:when test="@CURRENT!=@TOTAL">
                    <xsl:call-template name="LinkNext"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="TextNext"/>
                </xsl:otherwise>
            </xsl:choose>]&#160; [<xsl:choose>
                <xsl:when test="@CURRENT!=@TOTAL">
                    <xsl:call-template name="LinkLast"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="TextLast"/>
                </xsl:otherwise>
            </xsl:choose>] </FONT>
    </xsl:template>
    <xsl:template name="LinkFirst">
        <A class="page">
            <xsl:call-template name="AddScieloLogLinkCall">
                <xsl:with-param name="page">1</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="TextFirst"/>
        </A>
    </xsl:template>
    <xsl:template name="TextFirst">
        <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='first']"/>
    </xsl:template>
    <xsl:template name="LinkPrevious">
        <A class="page">
            <xsl:call-template name="AddScieloLogLinkCall">
                <xsl:with-param name="page" select="@PREVIOUS"/>
            </xsl:call-template>
            <xsl:call-template name="TextPrevious"/>
        </A>
    </xsl:template>
    <xsl:template name="TextPrevious">
        <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='previous']"/>
    </xsl:template>
    <xsl:template name="LinkNext">
        <A class="page">
            <xsl:call-template name="AddScieloLogLinkCall">
                <xsl:with-param name="page" select="@NEXT"/>
            </xsl:call-template>
            <xsl:call-template name="TextNext"/>
        </A>
    </xsl:template>
    <xsl:template name="TextNext">
        <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='next']"/>
    </xsl:template>
    <xsl:template name="LinkLast">
        <A class="page">
            <xsl:call-template name="AddScieloLogLinkCall">
                <xsl:with-param name="page" select="@TOTAL"/>
            </xsl:call-template>
            <xsl:call-template name="TextLast"/>
        </A>
    </xsl:template>
    <xsl:template name="TextLast">
        <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='last']"/>
    </xsl:template>
    <xsl:template name="AddScieloLogLinkCall">
        <xsl:param name="page"/>
        <xsl:call-template name="AddScieloLogLink">
            <xsl:with-param name="script" select="$control_info/PAGE_NAME"/>
            <xsl:with-param name="dti" select="//STATPARAM/FILTER/INITIAL_DATE"/>
            <xsl:with-param name="dtf" select="//STATPARAM/FILTER/FINAL_DATE"/>
            <xsl:with-param name="access" select="//STATPARAM/FILTER/NUM_ACCESS"/>
            <xsl:with-param name="cpage" select="$page"/>
            <xsl:with-param name="nlines" select="@NLINES"/>
            <xsl:with-param name="tpages" select="@TOTAL"/>
            <xsl:with-param name="maccess" select="//POSSIBLE_NO_ACCESS/@MAX"/>
            <xsl:with-param name="pid" select="/STATISTICS/ISSN_AS_ID"/>
            <xsl:with-param name="app" select="$control_info/APP_NAME"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="AUTHOR" mode="AUTHORS_META">
        <xsl:element name="meta">
            <xsl:attribute name="name">citation_author</xsl:attribute>
            <xsl:attribute name="content">
                <xsl:apply-templates select="." mode="AUTHOR_META"/>
            </xsl:attribute>
        </xsl:element>
        <xsl:apply-templates select="AFF" mode="A"/>
    </xsl:template>

    <xsl:template match="AFF" mode="A">
        <xsl:variable name="affilid" select="@xref"/>
        <xsl:apply-templates select="../../../../AFF[@id=$affilid]" mode="B"/>
    </xsl:template>

    <xsl:template match="AFF" mode="B">
        <xsl:element name="meta">
            <xsl:attribute name="name">citation_author_institution</xsl:attribute>
            <xsl:attribute name="content">
                <xsl:apply-templates select="ORGNAME"/>
                <xsl:if test="CITY">, <xsl:apply-templates select="CITY"/></xsl:if>
                <xsl:if test="COUNTRY">, <xsl:apply-templates select="COUNTRY"/></xsl:if>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="AUTHOR" mode="AUTHOR_META">
        <xsl:apply-templates select=".//SURNAME"/>, <xsl:apply-templates select=".//NAME"/>
    </xsl:template>

    <xsl:template match="AUTHORS" mode="AUTHORS_META_DC">
        <xsl:apply-templates select=".//AUTHOR" mode="AUTHORS_META_DC"/>
    </xsl:template>

    <xsl:template match="AUTHOR" mode="AUTHORS_META_DC">
        <meta name="dc.Contributor" content="{concat(.//SURNAME, ', ', .//NAME)}"/>
    </xsl:template>

</xsl:stylesheet>
