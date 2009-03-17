<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="sci_error.xsl"/>
	<xsl:variable name="forceType" select="//CONTROLINFO/ENABLE_FORCETYPE"/>
	<xsl:variable name="ISSN" select="concat(substring-before(/SERIAL/ISSN,'-'),substring-after(/SERIAL/ISSN,'-'))" />
	<xsl:variable name="show_scimago" select="//show_scimago"/>
	<xsl:variable name="scimago_status" select="//scimago_status"/>
	<xsl:output method="html" indent="no"/>
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
				<!-- link pro RSS aparecer automaticamente no Browser -->
				<xsl:call-template name="AddRssHeaderLink">
					<xsl:with-param name="pid" select="//CURRENT/@PID"/>
					<xsl:with-param name="lang" select="//LANGUAGE"/>
					<xsl:with-param name="server" select="CONTROLINFO/SCIELO_INFO/SERVER"/>
					<xsl:with-param name="script">rss.php</xsl:with-param>
				</xsl:call-template>
			</head>
			<body bgcolor="#FFFFFF" link="#000080" vlink="#800080">
			
			<xsl:if test="//NO_SCI_SERIAL!='yes' or not(//NO_SCI_SERIAL)">

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
				
				<div class="content">

				<xsl:apply-templates select="CONTROLINFO">
					<xsl:with-param name="YEAR" select="substring(@LASTUPDT,1,4)"/>
					<xsl:with-param name="MONTH" select="substring(@LASTUPDT,5,2)"/>
					<xsl:with-param name="DAY" select="substring(@LASTUPDT,7,2)"/>
				</xsl:apply-templates>
				<br/>
				</div>
				<xsl:apply-templates select="." mode="footer-journal"/>
				</xsl:if>

			</body>
		</html>
	</xsl:template>
	<xsl:template match="PUBLISHER">
		<xsl:value-of select="NAME" disable-output-escaping="yes"/>
		<br/>
	</xsl:template>
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
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_home&amp;lng=pt&amp;nrm=iso</xsl:attribute>
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='portuguese']"/></font>
		</a><br/>
        </xsl:if>
        <xsl:if test="//CONTROLINFO/LANGUAGE != 'en'">
		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_home&amp;lng=en&amp;nrm=iso</xsl:attribute>
			<font class="linkado" size="-1"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='english']"/></font>
		</a><br/>
        </xsl:if>
        <xsl:if test="//CONTROLINFO/LANGUAGE != 'es'">
		<a>
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of 
				select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_home&amp;lng=es&amp;nrm=iso</xsl:attribute>

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
		<a class="optionsMenu">
			<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_SERIAL_HTML"/><xsl:value-of select="/SERIAL/TITLEGROUP/SIGLUM"/>/<xsl:value-of select="$pref"/><xsl:if test="$itemName2"><xsl:value-of select="$itemName2"/></xsl:if><xsl:if test="not($itemName2)"><xsl:value-of select="$itemName"/></xsl:if>.htm</xsl:attribute>
			<xsl:apply-templates select="." mode="link-text">
				<xsl:with-param name="type" select="$itemName"/>
			</xsl:apply-templates>
		</a>
		<br/>
	</xsl:template>
	<!--
		formacao dos links das páginas secundárias
	-->		
	<xsl:template match="CONTROLINFO" mode="links">
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
			<a class="optionsMenu" href="{SCIELO_INFO/STAT_SERVER}stat_biblio/index.php?lang={LANGUAGE}&amp;issn={/SERIAL/ISSN}">
				<xsl:apply-templates select="." mode="link-text">
					<xsl:with-param name="type" select="'statistic'"/>
				</xsl:apply-templates>
				<br/>
			</a>
		</xsl:if>
		
		
		<!--link de submissão-->	
		<xsl:apply-templates select="..//link[@type='online-submission']"/>
			<div class="optionsSubMenu">
			<!--SCIMAGO CONSULTA ../XML/SCIIMAGO.XML-->
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
			</xsl:template>
	
			
	<xsl:template match="link">
		<a class="optionsMenu" href="{.}" target="subm">
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
		<table cellspacing="0" border="0" cellpadding="7" width="100%">
			<tr>
				<td width="30%" align="LEFT" valign="TOP">
					<p class="nomodel" align="left">
						<xsl:apply-templates select="." mode="change-language"/>
					</p>
					<p class="nomodel" align="left">
						<font class="nomodel" color="#000080">
							<xsl:apply-templates select="." mode="update-date"/>
							<br/>
							<xsl:call-template name="GET_MONTH_NAME">
								<xsl:with-param name="LANG" select="LANGUAGE"/>
								<xsl:with-param name="MONTH" select="$MONTH"/>
							</xsl:call-template>&#160;<xsl:value-of select="$DAY"/>,&#160;<xsl:value-of select="$YEAR"/>
						</font>
					</p>
					<br/>
					<xsl:apply-templates select="." mode="links"/>
				</td>
				<td width="70%" align="LEFT" valign="TOP">
					<p align="left">
						<xsl:call-template name="ImageLogo">
							<xsl:with-param name="src">
								<xsl:value-of select="SCIELO_INFO/PATH_SERIMG"/>
								<xsl:value-of select="/SERIAL/TITLEGROUP/SIGLUM"/>/glogo.gif</xsl:with-param>
							<xsl:with-param name="alt">
								<xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/>
							</xsl:with-param>
						</xsl:call-template>
						<br/>
						<br/>
						<xsl:apply-templates select="/SERIAL/ISSN">
							<xsl:with-param name="LANG" select="normalize-space(LANGUAGE)"/>
							<xsl:with-param name="SERIAL" select="1"/>
						</xsl:apply-templates>
					</p>
					<p align="left">
						<font color="#000080">
							<xsl:apply-templates select="." mode="text-publication-of"/>
							<br/>
							<xsl:apply-templates select="/SERIAL/PUBLISHERS/PUBLISHER"/>
						</font>
						<font color="#800000">
							<br/>
						</font>
						<xsl:apply-templates select="." mode="text-mission"/>
						<br/>
						<xsl:apply-templates select="/SERIAL/MISSION"/>
						<xsl:apply-templates select="/SERIAL/CHANGESINFO">
							<xsl:with-param name="LANG" select="normalize-space(LANGUAGE)"/>
						</xsl:apply-templates>
					</p>
				</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>

