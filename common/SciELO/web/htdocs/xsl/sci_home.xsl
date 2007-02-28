<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="SCIELO_REGIONAL_DOMAIN" select="//SCIELO_REGIONAL_DOMAIN"/>
	<xsl:variable name="show_toolbox" select="//toolbox"/>
	<xsl:variable name="show_login" select="//show_login"/>
	<xsl:variable name="login_url" select="//loginURL"/>
	<xsl:variable name="logout_url" select="//logoutURL"/>

	<xsl:output method="html" indent="no"/>
	
	<xsl:include href="file:///d:/sites/scielo_repo/web/htdocs/xsl/sci_common.xsl"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="HOMEPAGE">
		<html>
			<head>
				<title>SciELO - Scientific electronic library online</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="STYLESHEET" type="text/css" href="/css/scielo.css"/>
			</head>
			<body link="#000080" vlink="#800080" bgcolor="#ffffff">
				<xsl:apply-templates select="CONTROLINFO"/>
				<xsl:apply-templates select="SCIELOINFOGROUP"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="CONTROLINFO[LANGUAGE='en']">
		<p align="center">
			<a href="http://www.scielo.org">
				<img>
					<xsl:attribute name="alt">Scientific Electronic Library Online</xsl:attribute>
					<xsl:attribute name="border">0</xsl:attribute>
					<xsl:attribute name="src"><xsl:value-of select="SCIELO_INFO/PATH_GENIMG"/><xsl:value-of select="LANGUAGE"/>/scielobre.gif</xsl:attribute>
				</img>
			</a>
			<br/>
			<img>
				<xsl:attribute name="src"><xsl:value-of select="SCIELO_INFO/PATH_GENIMG"/>assinat.gif</xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
			</img>
		</p>
		<table border="0">
			<tr>
				<td width="205" valign="top" rowspan="2">
					<!--
			Usuarios no SciELO - Botao de Login
		-->
					<xsl:if test="$show_login = 1">
						<xsl:apply-templates select="//USERINFO" mode="box">
							<xsl:with-param name="lang" select="'en'"/>
						</xsl:apply-templates>
					</xsl:if>
					<!--
			Fim: Usuarios no SciELO - Botao de Login
		-->
					<a href="http://www.scielo.org">
						<font class="linkado" size="-1">SciELO.org</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://www.scielo.org/scielo_org_en.html</xsl:attribute>
						<font class="linkado" size="-1">criteria SciELO</font>
					</a>
					<br/>&#160;<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_home/lng_pt/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">português</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_home/lng_es/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">español</font>
					</a>
					<br/>&#160;<br/>
					<a href="#help">
						<font class="linkado" size="1">help</font>
					</a>
					<br/>
					<a href="#about">
						<font class="linkado" size="-1">about this site</font>
					</a>
					<br/>
				</td>
				<td width="205" valign="top">
					<font class="nomodel" color="#800000" size="-1">serial browsing</font>
					<br/>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_alphabetic/lng_en/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">alphabetic list</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_subject/lng_en/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">subject list</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=title&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>
						<font class="linkado" size="-1">search form</font>
					</a>
					<br/>
				</td>
				<td width="205" valign="top">
					<font class="nomodel" color="#800000" size="-1">article browsing</font>
					<br/>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;index=AU&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>
						<font class="linkado" size="-1">author index</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;index=KW&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>
						<font class="linkado" size="-1">subject index</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>
						<font class="linkado" size="-1">search form</font>
					</a>
					<br/>
				</td>
				<td valign="top" width="205">
					<xsl:if test="ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 ">
						<font class="nomodel" color="#800000" size="-1">reports</font>
						<br/>
						<br/>
					</xsl:if>
					<xsl:if test="ENABLE_STAT_LINK = 1">
						<a>
							<xsl:call-template name="AddScieloLink">
								<xsl:with-param name="script">sci_stat</xsl:with-param>
							</xsl:call-template>
							<font class="linkado" size="-1">site usage</font>
						</a>
						<br/>
					</xsl:if>
					<xsl:if test="ENABLE_CIT_REP_LINK = 1">
						<a>
							<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>bib2jcr.htm</xsl:attribute>
							<font class="linkado" size="-1">journal citation</font>
						</a>
					</xsl:if>
				</td>
			</tr>
		</table>
		<table width="100%">
			<tr>
				<td valign="top" align="right" nowrap="nowrap" width="20%">
					<br/>
					<br/>
					<a name="explain">&#160;</a>
					<font class="negrito" size="-1">SciELO&#160;&#160;&#160;</font>
				</td>
				<td width="70%">
					<br/>
					<br/>
					<font class="nomodel" size="-1">
				The Scientific Electronic Library Online - SciELO is an electronic virtual library covering a selected collection of Brazilian scientific journals.<br/>
						<br/>The library is an integral part of a project being developed by <a href="http://www.fapesp.br">FAPESP</a> - Fundação de Amparo à Pesquisa do Estado de São Paulo, in partnership with <a href="http://www.bireme.br/bvs/I/ihome.htm">BIREME</a> - the Latin American and Caribbean Center on Health Sciences Information.<br/>
						<br/>The FAPESP-BIREME Project envisages the development of a common methodology for the preparation, storage, dissemination and evaluation of scientific literature in electronic format.<br/>
						<br/>As the project develops, new journal titles will be added in the library collection.
			</font>
				</td>
				<td width="10%">&#160;</td>
			</tr>
			<tr>
				<td valign="top" align="right" nowrap="nowrap" width="20%">
					<br/>
					<br/>
					<br/>
					<a name="about">&#160;</a>
					<font class="negrito" size="-1">about this site&#160;&#160;&#160;</font>
				</td>
				<td width="70%">
					<br/>
					<br/>
					<br/>
					<font class="nomodel" size="-1">
				This is the home page of SciELO Site.<br/>
						<br/>The objective of the site is to implement an electronic virtual library, providing full access to a collection of serial titles, a collection of issues from individual serial titles, as well as to the full text of articles. The access to both serial titles and articles is available via indexes and search forms.<br/>
						<br/>SciELO site is an integral part of the FAPESP-BIREME Project and it is an application of the methodology being developed by the project, particularly the Internet Interface module.<br/>
						<br/>The site will be constantly updated both in form and content, according to the project's advancements.<br/>
						<br/>
					</font>
				</td>
				<td width="10%">&#160;</td>
			</tr>
			<tr>
				<td valign="top" align="right" nowrap="nowrap" width="20%">
					<br/>
					<br/>
					<br/>
					<a name="help">&#160;</a>
					<font class="negrito" size="-1">help&#160;&#160;&#160;</font>
				</td>
				<td width="70%">
					<br/>
					<br/>
					<br/>
					<font class="nomodel" size="-1">
				SciELO interface provides access to its serials collection via an alphabetic list of titles or a subject index or a search by word of serial titles, publisher names, city of publication and subject.<br/>
						<br/>The interface also provides access to the full text of articles via author index or subject index or a search form on article elements such as author names, words from title, subject and words from the full text.<br/>
						<br/>Click an hypertext link to call the corresponding access page.<br/>
						<br/>
					</font>
					<br/>
					<br/>
					<br/>
				</td>
				<td width="10%">&#160;</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="CONTROLINFO[LANGUAGE='pt']">
		<p align="center">
			<a href="http://www.scielo.org/index_p.html">
				<img>
					<xsl:attribute name="alt">Scientific Electronic Library Online</xsl:attribute>
					<xsl:attribute name="border">0</xsl:attribute>
					<xsl:attribute name="src"><xsl:value-of select="SCIELO_INFO/PATH_GENIMG"/><xsl:value-of select="LANGUAGE"/>/scielobre.gif</xsl:attribute>
				</img>
			</a>
			<br/>
			<img>
				<xsl:attribute name="src"><xsl:value-of select="SCIELO_INFO/PATH_GENIMG"/>assinat.gif</xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
			</img>
		</p>
		<table border="0">
			<tr>
				<td width="205" valign="top" rowspan="2">
					<!--
			Usuarios no SciELO - Botao de Login
		-->
					<xsl:if test="$show_toolbox = 1">
						<xsl:apply-templates select="//USERINFO" mode="box">
							<xsl:with-param name="lang" select="'pt'"/>
						</xsl:apply-templates>
					</xsl:if>
					<!--
			Fim: Usuarios no SciELO - Botao de Login
		-->
					<a href="http://www.scielo.org/index_p.html">
						<font class="linkado" size="-1">SciELO.org</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://www.scielo.org/scielo_org_pt.html</xsl:attribute>
						<font class="linkado" size="-1">critérios SciELO</font>
					</a>
					<br/>&#160;<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_home/lng_en/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">english</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_home/lng_es/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">español</font>
					</a>
					<br/>&#160;<br/>
					<a href="#help">
						<font class="linkado" size="1">help</font>
					</a>
					<br/>
					<a href="#about">
						<font class="linkado" size="-1">sobre este site</font>
					</a>
					<br/>
				</td>
				<td width="205" valign="top">
					<font class="nomodel" color="#800000" size="-1">periódicos</font>
					<br/>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_alphabetic/lng_pt/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">lista alfabética</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_subject/lng_pt/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">lista por assunto</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=title&amp;fmt=iso.pft&amp;lang=p</xsl:attribute>
						<font class="linkado" size="-1">pesquisa de títulos</font>
					</a>
					<br/>
				</td>
				<td width="205" valign="top">
					<font class="nomodel" color="#800000" size="-1">artigos</font>
					<br/>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;index=AU&amp;fmt=iso.pft&amp;lang=p</xsl:attribute>
						<font class="linkado" size="-1">índice de autores</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;index=KW&amp;fmt=iso.pft&amp;lang=p</xsl:attribute>
						<font class="linkado" size="-1">índice de assuntos</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;fmt=iso.pft&amp;lang=p</xsl:attribute>
						<font class="linkado" size="-1">pesquisa de artigos</font>
					</a>
					<br/>
				</td>
				<td valign="top" width="205">
					<xsl:if test="ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 ">
						<font class="nomodel" color="#800000" size="-1">relatórios</font>
						<br/>
						<br/>
					</xsl:if>
					<xsl:if test="ENABLE_STAT_LINK = 1">
						<a>
							<xsl:call-template name="AddScieloLink">
								<xsl:with-param name="script">sci_stat</xsl:with-param>
							</xsl:call-template>
							<font class="linkado" size="-1">uso do site</font>
						</a>
						<br/>
					</xsl:if>
					<xsl:if test="ENABLE_CIT_REP_LINK = 1">
						<a>
							<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>bib2jcrp.htm</xsl:attribute>
							<font class="linkado" size="-1">citações de revistas</font>
						</a>
					</xsl:if>
				</td>
			</tr>
		</table>
		<table border="0" width="100%">
			<tr>
				<td align="right" valign="top" width="20%" nowrap="nowrap">
					<br/>
					<br/>
					<a name="explain">&#160;</a>
					<font class="negrito" size="-1">SciELO&#160;&#160;&#160;</font>
				</td>
				<td width="70%">
					<br/>
					<br/>
					<font class="nomodel" size="-1">
		A Scientific Electronic Library Online - SciELO é uma biblioteca virtual que abrange uma coleção selecionada de periódicos científicos brasileiros.<br/>
						<br/>A SciELO é a aplicação de um projeto de pesquisa da Fundação de Amparo à Pesquisa do Estado de São Paulo - <a href="http://www.fapesp.br">FAPESP</a>, em parceria com o Centro Latino-Americano e do Caribe de Informação em Ciências da Saúde - <a href="http://www.bireme.br">BIREME</a>.<br/>
						<br/>O Projeto FAPESP/BIREME tem por objetivo o desenvolvimento de uma metodologia comum para a preparação, armazenamento, disseminação e avaliação da produção científica em formato eletrônico.<br/>
						<br/>Com o avanço das atividades do projeto, novos títulos de periódicos serão incorporados à coleção da biblioteca.<br/>
						<br/>
					</font>
				</td>
				<td width="10%">&#160; 
	</td>
			</tr>
			<tr>
				<td align="right" valign="top" width="20%" nowrap="nowrap">
					<br/>
					<br/>
					<br/>
					<a name="about">&#160;</a>
					<font class="negrito" size="-1">sobre este site&#160;&#160;&#160;</font>
				</td>
				<td width="70%">
					<br/>
					<br/>
					<br/>
					<font class="nomodel" size="-1">
			Esta é a home page do site SciELO.<br/>
						<br/>O objetivo deste site é implementar uma biblioteca eletrônica que possa proporcionar um amplo acesso a coleções de periódicos como um todo, aos fascículos de cada título de periódico, assim como aos textos completos dos artigos. O acesso aos títulos dos periódicos e aos artigos pode ser feito através de índices e de formulários de busca.<br/>
						<br/>O site da SciELO é parte do Projeto FAPESP/BIREME e um dos produtos da aplicação da metodologia para preparação de publicações eletrônicas em desenvolvimento, especialmente o módulo de interface Internet.<br/>
						<br/>Este site é constantemente atualizado tanto no seu formato como no seu conteúdo, de acordo com os avanços e os resultados do projeto.<br/>
					</font>
					<br/>
				</td>
				<td width="10%">&#160;</td>
			</tr>
			<tr>
				<td align="right" valign="top" width="20%" nowrap="nowrap">
					<br/>
					<br/>
					<br/>
					<a name="help">&#160;</a>
					<font class="negrito" size="-1">help&#160;&#160;&#160;</font>
				</td>
				<td width="70%">
					<br/>
					<br/>
					<br/>
					<font class="nomodel" size="-1">
			A interface SciELO proporciona acesso à sua coleção de periódicos através de uma lista alfabética de títulos, ou por meio de um índice de assuntos, ou ainda através de um módulo de busca por palavras do título dos periódicos, pelos nomes das instituições publicadoras, pelo local de publicação e por assunto.<br/>
						<br/>A interface também propicia acesso aos textos completos dos artigos através de índices de autor e de assunto, ou por meio de um formulário de busca dos elementos que compõem um artigo, tais como autor, palavras do título, assunto e palavras do texto.<br/>
						<br/>Clique nas opções marcadas com links para ter acesso às páginas correspondentes.<br/>
					</font>
					<br/>
					<br/>
					<br/>
					<br/>
				</td>
				<td width="10%">&#160;</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="CONTROLINFO[LANGUAGE='es']">
		<p align="center">
			<a href="http://www.scielo.org/index_e.html">
				<img>
					<xsl:attribute name="alt">Scientific Electronic Library Online</xsl:attribute>
					<xsl:attribute name="border">0</xsl:attribute>
					<xsl:attribute name="src"><xsl:value-of select="SCIELO_INFO/PATH_GENIMG"/><xsl:value-of select="LANGUAGE"/>/scielobre.gif</xsl:attribute>
				</img>
			</a>
			<br/>
			<img>
				<xsl:attribute name="src"><xsl:value-of select="SCIELO_INFO/PATH_GENIMG"/>assinat.gif</xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
			</img>
		</p>
		<table border="0">
			<tr>
				<td width="205" valign="top" rowspan="2">
					<!--
			Usuarios no SciELO - Botao de Login
		-->
					<xsl:if test="$show_toolbox = 1">
						<xsl:apply-templates select="//USERINFO" mode="box">
							<xsl:with-param name="lang" select="'es'"/>
						</xsl:apply-templates>
					</xsl:if>
					<!--
			Fim: Usuarios no SciELO - Botao de Login
		-->
					<a href="http://www.scielo.org/index_e.html">
						<font class="linkado" size="-1">SciELO.org</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://www.scielo.org/scielo_org_es.html</xsl:attribute>
						<font class="linkado" size="-1">criterios SciELO</font>
					</a>
					<br/>&#160;<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_home/lng_en/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">english</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_home/lng_pt/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">português</font>
					</a>
					<br/>&#160;<br/>
					<a href="#help">
						<font class="linkado" size="1">ayuda</font>
					</a>
					<br/>
					<a href="#about">
						<font class="linkado" size="-1">acerca deste sitio</font>
					</a>
					<br/>
				</td>
				<td width="205" valign="top">
					<font class="nomodel" color="#800000" size="-1">seriadas</font>
					<br/>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_alphabetic/lng_es/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">lista alfabética</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php/script_sci_subject/lng_es/nrm_iso</xsl:attribute>
						<font class="linkado" size="-1">lista por materia</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=title&amp;fmt=iso.pft&amp;lang=e</xsl:attribute>
						<font class="linkado" size="-1">búsqueda de títulos</font>
					</a>
					<br/>
				</td>
				<td width="205" valign="top">
					<font class="nomodel" color="#800000" size="-1">artículos</font>
					<br/>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;index=AU&amp;fmt=iso.pft&amp;lang=e</xsl:attribute>
						<font class="linkado" size="-1">índice de autores</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;index=KW&amp;fmt=iso.pft&amp;lang=e</xsl:attribute>
						<font class="linkado" size="-1">índice de materia</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;fmt=iso.pft&amp;lang=e</xsl:attribute>
						<font class="linkado" size="-1">búsqueda de artículos</font>
					</a>
					<br/>
				</td>
				<td valign="top" width="205">
					<xsl:if test="ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 ">
						<font class="nomodel" color="#800000" size="-1">informes</font>
						<br/>
						<br/>
					</xsl:if>
					<xsl:if test="ENABLE_STAT_LINK = 1">
						<a>
							<xsl:call-template name="AddScieloLink">
								<xsl:with-param name="script">sci_stat</xsl:with-param>
							</xsl:call-template>
							<font class="linkado" size="-1">uso del sítio</font>
						</a>
						<br/>
					</xsl:if>
					<xsl:if test="ENABLE_CIT_REP_LINK = 1">
						<a>
							<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>bib2jcre.htm</xsl:attribute>
							<font class="linkado" size="-1">citas de revistas</font>
						</a>
					</xsl:if>
				</td>
			</tr>
		</table>
		<table border="0" width="100%">
			<tr>
				<td align="right" valign="top" width="20%" nowrap="nowrap">
					<br/>
					<br/>
					<a name="explain">&#160;</a>
					<font class="negrito" size="-1">SciELO&#160;&#160;&#160;</font>
				</td>
				<td width="70%">
					<br/>
					<br/>
					<font class="nomodel" size="-1">
			La Scientific Electronic Library Online - SciELO es una biblioteca virtual que abarca una colección seleccionada de revistas científicas Brasileñas. <br/>
						<br/>La biblioteca es parte de un proyecto que está siendo desarrollado por la <a href="http://www.fapesp.org">FAPESP</a> - Fundação de Amparo à Pesquisa do Estado de São Paulo, en colaboración con <a href="http://www.bireme.br/bvs/E/ehome.htm">BIREME</a> - Centro Latinoamericano y del Caribe de Información en Ciencias de la Salud.<br/>
						<br/>El proyecto FAPESP/BIREME contempla el desarrollo de una metodología común para la preparación, almacenamiento, diseminación y evaluación de literatura científica en formato electrónico.<br/>
						<br/>Con el desarrollo del proyecto, nuevos títulos serán añadidos a la colección de la biblioteca. <br/>
						<br/>
					</font>
				</td>
				<td width="10%">&#160;</td>
			</tr>
			<tr>
				<td align="right" valign="top" width="20%" nowrap="nowrap">
					<br/>
					<br/>
					<br/>
					<a name="about">&#160;</a>
					<font class="negrito" size="-1">acerca de este sitio&#160;&#160;&#160;</font>
				</td>
				<td width="70%">
					<br/>
					<br/>
					<br/>
					<font class="nomodel" size="-1">
			Esta es la home page del Sitio SciELO.<br/>
						<br/>El objetivo del sitio es implementar una biblioteca electrónica, que proporcione acceso completo a una colección de revistas, una colección de números de revistas individuales, así como al texto completo de los artículos. El acceso tanto a las revistas como a los artículos se puede realizar usando índices y formularios de búsqueda.<br/>
						<br/>El sitio de SciELO es una parte del Proyecto FAPESP/BIREME y es una aplicación de la metodología que el proyecto está desarrollando, en particular, el módulo de Interfase en Internet.<br/>
						<br/>El sitio será constantemente actualizado tanto en forma como en contenido, en la medida en que el proyecto avance.
		</font>
					<br/>
					<br/>
				</td>
				<td width="10%">&#160;</td>
			</tr>
			<tr>
				<td align="right" valign="top" width="20%" nowrap="nowrap">
					<br/>
					<br/>
					<br/>
					<a name="help">&#160;</a>
					<font class="negrito" size="-1">ayuda&#160;&#160;&#160;</font>
				</td>
				<td width="70%">
					<br/>
					<br/>
					<br/>
					<font class="nomodel" size="-1">
			La interfase SciELO proporciona acceso a su colección de revistas mediante una lista alfabética de títulos, un índice de materias, o una búsqueda por palabra de las revistas, nombres de publicadores, ciudad de publicación y materia.<br/>
						<br/>La interfase también proporciona acceso al texto completo de los artículos por medio de un índice de autores, un índice de materias o un formulario de búsqueda por los elementos del artículo como nombres de autores, palabras del título, materias y palabras del texto completo.<br/>
						<br/>Clique un enlace hipertexto para llamar la correspondiente página de acceso.<br/>
					</font>
					<br/>
					<br/>
					<br/>
					<br/>
				</td>
				<td width="10%">&#160;</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="SCIELOINFOGROUP">
		<hr/>
		<p align="center">
			<font class="nomodel" color="#0000A0" size="-1">
				<xsl:value-of select="normalize-space(SITE_NAME)"/>
				<br/>
				<xsl:value-of select="normalize-space(ORGANIZATION)"/>
				<br/>
				<xsl:value-of select="normalize-space(ADDRESS/ADDRESS_1)"/>
				<br/>
				<xsl:value-of select="normalize-space(ADDRESS/ADDRESS_2)"/> - <xsl:value-of select="normalize-space(ADDRESS/COUNTRY)"/>
				<br/>
			Tel.: <xsl:value-of select="normalize-space(PHONE)"/>
				<br/>
			Fax: <xsl:value-of select="normalize-space(FAX)"/>
			</font>
			<br/>
			<a class="email">
				<xsl:attribute name="href">mailto:<xsl:value-of select="normalize-space(EMAIL)"/></xsl:attribute>
				<img>
					<xsl:attribute name="src"><xsl:value-of select="//PATH_GENIMG"/>e-mailt.gif</xsl:attribute>
					<xsl:attribute name="border">0</xsl:attribute>
				</img>
				<br/>
				<font color="#0000A0" size="2">
					<xsl:value-of select="normalize-space(EMAIL)"/>
				</font>
			</a>
		</p>
		<xsl:call-template name="UpdateLog"/>
	</xsl:template>
	<xsl:template match="USERINFO" mode="box">
		<xsl:param name="lang"/>
		<xsl:variable name="STATUS" select="@status"/>
		<xsl:if test="$STATUS = 'logout'">
			<p>
				<a href="http://{$SCIELO_REGIONAL_DOMAIN}/{$login_url}">
					<xsl:choose>
						<xsl:when test="$lang = 'pt'">
							<span>Efetuar Login</span>
						</xsl:when>
						<xsl:when test="$lang = 'en'">
							<span>Login</span>
						</xsl:when>
						<xsl:when test="$lang = 'es'">
							<span>Login</span>
						</xsl:when>
					</xsl:choose>
				</a>
			</p>
		</xsl:if>
		<xsl:if test="$STATUS = 'login'">
			<p>
				<xsl:choose>
					<xsl:when test="$lang = 'pt'">
						Bem Vindo
					</xsl:when>
					<xsl:when test="$lang = 'en'">
						Welcome
					</xsl:when>
					<xsl:when test="$lang = 'es'">
						Bien Vindo
					</xsl:when>
				</xsl:choose>
					: <xsl:value-of select="."/>
			</p>
			<p>
				<a href="http://{$SCIELO_REGIONAL_DOMAIN}/{$logout_url}">
					<xsl:choose>
						<xsl:when test="$lang = 'pt'">
							<span>Sair</span>
						</xsl:when>
						<xsl:when test="$lang = 'en'">
							<span>Logout</span>
						</xsl:when>
						<xsl:when test="$lang = 'es'">
							<span>Salir</span>
						</xsl:when>
					</xsl:choose>
				</a>
			</p>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>