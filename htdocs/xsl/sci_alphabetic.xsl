<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="journalStatus.xsl"/>
	<xsl:output encoding="utf-8"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='alphabetic_list']"/>
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="STYLESHEET" type="text/css" href="/css/scielo.css"/>
			</head>
			<body link="#0000ff" vlink="#800080" bgcolor="#ffffff">
				<xsl:call-template name="NAVBAR">
					<xsl:with-param name="bar1">serials</xsl:with-param>
					<xsl:with-param name="bar2">articlesiah</xsl:with-param>
					<xsl:with-param name="scope">library</xsl:with-param>
				</xsl:call-template>
				<table cellspacing="0" border="0" cellpadding="7" width="100%">
					<tr>
						<td width="26%">&#160;</td>
						<td width="74%">
							<font class="nomodel" size="+1" color="#000080">
								<xsl:value-of select="$translations/xslid[@id='sci_alphabetic']/text[@find='library_collection']"/>
							</font>
						</td>
					</tr>
				</table>
				<br/>
				<br/>
				<xsl:apply-templates select="//LIST"/>
				<br/>
				<xsl:apply-templates select="SERIALLIST/COPYRIGHT"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="LIST">
		<table width="100%">
			<tr>
				<td width="8%">&#160;</td>
				<td width="82%">
					<p align="LEFT">
						<font class="nomodel" color="#800000">
							<xsl:value-of select="$translations/xslid[@id='sci_alphabetic']/text[@find='alphabetic_list']"/> - <xsl:value-of select="count(SERIAL)"/>&#160;<xsl:value-of select="$translations/xslid[@id='sci_alphabetic']/text[@find='serials_listed']"/>
						</font>
					</p>
					<xsl:apply-templates select="." mode="display-list"/>
					<font class="divisoria">&#160;<br/>
					</font>
					<br/>
					<br/>
				</td>
				<td width="10%">&#160;</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="*" mode="display-list">
		<xsl:choose>
			<xsl:when test="count(SERIAL[.//current-status/@status!=''])&gt;0">
				<xsl:apply-templates select="." mode="classified"/>
			</xsl:when>
			<xsl:otherwise>
				<ul>
					<xsl:apply-templates select="SERIAL"/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" mode="classified">
		<xsl:variable name="count" select="count(SERIAL[.//current-status/@status='C'])"/>
		<xsl:variable name="c" select="count(SERIAL[.//current-status/@status!='C' or not(journal-status-history)])"/>
		<xsl:apply-templates select="." mode="display-msg-current-list">
			<xsl:with-param name="count" select="$count"/>
		</xsl:apply-templates>
		<ul>
			<xsl:apply-templates select="SERIAL[.//current-status/@status='C']"/>
		</ul>
		<xsl:if test="SERIAL[.//current-status/@status!='C'  or not(journal-status-history)]">
			<xsl:apply-templates select="." mode="display-msg-not-current-list">
				<xsl:with-param name="count" select="$c"/>
			</xsl:apply-templates>
			<ul>
				<xsl:apply-templates select="SERIAL[.//current-status/@status!='C' or not(journal-status-history)]"/>
			</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template match="SERIAL">
		<li>
			<font class="linkado">
				<a>
					<xsl:attribute name="href">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php?script=<xsl:apply-templates select="." mode="sci_serial"/>&amp;pid=<xsl:value-of select="TITLE/@ISSN"/>&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/><xsl:apply-templates select="." mode="repo_url_param"/></xsl:attribute>
					<xsl:value-of select="TITLE" disable-output-escaping="yes"/>
				</a>
				<xsl:if test="not(//NO_SCI_SERIAL='yes')">-	
					<!--a>
						<xsl:attribute name="href">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php?script=sci_issues&amp;pid=<xsl:value-of select="TITLE/@ISSN"/>&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/><xsl:apply-templates select="." mode="repo_url_param"/></xsl:attribute-->
						<xsl:value-of select="@QTYISS"/>
					<!--/a-->
				&#160;<xsl:value-of select="$translations/xslid[@id='sci_alphabetic']/text[@find='issue']"/>
					<xsl:if test="@QTYISS > 1">s</xsl:if>
				</xsl:if>
				<xsl:choose>
					<xsl:when test=".//current-status/@status='' or not(.//current-status)">
						<xsl:if test="not(starts-with(normalize-space(following-sibling::node()/TITLE), substring(normalize-space(TITLE), 1, 1)))">
							<br/>
						</xsl:if>
					</xsl:when>
					<xsl:when test=".//current-status/@status='C'">
						<xsl:apply-templates select=".//journal-status-history" mode="display-status-info"/>
						<xsl:if test="not(starts-with(normalize-space(following-sibling::node()/TITLE), substring(normalize-space(TITLE), 1, 1)))">
							<br/>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						  - <xsl:apply-templates select=".//journal-status-history" mode="display-status-info"/>
					</xsl:otherwise>
				</xsl:choose>
			</font>
			<br/>
		</li>
	</xsl:template>
	<xsl:template match="COPYRIGHT">
		<xsl:call-template name="COPYRIGHTSCIELO"/>
	</xsl:template>
</xsl:stylesheet>
