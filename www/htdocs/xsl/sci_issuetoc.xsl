<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes" indent="no"/>
	<xsl:include href="sci_navegation_tableless.xsl"/>
	<xsl:variable name="issuetoc_controlInfo" select="//CONTROLINFO"/>
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
				<link rel="STYLESHEET" TYPE="text/css" href="/css/scielo.css" media="screen"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_layout.css" media="screen"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_styles.css" media="screen"/>
				<link rel="stylesheet" type="text/css" href="/css/include_general.css" media="screen"/>
				<style type="text/css">
#pagination { font-size: 8pt; border-bottom: 1px solid #808080; padding: 5px; margin: 20px 0; align: justified; width: 80%; left:20%}
#xpagination { padding: 5px;  margin: 20px 0;}
#pagination a {font-size: 8pt;  margin: 0 4px; padding: 0 2px; font-color: #000; text-decoration: none}
#pageNav {text-align: right; position: absolute;
right: 20%}
#pageOf {text-align: left;}
   </style>
				<style type="text/css">
	a { text-decoration: none; }
   </style>
				<script language="javascript" src="article.js"/>
				<META http-equiv="Pragma" content="no-cache"/>
				<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<!-- link pro RSS aparecer automaticamente no Browser				<xsl:call-template name="AddRssHeaderLink">
					<xsl:with-param name="pid" select="//CURRENT/@PID"/>
					<xsl:with-param name="lang" select="//LANGUAGE"/>
					<xsl:with-param name="server" select="CONTROLINFO/SCIELO_INFO/SERVER"/>
					<xsl:with-param name="script">rss.php</xsl:with-param>
				</xsl:call-template> -->
			</HEAD>
			<BODY>
				<!--xsl:call-template name="NAVBAR">
					<xsl:with-param name="bar1">issues</xsl:with-param>
					<xsl:with-param name="bar2">articlesiah</xsl:with-param>
					<xsl:with-param name="scope" select="//TITLEGROUP/SIGLUM"/>
					<xsl:with-param name="home">1</xsl:with-param>
					<xsl:with-param name="alpha">
						<xsl:choose>
							<xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' ">0</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template-->
				<div class="container">
					<div class="top">
						<xsl:apply-templates select="." mode="tableless-navbar">
							<xsl:with-param name="bar1">issues</xsl:with-param>
							<xsl:with-param name="bar2">articlesiah</xsl:with-param>
							<xsl:with-param name="scope" select="//TITLEGROUP/SIGLUM"/>
							<xsl:with-param name="home">1</xsl:with-param>
							<xsl:with-param name="alpha">
								<xsl:choose>
									<xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' ">0</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</div>
					<div>
						<xsl:apply-templates select="//TITLEGROUP"/>
						<div>
							<CENTER>
								<FONT color="#000080">
									<xsl:apply-templates select="//ISSUE_ISSN">
										<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
									</xsl:apply-templates>
								</FONT>
							</CENTER>
						</div>
					</div>
					<br/>
					<div>
						<xsl:apply-templates select="//ISSUE"/>
					</div>
					<xsl:apply-templates select="." mode="footer-journal"/>
				</div>
			</BODY>
		</HTML>
	</xsl:template>
	<xsl:template match="ISSUE">
		<TABLE width="100%" border="0">
			<TBODY>
				<TR>
					<TD width="8%">&#160;</TD>
					<TD width="82%">
						<P align="left">
							<xsl:apply-templates select="TITLE"/>
							<xsl:apply-templates select="STRIP"/>
						</P>
						<xsl:apply-templates select="PAGES"/>
						<table border="0">
							<tbody>
								<xsl:apply-templates select="SECTION"/>
							</tbody>
						</table>
						<xsl:apply-templates select="PAGES"/>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
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
			<xsl:value-of select="$translations//xslid[@id='sci_issuetoc']//text[@find='table_of_contents']"/>
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
				<xsl:with-param name="reviewType">
					<xsl:if test="contains(NUM,'review')">provisional</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</font>
	</xsl:template>
	<xsl:template match="SECTION">
		<xsl:if test="NAME">
			<tr>
				<td class="section" colspan="2">
					<IMG>
						<xsl:attribute name="src"><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/><xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>/lead.gif</xsl:attribute>
					</IMG>
					<font size="-1">&#160;</font>
					<xsl:value-of select="NAME" disable-output-escaping="yes"/>
				</td>
			</tr>
			<tr>
				<td>&#160;</td>
				<xsl:if test="//ISSUE/SECTION/NAME">
					<td>&#160;</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="ARTICLE"/>
	</xsl:template>
	<xsl:template match="ARTICLE">
		<tr>
			<!-- If there was a section name -->
			<xsl:if test="../NAME">
				<td>&#160;</td>
			</xsl:if>
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
	<xsl:template match="PAGES">
		<div id="pagination">
			<span id="pageOf">
				<xsl:value-of select="$translations//xslid[@id='sci_issuetoc']//text[@find='page']"/>&#160;
				<xsl:value-of select="PAGE[@selected]/@number"/>&#160;
				<xsl:value-of select="$translations//xslid[@id='sci_issuetoc']//text[@find='of']"/>&#160;
				<xsl:value-of select="PAGE[position()=last()]/@number"/>
			</span>
			<span id="pageNav">
				<xsl:value-of select="$translations//xslid[@id='sci_issuetoc']//text[@find='gotopage']"/>&#160;<xsl:apply-templates select="PAGE" mode="look"/>
			</span>
		</div>
	</xsl:template>
	<xsl:template match="PAGE" mode="look">
		<xsl:if test="@number != '1'"/>
		<span class="page">
			<xsl:apply-templates select="."/>
		</span>
	</xsl:template>
	<xsl:template match="PAGE/@number">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="PAGE[@selected]/@number">
		<strong>

&#160;<xsl:value-of select="."/>&#160;

		</strong>
	</xsl:template>
	<xsl:template match="PAGE">
		<a>
			<xsl:attribute name="href"><xsl:call-template name="getScieloLink"><xsl:with-param name="seq" select="$issuetoc_controlInfo/PAGE_PID"/><xsl:with-param name="script" select="'sci_issuetoc'"/></xsl:call-template>&amp;page=<xsl:value-of select="@number"/></xsl:attribute>
			<xsl:apply-templates select="@number"/>
		</a>
	</xsl:template>
	<xsl:template match="PAGE[@selected='true']">
		<xsl:apply-templates select="@number"/>
	</xsl:template>
	<xsl:template match="PAGE/@selected">
	</xsl:template>
</xsl:stylesheet>
