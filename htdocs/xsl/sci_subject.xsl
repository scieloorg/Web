<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="journalStatus.xsl"/>
	<xsl:output method="html" indent="no"/>
	<xsl:variable name="forceType" select="//CONTROLINFO/ENABLE_FORCETYPE"/>
	
	<xsl:variable name="padrao">
		<xsl:if test="not(//SERIAL[journal-status-history]) or (count(//SERIAL[journal-status-history/current-status/@status!=''])=0 )">true</xsl:if>
	</xsl:variable>
	<xsl:variable name="text_issues">&#160;
        <xsl:value-of select="$translations/xslid[@id='sci_subject']/text[@find = 'issue']"/>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:variable name="curr_lang">
			<xsl:choose>
				<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)!=''">
					<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
				</xsl:when>
				<xsl:when test="normalize-space(//lng)!=''">
					<xsl:value-of select="normalize-space(//lng)"/>
				</xsl:when>
				<xsl:when test="normalize-space(//LANGUAGE)!=''">
					<xsl:value-of select="normalize-space(//LANGUAGE)"/>
				</xsl:when>
				<xsl:otherwise>en</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="curr_nrm">
			<xsl:choose>
				<xsl:when test="normalize-space(//CONTROLINFO/STANDARD)!=''">
					<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/>
				</xsl:when>
				<xsl:when test="normalize-space(//nrm)!=''">
					<xsl:value-of select="normalize-space(//nrm)"/>
				</xsl:when>
				<xsl:when test="normalize-space(//STANDARD)!=''">
					<xsl:value-of select="normalize-space(//STANDARD)"/>
				</xsl:when>
				<xsl:otherwise>iso</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<html>
			<head>
				<title>
                    <xsl:value-of select="$translations/xslid[@id='sci_subject']/text[@find = 'subject_list_of_serials']"/>
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="STYLESHEET" type="text/css" href="/css/scielo.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css"/>
			</head>
			<body class="serial-page" link="#0000ff" vlink="#800080" bgcolor="#ffffff">
				<div class="container">
					<div class="top">
						<div class="issues-top">
							<div class="issues-top-logo">
								<a href="/scielo.php?lng={$curr_lang}">
									<img src="https://www.scielo.br/static/img/logo-scielo-no-label.svg" alt="SciELO - Scientific Electronic Library Online" border="0" style="max-width:120px;height:auto;display:block;margin:0 auto;"/>
								</a>
							</div>
							<div class="issues-top-nav">
								<div class="serial-nav">
									<div class="serial-nav-main">
										<a class="sci-nav-btn" href="/scielo.php?script=sci_alphabetic&amp;lng={$curr_lang}&amp;nrm={$curr_nrm}"><span>A-Z</span></a>
										<span class="sci-nav-btn sci-nav-btn-disabled">
											<span>
												<xsl:choose>
													<xsl:when test="$curr_lang='pt'">Tem&#225;tica</xsl:when>
													<xsl:when test="$curr_lang='es'">Tem&#225;tica</xsl:when>
													<xsl:otherwise>Subject</xsl:otherwise>
												</xsl:choose>
											</span>
										</span>
										<a class="sci-nav-btn" href="https://search.scielo.org/?q=*&amp;lang={$curr_lang}" target="_blank" rel="noopener noreferrer">
											<span>
												<xsl:choose>
													<xsl:when test="$curr_lang='pt'">Buscar</xsl:when>
													<xsl:when test="$curr_lang='es'">Buscar</xsl:when>
													<xsl:otherwise>Search</xsl:otherwise>
												</xsl:choose>
											</span>
										</a>
									</div>
									<div class="serial-nav-tools">
										<a class="sci-nav-btn" href="https://search.scielo.org/?q=*&amp;lang={$curr_lang}" target="_blank" rel="noopener noreferrer">
											<span>
												<xsl:choose>
													<xsl:when test="$curr_lang='pt'">Buscar</xsl:when>
													<xsl:when test="$curr_lang='es'">Buscar</xsl:when>
													<xsl:otherwise>Search</xsl:otherwise>
												</xsl:choose>
											</span>
										</a>
										<a class="sci-nav-btn" href="https://analytics.scielo.org/?collection=scl" target="_blank" rel="noopener noreferrer">
											<span>
												<xsl:choose>
													<xsl:when test="$curr_lang='en'">Metrics</xsl:when>
													<xsl:otherwise>M&#233;tricas</xsl:otherwise>
												</xsl:choose>
											</span>
										</a>
										<div class="sci-nav-lang-menu">
											<button class="sci-nav-lang-btn" type="button">
												&#127760;
												<xsl:text> </xsl:text>
												<xsl:choose>
													<xsl:when test="$curr_lang='pt'">Portugu&#234;s</xsl:when>
													<xsl:when test="$curr_lang='es'">Espa&#241;ol</xsl:when>
													<xsl:otherwise>English</xsl:otherwise>
												</xsl:choose>
											</button>
											<ul class="sci-nav-lang-dropdown">
												<xsl:if test="$curr_lang!='pt'">
													<li><a href="/scielo.php?script=sci_subject&amp;lng=pt&amp;nrm={$curr_nrm}">Portugu&#234;s</a></li>
												</xsl:if>
												<xsl:if test="$curr_lang!='es'">
													<li><a href="/scielo.php?script=sci_subject&amp;lng=es&amp;nrm={$curr_nrm}">Espa&#241;ol</a></li>
												</xsl:if>
												<xsl:if test="$curr_lang!='en'">
													<li><a href="/scielo.php?script=sci_subject&amp;lng=en&amp;nrm={$curr_nrm}">English</a></li>
												</xsl:if>
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
						<br/>
					</div>
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
			<xsl:if test=".//current-status/@status!='' and .//current-status/@status!='C' "> - 
				<xsl:apply-templates select=".//journal-status-history" mode="display-status-info"/>
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
