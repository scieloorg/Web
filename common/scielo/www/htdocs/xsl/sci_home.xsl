<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:variable name="SCIELO_REGIONAL_DOMAIN" select="//SCIELO_REGIONAL_DOMAIN"/>
	<xsl:variable name="show_toolbox" select="//toolbox"/>
	<xsl:variable name="show_login" select="//show_login"/>
	<xsl:variable name="login_url" select="//loginURL"/>
	<xsl:variable name="logout_url" select="//logoutURL"/>
	<xsl:output method="html" indent="no"/>
	<xsl:include href="sci_common.xsl"/>
	<xsl:variable name="FILE" select="concat('../custom/',//CONTROLINFO/APP_NAME,'/xml/',//CONTROLINFO/LANGUAGE,'/sci_home.xml')"/>
	<xsl:variable name="LEFT" select="document(concat('../custom/',//CONTROLINFO/APP_NAME,'/xml/',//CONTROLINFO/LANGUAGE,'/sci_home_left.xml'))"/>
	<xsl:variable name="LABELS" select="concat('../xml/',//CONTROLINFO/LANGUAGE,'/sci_home_labels.xml')"/>
	<xsl:variable name="document_labels" select="document($LABELS)"/>
	<xsl:template match="HOMEPAGE">
		<html>
			<head>
				<title>SciELO - Scientific electronic library online</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="STYLESHEET" type="text/css" href="/css/scielo.css"/>
			</head>
			<body link="#000080" vlink="#800080" bgcolor="#ffffff">
				<xsl:apply-templates select="CONTROLINFO" mode="test"/>
				<xsl:apply-templates select="SCIELOINFOGROUP"/>
				<br/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="language_link">
		<xsl:param name="label"/>
		<xsl:param name="value"/>
		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_home&amp;lng=<xsl:value-of select="$value"/>&amp;nrm=iso</xsl:attribute>
			<font class="linkado" size="-1">
				<xsl:value-of select="$label"/>
			</font>
		</a>
		<br/>
	</xsl:template>
	<xsl:template match="CONTROLINFO" mode="menus_home">
		<xsl:variable name="LANGUAGE">
			<xsl:choose>
				<xsl:when test="LANGUAGE='en'">i</xsl:when>
				<xsl:when test="LANGUAGE='es'">e</xsl:when>
				<xsl:when test="LANGUAGE='pt'">p</xsl:when>
			</xsl:choose>
		</xsl:variable>
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
					<!-- fixed_20051025 abel a>
						<xsl:attribute name="href">http://www.scielo.org/scielo_org_en.html</xsl:attribute>
						<font class="linkado" size="-1">criteria SciELO</font>
					</a>
					<br/>&#160;<br/-->
					<xsl:if test="LANGUAGE!='pt'">
						<xsl:call-template name="language_link">
							<xsl:with-param name="label">português</xsl:with-param>
							<xsl:with-param name="value">pt</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="LANGUAGE!='es'">
						<xsl:call-template name="language_link">
							<xsl:with-param name="label">español</xsl:with-param>
							<xsl:with-param name="value">es</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="LANGUAGE!='en'">
						<xsl:call-template name="language_link">
							<xsl:with-param name="label">English</xsl:with-param>
							<xsl:with-param name="value">en</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<!--a href="#help">
						<font class="linkado" size="1">help</font>
					</a>
					<br/>
					<a href="#about">
						<font class="linkado" size="-1">about this site</font>
					</a>
					<br/-->
					<xsl:copy-of select="$LEFT//left/*"/>
				</td>
				<td width="205" valign="top">
					<font class="nomodel" color="#800000" size="-1">
						<xsl:value-of select="$document_labels//label[@id='serial browsing']"/>
					</font>
					<br/>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_alphabetic&amp;lng=<xsl:value-of select="LANGUAGE"/>&amp;nrm=iso</xsl:attribute>
						<font class="linkado" size="-1">
							<xsl:value-of select="$document_labels//label[@id='alphabetic list']"/>
						</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_subject&amp;lng=<xsl:value-of select="LANGUAGE"/>&amp;nrm=iso</xsl:attribute>
						<font class="linkado" size="-1">
							<xsl:value-of select="$document_labels//label[@id='subject list']"/>
						</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=title&amp;fmt=iso.pft&amp;lang=<xsl:value-of select="$LANGUAGE"/></xsl:attribute>
						<font class="linkado" size="-1">
							<xsl:value-of select="$document_labels//label[@id='search form']"/>
						</font>
					</a>
					<br/>
				</td>
				<td width="205" valign="top">
					<font class="nomodel" color="#800000" size="-1">
						<xsl:value-of select="$document_labels//label[@id='article browsing']"/>
					</font>
					<br/>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;index=AU&amp;fmt=iso.pft&amp;lang=<xsl:value-of select="$LANGUAGE"/></xsl:attribute>
						<font class="linkado" size="-1">
							<xsl:value-of select="$document_labels//label[@id='author index']"/>
						</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;index=KW&amp;fmt=iso.pft&amp;lang=<xsl:value-of select="$LANGUAGE"/></xsl:attribute>
						<font class="linkado" size="-1">
							<xsl:value-of select="$document_labels//label[@id='subject index']"/>
						</font>
					</a>
					<br/>
					<a>
						<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;fmt=iso.pft&amp;lang=<xsl:value-of select="$LANGUAGE"/></xsl:attribute>
						<font class="linkado" size="-1">
							<xsl:value-of select="$document_labels//label[@id='search form2']"/>
						</font>
					</a>
					<br/>
				</td>
				<td valign="top" width="205">
					<xsl:if test="ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 ">
						<font class="nomodel" color="#800000" size="-1">
							<xsl:value-of select="$document_labels//label[@id='reports']"/>
						</font>
						<br/>
						<br/>
					</xsl:if>
					<xsl:if test="ENABLE_STAT_LINK = 1">
						<a>
							<!--xsl:call-template name="AddScieloLink">
								<xsl:with-param name="script">sci_stat</xsl:with-param>
							</xsl:call-template-->
							<xsl:attribute name="href">http://logs.bireme.br/cgi-bin/awstats.pl?config=socialsciences</xsl:attribute>
							<font class="linkado" size="-1">
								<xsl:value-of select="$document_labels//label[@id='site usage']"/>
							</font>
						</a>
						<br/>
					</xsl:if>
					<xsl:if test="ENABLE_CIT_REP_LINK = 1">
						<a>
							<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>bib2jcr.htm</xsl:attribute>
							<font class="linkado" size="-1">
								<xsl:value-of select="$document_labels//label[@id='journal citation']"/>
							</font>
						</a>
					</xsl:if>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="CONTROLINFO" mode="test">
		<xsl:param name="xml"/>
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
		<xsl:apply-templates select="." mode="menus_home"/>
		<xsl:copy-of select="document($FILE)/*"/>
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
		<xsl:if test="$STATUS = 'logout' and $show_login=1">
			<p>
				<a href="http://{$SCIELO_REGIONAL_DOMAIN}/{$login_url}?lang={$lang}">
					<xsl:choose>
						<xsl:when test="$lang = 'pt'">
							<span>Registre-se Gratuitamente</span>
						</xsl:when>
						<xsl:when test="$lang = 'en'">
							<span>Free sign up</span>
						</xsl:when>
						<xsl:when test="$lang = 'es'">
							<span>Regístrese Gratuitamente</span>
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
