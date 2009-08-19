<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="related_documents.xsl"/>
	<xsl:template name="tool_box">
		<xsl:variable name="show_requests" select="//varScieloOrg/requests" />
		<xsl:variable name="show_login" select="//varScieloOrg/show_login" />
		<xsl:variable name="show_send_by_email" select="//varScieloOrg/show_send_by_email" />
		<xsl:variable name="show_cited_scielo" select="//varScieloOrg/show_cited_scielo" />
		<xsl:variable name="show_cited_google" select="//varScieloOrg/show_cited_google" />
		<xsl:variable name="show_similar_in_scielo" select="//varScieloOrg/show_similar_in_scielo" />
		<xsl:variable name="show_similar_in_google" select="//varScieloOrg/show_similar_in_google" />
		<xsl:variable name="google_last_process" select="//varScieloOrg/google_last_process" />
		<xsl:variable name="show_article_references" select="//varScieloOrg/show_article_references" />
		<xsl:variable name="show_datasus" select="//varScieloOrg/show_datasus" />
		<xsl:variable name="services_comments" select="//varScieloOrg/services_comments" />
		<xsl:variable name="show_article_wltranslation" select="//varScieloOrg/show_article_wltranslation" />
        <xsl:variable name="show_semantic_hl" select="//varScieloOrg/show_semantic_hl" />
		<xsl:variable name="acron" select="//SIGLUM" />
		<xsl:variable name="commentCount" select="//commentCount" />
		<!--xsl:variable name="current_issn" select="//ARTICLE/ISSUEINFO/ISSN"/-->
		<xsl:variable name="current_issn" select="//SERIAL/ISSN"/>
		<xsl:variable name="allow_comments" select="document('../xml/allow_comment.xml')/COMMENT/ISSN[text() = $current_issn ]"/>
		<xsl:variable name="title_subjects" select="//TITLEGROUP/SUBJECT"/>
		<xsl:variable name="show_fapesp_projects" select="//varScieloOrg/show_fapesp_projects" />        
		<xsl:variable name="show_clinical_trials" select="//varScieloOrg/show_clinical_trials"/>

		<div id="toolBox">
			<h2 id="toolsSection">
                <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='services']"/>
			</h2>
			<!--
			<textarea>
				<xsl:copy-of select="/" />
			</textarea>
			-->
			<form name="addToShelf" method="post" action="http://{$SCIELO_REGIONAL_DOMAIN}/applications/scielo-org/services/addArticleToShelf.php" target="mensagem">
				<input type="hidden" name="PID" value="{//SERIAL/CONTROLINFO/PAGE_PID}"/>
				<input type="hidden" name="url" value="{concat('http://',//SERIAL/CONTROLINFO/SCIELO_INFO/SERVER,'/applications/scielo-org/scielo.php?script=sci_arttext&amp;pid=',//SERIAL/CONTROLINFO/PAGE_PID,'&amp;lng=',$LANGUAGE,'&amp;nrm=',//SERIAL/CONTROLINFO/STANDARD,'&amp;tlng=',//SERIAL/ISSUE/ARTICLE/@TEXTLANG)}"/>
			</form>
			<form name="citedAlert" method="post" action="http://{$SCIELO_REGIONAL_DOMAIN}/applications/scielo-org/services/citedAlert.php" target="mensagem">
				<input type="hidden" name="PID" value="{//SERIAL/CONTROLINFO/PAGE_PID}"/>
				<input type="hidden" name="url" value="{concat('http://',//SERIAL/CONTROLINFO/SCIELO_INFO/SERVER,'/applications/scielo-org/scielo.php?script=sci_arttext&amp;pid=',//SERIAL/CONTROLINFO/PAGE_PID,'&amp;lng=',$LANGUAGE,'&amp;nrm=',//SERIAL/CONTROLINFO/STANDARD,'&amp;tlng=',//SERIAL/ISSUE/ARTICLE/@TEXTLANG)}"/>
			</form>
			<form name="accessAlert" method="post" action="http://{$SCIELO_REGIONAL_DOMAIN}/applications/scielo-org/services/accessAlert.php" target="mensagem">
				<input type="hidden" name="PID" value="{//SERIAL/CONTROLINFO/PAGE_PID}"/>
				<input type="hidden" name="url" value="{concat('http://',//SERIAL/CONTROLINFO/SCIELO_INFO/SERVER,'/applications/scielo-org/scielo.php?script=sci_arttext&amp;pid=',//SERIAL/CONTROLINFO/PAGE_PID,'&amp;lng=',$LANGUAGE,'&amp;nrm=',//SERIAL/CONTROLINFO/STANDARD,'&amp;tlng=',//SERIAL/ISSUE/ARTICLE/@TEXTLANG)}"/>
			</form>
			<ul>
				<xsl:if test="$show_login != 0">
					<xsl:choose>
						<xsl:when test="normalize-space(//USERINFO/@status) != normalize-space('logout') ">
							<li>
								<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.addToShelf.submit();{$services//service[name="minhaColecao"]/call}' rel="nofollow"><img src="/img/en/iconSend2MyLibrary.gif"/>
                                    <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='add_to_my_collection']"/>
                                </a>
							</li>
							<li>
    							<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240");document.forms.citedAlert.submit();{$services//service[name="aviseMeCitado"]/call}' rel="nofollow"><img src="/img/en/iconAlert.gif" />
                                    <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='alert_me_when_cited']"/>
                                </a>
							</li>
							<li>
								<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240");document.forms.accessAlert.submit();{$services//service[name="envieMeEstatisticaAcesso"]/call}' rel="nofollow"><img src="/img/es/iconStatistics.gif"/>
                                    <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='send_me_access_statistics']"/>
                                </a>
							</li>
						</xsl:when>
						<xsl:when test="normalize-space(//USERINFO/@status) = normalize-space('logout') ">
							<li>
                                <a href="http://{$SCIELO_REGIONAL_DOMAIN}/applications/scielo-org/sso/loginScielo.php?lang={$LANGUAGE}" onClick="{$services//service[name='servicosCustomizados']/call}" rel="nofollow" ><img src="/img/{$LANGUAGE}/iconLogin.gif"/>
                                    <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='custom_services']"/>
                                </a>
                            </li>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$services_comments != 0">
					<xsl:if test="string-length($allow_comments) !=  '0' ">					
					<li>
						<a>
                            <xsl:attribute name="href">javascript: void(0);</xsl:attribute>
                            <xsl:attribute name="onClick">window.open('http://<xsl:value-of select="concat(//SERVER,'/scieloOrg/php/wpPosts.php?pid=',//ARTICLE/@PID,'&amp;lang=',$LANGUAGE,'&amp;acron=',$acron)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes'); <xsl:value-of select="$services//service[name='comentarios']/call"/></xsl:attribute>
                            <xsl:attribute name="rel">nofollow</xsl:attribute>
                            <img src="/img/{$LANGUAGE}/iconComment.gif"/>
                            <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='comments']"/> (<xsl:value-of select="$commentCount" />)
						</a>					
					</li>
                    </xsl:if>
                </xsl:if>
				<xsl:if test="//ARTICLE/@PDF">
					<xsl:variable name="tlng" select="//ARTICLE/@TEXTLANG"/>
					<xsl:variable name="pdf_tlng">
						<xsl:choose>
							<xsl:when test="//LANGUAGES/PDF_LANGS[LANG=$tlng]">
								<xsl:value-of select="$tlng"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="//LANGUAGES/PDF_LANGS/LANG"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<li>
						<a>
							<xsl:call-template name="AddScieloLink">
								<xsl:with-param name="seq" select="CONTROLINFO/PAGE_PID"/>
								<xsl:with-param name="script">sci_pdf</xsl:with-param>
								<xsl:with-param name="txtlang">
									<xsl:value-of select="$pdf_tlng"/>
								</xsl:with-param>
							</xsl:call-template>
							<img src="/img/{$LANGUAGE}/iconPDFDocument.gif"/>
                            <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='article_in_pdf_format']"/>
						</a>
					</li>
				</xsl:if>
				<li>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="concat(//SERVER,'/scieloOrg/php/articleXML.php?pid=',//ARTICLE/@PID,'&amp;lang=',$LANGUAGE)"/></xsl:attribute>
						<xsl:attribute name="rel">nofollow</xsl:attribute>
						<xsl:attribute name="target">xml</xsl:attribute>
						<xsl:if test="$service_log = 1"><xsl:attribute name="onClick">callUpdateArticleLog('artigo_em_formato_xml');</xsl:attribute></xsl:if>
						<img src="/img/{$LANGUAGE}/iconXMLDocument.gif"/>						
                        <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='article_in_xml_format']"/>
					</a>
				</li>
				<xsl:if test="($show_article_references = 1) and (//EMBARGO/@text='yes' or not(//EMBARGO))">
				<li>
					<a>
						<xsl:attribute name="href">javascript: void(0);</xsl:attribute>
						<xsl:attribute name="onClick">window.open('http://<xsl:value-of select="concat(//SERVER,'/scieloOrg/php/reference.php?pid=',//ARTICLE/@PID,'&amp;caller=',//SERVER,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes'); <xsl:value-of select="$services//service[name='referenciasArtigo']/call"/></xsl:attribute>
						<xsl:attribute name="rel">nofollow</xsl:attribute>
						<img src="/img/{$LANGUAGE}/iconReferences.gif"/>						
                        <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='article_references']"/></a>
				</li>
				</xsl:if>
				
				<xsl:if test="$show_datasus = 1 and (//ARTICLE/@AREASGEO != 0 and //ARTICLE/@AREASGEO != '')">
				<li>
					<a>
						<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
						<xsl:attribute name="onClick">javascript: window.open('http://<xsl:value-of select="concat(//SERVER,'/scieloOrg/php/datasus.php?pid=',//ARTICLE/@PID,'&amp;caller=',//SERVER,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes'); <xsl:value-of select="$services//service[name='indicadoresSaude']/call"/></xsl:attribute>
						<xsl:attribute name="rel">nofollow</xsl:attribute>
						<img src="/img/{$LANGUAGE}/iconDATASUS.gif"/>
                        <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='health_indicators']"/>
					</a>
				</li>
				</xsl:if>
				

				<!-- Tirando o "buraco" que fica no IE qnd não tem curriculo LATES -->
				<xsl:if test="ISSUE/ARTICLE/LATTES/AUTHOR">
					<li>
						<xsl:apply-templates select="ISSUE/ARTICLE/LATTES"/>
					</li>
				</xsl:if>
		<!-- Projetos FAPESP entra aqui!-->
				<xsl:if test="$show_fapesp_projects = 1 and (//ARTICLE/@PROJFAPESP != 0 and //ARTICLE/@PROJFAPESP != '')">
                    <li>
                        <a>
                        <xsl:choose>
                            <xsl:when test="normalize-space(//ARTICLE/@PROJFAPESP) != normalize-space(1)">
                                <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
                                <xsl:attribute name="onClick">javascript: window.open('http://<xsl:value-of select="concat(//SERVER,'/scieloOrg/php/projfapesp.php?pid=',//ARTICLE/@PID,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes');</xsl:attribute>
                                <xsl:attribute name="rel">nofollow</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="normalize-space(//ARTICLE/@PROJFAPESP) = normalize-space(1)">
                                <xsl:attribute name="href"><xsl:value-of select="//FAPESP/PROJETO/url"/></xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <img src="/img/{$LANGUAGE}/iconProjFapesp.gif"/>
                        <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='fapesp_projects']"/>
                        </a>
                    </li>
                </xsl:if>
		<!-- FAPESP termina aqui! -->
        <!-- CLINICAL TRIALS entra aqui!-->
                <!-- o atributo clinicaltrials aparece apenas quando a funcionalidade esta habilitada -->
				<xsl:if test="$show_clinical_trials = 1 and (normalize-space(//ARTICLE/@CLINICALTRIALS) != normalize-space(0))">
                    <li>
                        <a>
                        <xsl:choose>
                            <xsl:when test="normalize-space(//ARTICLE/@CLINICALTRIALS) != normalize-space(1)">
                                <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
                                <xsl:attribute name="onClick">javascript: window.open('http://<xsl:value-of select="concat(//SERVER,'/scieloOrg/php/clinicaltrials.php?pid=',//ARTICLE/@PID,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes');</xsl:attribute>
                                <xsl:attribute name="rel">nofollow</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="normalize-space(//ARTICLE/@CLINICALTRIALS) = normalize-space(1)">
                                <xsl:attribute name="href"><xsl:value-of select="//CLINICALTRIALS/trial/@url"/></xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <img src="/img/{$LANGUAGE}/iconClinicalTrials.gif"/>                        
                        <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='clinical_trial']"/>
                        </a>
                    </li>
                </xsl:if>
		<!-- CLINICAL TRIALS termina aqui! -->
				<li>
				<!-- How to cite this article -->
					<xsl:call-template name="PrintArticleInformationLink"/>
				</li>
				<!-- Requests -->
				<xsl:if test="$show_requests = 1">
					<li>
						<xsl:apply-templates select="//fulltext-service[@id='access']" mode="link"/>
					</li>
				</xsl:if>
				<xsl:if test="$show_cited_scielo = 1">
					<!-- Cited in SciELO -->
					<li>
						<xsl:apply-templates select="//fulltext-service[@id='cited_SciELO']" mode="linkCited"/>
					</li>
				</xsl:if>				
				<xsl:if test="$show_cited_google = 1">
					<!-- Cited in Google -->
					<li>
						<xsl:apply-templates select="//fulltext-service[@id='cited_Google']" mode="linkGoogle">
							<xsl:with-param name="google_last_process" select="$google_last_process"/>
						</xsl:apply-templates>
					</li>
				</xsl:if>
				<xsl:if test="$show_similar_in_scielo = 1">
					<!-- Related in Scielo-->
					<li>
						<xsl:apply-templates select="//fulltext-service[@id='related']" mode="linkRelated"/>
					</li>
				</xsl:if>
				<xsl:if test="$show_similar_in_google = 1">
					<!-- Related in Google-->
					<li>
						<xsl:apply-templates select="//fulltext-service[@id='related_Google']" mode="linkGoogle">
                               <xsl:with-param name="google_last_process" select="$google_last_process"/>
                                </xsl:apply-templates>
					</li>				
				</xsl:if>
				
				<xsl:if test="($show_article_wltranslation = 1)">
					<li>
						<a>
							<xsl:attribute name="href">javascript: void(0);</xsl:attribute>
							<xsl:attribute name="onClick">window.open('http://<xsl:value-of select="concat(//SERVER,'/scieloOrg/php/translate.php?pid=',//ARTICLE/@PID,'&amp;caller=',//SERVER,'&amp;lang=',$LANGUAGE,'&amp;tlang=',//ISSUE/ARTICLE/@TEXTLANG)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes'); <xsl:value-of select="$services//service[name='referenciasArtigo']/call"/></xsl:attribute>
							<xsl:attribute name="rel">nofollow</xsl:attribute>
							<img src="/img/{$LANGUAGE}/iconTranslation.gif"/>						
                            <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='automatic_translation']"/>
						</a>
					</li>
				</xsl:if>
                <xsl:if test="($show_semantic_hl = 1)">
					<xsl:if test="//ARTICLE/@TEXTLANG='en' or //ABSTRACT/@xml:lang='en'">
						<xsl:if test="$title_subjects = 'HEALTH SCIENCES' or $title_subjects = 'BIOLOGICAL SCIENCES'">
							<li>
                              <xsl:apply-templates select="//fulltext-service[@id='semantic_highlights']" mode="semanticHighlights"/>
			                </li>
	                    </xsl:if>
					</xsl:if>
                </xsl:if>
				<xsl:if test="$show_send_by_email = 1">
					<li>
						<xsl:apply-templates select="//fulltext-service[@id='send_mail']" mode="link"/>
					</li>	
				</xsl:if>
				<xsl:apply-templates select=".//ARTICLE" mode="related-documents"/>
            </ul>
		</div>
	</xsl:template>
	
	<xsl:template match="fulltext-service" mode="link">
		<xsl:variable name="params">
			<xsl:if test="@id='cited_Google' or @id='related_Google'">,menubar=1,location=1,toolbar=1,status=1,scrollbars=1,directories=1</xsl:if>
		</xsl:variable>
		<a href="javascript:void(0);" >	
            <xsl:attribute name="onclick">window.open('<xsl:value-of select="concat(url,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes,<xsl:value-of select="$params"/>');<xsl:if test="$service_log = 1">callUpdateArticleLog('<xsl:value-of select="@id"/>');</xsl:if></xsl:attribute>
            <xsl:attribute name="rel">nofollow</xsl:attribute>
			<xsl:apply-templates select="." mode="label"/>
		</a>
	</xsl:template>

    <xsl:template match="fulltext-service" mode="semanticHighlights">
        <xsl:variable name="show">
                    <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='show_semantic_highlights']"/>
        </xsl:variable>
        <xsl:variable name="hide">
                    <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='hide_semantic_highlights']"/>
        </xsl:variable>
        <xsl:variable name="serviceUrl">
              <xsl:value-of select="url" />&amp;showlabel=<xsl:value-of select="$show"/>&amp;hidelabel=<xsl:value-of select="$hide"/>
        </xsl:variable>
        <script src="{$serviceUrl}"></script>
    	<img id="wikifier-conceptweblinker-image" src="/img/btknewco.gif" onclick="WikiProfClick();" align="absmiddle"/>
		<a id="wikifier-conceptweblinker-button" href="#" title="Knewco's ConceptWeb Linker Button"><xsl:value-of select="$show"/></a>
	</xsl:template>

    <xsl:template match="fulltext-service" mode="linkGoogle">
        <xsl:param name="google_last_process"/>
        <xsl:variable name="params">
            <xsl:if test="@id='cited_Google' or @id='related_Google'">,menubar=1,location=1,toolbar=1,status=1,scrollbars=1,directories=1</xsl:if>
        </xsl:variable>
        <xsl:choose>
        <xsl:when test="normalize-space(//ARTICLE/@PROCESSDATE) &lt; normalize-space($google_last_process)">
            <a href="javascript:void(0);" >
                <xsl:attribute name="onclick">window.open('<xsl:value-of select="concat(url,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes,<xsl:value-of select="$params"/>');<xsl:if test="$service_log = 1">callUpdateArticleLog('<xsl:value-of select="@id"/>');</xsl:if></xsl:attribute>
                <xsl:attribute name="rel">nofollow</xsl:attribute>
                <xsl:apply-templates select="." mode="label"/>
            </a>
        </xsl:when>
        <xsl:otherwise>
                <xsl:apply-templates select="." mode="labelNotLinked"/>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="fulltext-service" mode="linkRelated">
        <xsl:variable name="params">
                <xsl:if test="@id='cited_Google' or @id='related_Google'">,menubar=1,location=1,toolbar=1,status=1,scrollbars=1,directories=1</xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="//ARTICLE/@RELATED != '' and //ARTICLE/@RELATED != 0">
                <a href="javascript:void(0);" >
                    <xsl:attribute name="onclick">window.open('<xsl:value-of select="concat(url,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes,<xsl:value-of select="$params"/>');<xsl:if test="$service_log = 1">callUpdateArticleLog('<xsl:value-of select="@id"/>');</xsl:if></xsl:attribute>
                    <xsl:attribute name="rel">nofollow</xsl:attribute>
                    <xsl:apply-templates select="." mode="label"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="labelNotLinked"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="fulltext-service" mode="linkCited">
        <xsl:variable name="params">
            <xsl:if test="@id='cited_Google' or @id='related_Google'">,menubar=1,location=1,toolbar=1,status=1,scrollbars=1,directories=1</xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="//ARTICLE/@CITED != '' and //ARTICLE/@CITED != 0">
                <a href="javascript:void(0);" >
                    <xsl:attribute name="onclick">window.open('<xsl:value-of select="concat(url,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes,<xsl:value-of select="$params"/>');<xsl:if test="$service_log = 1">callUpdateArticleLog('<xsl:value-of select="@id"/>');</xsl:if></xsl:attribute>
                    <xsl:attribute name="rel">nofollow</xsl:attribute>
                    <xsl:apply-templates select="." mode="label"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="labelNotLinked"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<xsl:template match="fulltext-service[@id='access']" mode="label">
		<img src="/img/{$LANGUAGE}/iconStatistics.gif"/>	
        <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='access']"/>
	</xsl:template>
	
	<xsl:template name="cited" >
        <img src="/img/{$LANGUAGE}/iconCitedOn.jpg" alt="{//ARTICLE/@CITED} artículo(s)"/><xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='cited_by']"/>
	</xsl:template>

    <xsl:template name="citedNotLinked">
        <img src="/img/{$LANGUAGE}/iconCitedOff.jpg" alt="{$translations/xslid[@id='sci_toolbox']/text[@find='have_no_cited_article']}"/><xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='cited_by']"/>
    </xsl:template>


    <xsl:template name="citedGoogle">
        <img src="/img/{$LANGUAGE}/iconcitedbygoogle.gif" alt="{$translations/xslid[@id='sci_toolbox']/text[@find='indexed_by_google']}"/><xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='cited_by']"/>
    </xsl:template>

    <xsl:template name="citedNotLinkedGoogle">
        <img src="/img/{$LANGUAGE}/iconCitedOff.jpg" alt="{$translations/xslid[@id='sci_toolbox']/text[@find='on_index_process']}"/><xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='cited_by']"/>
    </xsl:template>


	<xsl:template match="fulltext-service[@id='cited_SciELO']" mode="label">
		<xsl:call-template name="cited" /> SciELO
	</xsl:template>

    <xsl:template match="fulltext-service[@id='cited_SciELO']" mode="labelNotLinked">
        <xsl:call-template name="citedNotLinked" /> SciELO
    </xsl:template>

	<xsl:template match="fulltext-service[@id='cited_Google']" mode="label">
		<xsl:call-template name="citedGoogle" /> Google
	</xsl:template>

    <xsl:template match="fulltext-service[@id='cited_Google']" mode="labelNotLinked">
        <xsl:call-template name="citedNotLinkedGoogle" /> Google
    </xsl:template>

	<xsl:template match="fulltext-service[@id='related']" mode="label">
        <img src="/img/{$LANGUAGE}/iconRelatedOn.gif" alt="{//ARTICLE/@RELATED} {$translations/xslid[@id='sci_toolbox']/text[@find='article']}(s)"/><xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='similars_in']"/> SciELO
	</xsl:template>

    <xsl:template match="fulltext-service[@id='related']" mode="labelNotLinked">
        <img src="/img/{$LANGUAGE}/iconRelatedOff.jpg" alt="{$translations/xslid[@id='sci_toolbox']/text[@find='have_no_similar_article']}"/><xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='similars_in']"/> SciELO
    </xsl:template>

	<xsl:template match="fulltext-service[@id='related_Google']" mode="label">
        <img src="/img/{$LANGUAGE}/iconRelatedOn.gif" alt="{$translations/xslid[@id='sci_toolbox']/text[@find='indexed_by_google']}"/><xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='similars_in']"/> Google
    </xsl:template>

    <xsl:template match="fulltext-service[@id='related_Google']" mode="labelNotLinked">
        <img src="/img/{$LANGUAGE}/iconRelatedOff.jpg" alt="{$translations/xslid[@id='sci_toolbox']/text[@find='on_index_process']}"/><xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='similars_in']"/> Google
    </xsl:template>

    <xsl:template match="fulltext-service[@id='send_mail']" mode="label">
		<img src="/img/{$LANGUAGE}/iconEmail.jpg"/>
        <xsl:value-of select="$translations/xslid[@id='sci_toolbox']/text[@find='send_this_article_by_email']"/>
    </xsl:template>

</xsl:stylesheet>