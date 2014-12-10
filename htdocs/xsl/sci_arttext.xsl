<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mml="http://www.w3.org/1998/Math/MathML"  xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:import href="sci_navegation.xsl"/>
	<xsl:import href="sci_arttext_pmc.xsl"/>
	<xsl:import href="sci_toolbox.xsl"/>
	
	<xsl:template match="*[@xlink:href]" mode="fix_img_extension">
		<xsl:variable name="size" select="string-length(@xlink:href)"/>
		<xsl:variable name="c1" select="substring(@xlink:href,$size - 4,1)"/>
		<xsl:variable name="c2" select="substring(@xlink:href,$size - 3,1)"/>
		<xsl:choose>
			<xsl:when test="$c1='.'"><xsl:value-of select="@xlink:href"/></xsl:when>
			<xsl:when test="$c2='.'"><xsl:value-of select="@xlink:href"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@xlink:href"/>.jpg</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*[@href]" mode="fix_img_extension">
		<xsl:variable name="size" select="string-length(@href)"/>
		<xsl:variable name="c1" select="substring(@xlink:href,$size - 4,1)"/>
		<xsl:variable name="c2" select="substring(@xlink:href,$size - 3,1)"/>
		<xsl:choose>
			<xsl:when test="$c1='.'"><xsl:value-of select="@href"/></xsl:when>
			<xsl:when test="$c2='.'"><xsl:value-of select="@href"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@href"/>.jpg</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:variable name="PID" select="//ARTICLE/@PID"/>
	<xsl:variable name="version">
		<xsl:choose>
			<xsl:when test=".//BODY">html</xsl:when>
			<xsl:when test=".//fulltext/front">xml</xsl:when>
			<xsl:otherwise>xml-file</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="TXTLANG" select="//ARTICLE/@TEXTLANG"/>
	<!--xsl:variable name="xml_article"><xsl:if test="$version='xml-file'">file:///<xsl:value-of select="concat(.//PATH_HTDOCS,'/xml_files/',.//filename)"/></xsl:if></xsl:variable-->
	<xsl:variable name="xml_article">
		<xsl:if test="$version='xml-file'"><xsl:choose>
			<xsl:when test="//TESTE">file://<xsl:value-of select="//TESTE"/></xsl:when>
			<xsl:otherwise>file:///<xsl:value-of select="concat(substring-before(.//PATH_HTDOCS,'htdocs'),'bases/xml/',.//ISSUE/ARTICLE[1]/filename)"/></xsl:otherwise>
		</xsl:choose></xsl:if>
	</xsl:variable>

	<xsl:variable name="path_img" select="'/img/revistas/'"/>

	<xsl:variable name="issue_label">
		<xsl:choose>
			<xsl:when test="//ISSUE/@NUM = 'AHEAD'">
				<xsl:value-of select="substring(//ISSUE/@PUBDATE,1,4)"/>
				<xsl:if test="//ISSUE/@NUM">nahead</xsl:if>
			</xsl:when>
			<xsl:when test="//ISSUE/@NUM or //ISSUE/@VOL">
				<xsl:if test="//ISSUE/@VOL">v<xsl:value-of select="translate(//ISSUE/@VOL, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:if>
				<xsl:if test="//ISSUE/@NUM">n<xsl:value-of select="translate(//ISSUE/@NUM, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:if>
				<xsl:if test="//ISSUE/@SUPPL">s<xsl:value-of select="translate(//ISSUE/@SUPPL, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:if>
			</xsl:when>
			<xsl:when test="$version='xml-file'">
				<xsl:apply-templates select="document($xml_article)//front/article-meta"
					mode="scift-issue-label"/>
			</xsl:when>
			<xsl:when test="$version='xml'">
				<xsl:apply-templates select=".//front/article-meta" mode="scift-issue-label"/>
			</xsl:when>
			
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="front/article-meta" mode="scift-issue-label">
		<xsl:if test="volume">v<xsl:value-of select="volume"/></xsl:if>
		<xsl:if test="issue">
			<xsl:choose>
				<xsl:when test="contains(issue,'Suppl')">
					<xsl:variable name="n"><xsl:value-of
							select="normalize-space(substring-before(issue,'Suppl'))"
						/></xsl:variable>
					<xsl:variable name="s"><xsl:value-of
							select="normalize-space(substring-after(issue,'Suppl'))"
						/></xsl:variable>
					<xsl:if test="$n!=''">n<xsl:value-of select="$n"/></xsl:if>s<xsl:value-of
						select="$s"/><xsl:if test="$s=''">0</xsl:if>
				</xsl:when>
				<xsl:otherwise>n<xsl:value-of select="issue"/></xsl:otherwise>
			</xsl:choose>

		</xsl:if>
		<xsl:if test="supplement"><xsl:variable name="s"><xsl:choose>
					<xsl:when test="contains(supplement, 'Suppl')"><xsl:value-of
							select="substring-after(supplement,'Suppl')"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="supplement"/></xsl:otherwise>
				</xsl:choose></xsl:variable>s<xsl:value-of select="$s"/><xsl:if test="$s=''"
				>0</xsl:if>
		</xsl:if>

	</xsl:template>
	<xsl:variable name="var_IMAGE_PATH">
		<xsl:choose>
			<xsl:when test="//PATH_SERIMG and //SIGLUM and //ISSUE">
				<xsl:value-of select="//PATH_SERIMG"/>
				<xsl:value-of select="//SIGLUM"/>/<xsl:value-of select="$issue_label"/>/</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="//image-path"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="merge">true</xsl:variable>
	<xsl:variable name="xml_display_objects">
		<xsl:choose>
			<xsl:when test="document($xml_article)//sec/@sec-type='display-objects'">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="xml_article_lang">
		<xsl:choose>
			<xsl:when test=".//BODY">html</xsl:when>
			<xsl:when test=".//fulltext/article">xml</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="document($xml_article)/article/@xml:lang"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="article" select=".//ISSUE/ARTICLE"/>
	<xsl:variable name="LANGUAGE" select="//LANGUAGE"/>
	<xsl:variable name="SCIELO_REGIONAL_DOMAIN" select="//SCIELO_REGIONAL_DOMAIN"/>
	<xsl:variable name="hasPDF" select="//ARTICLE/@PDF"/>
	<xsl:variable name="show_toolbox" select="//toolbox"/>
	<xsl:variable name="show_meta_citation_reference"
		select="//varScieloOrg/show_meta_citation_reference"/>
	<xsl:template match="fulltext-service-list"/>
	<xsl:template match="/">

		<xsl:choose>
			<xsl:when test="$version='xml-file' or $merge='true'">
				<xsl:apply-templates select="//SERIAL" mode="merged"/>
			</xsl:when>

			<xsl:otherwise>
				<xsl:apply-templates select="//SERIAL"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ARTICLE" mode="redirect_press_release">
		<xsl:if test="@is='pr'">

			<xsl:variable name="X">/scielo.php?script=sci_arttext_pr&amp;pid=<xsl:value-of
					select="@PID"/></xsl:variable>
			<meta HTTP-EQUIV="REFRESH">
				<xsl:attribute name="Content">
					<xsl:value-of select="concat('0;URL=',$X)"/>
				</xsl:attribute>
			</meta>
		</xsl:if>

	</xsl:template>
	<xsl:template match="SERIAL" mode="meta_names">
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
		<meta Content-math-Type="text/mathml"/>

		<xsl:apply-templates select="//ARTICLE" mode="redirect_press_release"/>
		<!--Meta Google Scholar-->
		<meta name="citation_journal_title" content="{TITLEGROUP/TITLE}"/>
		<meta name="citation_journal_title_abbrev" content="{TITLEGROUP/SHORTTITLE}"/>
		<meta name="citation_publisher" content="{normalize-space(COPYRIGHT)}"/>
		<meta name="citation_title" content="{ISSUE/ARTICLE/TITLE}"/>
		<meta name="citation_date"
			content="{concat(substring(ISSUE/@PUBDATE,5,2),'/',substring(ISSUE/@PUBDATE,1,4))}"/>
		<meta name="citation_volume" content="{ISSUE/@VOL}"/>
		<meta name="citation_issue" content="{ISSUE/@NUM}"/>
		<meta name="citation_issn" content="{ISSN}"/>
		<meta name="citation_doi" content="{ISSUE/ARTICLE/@DOI}"/>
		<meta name="citation_abstract_html_url"
			content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_abstract&amp;pid=', ISSUE/ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ISSUE/ARTICLE/@TEXTLANG)}"/>
		<meta name="citation_fulltext_html_url"
			content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_arttext&amp;pid=', ISSUE/ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ISSUE/ARTICLE/@TEXTLANG)}"/>
		<meta name="citation_pdf_url"
			content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_pdf&amp;pid=', ISSUE/ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ISSUE/ARTICLE/@TEXTLANG)}"/>
		<xsl:apply-templates select="ISSUE/ARTICLE/AUTHORS/AUTH_PERS/AUTHOR" mode="AUTHORS_META"/>
		<meta name="citation_firstpage" content="{ISSUE/ARTICLE/@FPAGE}"/>
		<meta name="citation_lastpage" content="{ISSUE/ARTICLE/@LPAGE}"/>
		<meta name="citation_id" content="{ISSUE/ARTICLE/@DOI}"/>

		<!--Reference Citation-->
		<xsl:if test="$show_meta_citation_reference='1'">
			<xsl:apply-templates select="ISSUE/ARTICLE/REFERENCES"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="SERIAL">

		<xsl:if test=".//mml:math">
			<xsl:processing-instruction name="xml-stylesheet"> type="text/xsl" href="/xsl/mathml.xsl"</xsl:processing-instruction>
		</xsl:if>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>
					<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/> -
						<xsl:value-of select="normalize-space(ISSUE/ARTICLE/TITLE)"
						disable-output-escaping="yes"/>
				</title>
				<xsl:apply-templates select="." mode="meta_names"/>

				<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
				<xsl:apply-templates select="." mode="css"/>
			</head>
			<body>
				<a name="top"/>
				<div class="container">
					<div class="top">
						<div id="issues"/>
						<xsl:call-template name="NAVBAR">
							<xsl:with-param name="bar1">articles</xsl:with-param>
							<xsl:with-param name="bar2">articlesiah</xsl:with-param>
							<xsl:with-param name="home">1</xsl:with-param>
							<xsl:with-param name="alpha">
								<xsl:choose>
									<xsl:when
										test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' "
										>0</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="scope" select="TITLEGROUP/SIGLUM"/>
						</xsl:call-template>
					</div>
					<div class="content">
						<xsl:if test="$show_toolbox = 1">
							<xsl:call-template name="tool_box"/>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="//NO_SCI_SERIAL='yes'">
								<h2 id="printISSN">
									<xsl:value-of
										select="$translations/xslid[@id='sci_arttext']/text[@find='original_version_published_in']"
									/>
								</h2>
							</xsl:when>
							<xsl:otherwise>
								<h2>
									<xsl:choose>
										<xsl:when test="//CONTROLINFO/NO_SCI_SERIAL='yes'">
											<xsl:value-of select="TITLEGROUP/TITLE"
												disable-output-escaping="yes"/>

										</xsl:when>
										<xsl:otherwise>
											<a>
												<xsl:call-template name="AddScieloLink">
												<xsl:with-param name="seq" select=".//ISSN_AS_ID"/>
												<xsl:with-param name="script"
												>sci_serial</xsl:with-param>
												</xsl:call-template>
												<xsl:value-of select="TITLEGROUP/TITLE"
												disable-output-escaping="yes"/>
											</a>
										</xsl:otherwise>
									</xsl:choose>
								</h2>
								<h2 id="printISSN">
									<xsl:apply-templates select=".//ISSUE_ISSN">
										<xsl:with-param name="LANG"
											select="normalize-space(CONTROLINFO/LANGUAGE)"/>
									</xsl:apply-templates>
								</h2>
							</xsl:otherwise>
						</xsl:choose>
						<h3>
							<xsl:if test="TITLEGROUP/SIGLUM != 'bjmbr' ">
								<xsl:apply-templates select="ISSUE/STRIP"/>
							</xsl:if>
							<xsl:if test="TITLEGROUP/SIGLUM = 'bjmbr' ">
								<xsl:apply-templates select="ISSUE/STRIP"/>
								<!--xsl:apply-templates select="ISSUE/ARTICLE" mode="Epub">
									<xsl:with-param name="ahpdate" select="ISSUE/ARTICLE/@ahpdate"/>
									<xsl:with-param name="rvpdate" select="ISSUE/ARTICLE/@rvpdate"/>
								</xsl:apply-templates-->
							</xsl:if>
						</h3>
						<h4 id="doi">
							<xsl:apply-templates select="ISSUE/ARTICLE/@DOI" mode="display"/>&#160; </h4>
						<div class="index,{ISSUE/ARTICLE/@TEXTLANG}">
							<xsl:apply-templates select="ISSUE/ARTICLE/BODY"/>
						</div>
						<xsl:if test="$isProvisional='1' and $hasPDF='1'">
							<a>
								<xsl:call-template name="AddScieloLink">
									<xsl:with-param name="seq" select="ISSUE/ARTICLE/@PID"/>
									<xsl:with-param name="script">sci_pdf</xsl:with-param>
									<xsl:with-param name="txtlang" select="ISSUE/ARTICLE/@TEXTLANG"
									/>
								</xsl:call-template>
								<xsl:value-of
									select="$translations/xslid[@id='sci_arttext']/text[@find='fulltext_only_in_pdf']"
								/>
							</a>
						</xsl:if>
						<xsl:if test="ISSUE/ARTICLE/fulltext">

							<xsl:apply-templates select="ISSUE/ARTICLE[fulltext]"/>

						</xsl:if>
						<xsl:if test="not(ISSUE/ARTICLE/BODY) and not(ISSUE/ARTICLE/fulltext)">
							<xsl:apply-templates select="ISSUE/ARTICLE/EMBARGO/@date">
								<xsl:with-param name="lang" select="$interfaceLang"/>
							</xsl:apply-templates>
						</xsl:if>
						<div align="left"/>
						<div class="spacer">&#160;</div>
					</div>
					<xsl:apply-templates select="." mode="footer-journal"/>
				</div>

				<script language="javascript" src="applications/scielo-org/js/jquery-1.4.2.min.js"/>
				<script language="javascript" src="applications/scielo-org/js/toolbox.js"/>
				
			</body>
		</html>
	</xsl:template>

	<xsl:template match="SERIAL" mode="merged">
		<xsl:if test=".//mml:math">
			<xsl:processing-instruction name="xml-stylesheet"> type="text/xsl" href="/xsl/mathml.xsl"</xsl:processing-instruction>
		</xsl:if>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>
					<xsl:apply-templates select="." mode="version-head-title"/>
				</title>
				<xsl:apply-templates select="." mode="meta_names"/>
				<xsl:apply-templates select="." mode="version-css"/>
				<xsl:apply-templates select="." mode="version-js"/>
				
				</head>
			<body>
				<a name="top"/>
				<xsl:comment><xsl:value-of select="$version"/><xsl:value-of select="$merge"/></xsl:comment>

				<xsl:choose>
					<xsl:when test="$version='xml-file' or $version='xml'">
						<xsl:apply-templates select="." mode="version-body-xml-file"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="version-body-html"/>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:comment><xsl:value-of select="$xml_article"/></xsl:comment>
				
			</body>
		</html>
	</xsl:template>

	<xsl:template match="SERIAL" mode="version-head-title">
		<!--xsl:choose>
			<xsl:when test="$version='xml-file'">
				<xsl:variable name="xml" select="document($xml_article)"/>
                <xsl:apply-templates select="$xml//front/journal-meta/journal-id" />
				<xsl:apply-templates select="$xml//front/article-meta/volume" mode="id-vol"/>
                <xsl:apply-templates select="$xml//front/article-meta/issue" mode="id-issue"/>
                <xsl:apply-templates select="$xml//front/article-meta/fpage" mode="id-fp"/>
                <xsl:apply-templates select="$xml//front/article-meta/lpage" mode="id-lp"/>.
			</xsl:when>
		    <xsl:otherwise-->
		<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/> - <xsl:value-of
			select="normalize-space(ISSUE/ARTICLE/TITLE)" disable-output-escaping="yes"/>
		<!--/xsl:otherwise>
        </xsl:choose-->
	</xsl:template>

	<xsl:template match="SERIAL" mode="version-css">
		<xsl:choose>
			<xsl:when test="$version='xml-file' or $version= 'xml'">
				<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
				<link rel="stylesheet" type="text/css" href="/xsl/pmc/v3.0/xml.css"/>
				<!--link rel="stylesheet" type="text/css" href="/xsl/pmc/v3.0/css/jpub-preview.css" /-->
			</xsl:when>
			<!--xsl:when test="$version='xml'">
            	<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
                <link xmlns="" rel="stylesheet" type="text/css" href="/css/pmc/ViewNLM.css"/>
                <link xmlns="" rel="stylesheet" type="text/css" href="/css/pmc/ViewScielo.css"/>

            </xsl:when-->
			<xsl:otherwise>
				<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="SERIAL" mode="version-js">
		<xsl:choose>
			<xsl:when test="$version='xml-file'">
				<script language="javascript" src="applications/scielo-org/js/jquery-1.4.2.min.js"/>
				<script language="javascript" src="applications/scielo-org/js/toolbox.js"/>
				<xsl:if test="document($xml_article)//math or document($xml_article)//mml:math">
					<script type="text/javascript"
						src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
					</script></xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<script language="javascript" src="applications/scielo-org/js/jquery-1.4.2.min.js"/>
				<script language="javascript" src="applications/scielo-org/js/toolbox.js"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="SERIAL" mode="version-body-xml-file">
		<div class="container">
			<div class="top">
				<div id="issues"/>
				<xsl:apply-templates select="." mode="common-display-nav-bar"/>
			</div>
			<div class="content">
				<xsl:if test="$show_toolbox = '1'">
					<xsl:call-template name="tool_box"/>
				</xsl:if>
				<xsl:apply-templates select="." mode="text-header"/>
				<xsl:apply-templates select="." mode="text-content"/>

			</div>
		</div>
		<!--xsl:value-of select="$xml_article"/-->
		<!--xsl:apply-templates select="document($xml_article)" mode="sections-navegation"/-->
		<div class="container">
			<div align="left"/>
			<div class="spacer">&#160;</div>
			<xsl:apply-templates select="." mode="footer-journal"/>
		</div>
	</xsl:template>


	<xsl:template match="SERIAL" mode="version-body-html">
		<div class="container">
			<div class="top">
				<div id="issues"/>
				<xsl:apply-templates select="." mode="common-display-nav-bar"/>
			</div>
			<div class="content">
				<xsl:if test="$show_toolbox = '1'">
					<xsl:call-template name="tool_box"/>
				</xsl:if>
				<xsl:apply-templates select="." mode="text-header"/>
				<xsl:apply-templates select="." mode="text-content"/>
			</div>
			<xsl:apply-templates select="." mode="footer-journal"/>
		</div>
	</xsl:template>
	<xsl:template match="SERIAL" mode="common-display-nav-bar">
		<xsl:call-template name="NAVBAR">
			<xsl:with-param name="bar1">articles</xsl:with-param>
			<xsl:with-param name="bar2">articlesiah</xsl:with-param>
			<xsl:with-param name="home">1</xsl:with-param>
			<xsl:with-param name="alpha">
				<xsl:choose>
					<xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' "
						>0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="scope" select="TITLEGROUP/SIGLUM"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="SERIAL" mode="text-header">
		<xsl:choose>
			<xsl:when test="//NO_SCI_SERIAL='yes'">
				<!-- 
					when there is no sci_serial page, which means, no home page for journal, 
					because it is a repository website, for instance
				-->
				<h2 id="printISSN">
					<xsl:value-of
						select="$translations/xslid[@id='sci_arttext']/text[@find='original_version_published_in']"
					/>
				</h2>
				<h2>
					<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/>
				</h2>

			</xsl:when>
			<xsl:otherwise>
				<h2>
					<a>
						<xsl:call-template name="AddScieloLink">
							<xsl:with-param name="seq" select=".//ISSN_AS_ID"/>
							<xsl:with-param name="script">sci_serial</xsl:with-param>
						</xsl:call-template>
						<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/>
					</a>

				</h2>
				<h2 id="printISSN">
					<xsl:apply-templates select=".//ISSUE_ISSN">
						<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)"/>
					</xsl:apply-templates>
				</h2>
			</xsl:otherwise>
		</xsl:choose>
		<h3>
			<xsl:apply-templates select="ISSUE/STRIP"/>

		</h3>
		<h4 id="doi">
			<xsl:apply-templates select="ISSUE/ARTICLE/@DOI" mode="display"/>&#160; </h4>
	</xsl:template>
	<xsl:template match="SERIAL" mode="text-content">
		<div class="index,{ISSUE/ARTICLE/@TEXTLANG}">
			<xsl:choose>
				<xsl:when test="$version='html'">
					<xsl:comment>version=html</xsl:comment>
					<xsl:apply-templates select="ISSUE/ARTICLE/BODY"/>
				</xsl:when>

				<xsl:when test="$version='xml'">
					<xsl:comment>version=xml</xsl:comment>
					<xsl:apply-templates select="ISSUE/ARTICLE[fulltext]"/>
				</xsl:when>
				<xsl:when test="$version='xml-file'">
					<xsl:comment>version=xml-file</xsl:comment>
					<xsl:comment><xsl:value-of select="$xml_article"/></xsl:comment>
					<xsl:apply-templates select="document($xml_article)" mode="text-content"/>
				</xsl:when>
			</xsl:choose>
		</div>
		<xsl:if test="$isProvisional='1' and $hasPDF='1'">
			<a>
				<xsl:call-template name="AddScieloLink">
					<xsl:with-param name="seq" select="ISSUE/ARTICLE/@PID"/>
					<xsl:with-param name="script">sci_pdf</xsl:with-param>
					<xsl:with-param name="txtlang" select="ISSUE/ARTICLE/@TEXTLANG"/>
				</xsl:call-template>
				<xsl:value-of
					select="$translations/xslid[@id='sci_arttext']/text[@find='fulltext_only_in_pdf']"
				/>
			</a>
		</xsl:if>

		<xsl:if
			test="not(ISSUE/ARTICLE/BODY) and not(ISSUE/ARTICLE/fulltext) and ISSUE/ARTICLE/EMBARGO/@date!=''">
			<xsl:apply-templates select="ISSUE/ARTICLE/EMBARGO/@date">
				<xsl:with-param name="lang" select="$interfaceLang"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="BODY">
		<xsl:apply-templates select="*|text()" mode="body-content"/>

	</xsl:template>

	<xsl:template match="REFERENCES/REFERENCE">
		<meta name="citation_reference"
			content="citation_title={TITLE_REFERENCE}; citation_author={AUTHORS_REFERENCE};citation_journal_title={JOURNAL_TITLE_REFERENCE};citation_volume={VOLUME_REFERENCE};citation_pages={PAGE_REFERENCE};citation_year={YEAR_REFERENCE};citation_fulltext_html_url={URL_REFERENCE};"
		/>
	</xsl:template>

	<xsl:template match="*|text()" mode="body-content">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>
	<xsl:template match="STRIP">
		<xsl:call-template name="SHOWSTRIP">
			<xsl:with-param name="SHORTTITLE" select="SHORTTITLE"/>
			<xsl:with-param name="VOL" select="VOL"/>
			<xsl:with-param name="NUM" select="NUM"/>
			<xsl:with-param name="SUPPL" select="SUPPL"/>
			<xsl:with-param name="CITY" select="CITY"/>
			<xsl:with-param name="MONTH" select="MONTH"/>
			<xsl:with-param name="YEAR" select="YEAR"/>
			<xsl:with-param name="reviewType">
				<xsl:if test="../ARTICLE/@hcomment!='1' or not(../ARTICLE/@hcomment)"
					>provisional</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="p[contains(.,'apenas em PDF')] | p[contains(.,'available only in PDF')] ">
		<p>
			<a>
				<xsl:call-template name="AddScieloLink">
					<xsl:with-param name="seq" select="$article/@PID"/>
					<xsl:with-param name="script">sci_pdf</xsl:with-param>
					<xsl:with-param name="txtlang" select="$article/@TEXTLANG"/>
				</xsl:call-template>
				<xsl:value-of select="."/>
			</a>
		</p>
	</xsl:template>
</xsl:stylesheet>
