<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sci_navegation_tableless.xsl"/>
	<xsl:include href="journalStatus.xsl"/>
	<xsl:output method="html"  encoding="utf-8" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>


	<xsl:variable name="forceType" select="//CONTROLINFO/ENABLE_FORCETYPE"/>
	<xsl:variable name="padrao">
		<xsl:if test="not(//SERIAL[journal-status-history]) or (count(//SERIAL[journal-status-history/current-status/@status!=''])=0 )">true</xsl:if>
	</xsl:variable>
	<xsl:variable name="text_issues">&#160;
        <xsl:value-of select="$translations/xslid[@id='sci_subject']/text[@find = 'issue']"/>
	</xsl:variable>
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="$translations/xslid[@id='sci_subject']/text[@find = 'subject_list_of_serials']"/>
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/scielo.css" media="screen"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_layout.css" media="screen"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_styles.css" media="screen"/>
				<link rel="stylesheet" type="text/css" href="/css/include_general.css" media="screen"/>
			</head>
			<body>
				<div class="container">
					<div class="top">
						<xsl:apply-templates select="." mode="tableless-navbar">
							<xsl:with-param name="bar1">serials</xsl:with-param>
							<xsl:with-param name="bar2">articlesiah</xsl:with-param>
							<xsl:with-param name="scope">library</xsl:with-param>
						</xsl:apply-templates>
					</div>
					<div>
					<table cellspacing="0" border="0" cellpadding="7" width="100%">
						<tr>
							<td width="26%">&#160;</td>
							<td width="74%">
								<font class="nomodel" size="+1" color="#000080">
									<xsl:value-of select="$translations/xslid[@id='sci_subject']/text[@find = 'library_collection']"/>
								</font>
							</td>
						</tr>
					</table>
					<br/>
					<br/>
					<xsl:apply-templates select="//LIST"/>
					</div>
					<xsl:apply-templates select="SUBJECTLIST/COPYRIGHT"/>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="LIST">
		<table width="100%">
			<tr>
				<td width="8%">&#160;</td>
				<td width="82%">
					<xsl:call-template name="Subjects"/>
					<p align="LEFT">
						<font class="nomodel" color="#800000">
							<xsl:value-of select="$translations/xslid[@id='sci_subject']/text[@find = 'subject_list_of_serials']"/>
						</font>
					</p>
					<xsl:apply-templates select="SUBJECT"/>
					<font class="divisoria">&#160;<br/>
					</font>
					<br/>
					<br/>
				</td>
				<td width="10%">&#160;</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="SUBJECT">
		<xsl:param name="status"/>
		<p class="section">
			<img>
				<xsl:attribute name="src"><xsl:value-of select="//PATH_GENIMG"/>lead.gif</xsl:attribute>
			</img>&#160;&#160;
		<font size="-1" color="#000080">
				<a>
					<xsl:attribute name="name">subj<xsl:value-of select="position()"/></xsl:attribute>
					<xsl:value-of select="@NAME"/>
				</a>
			</font>
			<br/>
			<xsl:choose>
				<xsl:when test="$padrao='true'">
					<br/>
					<xsl:apply-templates select="SERIAL"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="SERIAL[journal-status-history/current-status/@status='C']">
						<p>&#160;&#160;&#160;&#160;
							<xsl:value-of select="$translations-j//term[@code='current-titles']"/>
						</p>
						<p>
							<xsl:apply-templates select="SERIAL[journal-status-history/current-status/@status='C']"/>
						</p>
					</xsl:if>
					<br/>
					<xsl:if test="SERIAL[journal-status-history/current-status/@status!='C']">
						<p>&#160;&#160;&#160;&#160;							<xsl:value-of select="$translations-j//term[@code='not-current-titles']"/>
						</p>
						<p>
							<xsl:apply-templates select="SERIAL[journal-status-history/current-status/@status!='C']"/>
						</p>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</p>
		<p>&#160;</p>
	</xsl:template>
	<xsl:template match="SERIAL">
		&#160;&#160;&#160;&#160;&#160;

			<font class="linkado">
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php?script=<xsl:apply-templates select="." mode="sci_serial"/>&amp;pid=<xsl:value-of select="TITLE/@ISSN"/>&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/><xsl:apply-templates select="." mode="repo_url_param"/></xsl:attribute>
				<xsl:value-of select="TITLE" disable-output-escaping="yes"/>
			</a>
			<xsl:if test="not(//NO_SCI_SERIAL='yes')">
			- <xsl:value-of select="@QTYISS"/>
				<xsl:value-of select="$text_issues"/>
				<xsl:if test="@QTYISS > 1">s</xsl:if>
			</xsl:if>
			<xsl:if test=".//current-status/@status!='' and .//current-status/@status!='C' ">
				<xsl:apply-templates select="." mode="display-status-info"/>
			</xsl:if>
		</font>
		<br/>
	</xsl:template>
	<xsl:template match="COPYRIGHT">
		<xsl:call-template name="COPYRIGHTSCIELO"/>
	</xsl:template>
	<xsl:template name="Subjects">
		<p align="LEFT">
			<font class="nomodel" color="#800000">
				<xsl:value-of select="$translations/xslid[@id='sci_subject']/text[@find = 'subjects']"/>
			</font>
		</p>
		<table width="100%">
			<tr>
				<td>
					<xsl:attribute name="width"><xsl:choose><xsl:when test="count(//SUBJECT) > 10">50%</xsl:when><xsl:otherwise>100%</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="valign">top</xsl:attribute>
					<xsl:for-each select="//SUBJECT[11 > position()]">
		&#160;&#160;&#160;&#160;&#160;&#160;
		<font size="-1" color="#000080">
							<a>
								<xsl:attribute name="href">#subj<xsl:value-of select="position()"/></xsl:attribute>
								<xsl:value-of select="@NAME"/>
							</a>
							<br/>
						</font>
					</xsl:for-each>
				</td>
				<xsl:if test="count(//SUBJECT) > 10">
					<td width="*" valign="top">
						<xsl:for-each select="//SUBJECT[position() > 10]">
		&#160;&#160;&#160;&#160;&#160;&#160;
		<font size="-1" color="#000080">
								<a>
									<xsl:attribute name="href">#subj<xsl:value-of select="position() + 10"/></xsl:attribute>
									<xsl:value-of select="@NAME"/>
								</a>
								<br/>
							</font>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
