<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
	<xsl:variable name="acron" select="//SIGLUM" />
	


		<div id="toolBox">
			<h2 id="toolsSection">
				<xsl:choose>
					<xsl:when test=" $LANGUAGE = 'en' ">Services</xsl:when>
					<xsl:when test=" $LANGUAGE = 'pt' ">Serviços</xsl:when>
					<xsl:when test=" $LANGUAGE = 'es' ">Servicios</xsl:when>
				</xsl:choose>
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
								<xsl:choose>
									<xsl:when test="$LANGUAGE = 'en' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.addToShelf.submit();{$services//service[name="minhaColecao"]/call}' rel="nofollow"><img src="/img/en/iconSend2MyLibrary.gif"/>Add to My Collection</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'pt' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.addToShelf.submit();{$services//service[name="minhaColecao"]/call}' rel="nofollow"><img src="/img/en/iconSend2MyLibrary.gif"/>Adicionar à Minha Coleção</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'es' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.addToShelf.submit();{$services//service[name="minhaColecao"]/call}' rel="nofollow"><img src="/img/en/iconSend2MyLibrary.gif"/>Añadir a mi colección</a>
									</xsl:when>
								</xsl:choose>
							</li>
							<li>

								<xsl:choose>
									<xsl:when test=" $LANGUAGE = 'en' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.citedAlert.submit();{$services//service[name="aviseMeCitado"]/call}' rel="nofollow"><img src="/img/en/iconAlert.gif" />Alert me when cited</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'pt' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.citedAlert.submit();{$services//service[name="aviseMeCitado"]/call}' rel="nofollow"><img src="/img/en/iconAlert.gif" />Avise-me quando for citado</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'es' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240");document.forms.citedAlert.submit();{$services//service[name="aviseMeCitado"]/call}' rel="nofollow"><img src="/img/en/iconAlert.gif" />Alerteme cuando el artículo es citado</a>
									</xsl:when>
								</xsl:choose>
							</li>
							<li>
								<xsl:choose>
									<xsl:when test=" $LANGUAGE = 'en' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240");document.forms.accessAlert.submit();{$services//service[name="envieMeEstatisticaAcesso"]/call}' rel="nofollow"><img src="/img/en/iconStatistics.gif"/>Send me access statistics</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'pt' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240");document.forms.accessAlert.submit();{$services//service[name="envieMeEstatisticaAcesso"]/call}' rel="nofollow"><img src="/img/pt/iconStatistics.gif"/>Envie-me estatisticas de acesso</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'es' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240");document.forms.accessAlert.submit();{$services//service[name="envieMeEstatisticaAcesso"]/call}' rel="nofollow"><img src="/img/es/iconStatistics.gif"/>Enviarme estadísticas del acceso</a>
									</xsl:when>
								</xsl:choose>
							</li>
						</xsl:when>
						<xsl:when test="normalize-space(//USERINFO/@status) = normalize-space('logout') ">
							<xsl:choose>
								<xsl:when test=" $LANGUAGE = 'en' ">
									<li><a href="http://{$SCIELO_REGIONAL_DOMAIN}/applications/scielo-org/sso/loginScielo.php?lang={$LANGUAGE}" rel="nofollow"><img src="/img/{$LANGUAGE}/iconLogin.gif"/>Custom services</a></li>
								</xsl:when>
								<xsl:when test=" $LANGUAGE = 'pt' ">
									<li><a href="http://{$SCIELO_REGIONAL_DOMAIN}/applications/scielo-org/sso/loginScielo.php?lang={$LANGUAGE}" rel="nofollow"><img src="/img/{$LANGUAGE}/iconLogin.gif"/>Serviços personalizados</a></li>
								</xsl:when>
								<xsl:when test=" $LANGUAGE = 'es' ">
									<li><a href="http://{$SCIELO_REGIONAL_DOMAIN}/applications/scielo-org/sso/loginScielo.php?lang={$LANGUAGE}" rel="nofollow" ><img src="/img/{$LANGUAGE}/iconLogin.gif"/>Servicios customizados</a></li>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$services_comments != 0">
					<li>
						<a>
						<xsl:attribute name="href">javascript: void(0);</xsl:attribute>
						<xsl:attribute name="onClick">window.open('http://<xsl:value-of select="concat(//SERVER,'/scieloOrg/php/wpPosts.php?pid=',//ARTICLE/@PID,'&amp;lang=',$LANGUAGE,'&amp;acron=',$acron)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes'); <xsl:value-of select="$services//service[name='comentarios']/call"/></xsl:attribute>
						<xsl:attribute name="rel">nofollow</xsl:attribute>
						<img src="/img/{$LANGUAGE}/iconComment.gif"/>						
						<xsl:choose>
							<xsl:when test="$LANGUAGE='en' ">Comment this article</xsl:when>
							<xsl:when test="$LANGUAGE='pt' ">Comente este artigo</xsl:when>
							<xsl:when test="$LANGUAGE='es' ">Comentar este artículo</xsl:when>
						</xsl:choose>
						</a>					
						</li>
				</xsl:if>
					<xsl:if test="ISSUE/ARTICLE/@PDF">
					<xsl:variable name="tlng" select="ISSUE/ARTICLE/@TEXTLANG"/>
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
							<xsl:choose>
								<xsl:when test="$LANGUAGE='en' ">Article in PDF format</xsl:when>
								<xsl:when test="$LANGUAGE='pt' ">Artigo em formato PDF</xsl:when>
								<xsl:when test="$LANGUAGE='es' ">Artículo en el formato PDF</xsl:when>
							</xsl:choose>
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
						<xsl:choose>
							<xsl:when test="$LANGUAGE='en' ">Article in XML  format</xsl:when>
							<xsl:when test="$LANGUAGE='pt' ">Artigo em formato XML  </xsl:when>
							<xsl:when test="$LANGUAGE='es' ">Artículo en el formato XML  </xsl:when>
						</xsl:choose>
					</a>
				</li>
				<xsl:if test="$show_article_references = 1">
				<li>
					<a>
						<xsl:attribute name="href">javascript: void(0);</xsl:attribute>
						<xsl:attribute name="onClick">window.open('http://<xsl:value-of select="concat(//SERVER,'/scieloOrg/php/reference.php?pid=',//ARTICLE/@PID,'&amp;caller=',//SERVER,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes'); <xsl:value-of select="$services//service[name='referenciasArtigo']/call"/></xsl:attribute>
						<xsl:attribute name="rel">nofollow</xsl:attribute>
						<img src="/img/{$LANGUAGE}/iconReferences.gif"/>						
						<xsl:choose>
							<xsl:when test="$LANGUAGE='en' ">Article references</xsl:when>
							<xsl:when test="$LANGUAGE='pt' ">Referências do artigo</xsl:when>
							<xsl:when test="$LANGUAGE='es' ">Referencias del artículo</xsl:when>
						</xsl:choose>
					</a>
				</li>
				</xsl:if>
				<xsl:if test="$show_datasus = 1 and (//ARTICLE/@AREASGEO != 0 and //ARTICLE/@AREASGEO != '')">
				<li>
					<a>
						<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
						<xsl:attribute name="onClick">javascript: window.open('http://<xsl:value-of select="concat(//SERVER,'/scieloOrg/php/datasus.php?pid=',//ARTICLE/@PID,'&amp;caller=',//SERVER,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes'); <xsl:value-of select="$services//service[name='indicadoresSaude']/call"/></xsl:attribute>
						<xsl:attribute name="rel">nofollow</xsl:attribute>
						<img src="/img/{$LANGUAGE}/iconDATASUS.gif"/>
						<xsl:choose>
							<xsl:when test="$LANGUAGE='en' ">Health Indicators</xsl:when>
							<xsl:when test="$LANGUAGE='pt' ">Indicadores de Saúde</xsl:when>
							<xsl:when test="$LANGUAGE='es' ">Indicadores de Salud</xsl:when>
						</xsl:choose>
						
					</a>
				</li>
				</xsl:if>
				

				<!-- Tirando o "buraco" que fica no IE qnd não tem curriculo LATES -->
				<xsl:if test="ISSUE/ARTICLE/LATTES/AUTHOR">
					<li>
						<xsl:apply-templates select="ISSUE/ARTICLE/LATTES"/>
					</li>
				</xsl:if>
				
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
				<xsl:if test="$show_send_by_email = 1">
					<li>
						<xsl:apply-templates select="//fulltext-service[@id='send_mail']" mode="link"/>
					</li>	
				</xsl:if>
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="fulltext-service" mode="link">
		<xsl:variable name="params">
			<xsl:if test="@id='cited_Google' or @id='related_Google'">,menubar=1,location=1,toolbar=1,status=1,scrollbars=1,directories=1</xsl:if>
		</xsl:variable>
		<a href="javascript:void(0);" >	
			<xsl:attribute name="onclick">window.open('<xsl:value-of select="concat(url,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes,<xsl:value-of select="$params"/>');<xsl:if test="$service_log = 1">callUpdateArticleLog('<xsl:value-of select="@id"/> ');</xsl:if></xsl:attribute>
<xsl:attribute name="rel">nofollow</xsl:attribute>
			<xsl:apply-templates select="." mode="label"/>
		</a>
	</xsl:template>

        <xsl:template match="fulltext-service" mode="linkGoogle">
		<xsl:param name="google_last_process"/>
                <xsl:variable name="params">
                        <xsl:if test="@id='cited_Google' or @id='related_Google'">,menubar=1,location=1,toolbar=1,status=1,scrollbars=1,directories=1</xsl:if>
                </xsl:variable>
		<xsl:choose>
                <xsl:when test="normalize-space(//ARTICLE/@PROCESSDATE) &lt; normalize-space($google_last_process)">
			<a href="javascript:void(0);" >
                                <xsl:attribute name="onclick">window.open('<xsl:value-of select="concat(url,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes,<xsl:value-of select="$params"/>');<xsl:if test="$service_log = 1">callUpdateArticleLog('<xsl:value-of select="@id"/> ');</xsl:if></xsl:attribute>
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
                <xsl:when test="//ARTICLE/@RELATED != 0">
	                <a href="javascript:void(0);" >
                	        <xsl:attribute name="onclick">window.open('<xsl:value-of select="concat(url,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes,<xsl:value-of select="$params"/>');<xsl:if test="$service_log = 1">callUpdateArticleLog('<xsl:value-of select="@id"/> ');</xsl:if></xsl:attribute>
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
                <xsl:when test="//ARTICLE/@CITED != 0">
                        <a href="javascript:void(0);" >
                                <xsl:attribute name="onclick">window.open('<xsl:value-of select="concat(url,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes,<xsl:value-of select="$params"/>');<xsl:if test="$service_log = 1">callUpdateArticleLog('<xsl:value-of select="@id"/> ');</xsl:if></xsl:attribute>
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
		<xsl:choose>
			<xsl:when test=" $LANGUAGE = 'en' ">Requests</xsl:when>
			<xsl:when test=" $LANGUAGE = 'pt' ">Acessos</xsl:when>
			<xsl:when test=" $LANGUAGE = 'es' ">Accesos</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="cited" >
		<xsl:choose>
			<xsl:when test=" $LANGUAGE = 'en' "><img src="/img/{$LANGUAGE}/iconCitedOn.jpg" alt="{//ARTICLE/@CITED} article(s)"/>Cited by </xsl:when>
			<xsl:when test=" $LANGUAGE = 'pt' "><img src="/img/{$LANGUAGE}/iconCitedOn.jpg" alt="{//ARTICLE/@CITED} artigo(s)"/>Citado por </xsl:when>
			<xsl:when test=" $LANGUAGE = 'es' "><img src="/img/{$LANGUAGE}/iconCitedOn.jpg" alt="{//ARTICLE/@CITED} artículo(s)"/>Citado por </xsl:when>
		</xsl:choose>
	</xsl:template>

        <xsl:template name="citedNotLinked">
                <xsl:choose>
                        <xsl:when test=" $LANGUAGE = 'en' "><img src="/img/{$LANGUAGE}/iconCitedOff.jpg" alt="have no cited articles"/>Cited by </xsl:when>
                        <xsl:when test=" $LANGUAGE = 'pt' "><img src="/img/{$LANGUAGE}/iconCitedOff.jpg" alt="não existem artigos citados"/>Citado por </xsl:when>
                        <xsl:when test=" $LANGUAGE = 'es' "><img src="/img/{$LANGUAGE}/iconCitedOff.jpg" alt="no hay artículos citados"/>Citado por </xsl:when>
                </xsl:choose>
        </xsl:template>


        <xsl:template name="citedGoogle">
                <xsl:choose>
                        <xsl:when test=" $LANGUAGE = 'en' "><img src="/img/{$LANGUAGE}/iconcitedbygoogle.gif" alt="indexed by Google"/>Cited by </xsl:when>
                        <xsl:when test=" $LANGUAGE = 'pt' "><img src="/img/{$LANGUAGE}/iconcitedbygoogle.gif" alt="indexado pelo Google"/>Citado por </xsl:when>
                        <xsl:when test=" $LANGUAGE = 'es' "><img src="/img/{$LANGUAGE}/iconcitedbygoogle.gif" alt="indizado por Google"/>Citado por </xsl:when>
                </xsl:choose>
        </xsl:template>

        <xsl:template name="citedNotLinkedGoogle">
                <xsl:choose>
                        <xsl:when test=" $LANGUAGE = 'en' "><img src="/img/{$LANGUAGE}/iconCitedOff.jpg" alt="on index process"/>Cited by </xsl:when>
                        <xsl:when test=" $LANGUAGE = 'pt' "><img src="/img/{$LANGUAGE}/iconCitedOff.jpg" alt="em processo de indexação"/>Citado por </xsl:when>
                        <xsl:when test=" $LANGUAGE = 'es' "><img src="/img/{$LANGUAGE}/iconCitedOff.jpg" alt="en proceso de indización"/>Citado por </xsl:when>
                </xsl:choose>
        </xsl:template>


	<xsl:template match="fulltext-service[@id='cited_SciELO']" mode="label">
		<xsl:call-template name="cited" />
		SciELO
	</xsl:template>

        <xsl:template match="fulltext-service[@id='cited_SciELO']" mode="labelNotLinked">
                <xsl:call-template name="citedNotLinked" />
                SciELO
        </xsl:template>


	<xsl:template match="fulltext-service[@id='cited_Google']" mode="label">
		<xsl:call-template name="citedGoogle" />
		Google
	</xsl:template>

        <xsl:template match="fulltext-service[@id='cited_Google']" mode="labelNotLinked">
                <xsl:call-template name="citedNotLinkedGoogle" />
                Google
        </xsl:template>


	<xsl:template match="fulltext-service[@id='related']" mode="label">
		<xsl:choose>
			<xsl:when test=" $LANGUAGE = 'en' "><img src="/img/{$LANGUAGE}/iconRelatedOn.gif" alt="{//ARTICLE/@RELATED} article(s)"/>Similars in SciELO</xsl:when>
			<xsl:when test=" $LANGUAGE = 'pt' "><img src="/img/{$LANGUAGE}/iconRelatedOn.gif" alt="{//ARTICLE/@RELATED} artigo(s)"/>Similares em SciELO </xsl:when>
			<xsl:when test=" $LANGUAGE = 'es' "><img src="/img/{$LANGUAGE}/iconRelatedOn.gif" alt="{//ARTICLE/@RELATED} artículo(s)"/>Similares en SciELO </xsl:when>
		</xsl:choose>
	</xsl:template>

        <xsl:template match="fulltext-service[@id='related']" mode="labelNotLinked">
                <xsl:choose>
                        <xsl:when test=" $LANGUAGE = 'en' "><img src="/img/{$LANGUAGE}/iconRelatedOff.jpg" alt="have no similar articles"/>Similars in SciELO </xsl:when>
                        <xsl:when test=" $LANGUAGE = 'pt' "><img src="/img/{$LANGUAGE}/iconRelatedOff.jpg" alt="Não existem artigos similares"/>Similares em SciELO </xsl:when>
                        <xsl:when test=" $LANGUAGE = 'es' "><img src="/img/{$LANGUAGE}/iconRelatedOff.jpg" alt="No hay artílculos similares"/>Similares en SciELO </xsl:when>
                </xsl:choose>
        </xsl:template>

	<xsl:template match="fulltext-service[@id='related_Google']" mode="label">
		<xsl:choose>
		   <xsl:when test=" $LANGUAGE = 'en' "><img src="/img/{$LANGUAGE}/iconRelatedOn.gif" alt="indexed by Google"/>Similars in Google</xsl:when>
		   <xsl:when test=" $LANGUAGE = 'pt' "><img src="/img/{$LANGUAGE}/iconRelatedOn.gif" alt="indexado pelo Google"/>Similares em Google</xsl:when>
		   <xsl:when test=" $LANGUAGE = 'es' "><img src="/img/{$LANGUAGE}/iconRelatedOn.gif" alt="indizado por Google"/>Similares en Google</xsl:when>
		</xsl:choose>
	</xsl:template>	

        <xsl:template match="fulltext-service[@id='related_Google']" mode="labelNotLinked">
                <xsl:choose>
                        <xsl:when test=" $LANGUAGE = 'en' "><img src="/img/{$LANGUAGE}/iconRelatedOff.jpg" alt="on index process"/>Similars in Google</xsl:when>
                        <xsl:when test=" $LANGUAGE = 'pt' "><img src="/img/{$LANGUAGE}/iconRelatedOff.jpg" alt="em processo de indexação"/>Similares em Google</xsl:when>
                        <xsl:when test=" $LANGUAGE = 'es' "><img src="/img/{$LANGUAGE}/iconRelatedOff.jpg" alt="en proceso de indización"/>Similares en Google</xsl:when>
                </xsl:choose>
        </xsl:template>


	<xsl:template match="fulltext-service[@id='send_mail']" mode="label">
		<img src="/img/{$LANGUAGE}/iconEmail.jpg"/>
		<xsl:choose>
			<xsl:when test=" $LANGUAGE = 'en' ">Send this article by e-mail</xsl:when>
			<xsl:when test=" $LANGUAGE = 'pt' ">Enviar este artigo por e-mail</xsl:when>
			<xsl:when test=" $LANGUAGE = 'es' ">Enviar este artículo por e-mail</xsl:when>
		</xsl:choose>
	</xsl:template>		
</xsl:stylesheet>
