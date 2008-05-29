<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes" indent="no"/>
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="sci_error.xsl"/>
	<xsl:variable name="PAGINATION" select="//PAGINATION"/>
	<xsl:template match="SERIAL">
		<HTML>
			<HEAD>
				<TITLE>
					<xsl:value-of select="//TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/> - <xsl:call-template name="GetStrip">
						<xsl:with-param name="vol" select="//ISSUE/@VOL"/>
						<xsl:with-param name="num" select="//ISSUE/@NUM"/>
						<xsl:with-param name="suppl" select="//ISSUE/@SUPPL"/>
						<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
					</xsl:call-template>
				</TITLE>
				<LINK href="/css/scielo.css" type="text/css" rel="STYLESHEET"/>
				<style type="text/css">
	div.browse h1 		{ margin-bottom: 20px; margin-right: 140px;}
div.browse #search-results { margin-left: 0; margin-right: 140px; padding-left: 20px; border-left: 240px solid #eee;}
div.browse div#search-results	{ z-index: 69; position: relative;}
div#browseNav 		{ float: left; position: relative; z-index: 70; width: 240px;  padding: 0; background: #eee; margin-bottom: 20px; padding-bottom: 20px; min-height: 480px;}
#browseNav li 		{ font-size: .9em; font-weight: bold; padding: 0;margin: 0; }
#browseNav li input { position: relative; }
#browseNav ul		{ padding: 0; }
#browseNav ul li	{ background: url(../images/pone_browsenav_li.gif) no-repeat 0 8px; list-style-type: none; padding-left: 10px; }
#browseNav ul.subjects li { float:none; } /* fix for wrapping problem in IE7 -SWT */
named-content[content-type="genus-species"] { font-style:italic; } /* italicizes genus and species names in titles returned by browse pages */

/*--- Browse By Publication Date ----*/
#browseNav ol 		{ list-style-type: none; padding: 0 6px 0 15px; margin: 0; float: left;clear: left; width: auto;margin-top: 5px;}
#browseNav li li 	{ float: left;text-align:center; margin: 0; }
#browseNav li ol	{ display: block; clear: left; padding: 0; }
#browseNav li		{ clear: left; float: left;}
#browseNav li li	{ clear: none; }

#browseNav ol a:link,
#browseNav ol a:visited 	{ display: block; width: 32px; margin: 4px 0; text-align: center;}

#browseNav li .month {width: 62px}

/*--- Browse Form ---- */

/* ------ Search Styles ----*/

#search-results ul 		{ margin: 0 30px 0 0; padding: 0; list-style-type: none; line-height: 1.6em;}
#search-results li		{ margin: 12px 8px; background: url(../images/pone_sectionnav_li_bg.gif) no-repeat 0 4px; padding-left: 12px; }
#search-results li span	{ display: block; }
#search-results span.article { font-weight: bold; font-size: 1.2em;}
#search-results span.date { color: #666; font-weight: normal; font-size: .9em; }
#search-results span.cite { font-style: italic;  color: #666; }
#search-results span.highlight { font-weight: bold; display: inline;}
#search-results span.authors { font-size: .9em; }
div.resultsTab { border: 2px solid #ccc; padding: 5px; background: #eee; margin: 20px 0;}
div.resultsTab a { margin: 0 4px; padding: 0 2px;}

div.date {color: gray; font-size: .9em}
li.current { list-style-type: none!important; background: url(../images/pone_li_current.gif) no-repeat 0 8px!important; font-size: 1em!important;}
ol li.current { background: none!important; font-size: inherit;}
ol li.current * { color: #000; text-decoration: none; background: none; cursor: default;}
.invisible {display: none}

   </style>
				<META http-equiv="Pragma" content="no-cache"/>
				<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<!-- link pro RSS aparecer automaticamente no Browser -->
				<xsl:call-template name="AddRssHeaderLink">
					<xsl:with-param name="pid"><xsl:value-of select="//CURRENT/@PID"/></xsl:with-param>
					<xsl:with-param name="lang"><xsl:value-of select="//LANGUAGE"/></xsl:with-param>
					<xsl:with-param name="server"><xsl:value-of select="CONTROLINFO/SCIELO_INFO/SERVER"/></xsl:with-param>
					<xsl:with-param name="script">rss.php</xsl:with-param>
				</xsl:call-template>

			</HEAD>
			<BODY vLink="#800080" bgColor="#ffffff">
				<xsl:call-template name="NAVBAR">
					<xsl:with-param name="bar1">issues</xsl:with-param>
					<xsl:with-param name="bar2">articlesiah</xsl:with-param>
					<xsl:with-param name="scope"><xsl:choose>
						<xsl:when test="string-length(//TITLEGROUP/SIGLUM) &gt; 0"><xsl:value-of select="//TITLEGROUP/SIGLUM"/></xsl:when><xsl:otherwise>library</xsl:otherwise>
					</xsl:choose></xsl:with-param>
					<xsl:with-param name="home">1</xsl:with-param>
					<xsl:with-param name="alpha">
						<xsl:choose>
							<xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' ">0</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:apply-templates select="//TITLEGROUP"/>
				<CENTER>
					<FONT color="#000080">
						<xsl:apply-templates select="//ISSN">
							<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
						</xsl:apply-templates>
					</FONT>
				</CENTER>
				<br/>
				<TABLE width="100%" border="0">
					<TBODY>
						<TR>
							<TD width="8%">&#160;</TD>
							<TD width="20%" valign="top">
								<xsl:apply-templates select="CALENDAR"/>
							</TD>
							<TD width="62%" valign="top">
								<P align="left">
									<xsl:apply-templates select="TITLE"/>
									<xsl:apply-templates select="STRIP"/>
								</P>
								<div id="search-results">
									<p>
										<strong>
											<xsl:value-of select="ARTICLE[1]/@i"/> - <xsl:value-of select="ARTICLE[position()=last()]/@i"/>
										</strong> of <strong>
											<xsl:value-of select="//PAGINATION/total"/>
										</strong>
									</p>
									<xsl:apply-templates select="//PAGINATION"/>
								</div>
								<table border="0">
									<tbody>
										<xsl:apply-templates select="ARTICLE"/>
									</tbody>
								</table>
								<xsl:apply-templates select="//PAGINATION"/>
							</TD>
						</TR>
					</TBODY>
				</TABLE>
				<HR/>
				<P align="center">
					<xsl:apply-templates select="//COPYRIGHT"/>
					<xsl:apply-templates select="//CONTACT"/>
				</P>
			</BODY>
		</HTML>
	</xsl:template>
	<xsl:template match="TITLE">
		<FONT COLOR="#005E5E">
			<B>
				<xsl:value-of select="." disable-output-escaping="yes"/>
			</B>
		</FONT>
		<BR/>
		<BR/>
	</xsl:template>
	<xsl:template match="STRIP">
		<FONT class="nomodel" color="#800000">
			<xsl:choose>
				<xsl:when test="//CONTROLINFO[LANGUAGE='en']">Table of contents</xsl:when>
				<xsl:when test="//CONTROLINFO[LANGUAGE='es']">Tabla de contenido</xsl:when>
				<xsl:when test="//CONTROLINFO[LANGUAGE='pt']">Sumário</xsl:when>
			</xsl:choose>
		</FONT>
		<BR/>
		<font color="#800000">
			<xsl:call-template name="SHOWSTRIP">
				<xsl:with-param name="SHORTTITLE" select="SHORTTITLE"/>
				<xsl:with-param name="VOL" select="VOL"/>
				<xsl:with-param name="NUM" select="NUM"/>
				<xsl:with-param name="SUPPL" select="SUPPL"/>
				<xsl:with-param name="CITY" select="CITY"/>
				<xsl:with-param name="MONTH" select="MONTH"/>
				<xsl:with-param name="YEAR" select="YEAR"/>
			</xsl:call-template>
		</font>
	</xsl:template>
	<xsl:template match="ARTICLE">
		<tr valign="top">
			<!-- If there was a section name -->
			<xsl:if test="../NAME">
				<td>&#160;</td>
			</xsl:if>
			<td width="5%" valign="top">
				<xsl:value-of select="@i"/>/<xsl:value-of select="$PAGINATION/total"/>
			</td>
			<td>
				<xsl:if test="//ISSUE/SECTION/NAME and not(../NAME)">
					<!-- This section has no name but there is another session with name inside the TOC -->
					<xsl:attribute name="colspan">2</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="TITLE and ../NAME">
						<FONT class="normal">
							<font face="Symbol">·</font> &#160;</FONT>
					</xsl:when>
				</xsl:choose>
				<div class="date">
					<xsl:apply-templates select="@entrdate"/>
				</div>
				<xsl:if test="TITLE">
					<FONT class="normal">
						<B>
							<xsl:value-of select="TITLE" disable-output-escaping="yes"/>
						</B>
					</FONT>
					<br/>
				</xsl:if>
				<FONT class="normal">
					<xsl:apply-templates select="AUTHORS">
						<xsl:with-param name="NORM" select="//CONTROLINFO/STANDARD"/>
						<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
						<xsl:with-param name="AUTHLINK">1</xsl:with-param>
					</xsl:apply-templates>
				</FONT>
				<xsl:if test="TITLE">
					<br/>
					<br/>
				</xsl:if>
				<!-- CENTER -->
				<xsl:apply-templates select="LANGUAGES">
					<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
					<xsl:with-param name="PID" select="@PID"/>
					<xsl:with-param name="VERIFY" select="/SERIAL/DEBUG/@VERIFY"/>
				</xsl:apply-templates>
				<!-- /CENTER -->
				<tr>
					<td>&#160;</td>
					<xsl:if test="//ISSUE/SECTION/NAME">
						<td>&#160;</td>
					</xsl:if>
				</tr>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="CALENDAR">
		<div id="browseNav">
			<ol>
				<xsl:apply-templates select="YEAR"/>
			</ol>
		</div>
	</xsl:template>
	<xsl:template match="YEAR">
		<li>
			<!--a>
				<xsl:apply-templates select="." mode="link2list">
					<xsl:with-param name="date" select="@key"/>
				</xsl:apply-templates>
				<xsl:value-of select="@value"/>
			</a-->
			<xsl:value-of select="@value"/>
		</li>
		<xsl:apply-templates select="MONTH"/>
	</xsl:template>
	<xsl:template match="MONTH">
		<li>
			<ol>
				<li class="month">
					<a>
						<xsl:apply-templates select="." mode="link2list">
							<xsl:with-param name="date" select="@key"/>
						</xsl:apply-templates>
						<xsl:value-of select="@name"/>
					</a>
				</li>
				<xsl:apply-templates select="DAY"/>
			</ol>
		</li>
	</xsl:template>
	<xsl:template match="DAY">
		<li>
			<a>
				<xsl:apply-templates select="." mode="link2list">
					<xsl:with-param name="date" select="@key"/>
				</xsl:apply-templates>
				<xsl:value-of select="@value"/>
			</a>
		</li>
	</xsl:template>
	<xsl:template match="*" mode="link2list">
		<xsl:param name="date"/>
		<xsl:param name="page"/>
		<xsl:call-template name="AddScieloLink">
			<xsl:with-param name="seq" select="$PAGINATION/@journal"/>
			<xsl:with-param name="script">sci_artlist</xsl:with-param>			
			<xsl:with-param name="date" select="$date"/>
			<xsl:with-param name="page" select="$page"/>

		</xsl:call-template>
	</xsl:template>
	<xsl:template match="PAGINATION">
		<div class="resultsTab">
			<xsl:if test="//PAGE[@selected]/@NUM != '1'">
				<!-- previous -->
				<a>
					<xsl:apply-templates select="." mode="link2list">
						<xsl:with-param name="page" select="//PAGE[@selected]/@NUM - 1"/>
					</xsl:apply-templates>&lt;

					<xsl:choose>			<xsl:when test="$interfaceLang='pt'">Anterior </xsl:when>
			<xsl:when test="$interfaceLang='es'">Anterior </xsl:when>
			<xsl:when test="$interfaceLang='en'">Previous </xsl:when>
		</xsl:choose>
				</a>
			</xsl:if>
			<xsl:apply-templates select=".//PAGE"/>
			<xsl:if test="//PAGE[@selected]/@NUM != //PAGE[position()=last()]/@NUM">
				<!-- next -->
				<a>
					<xsl:apply-templates select="." mode="link2list">
						<xsl:with-param name="page" select="//PAGE[@selected]/@NUM + 1"/>
					</xsl:apply-templates>
					<xsl:choose> 
			<xsl:when test="$interfaceLang='pt'">Próxima </xsl:when>
			<xsl:when test="$interfaceLang='es'">Próxima </xsl:when>
			<xsl:when test="$interfaceLang='en'">Next </xsl:when>
		</xsl:choose> &gt;
				</a>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template match="PAGE">
		<xsl:if test="position()&gt;1"> | </xsl:if>
		<a>
			<xsl:apply-templates select="." mode="link2list">
				<xsl:with-param name="page" select="@NUM"/>
			</xsl:apply-templates>
			<xsl:value-of select="@NUM"/>
		</a>
	</xsl:template>
	<xsl:template match="PAGE[@selected]">
		<xsl:if test="position()&gt;1"> | </xsl:if>
		<strong>
			<xsl:value-of select="@NUM"/>
		</strong>
	</xsl:template>
	<xsl:template match="@entrdate">
		<xsl:choose>
			<xsl:when test="$interfaceLang='pt'">Publicado em </xsl:when>
			<xsl:when test="$interfaceLang='es'">Publicado en </xsl:when>
			<xsl:when test="$interfaceLang='en'">Published </xsl:when>
		</xsl:choose>
		<xsl:call-template name="ShowDate">
			<xsl:with-param name="DATEISO" select="."/>
			<xsl:with-param name="LANG" select="$interfaceLang"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
