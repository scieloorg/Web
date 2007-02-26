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
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.addToShelf.submit()'><img src="/img/en/iconSend2MyLibrary.gif"/>Add to My Collection</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'pt' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.addToShelf.submit()'><img src="/img/en/iconSend2MyLibrary.gif"/>Adicionar à Minha Coleção</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'es' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.addToShelf.submit()'><img src="/img/en/iconSend2MyLibrary.gif"/>Añadir a mi colección</a>
									</xsl:when>
								</xsl:choose>
							</li>
							<li>

								<xsl:choose>
									<xsl:when test=" $LANGUAGE = 'en' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.citedAlert.submit()'><img src="/img/en/iconAlert.gif" />Alert me when cited</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'pt' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240"); document.forms.citedAlert.submit()'><img src="/img/en/iconAlert.gif" />Avise-me quando for citado</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'es' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240");document.forms.citedAlert.submit()'><img src="/img/en/iconAlert.gif" />Alerteme cuando el artículo es citado</a>
									</xsl:when>
								</xsl:choose>
							</li>
							<li>
								<xsl:choose>
									<xsl:when test=" $LANGUAGE = 'en' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240");document.forms.accessAlert.submit()'><img src="/img/en/iconStatistics.gif"/>Send me access statistics</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'pt' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240");document.forms.accessAlert.submit()'><img src="/img/pt/iconStatistics.gif"/>Envie-me estatisticas de acesso</a>
									</xsl:when>
									<xsl:when test=" $LANGUAGE = 'es' ">
										<a href="javascript:void(0);" onclick='window.open("","mensagem","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=320,height=240");document.forms.accessAlert.submit()'><img src="/img/es/iconStatistics.gif"/>Enviarme estadísticas del acceso</a>
									</xsl:when>
								</xsl:choose>
							</li>
						</xsl:when>
						<xsl:when test="normalize-space(//USERINFO/@status) = normalize-space('logout') ">
							<xsl:choose>
								<xsl:when test=" $LANGUAGE = 'en' ">
									<li><a href="http://{$SCIELO_REGIONAL_DOMAIN}/applications/scielo-org/sso/loginScielo.php">Login</a></li>
								</xsl:when>
								<xsl:when test=" $LANGUAGE = 'pt' ">
									<li><a href="http://{$SCIELO_REGIONAL_DOMAIN}/applications/scielo-org/sso/loginScielo.php">Efetuar Login</a></li>
								</xsl:when>
								<xsl:when test=" $LANGUAGE = 'es' ">
									<li><a href="http://{$SCIELO_REGIONAL_DOMAIN}/applications/scielo-org/sso/loginScielo.php">Hacer el Login</a></li>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="ISSUE/ARTICLE/@PDF">
					<li>
						<a>
							<xsl:call-template name="AddScieloLink">
								<xsl:with-param name="seq" select="CONTROLINFO/PAGE_PID"/>
								<xsl:with-param name="script">sci_pdf</xsl:with-param>
								<xsl:with-param name="txtlang">
									<xsl:value-of select="ISSUE/ARTICLE/@TRANSLATION"/>
									<xsl:if test="not(ISSUE/ARTICLE/@TRANSLATION)">
										<xsl:value-of select="ISSUE/ARTICLE/@TEXTLANG"/>
									</xsl:if>
								</xsl:with-param>
							</xsl:call-template>
							<img src="/img/{$LANGUAGE}/iconPDFDocument.gif"/>
							<xsl:choose>
								<xsl:when test="$LANGUAGE='en' ">article in PDF format</xsl:when>
								<xsl:when test="$LANGUAGE='pt' ">artigo em formato PDF</xsl:when>
								<xsl:when test="$LANGUAGE='es' ">artículo en el formato PDF</xsl:when>
							</xsl:choose>
						</a>
					</li>
				</xsl:if>
				<li>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="concat(//SERVER,//PATH_WXIS,'/?IsisScript=ScieloXML/sci_arttext.xis&amp;def=scielo.def&amp;pid=',//ARTICLE/@PID)"/></xsl:attribute>
						<xsl:attribute name="target">xml</xsl:attribute>
						<img src="/img/{$LANGUAGE}/iconXMLDocument.gif"/>						
						<xsl:choose>
							<xsl:when test="$LANGUAGE='en' ">article in XML  format</xsl:when>
							<xsl:when test="$LANGUAGE='pt' ">artigo em formato XML  </xsl:when>
							<xsl:when test="$LANGUAGE='es' ">artículo en el formato XML  </xsl:when>
						</xsl:choose>
					</a>
				</li>

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
						<xsl:apply-templates select="//fulltext-service[@id='cited_SciELO']" mode="link"/>
					</li>
				</xsl:if>				
				<xsl:if test="$show_cited_google = 1">
					<!-- Cited in Google -->
					<li>
						<xsl:apply-templates select="//fulltext-service[@id='cited_Google']" mode="link"/>
					</li>
				</xsl:if>
				<xsl:if test="$show_similar_in_scielo = 1">
					<!-- Related in Scielo-->
					<li>
						<xsl:apply-templates select="//fulltext-service[@id='related']" mode="link"/>
					</li>
				</xsl:if>
				<xsl:if test="$show_similar_in_google = 1">
					<!-- Related in Google-->
					<li>
						<xsl:apply-templates select="//fulltext-service[@id='related_Google']" mode="link"/>
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
			<xsl:attribute name="onclick">window.open('<xsl:value-of select="concat(url,'&amp;lang=',$LANGUAGE)"/>','','width=640,height=480,resizable=yes,scrollbars=1,menubar=yes,<xsl:value-of select="$params"/>');</xsl:attribute>
			<xsl:apply-templates select="." mode="label"/>
		</a>
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
		<img src="/img/{$LANGUAGE}/iconCited.gif"/>	
		<xsl:choose>
			<xsl:when test=" $LANGUAGE = 'en' ">Cited by </xsl:when>
			<xsl:when test=" $LANGUAGE = 'pt' ">Citado por </xsl:when>
			<xsl:when test=" $LANGUAGE = 'es' ">Citado por </xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="fulltext-service[@id='cited_SciELO']" mode="label">
		<xsl:call-template name="cited" />
		SciELO
	</xsl:template>

	<xsl:template match="fulltext-service[@id='cited_Google']" mode="label">
		<xsl:call-template name="cited" />
		Google
	</xsl:template>

	<xsl:template match="fulltext-service[@id='related']" mode="label">
		<img src="/img/{$LANGUAGE}/iconRelated.gif"/>	
		<xsl:choose>
			<xsl:when test=" $LANGUAGE = 'en' ">Similars in SciELO </xsl:when>
			<xsl:when test=" $LANGUAGE = 'pt' ">Similares em SciELO </xsl:when>
			<xsl:when test=" $LANGUAGE = 'es' ">Similares en SciELO </xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="fulltext-service[@id='related_Google']" mode="label">
		<img src="/img/{$LANGUAGE}/iconRelated.gif"/>
		<xsl:choose>
			<xsl:when test=" $LANGUAGE = 'en' ">Similars in Google</xsl:when>
			<xsl:when test=" $LANGUAGE = 'pt' ">Similares em Google</xsl:when>
			<xsl:when test=" $LANGUAGE = 'es' ">Similares en Google</xsl:when>
		</xsl:choose>
	</xsl:template>	
	<xsl:template match="fulltext-service[@id='send_mail']" mode="label">
		<img src="/img/{$LANGUAGE}/iconCited.gif"/>
		<xsl:choose>
			<xsl:when test=" $LANGUAGE = 'en' ">Send this article by e-mail</xsl:when>
			<xsl:when test=" $LANGUAGE = 'pt' ">Enviar este artigo por e-mail</xsl:when>
			<xsl:when test=" $LANGUAGE = 'es' ">Enviar este artículo por e-mail</xsl:when>
		</xsl:choose>
	</xsl:template>		
</xsl:stylesheet>