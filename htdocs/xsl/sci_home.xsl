<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="SCIELO_REGIONAL_DOMAIN" select="//SCIELO_REGIONAL_DOMAIN"/>
	<xsl:variable name="show_toolbox" select="//toolbox"/>
	<xsl:variable name="show_login" select="//show_login"/>
	<xsl:variable name="login_url" select="//loginURL"/>
	<xsl:variable name="logout_url" select="//logoutURL"/>

	<xsl:output method="html" indent="no"/>
	<xsl:include href="sci_navegation.xsl"/>

<xsl:template match="HOMEPAGE">
	<html>
		<head>
			<title>SciELO - Scientific electronic library online</title>
			<meta http-equiv="Pragma" content="no-cache" />
			<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
			<xsl:if test="//NEW_HOME">
				<xsl:variable name="X" select="//NEW_HOME"/>
				<meta HTTP-EQUIV="REFRESH">
					<xsl:attribute name="Content"><xsl:value-of select="concat('0;URL=',$X)"/></xsl:attribute>
				</meta>

			</xsl:if>
			<link rel="STYLESHEET" type="text/css" href="/css/scielo.css" />
		</head>
		<xsl:if test="not(//NEW_HOME)">
		<body link="#000080" vlink="#800080" bgcolor="#ffffff">
			<xsl:apply-templates select="CONTROLINFO" />
			<xsl:apply-templates select="SCIELOINFOGROUP" />
		</body>
					</xsl:if>
	</html>
</xsl:template>
<xsl:template name="link-ext">
</xsl:template>
<xsl:template match="CONTROLINFO">
	<p align="center">
		<a href="http://www.scielo.org/php/index.php?lang=en">
			<img>
				<xsl:attribute name="alt">Scientific Electronic Library Online</xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
				<xsl:attribute name="src"><xsl:value-of
					select="SCIELO_INFO/PATH_GENIMG" /><xsl:value-of 
				select="LANGUAGE" />/scielobre.gif</xsl:attribute>
			</img>
		</a><br/>
		<img>
			<xsl:attribute name="src"><xsl:value-of 
				select="SCIELO_INFO/PATH_GENIMG" /><!--xsl:value-of 
				select="LANGUAGE" /-->assinat.gif</xsl:attribute>
			<xsl:attribute name="border">0</xsl:attribute>
		</img>
	</p>
	
	<table border="0">
	<tr>
		<td width="205" valign="top" rowspan="2">
        <xsl:if test="$show_login = 1">
            <xsl:apply-templates select="//USERINFO" mode="box">
                <xsl:with-param name="lang" select="'en'"/>
            </xsl:apply-templates>
        </xsl:if>
		<a href="http://www.scielo.org/php/index.php?lang=en">
			<font class="linkado" size="-1">SciELO.org</font>
		</a><br/>

        <a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA"/>avaliacao/avaliacao_en.htm</xsl:attribute>		
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='journals_evaluation']"/></font>
		</a><br/>
        <xsl:if test="//CONTROLINFO/LANGUAGE != 'pt'">
		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_home&amp;lng=pt&amp;nrm=iso</xsl:attribute>
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='portuguese']"/></font>
		</a><br/>
        </xsl:if>
        <xsl:if test="//CONTROLINFO/LANGUAGE != 'en'">
		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_home&amp;lng=en&amp;nrm=iso</xsl:attribute>
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='english']"/></font>
		</a><br/>
        </xsl:if>
        <xsl:if test="//CONTROLINFO/LANGUAGE != 'es'">
		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_home&amp;lng=es&amp;nrm=iso</xsl:attribute>

			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='spanish']"/></font>
		</a><br/>
        </xsl:if>
        <br/>

		<a href="#help">
			<font class="linkado" size="1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='help']"/></font>
		</a><br/>

		<a href="#about">
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='about_this_site']"/></font>
		</a><br/>

		<a href="http://listas.bireme.br/mailman/listinfo/scieloi-l">
			<font class="linkado" size="1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='scielo_news']"/></font>
		</a><br/>

		<a> 
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA"/>equipe/equipe_i.htm</xsl:attribute>

			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='scielo_team']"/></font>
		</a><br/>

	</td>

	<td width="205" valign="top">
		<font class="nomodel" color="#800000" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='serial_browsing']"/></font><br/><br/>

		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_alphabetic&amp;lng=en&amp;nrm=iso</xsl:attribute>

			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='alphabetic_list']"/></font>
		</a><br/>

		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_subject&amp;lng=en&amp;nrm=iso</xsl:attribute>

			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='subject_list']"/></font>
		</a><br/>

		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of 
				select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=title&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>

			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='search_form']"/></font>
		</a><br/>
	</td>

	<td width="205" valign="top">
		<font class="nomodel" color="#800000" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='article_browsing']"/></font><br/><br/>

		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of 
				select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;index=AU&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>

			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='author_index']"/></font>
		</a><br/>

		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of 
				select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;index=KW&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>

			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='subject_index']"/></font>
		</a><br/>

		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_WXIS"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of 
				select="SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=article^dlibrary&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>

			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='search_form']"/></font>
		</a><br/>
	</td>    

	<td valign="top" width="205">
		<xsl:if test="ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 ">
		<font class="nomodel" color="#800000" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='reports']"/></font><br/><br/>
		</xsl:if>
		<xsl:if test="ENABLE_STAT_LINK = 1">
		<a>
			<xsl:call-template name="AddScieloLink">
				<xsl:with-param name="script">sci_stat</xsl:with-param>   
			</xsl:call-template>
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='site_usage']"/></font>
		</a><br/>
		</xsl:if>
		<xsl:if test="ENABLE_CIT_REP_LINK = 1">
		<!--a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of
				 select="SCIELO_INFO/PATH_DATA" />bib2jcr.htm</xsl:attribute>
			<font class="linkado" size="-1">journal citation</font>
		</a-->
		<a href="{SCIELO_INFO/STAT_SERVER}stat_biblio/index.php?lang={LANGUAGE}">
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='journal_citation']"/></font>
		</a>
		<br/>
		<a href="{SCIELO_INFO/STAT_SERVER}stat_biblio/index.php?xml={SCIELO_INFO/STAT_SERVER}stat_biblio/xml/16.xml&amp;lang={LANGUAGE}&amp;state=16">
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='co_authors']"/></font>
		</a>
		</xsl:if>
	</td>	
	</tr>
	</table>
	<table width="100%" border="0">
		<tr>
		<td valign="top" align="right" nowrap="nowrap"  width="20%">
			<a name="explain">&#160;</a>
			<font class="negrito" size="-1">SciELO&#160;&#160;&#160;</font>
		</td>

		<td width="70%">
			<font class="nomodel" size="-1">
                <xsl:copy-of select="$translations/xslid[@id='sci_home']/text[@find='text_1']"/>
			</font>
		</td>

		<td width="10%">&#160;</td>
		</tr>
		<tr>
		<td valign="top" align="right" nowrap="nowrap"  width="20%">
			<br/><br/><br/>
			<a name="about">&#160;</a>
			<font class="negrito" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='about_this_site']"/>&#160;&#160;&#160;</font>
		</td>

		<td width="70%">
			<br/><br/><br/>
			<font class="nomodel" size="-1"><xsl:copy-of select="$translations/xslid[@id='sci_home']/text[@find='text_2']"/></font>
		</td>

		<td width="10%">&#160;</td>
		</tr>

		<tr>
		<td valign="top" align="right" nowrap="nowrap"  width="20%">
			<br/><br/><br/>
			<a name="help">&#160;</a>
			<font class="negrito" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='help']"/>&#160;&#160;&#160;</font>
		</td>

		<td width="70%">
			<br/><br/><br/>
			<font class="nomodel" size="-1"><xsl:copy-of select="$translations/xslid[@id='sci_home']/text[@find='text_3']"/></font>
			<br/><br/><br/>
		</td>

		<td width="10%">&#160;</td>
		</tr>
		</table>
</xsl:template>

<xsl:template match="SCIELOINFOGROUP">
	<hr/>
	<p align="center">
		<font class="nomodel" color="#0000A0" size="-1">
			<xsl:value-of select="normalize-space(SITE_NAME)" /><br/>
			<xsl:value-of select="normalize-space(ORGANIZATION)" /><br/>
			<xsl:value-of select="normalize-space(ADDRESS/ADDRESS_1)" /><br/>
			<xsl:value-of 
				select="normalize-space(ADDRESS/ADDRESS_2)" /> - <xsl:value-of 
				select="normalize-space(ADDRESS/COUNTRY)" /><br/>
			<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='phone']"/>: <xsl:value-of select="normalize-space(PHONE)" /><br/>
			<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='fax']"/>: <xsl:value-of select="normalize-space(FAX)" />
		</font><br/>

		<a class="email">
			<xsl:attribute name="href">mailto:<xsl:value-of select="normalize-space(EMAIL)" /></xsl:attribute>
			<img> 
				<xsl:attribute name="src"><xsl:value-of select="//PATH_GENIMG" />e-mailt.gif</xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
			</img><br/>
			<font color="#0000A0" size="2"><xsl:value-of select="normalize-space(EMAIL)" /></font>
		</a>
	</p>
	<xsl:call-template name="UpdateLog" />
</xsl:template>
	<xsl:template match="USERINFO" mode="box">
		<xsl:param name="lang"/>
		<xsl:variable name="STATUS" select="@status"/>
		<xsl:if test="$STATUS = 'logout' and $show_login=1">
			<p>
				<a href="http://{$SCIELO_REGIONAL_DOMAIN}/{$login_url}?lang={$lang}"><span><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='register_free']"/></span></a>
			</p>
		</xsl:if>
		<xsl:if test="$STATUS = 'login'">
			<p><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='welcome']"/>: <xsl:value-of select="."/></p>
			<p>
				<a href="http://{$SCIELO_REGIONAL_DOMAIN}/{$logout_url}"><span><xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='logout']"/></span></a>
			</p>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>

