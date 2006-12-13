<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output encoding="iso-8859-1" method="html" omit-xml-declaration="yes" indent="no" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<xsl:include href="file:///d:/sites/scielo/web/htdocs/xsl/sci_navegation.xsl"/>
	<xsl:include href="file:///d:/sites/scielo/web/htdocs/xsl/sci_error.xsl"/>

	<xsl:output method="html" encoding="iso-8859-1" />

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
	a { text-decoration: none; }
   </style>
   <META http-equiv="Pragma" content="no-cache" />
   <META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT" />
   			<!-- link pro RSS aparecer automaticamente no Browser -->

			<xsl:element name="link">
				<xsl:attribute name="rel">alternate</xsl:attribute>
				<xsl:attribute name="type">application/rss+xml</xsl:attribute>
				<xsl:attribute name="title">SciELO</xsl:attribute>

				<xsl:attribute name="href">
					<xsl:value-of select="concat('http://',CONTROLINFO/SCIELO_INFO/SERVER,'/rss.php?pid=',//PAGE_PID,'&amp;lang=',//LANGUAGE)" />
				</xsl:attribute>
			</xsl:element>
		</HEAD>

			<BODY vLink="#800080" bgColor="#ffffff">

				<xsl:call-template name="NAVBAR">
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
				<xsl:apply-templates select="//ISSUE"/>
				<HR/>
				<P align="center">
					<xsl:apply-templates select="//COPYRIGHT"/>
					<xsl:apply-templates select="//CONTACT"/>
				</P>
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
						<table border="0">
							<tbody>
								<xsl:apply-templates select="SECTION"/>
							</tbody>
						</table>
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
							&#8226; &#160;</FONT>
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
</xsl:stylesheet>
