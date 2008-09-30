<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="interfaceLang" select="//CONTROLINFO/LANGUAGE"/>
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
			<xsl:attribute name="href"><xsl:value-of select="concat('http://',$server,'/',$script,'?pid=',$pid,'&amp;lang=',$lang)"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<!-- Variável de Flag utilizada para log utilizada também no arquivo sci_toolbox -->
	<xsl:variable name="service_log" select="//services_log"/>
	<xsl:variable name="services">
		<xsl:if test="$service_log = 1">
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
		</xsl:if>
	</xsl:variable>
	<!--

Exibe caixa para exportação da citacao para "Reference Managers"

-->
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
						<xsl:choose>
							<xsl:when test=" $LANGUAGE = 'en' ">Reference Managers</xsl:when>
							<xsl:when test=" $LANGUAGE = 'pt' ">Gerenciadores de referências</xsl:when>
							<xsl:when test=" $LANGUAGE = 'es' ">Gerenciadores de citas</xsl:when>
						</xsl:choose>
					</span>
				</h3>
				<ul>
					<li>
						<a href="?download&amp;format=BibTex&amp;pid={$pid}">
							<xsl:choose>
								<xsl:when test=" $LANGUAGE = 'en' ">Export to BibTex</xsl:when>
								<xsl:when test=" $LANGUAGE = 'pt' ">Exportar para BibTex</xsl:when>
								<xsl:when test=" $LANGUAGE = 'es' ">Exportar para BibTeX</xsl:when>
							</xsl:choose>
						</a>
					</li>
					<li>
						<a href="?download&amp;format=RefMan&amp;pid={$pid}">
							<xsl:choose>
								<xsl:when test=" $LANGUAGE = 'en' ">Export to Reference Manager</xsl:when>
								<xsl:when test=" $LANGUAGE = 'pt' ">Exportar para Reference Manager</xsl:when>
								<xsl:when test=" $LANGUAGE = 'es' ">Exportar para Reference Manager</xsl:when>
							</xsl:choose>
						</a>
					</li>
					<li>
						<a href="?download&amp;format=ProCite&amp;pid={$pid}">
							<xsl:choose>
								<xsl:when test=" $LANGUAGE = 'en' ">Export to Pro Cite</xsl:when>
								<xsl:when test=" $LANGUAGE = 'pt' ">Exportar para Pro Cite</xsl:when>
								<xsl:when test=" $LANGUAGE = 'es' ">Exportar para Pro Cite</xsl:when>
							</xsl:choose>
						</a>
					</li>
					<li>
						<a href="?download&amp;format=EndNote&amp;pid={$pid}">
							<xsl:choose>
								<xsl:when test=" $LANGUAGE = 'en' ">Export to End Note</xsl:when>
								<xsl:when test=" $LANGUAGE = 'pt' ">Exportar para End Note</xsl:when>
								<xsl:when test=" $LANGUAGE = 'es' ">Exportar para End Note</xsl:when>
							</xsl:choose>
						</a>
					</li>
					<li>
						<a href="javascript:void(0)" onclick="javascript:w =  window.open('','download', '');document.exportCitation.format.value='RefWorks';document.exportCitation.submit();">
							<xsl:choose>
								<xsl:when test=" $LANGUAGE = 'en' ">Export to Refworks</xsl:when>
								<xsl:when test=" $LANGUAGE = 'pt' ">Exportar para Refworks</xsl:when>
								<xsl:when test=" $LANGUAGE = 'es' ">Exportar para Refworks</xsl:when>
							</xsl:choose>
						</a>
					</li>
				</ul>
			</div>
		</div>
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
				<xsl:attribute name="href">javascript: void(0); </xsl:attribute>
				<xsl:attribute name="onClick">setTimeout("window.open('http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="$script"/>&amp;<xsl:if test="$seq">pid=<xsl:value-of select="$seq"/>&amp;</xsl:if>lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/><xsl:if test="$txtlang">&amp;tlng=<xsl:value-of select="normalize-space($txtlang)"/></xsl:if><xsl:if test="$file">&amp;file=<xsl:value-of select="$file"/></xsl:if> ','_self')", 3000);</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="href">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="$script"/>&amp;<xsl:if test="$seq">pid=<xsl:value-of select="$seq"/>&amp;</xsl:if>lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/><xsl:if test="$txtlang">&amp;tlng=<xsl:value-of select="normalize-space($txtlang)"/></xsl:if><xsl:if test="$file">&amp;file=<xsl:value-of select="$file"/></xsl:if><xsl:apply-templates select="." mode="repo_url_param_scielo"/><xsl:if test="$date!=''">&amp;date=<xsl:value-of select="$date"/></xsl:if><xsl:if test="$page!=''">&amp;page=<xsl:value-of select="$page"/></xsl:if></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Adds a LINK to the IAH search interface
        Parameters:
           index - AU,etc
           scope - library | siglum  -->
	<xsl:template name="AddIAHLink">
		<xsl:param name="index"/>
		<xsl:param name="scope"/>
		<xsl:param name="base">article</xsl:param>
		<xsl:attribute name="href">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=<xsl:value-of select="$base"/><xsl:if test="$scope">^d<xsl:apply-templates select="." mode="repo_database"><xsl:with-param name="scope" select="$scope"/></xsl:apply-templates></xsl:if>&amp;<xsl:if test="$index">index=<xsl:value-of select="$index"/>&amp;</xsl:if>format=<xsl:value-of select="//CONTROLINFO/STANDARD"/>.pft&amp;lang=<xsl:choose><xsl:when test="//CONTROLINFO/LANGUAGE='en'">i</xsl:when><xsl:when test="//CONTROLINFO/LANGUAGE='es'">e</xsl:when><xsl:when test="//CONTROLINFO/LANGUAGE='pt'">p</xsl:when></xsl:choose><xsl:if test="$scope and $scope!='library'">&amp;limit=<xsl:apply-templates select="." mode="repo_limit"/></xsl:if></xsl:attribute>
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
		<xsl:apply-templates select="../." mode="license"/>
		<!--font class="normal">&#169;&#160;</font-->
		<span>
			<img src="http://creativecommons.org/images/public/somerights20.png"/>&#160;
		</span>
		<FONT color="#000080" class="negrito">
			<I>
				<!--xsl:value-of select="@YEAR"/-->&#160;
    <xsl:value-of select="." disable-output-escaping="yes"/>
				<br/>
			</I>
		</FONT>
		<br/>
	</xsl:template>
	<!-- Shows contact information -->
	<xsl:template match="CONTACT">
		<xsl:apply-templates select="LINES"/>
		<br/>
		<br/>
		<xsl:apply-templates select="EMAILS"/>
		<xsl:call-template name="UpdateLog"/>
	</xsl:template>
	<!-- Shows lines from contact information -->
	<xsl:template match="LINES">
		<FONT color="#000080" class="negrito">
			<xsl:apply-templates select="LINE"/>
		</FONT>
	</xsl:template>
	<xsl:template match="LINE">
		<xsl:value-of select="." disable-output-escaping="yes"/>
		<br/>
	</xsl:template>
	<!-- Shows e-mail links -->
	<xsl:template match="EMAILS">
		<IMG>
			<xsl:attribute name="src"><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/><xsl:value-of select="//CONTROLINFO/LANGUAGE"/>/e-mailt.gif</xsl:attribute>
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
		<xsl:choose>
			<xsl:when test=" $LANG = 'en' ">
				<xsl:choose>
					<xsl:when test=" $TYPE = 'PRINT' ">Print</xsl:when>
					<xsl:when test=" $TYPE = 'CDROM' ">CDROM</xsl:when>
					<xsl:when test=" $TYPE = 'DISKE' ">Diskette</xsl:when>
					<xsl:when test=" $TYPE = 'ONLIN' ">On-line</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test=" $LANG = 'pt' ">
				<em>versão
     <xsl:choose>
						<xsl:when test=" $TYPE = 'PRINT' "> impressa</xsl:when>
						<xsl:when test=" $TYPE = 'CDROM' "> em CDROM</xsl:when>
						<xsl:when test=" $TYPE = 'DISKE' "> em disquete</xsl:when>
						<xsl:when test=" $TYPE = 'ONLIN' "> on-line</xsl:when>
					</xsl:choose>
				</em>
			</xsl:when>
			<xsl:when test=" $LANG = 'es' ">
				<em>versión
     <xsl:choose>
						<xsl:when test=" $TYPE = 'PRINT' "> impresa</xsl:when>
						<xsl:when test=" $TYPE = 'CDROM' "> en CDROM</xsl:when>
						<xsl:when test=" $TYPE = 'DISKE' "> en disquete</xsl:when>
						<xsl:when test=" $TYPE = 'ONLIN' "> on-line</xsl:when>
					</xsl:choose>
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
			<font color="#000000">
				<xsl:choose>
					<xsl:when test="$LANG='en'">Former Title:</xsl:when>
					<xsl:when test="$LANG='pt'">Título anterior:</xsl:when>
					<xsl:when test="$LANG='es'">Título anterior:</xsl:when>
				</xsl:choose>
			</font>
			<br/>
			<font color="#000080">
				<em>
					<xsl:apply-templates select="FORMERTITLE"/>
				</em>
			</font>
		</xsl:if>
		<xsl:if test="NEWTITLE/TITLE">
			<br/>
			<font color="#000000">
				<xsl:choose>
					<xsl:when test="$LANG='en'">New title:</xsl:when>
					<xsl:when test="$LANG='pt'">Título novo:</xsl:when>
					<xsl:when test="$LANG='es'">Título nuevo:</xsl:when>
				</xsl:choose>
			</font>
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
	<xsl:template match="ISSN">
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
								</xsl:call-template>&#160;ISSN</font>&#160;<xsl:value-of select="normalize-space(.)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="GET_ISSN_TYPE">
								<xsl:with-param name="TYPE" select="@TYPE"/>
								<xsl:with-param name="LANG" select="$LANG"/>
							</xsl:call-template>&#160;ISSN&#160;<xsl:value-of select="normalize-space(.)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test=" $LANG='pt' ">
					<xsl:choose>
						<xsl:when test="$SERIAL">
							<font color="#000000">ISSN</font>
						</xsl:when>
						<xsl:otherwise>ISSN</xsl:otherwise>
					</xsl:choose>&#160;<xsl:value-of select="normalize-space(.)"/>&#160;<xsl:if test="$SERIAL">
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
					</xsl:choose>&#160;<xsl:value-of select="normalize-space(.)"/>&#160;<xsl:if test="$SERIAL">
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
		<!-- xsl:if test=" $TYPE !='abstract' ">
   <font face="Symbol" color="#000080">&#183; </font>
  </xsl:if -->
		<a>
			<xsl:choose>
				<xsl:when test=" $TYPE='abstract' ">
					<xsl:call-template name="AddScieloLink">
						<xsl:with-param name="seq" select="$PID"/>
						<xsl:with-param name="script">sci_abstract</xsl:with-param>
						<xsl:with-param name="txtlang" select="$TXTLANG"/>
					</xsl:call-template>
					<xsl:if test="$FIRST_LABEL='1'">
						<xsl:choose>
							<xsl:when test=" $INTLANG = 'en' ">abstract in</xsl:when>
							<xsl:when test=" $INTLANG = 'pt' ">resumo em</xsl:when>
							<xsl:when test=" $INTLANG = 'es' ">resumen en</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:when>
				<xsl:when test=" $TYPE='full' ">
					<xsl:call-template name="AddScieloLink">
						<xsl:with-param name="seq" select="$PID"/>
						<xsl:with-param name="script">sci_arttext</xsl:with-param>
						<xsl:with-param name="txtlang" select="$TXTLANG"/>
						<xsl:with-param name="file" select="$file"/>
					</xsl:call-template>
					<xsl:if test="$FIRST_LABEL='1'">
						<xsl:choose>
							<xsl:when test=" $INTLANG = 'en' ">text in</xsl:when>
							<xsl:when test=" $INTLANG = 'pt' ">texto em</xsl:when>
							<xsl:when test=" $INTLANG = 'es' ">texto en</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:when>
				<xsl:when test=" $TYPE='pdf' ">
					<xsl:call-template name="AddScieloLink">
						<xsl:with-param name="seq" select="$PID"/>
						<xsl:with-param name="script">sci_pdf</xsl:with-param>
						<xsl:with-param name="txtlang" select="$TXTLANG"/>
					</xsl:call-template>
					<xsl:if test="$FIRST_LABEL='1'">
						<xsl:choose>
							<xsl:when test=" $INTLANG = 'en' ">pdf in</xsl:when>
							<xsl:when test=" $INTLANG = 'pt' ">pdf em</xsl:when>
							<xsl:when test=" $INTLANG = 'es' ">pdf en</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
			<xsl:variable name="languages" select="document(concat('../xml/',$INTLANG,'/language.xml'))//language"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="translate(substring($languages[@id=$TXTLANG],1,1),'ABCDEFGHJIKLMNOPQRSTUVWXYZ','abcdefghjiklmnopqrstuvwxyz')"/>
			<xsl:value-of select="substring($languages[@id=$TXTLANG],2)"/>
		</a>
		<!-- &#160;&#160;&#160; -->
	</xsl:template>
	<!-- Invisible Image To Update Log File -->
	<xsl:template name="UpdateLog">
		<xsl:if test="//CONTROLINFO/SCIELO_INFO/SERVER_LOG!=''">
			<img>
				<xsl:attribute name="src">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER_LOG"/>/<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SCRIPT_LOG_NAME"/>?app=<xsl:value-of select="normalize-space(//CONTROLINFO/APP_NAME)"/>&amp;page=<xsl:value-of select="//CONTROLINFO/PAGE_NAME"/>&amp;<xsl:if test="//CONTROLINFO/PAGE_PID">pid=<xsl:value-of select="//CONTROLINFO/PAGE_PID"/>&amp;</xsl:if>lang=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;norm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/>&amp;doctopic=<xsl:value-of select="//ARTICLE/@DOCTOPIC"/>&amp;doctype=<xsl:value-of select="//ARTICLE/@DOCTYPE"/></xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
				<xsl:attribute name="height">1</xsl:attribute>
				<xsl:attribute name="width">1</xsl:attribute>
			</img>
		</xsl:if>
		<!-- to use Google Analytics -->
		<xsl:if test="//CONTROLINFO/SCIELO_INFO/GOOGLE_CODE != ''">
			<script type="text/javascript">
				var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
				document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
				</script>
			<script type="text/javascript">
				var pageTracker = _gat._getTracker("<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/GOOGLE_CODE"/>");
				pageTracker._initData();
				pageTracker._trackPageview();
			</script>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ImageLogo">
		<xsl:param name="src"/>
		<xsl:param name="alt"/>
		<img>
			<xsl:attribute name="src"><xsl:value-of select="$src"/></xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
			<xsl:attribute name="border">0</xsl:attribute>
		</img>
	</xsl:template>
	<xsl:template name="COPYRIGHTSCIELO">
		<xsl:apply-templates select="." mode="license"/>
		<center>
		&#169;&#160;<xsl:value-of select="@YEAR"/>&#160;
		<i>
				<font color="#000080">
					<xsl:value-of select="OWNER"/>
				</font>
				<br/>
			</i>
			<img>
				<xsl:attribute name="src"><xsl:value-of select="//PATH_GENIMG"/><xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>/e-mailt.gif</xsl:attribute>
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
		<xsl:attribute name="href">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielolog.php?script=<xsl:value-of select="$script"/>&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/><xsl:if test="$pid">&amp;pid=<xsl:value-of select="$pid"/></xsl:if><xsl:if test="$order">&amp;order=<xsl:value-of select="$order"/></xsl:if><xsl:if test="$dti">&amp;dti=<xsl:value-of select="$dti"/></xsl:if><xsl:if test="$dtf">&amp;dtf=<xsl:value-of select="$dtf"/></xsl:if><xsl:if test="$access">&amp;access=<xsl:value-of select="$access"/></xsl:if><xsl:if test="$cpage">&amp;cpage=<xsl:value-of select="$cpage"/></xsl:if><xsl:if test="$nlines">&amp;nlines=<xsl:value-of select="$nlines"/></xsl:if><xsl:if test="$tpages">&amp;tpages=<xsl:value-of select="$tpages"/></xsl:if><xsl:if test="$maccess">&amp;maccess=<xsl:value-of select="$maccess"/></xsl:if></xsl:attribute>
	</xsl:template>
	<!-- Prints message with the log start date (count started at..) 
     Parameters: date - log start date
-->
	<xsl:template name="PrintLogStartDate">
		<xsl:param name="date"/>
		<xsl:choose>
			<xsl:when test=" //CONTROLINFO/LANGUAGE = 'en' ">
            * &#160;Count started in 
            <xsl:call-template name="ShowDate">
					<xsl:with-param name="DATEISO" select="$date"/>
					<xsl:with-param name="LANG">en</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test=" //CONTROLINFO/LANGUAGE = 'pt' ">
            * &#160;A contagem iniciou-se em 
            <xsl:call-template name="ShowDate">
					<xsl:with-param name="DATEISO" select="$date"/>
					<xsl:with-param name="LANG">pt</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test=" //CONTROLINFO/LANGUAGE = 'es' ">
            * &#160;La cuenta se empezo el 
            <xsl:call-template name="ShowDate">
					<xsl:with-param name="DATEISO" select="$date"/>
					<xsl:with-param name="LANG">es</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
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
		<xsl:attribute name="action">http://<xsl:value-of select="CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielolog.php</xsl:attribute>
		<xsl:attribute name="method">GET</xsl:attribute>
		<xsl:attribute name="onSubmit">return validate();</xsl:attribute>
		<input type="hidden" name="script">
			<xsl:attribute name="value"><xsl:value-of select="$script"/></xsl:attribute>
		</input>
		<input type="hidden" name="pid">
			<xsl:attribute name="value"><xsl:value-of select="$pid"/></xsl:attribute>
		</input>
		<input type="hidden" name="lng">
			<xsl:attribute name="value"><xsl:value-of select="//CONTROLINFO/LANGUAGE"/></xsl:attribute>
		</input>
		<input type="hidden" name="nrm">
			<xsl:attribute name="value"><xsl:value-of select="//CONTROLINFO/STANDARD"/></xsl:attribute>
		</input>
		<input type="hidden" name="order">
			<xsl:attribute name="value"><xsl:value-of select="//STATPARAM/FILTER/ORDER"/></xsl:attribute>
		</input>
		<input type="hidden" name="dti">
			<xsl:attribute name="value"><xsl:value-of select="//STATPARAM/FILTER/INITIAL_DATE"/></xsl:attribute>
		</input>
		<input type="hidden" name="dtf">
			<xsl:attribute name="value"><xsl:value-of select="//STATPARAM/FILTER/FINAL_DATE"/></xsl:attribute>
		</input>
	</xsl:template>
	<!-- Prints the Date Selection TextBoxes
-->
	<xsl:template name="PrintDateRangeSelection">
		<script language="javascript">
			<xsl:comment>
      setLanguage('<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>');
      setStartDate('<xsl:value-of select="normalize-space(//STATPARAM/START_DATE)"/>');
      setLastDate('<xsl:value-of select="normalize-space(//STATPARAM/CURRENT_DATE)"/>')

      CreateForm('<xsl:value-of select="//STATPARAM/FILTER/INITIAL_DATE"/>', '<xsl:value-of select="//STATPARAM/FILTER/FINAL_DATE"/>');
    // </xsl:comment>
		</script>
	</xsl:template>
	<!-- Prints the submit button (reload button)
-->
	<xsl:template name="PutSubmitButton">
		<xsl:choose>
			<xsl:when test=" //CONTROLINFO/LANGUAGE = 'en' ">
				<input type="submit" value="Reload"/>
			</xsl:when>
			<xsl:when test=" //CONTROLINFO/LANGUAGE = 'pt' ">
				<input type="submit" value="Recarregar"/>
			</xsl:when>
			<xsl:when test=" //CONTROLINFO/LANGUAGE = 'es' ">
				<input type="submit" value="Recargar"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- Shows empty query message -->
	<xsl:template name="ShowEmptyQueryResult">
		<hr/>
		<p>
			<center>
				<font color="blue">
					<xsl:choose>
						<xsl:when test=" //CONTROLINFO/LANGUAGE = 'en' ">There are no statistics for that period.</xsl:when>
						<xsl:when test=" //CONTROLINFO/LANGUAGE = 'pt' ">Não existem estatísticas nesse período.</xsl:when>
						<xsl:when test=" //CONTROLINFO/LANGUAGE = 'es' ">No existen estadísticas para ese período.</xsl:when>
					</xsl:choose>
				</font>
			</center>
		</p>
		<hr/>
	</xsl:template>
	<xsl:template match="LANGUAGES">
		<xsl:param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
		<xsl:param name="PID"/>
		<xsl:param name="VERIFY"/>
		<div align="left">
			<!--    <table align="left" width="100%">
       <tr>
	     <td width="7%">&#160;</td>
           <td width="93%"> -->
           &#160;&#160;&#160;
            <xsl:apply-templates select="ABSTRACT_LANGS">
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="PID" select="$PID"/>
			</xsl:apply-templates>
			<!-- tr -->
			<!-- td -->
			<xsl:apply-templates select="ART_TEXT_LANGS">
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="PID" select="$PID"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="PDF_LANGS">
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="PID" select="$PID"/>
			</xsl:apply-templates>
			<xsl:if test="$VERIFY">
                        &#160;&#160;&#160;&#160;
                        <xsl:call-template name="CREATE_VERIFY_LINK">
					<xsl:with-param name="PID" select="$PID"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="../EMBARGO/@text='no'">
				&#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font>
				<xsl:apply-templates select="../EMBARGO/@date">
					<xsl:with-param name="lang" select="$interfaceLang"/>
				</xsl:apply-templates>
			</xsl:if>
			<!--         </td>
            </tr>
        </table> -->
		</div>
	</xsl:template>
	<xsl:template match="ABSTRACT_LANGS">
		<xsl:param name="LANG"/>
		<xsl:param name="PID"/>
		<!--       <tr>
           <td>             -->
 
               &#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font>
		<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->
		<xsl:apply-templates select="LANG[.=$LANG]" mode="abstract">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="PID" select="$PID"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="LANG[.!=$LANG]" mode="abstract">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="PID" select="$PID"/>
			<xsl:with-param name="CONTINUATION" select="(LANG[.=$LANG]!='')"/>
		</xsl:apply-templates>
		<!-- /td -->
		<!-- /tr -->
	</xsl:template>
	<xsl:template match="ART_TEXT_LANGS">
		<xsl:param name="LANG"/>
		<xsl:param name="PID"/>

           &#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font>
		<!-- <xsl:choose>
           <xsl:when test=" $LANG = 'en' "> text in </xsl:when>
           <xsl:when test=" $LANG = 'es' "> texto en </xsl:when>
           <xsl:when test=" $LANG = 'pt' "> texto em </xsl:when>
       </xsl:choose> -->
		<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->
		<xsl:apply-templates select="LANG[.=$LANG]" mode="text">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="PID" select="$PID"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="LANG[.!=$LANG]" mode="text">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="PID" select="$PID"/>
			<xsl:with-param name="CONTINUATION" select="(LANG[.=$LANG]!='')"/>
		</xsl:apply-templates>
		<!--xsl:variable name="SPOS">
           <xsl:for-each select="LANG">
               <xsl:if test=" text() = $LANG ">
                   <xsl:value-of select="position()" />
               </xsl:if>
           </xsl:for-each>
       </xsl:variable>

       <xsl:choose>
           <xsl:when test=" $SPOS > 0">
               <xsl:apply-templates select="LANG[ position() = $SPOS ]" mode="text">
                    <xsl:with-param name="LANG" select="$LANG" />
                    <xsl:with-param name="PID" select="$PID"/>
               </xsl:apply-templates>
           </xsl:when>
           <xsl:otherwise>
               <xsl:apply-templates select="LANG[ position() = 1 ]" mode="text">
                    <xsl:with-param name="LANG" select="$LANG" />
                    <xsl:with-param name="PID" select="$PID"/>
               </xsl:apply-templates>
           </xsl:otherwise>
       </xsl:choose-->
	</xsl:template>
	<xsl:template match="PDF_LANGS">
		<xsl:param name="LANG"/>
		<xsl:param name="PID"/>

       &#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font>
		<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->
		<xsl:apply-templates select="LANG[.=$LANG]" mode="pdf">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="PID" select="$PID"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="LANG[.!=$LANG]" mode="pdf">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="PID" select="$PID"/>
			<xsl:with-param name="CONTINUATION" select="(LANG[.=$LANG]!='')"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="LANG" mode="abstract">
		<xsl:param name="LANG"/>
		<xsl:param name="PID"/>
		<xsl:param name="CONTINUATION"/>
		<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->
		<xsl:if test="$CONTINUATION or (not($CONTINUATION) and position()>1)"> |</xsl:if>
		<xsl:call-template name="CREATE_ARTICLE_LINK">
			<xsl:with-param name="TYPE">abstract</xsl:with-param>
			<xsl:with-param name="INTLANG" select="$LANG"/>
			<xsl:with-param name="TXTLANG" select="text()"/>
			<xsl:with-param name="PID" select="$PID"/>
			<xsl:with-param name="FIRST_LABEL">
				<xsl:choose>
					<xsl:when test="$CONTINUATION">0</xsl:when>
					<xsl:when test="not($CONTINUATION) and position()>1">0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="LANG" mode="text">
		<xsl:param name="LANG"/>
		<xsl:param name="PID"/>
		<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->
		<xsl:param name="CONTINUATION"/>
		<xsl:if test="$CONTINUATION or (not($CONTINUATION) and position()>1)"> |</xsl:if>
		<xsl:call-template name="CREATE_ARTICLE_LINK">
			<xsl:with-param name="TYPE">full</xsl:with-param>
			<xsl:with-param name="INTLANG" select="$LANG"/>
			<xsl:with-param name="TXTLANG" select="text()"/>
			<xsl:with-param name="PID" select="$PID"/>
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
	<xsl:template match="LANG" mode="pdf">
		<xsl:param name="LANG"/>
		<xsl:param name="PID"/>
		<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->
		<xsl:param name="CONTINUATION"/>
		<xsl:if test="$CONTINUATION or (not($CONTINUATION) and position()>1)"> |</xsl:if>
		<xsl:call-template name="CREATE_ARTICLE_LINK">
			<xsl:with-param name="TYPE">pdf</xsl:with-param>
			<xsl:with-param name="INTLANG" select="$LANG"/>
			<xsl:with-param name="TXTLANG" select="text()"/>
			<xsl:with-param name="PID" select="$PID"/>
			<xsl:with-param name="FIRST_LABEL">
				<xsl:choose>
					<xsl:when test="$CONTINUATION">0</xsl:when>
					<xsl:when test="not($CONTINUATION) and position()>1">0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Original version. It is commented to avoid mind change troubles

<xsl:template  match="LANGUAGES">
    <xsl:param name="PID" />
    <xsl:param name="VERIFY" />

    <table align="center">
        <xsl:attribute name="width"><xsl:if test="count(*) > 1">480</xsl:if></xsl:attribute>
        <xsl:call-template name="PrintLanguagesLinks">
            <xsl:with-param name="counter" select="1" />
            <xsl:with-param name="maxlines" select="@MAXLINES" />
            <xsl:with-param name="pid" select="$PID" />
            <xsl:with-param name="verify" select="$VERIFY" />
        </xsl:call-template>
    </table>
</xsl:template>

<xsl:template name="PrintLanguagesLinks">
    <xsl:param name="counter" />
    <xsl:param name="maxlines" />
    <xsl:param name="pid" />
    <xsl:param name="verify" />
	
    <xsl:choose>
        <xsl:when test="$counter > $maxlines"></xsl:when>
        <xsl:otherwise>
            <tr>
                <xsl:apply-templates select="ABSTRACT_LANGS">
                    <xsl:with-param name="type">abstract</xsl:with-param>
                    <xsl:with-param name="counter" select="$counter" />
                    <xsl:with-param name="pid" select="$pid" />
                </xsl:apply-templates>

                <xsl:apply-templates select="ART_TEXT_LANGS">
                    <xsl:with-param name="type">full</xsl:with-param>
                    <xsl:with-param name="counter" select="$counter" />
                    <xsl:with-param name="pid" select="$pid" />
                </xsl:apply-templates>

                <xsl:apply-templates select="PDF_LANGS">
                    <xsl:with-param name="type">pdf</xsl:with-param>
                    <xsl:with-param name="counter" select="$counter" />
                    <xsl:with-param name="pid" select="$pid" />
                </xsl:apply-templates>

                <xsl:if test="$verify">
                    <td valign="top" align="left">
                        <xsl:choose>
			        <xsl:when test="$counter = 1">
                                <xsl:call-template name="CREATE_VERIFY_LINK">
                                    <xsl:with-param name="PID" select="$pid"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>&#160;</xsl:otherwise>
                        </xsl:choose>
                    </td>
                </xsl:if>
            </tr>

            <xsl:call-template name="PrintLanguagesLinks">
                <xsl:with-param name="counter" select="$counter+1"></xsl:with-param>
                <xsl:with-param name="maxlines" select="$maxlines"></xsl:with-param>
                <xsl:with-param name="pid" select="$pid"></xsl:with-param>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>	
</xsl:template>

<xsl:template match="ABSTRACT_LANGS | ART_TEXT_LANGS | PDF_LANGS">
    <xsl:param name="type" />
    <xsl:param name="counter" />
    <xsl:param name="pid" />

    <td valign="top" align="left">
        <xsl:choose>
            <xsl:when test="LANG[$counter]">
                <xsl:call-template name="CREATE_ARTICLE_LINK">
                    <xsl:with-param name="TYPE" select="$type" />
                    <xsl:with-param name="INTLANG" select="//CONTROLINFO/LANGUAGE"/>
                    <xsl:with-param name="TXTLANG" select="LANG[$counter]"/>
                    <xsl:with-param name="PID" select="$pid"/>
                </xsl:call-template>					
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
    </td>
</xsl:template>
-->
	<xsl:template name="CREATE_VERIFY_LINK">
		<xsl:param name="PID"/>
		<font face="Symbol" color="#800000">Ñ </font>
		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_verify&amp;pid=<xsl:value-of select="$PID"/></xsl:attribute>see mst o/h/f records</a>
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
	<xsl:template match="AUTHOR" mode="LATTES">
	InsertAuthor("<xsl:value-of select="."/>", "<xsl:value-of select="@HREF"/>");
</xsl:template>
	<xsl:template name="PrintArticleInformationLink">
		<xsl:variable name="PATH_GENIMG" select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/>
		<xsl:variable name="CONTROLINFO" select="//CONTROLINFO"/>
		<xsl:variable name="LANGUAGE" select="$CONTROLINFO/LANGUAGE"/>
		<xsl:variable name="textLang">
			<xsl:choose>
				<xsl:when test="//CONTROLINFO[PAGE_NAME='sci_arttext']">
					<xsl:value-of select="//ARTICLE/@TEXTLANG"/>
				</xsl:when>
				<xsl:when test="//CONTROLINFO[PAGE_NAME='sci_abstract']">
					<xsl:variable name="abstractLang" select=".//ABSTRACT/@xml:lang"/>
					<xsl:if test="//ART_TEXT_LANGS[LANG=$abstractLang] or //PDF_LANGS[LANG=$abstractLang]">
						<xsl:value-of select="$abstractLang"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tlng">
			<xsl:value-of select="normalize-space($textLang)"/>
		</xsl:variable>
		<xsl:variable name="INFOPAGE">http://<xsl:value-of select="$CONTROLINFO/SCIELO_INFO/SERVER"/>
			<xsl:value-of select="$CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_isoref&amp;pid=<xsl:value-of select="$CONTROLINFO/PAGE_PID"/>&amp;lng=<xsl:value-of select="$LANGUAGE"/>
			<xsl:if test="string-length($tlng)&gt;0">&amp;tlng=<xsl:value-of select="$tlng"/>
			</xsl:if>
		</xsl:variable>
		<td valign="middle">
			<a href="javascript:void(0);" onmouseout="status='';" class="nomodel" style="text-decoration: none;">
				<xsl:attribute name="onclick">OpenArticleInfoWindow ( 640, 320,  "<xsl:value-of select="$INFOPAGE"/>");
				<xsl:if test="$service_log  = 1">callUpdateArticleLog('como_citar_este_artigo');</xsl:if></xsl:attribute>
				<xsl:attribute name="rel">nofollow</xsl:attribute>
				<xsl:attribute name="onmouseover">
				status='<xsl:call-template name="PrintArticleInformationLabel"><xsl:with-param name="LANGUAGE" select="$LANGUAGE"/></xsl:call-template>'; return true;
			</xsl:attribute>
				<img border="0" align="middle" src="{$PATH_GENIMG}{$LANGUAGE}/fulltxt.gif"/>
			</a>
		</td>
		<td>
			<a href="javascript:void(0);" onmouseout="status='';" class="nomodel" style="text-decoration: none;">
				<xsl:attribute name="onclick">OpenArticleInfoWindow ( 640, 320,  "<xsl:value-of select="$INFOPAGE"/>");<xsl:if test="$service_log = 1">callUpdateArticleLog('como_citar_este_artigo');</xsl:if></xsl:attribute>
				<xsl:attribute name="rel">nofollow</xsl:attribute>
				<xsl:attribute name="onmouseover">
				status='<xsl:call-template name="PrintArticleInformationLabel"><xsl:with-param name="LANGUAGE" select="$LANGUAGE"/></xsl:call-template>'; return true;
			</xsl:attribute>
				<xsl:call-template name="PrintArticleInformationLabel">
					<xsl:with-param name="LANGUAGE" select="$LANGUAGE"/>
				</xsl:call-template>
			</a>
		</td>
	</xsl:template>
	<xsl:template name="PrintArticleInformationLabel">
		<xsl:param name="LANGUAGE"/>
		<xsl:choose>
			<xsl:when test=" $LANGUAGE = 'en' ">How to cite this article</xsl:when>
			<xsl:when test=" $LANGUAGE = 'pt' ">Como citar este artigo</xsl:when>
			<xsl:when test=" $LANGUAGE = 'es' ">Como citar este artículo</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@DOI">
	doi: <xsl:value-of select="."/>
	</xsl:template>
	<!--

tem esses dois templates "vazios" para nao aparecer o conteudo nos rodapes . . .

-->
	<xsl:template match="SCIELO_REGIONAL_DOMAIN"/>
	<xsl:template match="USERINFO"/>
	<xsl:template match="fulltext-service-list"/>
	<xsl:template match="EMBARGO/@date">
		<xsl:param name="lang"/>
		<xsl:choose>
			<xsl:when test="$lang='pt'">texto disponível após </xsl:when>
			<xsl:when test="$lang='es'">texto disponible después de </xsl:when>
			<xsl:when test="$lang='en'">text available after </xsl:when>
		</xsl:choose>
		<xsl:call-template name="ShowDate">
			<xsl:with-param name="DATEISO" select="."/>
			<xsl:with-param name="LANG" select="$lang"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="*" mode="license">
		<xsl:choose>
			<xsl:when test=".//article-meta/permissions">
				<xsl:apply-templates select=".//article-meta/permissions"/>
			</xsl:when>
			<xsl:when test=".//PERMISSIONS">
				<xsl:apply-templates select=".//PERMISSIONS/permissions"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="..//PERMISSIONS/permissions"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="permissions">
		<div class="license">
			<xsl:copy-of select=".//license/*"/>
		</div>
	</xsl:template>
	<xsl:template match="*" mode="footer-journal">
		<div class="footer">
			<xsl:apply-templates select=".//COPYRIGHT"/>
			<xsl:apply-templates select=".//CONTACT"/>
		</div>
	</xsl:template>
	<xsl:template match="*" mode="repo_url_param_scielo"/>
	<xsl:template match="*" mode="issuetoc">sci_issuetoc<xsl:value-of select="//NAVEGATION_TYPE"/>
	</xsl:template>
	<xsl:template match="*" mode="issues">sci_issues<xsl:value-of select="//NAVEGATION_TYPE"/>
	</xsl:template>
	<xsl:template match="*" mode="sci_serial">
		<xsl:choose>
			<xsl:when test="//CONTROLINFO/NO_SCI_SERIAL='yes'">sci_artlist</xsl:when>
			<xsl:otherwise>sci_serial</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" mode="repo_database">
		<xsl:param name="scope"/>
		<xsl:choose>
			<xsl:when test="//PAGINATION">
				<xsl:apply-templates select="//PAGINATION/@rep" mode="rep3"/>
				<xsl:if test="//PAGINATION/@journal=//ISSN">
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
						<xsl:value-of select="//PAGINATION/@journal"/> and rep=<xsl:value-of select="//PAGINATION/@rep"/>
					</xsl:when>
					<xsl:when test="//PAGINATION/@rep">rep=<xsl:value-of select="//PAGINATION/@rep"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="//PAGINATION/@journal"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="//ISSN"/>
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
	<xsl:template match="@*" mode="repo_url_param_scielo">&amp;<xsl:value-of select="name()"/>=<xsl:value-of select="."/>
	</xsl:template>
</xsl:stylesheet>
