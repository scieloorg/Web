<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mml="http://www.w3.org/1998/Math/MathML"  xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:import href="sci_navegation.xsl"/>
	<xsl:import href="sci_arttext_pmc.xsl"/>
	<xsl:import href="sci_toolbox.xsl"/>
	<xsl:output indent="yes"/>
	
	<xsl:variable name="pdf_links" select="//PDF_LANGS/LANG"/>
	<xsl:template match="*[@xlink:href] | *[@href]" mode="fix_img_extension">
		<xsl:variable name="href"><xsl:choose>
			<xsl:when test="@xlink:href"><xsl:value-of select="@xlink:href"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@href"/></xsl:otherwise>
		</xsl:choose></xsl:variable>
		<xsl:variable name="size" select="string-length($href)"/>
		<xsl:variable name="c1" select="substring($href,$size - 4)"/>
		<xsl:variable name="c2" select="substring($href,$size - 3)"/>
		<xsl:choose>
			<xsl:when test="substring($c1,1,1)='.'">
				<xsl:choose>
					<xsl:when test="contains($c1,'.tif')"><xsl:value-of select="substring-before($href,'.tif')"/>.jpg</xsl:when>
					<xsl:otherwise><xsl:value-of select="$href"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="substring($c2,1,1)='.'">
				<xsl:choose>
					<xsl:when test="contains($c2,'.tif')"><xsl:value-of select="substring-before($href,'.tif')"/>.jpg</xsl:when>
					<xsl:otherwise><xsl:value-of select="$href"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$href"/>.jpg</xsl:otherwise>
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
	<xsl:variable name="document" select="document($xml_article)"/>
	<xsl:variable name="original" select="$document//article"/>
	
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
				<xsl:if test="//ISSUE/@COMPL"><xsl:value-of select="//ISSUE/@COMPL"/></xsl:if>
			</xsl:when>
			<xsl:when test="$version='xml-file'">
				<xsl:apply-templates select="$document//front/article-meta"
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
				<xsl:when test="contains(issue,' pr')">n<xsl:value-of select="substring-before(issue,' pr')"/>pr</xsl:when>
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
			<xsl:when test="$original//sec/@sec-type='display-objects'">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="TEXT_LANG">
		<xsl:choose>
			<xsl:when test="$TXTLANG!=''">
				<xsl:value-of select="$TXTLANG"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$original/@xml:lang"/>
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
		<link rel="canonical" href="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_arttext&amp;pid=', ISSUE/ARTICLE/@PID)}" />
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
		<xsl:apply-templates select="ISSUE/ARTICLE/AUTHORS/AUTH_PERS/AUTHOR" mode="AUTHORS_META"/>
		<meta name="citation_firstpage" content="{ISSUE/ARTICLE/@FPAGE}"/>
		<meta name="citation_lastpage" content="{ISSUE/ARTICLE/@LPAGE}"/>
		<meta name="citation_id" content="{ISSUE/ARTICLE/@DOI}"/>

		<xsl:apply-templates select="ISSUE/ARTICLE/LANGUAGES/PDF_LANGS/LANG" mode="meta_citation_pdf_url">
			<xsl:with-param name="orig_lang" select="ISSUE/ARTICLE/@ORIGINALLANG" />
		</xsl:apply-templates>

		<!--Reference Citation-->
		<xsl:if test="$show_meta_citation_reference='1'">
			<xsl:apply-templates select="ISSUE/ARTICLE/REFERENCES"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="LANG" mode="meta_citation_pdf_url">
		<xsl:param name="orig_lang" />
		<xsl:variable name="lang" select="." />
		<meta>
			<xsl:attribute name="name">citation_pdf_url</xsl:attribute>
			<xsl:attribute name="language"><xsl:value-of select="$lang" /></xsl:attribute>
			<xsl:if test="$orig_lang = $lang">
				<xsl:attribute name="default">true</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="content"><xsl:value-of select="concat('http://',//CONTROLINFO/SCIELO_INFO/SERVER,'/pdf/',@TRANSLATION)" /></xsl:attribute>
		</meta>
	</xsl:template>

	<xsl:template match="SERIAL">

		<xsl:if test=".//mml:math">
			<xsl:processing-instruction name="xml-stylesheet"> type="text/xsl" href="/xsl/mathml.xsl"</xsl:processing-instruction>
		</xsl:if>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>
					<xsl:value-of select="ISSUE/ARTICLE/TITLE" />
				</title>
				<xsl:apply-templates select="." mode="meta_names"/>

				<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
				<xsl:apply-templates select="." mode="css"/>
	            <xsl:if test="//show_readcube_epdf = '1'">
	                <script src="http://content.readcube.com/scielo/epdf_linker.js" type="text/javascript" async="true"></script>
    	        </xsl:if>
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
					<xsl:value-of select="ISSUE/ARTICLE/TITLE" />
				</title>
				<xsl:apply-templates select="." mode="meta_names"/>
				<xsl:apply-templates select="." mode="version-css"/>
				<xsl:apply-templates select="." mode="version-js"/>
	            <xsl:if test="//show_readcube_epdf = '1'">
	                <script src="http://content.readcube.com/scielo/epdf_linker.js" type="text/javascript" async="true"></script>
	            </xsl:if>
				</head>
			<body>
				<a name="top"/>
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
						<xsl:apply-templates select="." mode="text-disclaimer"/>
						<xsl:apply-templates select="." mode="text-content"/>
					</div>
					<xsl:if test="$version='html'">
						<xsl:apply-templates select="." mode="footer-journal"/>
					</xsl:if>
				</div>
				<xsl:if test="$version!='html'">
					<div class="container">
						<div align="left"/>
						<div class="spacer">&#160;</div>
						<xsl:apply-templates select="." mode="footer-journal"/>
					</div>
				</xsl:if>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="SERIAL" mode="version-head-title">
		<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/> - <xsl:value-of
			select="normalize-space(ISSUE/ARTICLE/TITLE)" disable-output-escaping="yes"/>
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
				<xsl:if test="$original//math or $original//mml:math">
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
					<xsl:apply-templates select="$document" mode="text-content"/>
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
	
	<xsl:template match="SERIAL" mode="text-disclaimer">
		<xsl:if test=".//ARTICLE/RELATED-DOC[@TYPE='correction'] or .//ARTICLE/RELATED-DOC[@TYPE='corrected-article'] or .//ARTICLE/RELATED-DOC[@TYPE='retraction'] or .//ARTICLE/RELATED-DOC[@TYPE='retracted-article']">
			<div class="disclaimer">
				<xsl:apply-templates select=".//ARTICLE/RELATED-DOC[@TYPE='correction']"/>			
				<xsl:apply-templates select=".//ARTICLE/RELATED-DOC[@TYPE='corrected-article']"/>
				<xsl:apply-templates select=".//ARTICLE/RELATED-DOC[@TYPE='retraction']"/>			
				<xsl:apply-templates select=".//ARTICLE/RELATED-DOC[@TYPE='retracted-article']"/>
			</div>
		</xsl:if>
		<!--xsl:if test=".//ARTICLE/RELATED-DOC[@TYPE='correction']">
			<div class="fixed-disclaimer">			
				<xsl:apply-templates select=".//ARTICLE/RELATED-DOC[@TYPE='correction']"/>			
			</div>
		</xsl:if-->
	</xsl:template>
	
	<xsl:template match="RELATED-DOC[@TYPE='corrected-article']" mode="label">
		<xsl:value-of
			select="$translations/xslid[@id='sci_arttext']/text[@find='this_corrects']"
		/>
	</xsl:template>
	<xsl:template match="RELATED-DOC[@TYPE='correction']" mode="label">
		<xsl:value-of
			select="$translations/xslid[@id='sci_arttext']/text[@find='this_article_has_been_corrected']"
		/>
	</xsl:template>
	
	<xsl:template match="RELATED-DOC[@TYPE='retraction']" mode="label">
		<xsl:value-of
			select="$translations/xslid[@id='sci_arttext']/text[@find='this_article_has_been_retracted']"
		/>
	</xsl:template>
	<xsl:template match="RELATED-DOC[@TYPE='retracted-article']" mode="label">
		<xsl:value-of
			select="$translations/xslid[@id='sci_arttext']/text[@find='this_retracts']"
		/>
	</xsl:template>
	
	<xsl:template match="RELATED-DOC">
		<p>
			<strong><xsl:apply-templates select="." mode="label"/>: </strong>
			<a target="_blank"><xsl:choose>
				<xsl:when test="@PID">
					<xsl:call-template name="AddScieloLink">
						<xsl:with-param name="seq" select="@PID"/>
						<xsl:with-param name="script">sci_arttext</xsl:with-param>
						<xsl:with-param name="txtlang" select="$TXTLANG"/>
					</xsl:call-template><xsl:if test="DOCTITLE"><xsl:value-of select="DOCTITLE"/>. </xsl:if><xsl:value-of select="ISSUE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="href"><xsl:if test="not(starts-with(@DOI,'http'))">https://dx.doi.org/</xsl:if><xsl:value-of select="@DOI"/></xsl:attribute>
					<xsl:value-of select="@DOI"/>
				</xsl:otherwise>
			</xsl:choose>
			
				
			</a>
		</p>
	</xsl:template>
	
	
	<xsl:template match="body/p[contains(text(),'Texto completo') and contains(text(),'apenas em PDF')]">
		<xsl:choose>
			<xsl:when test="count($pdf_links)=1">
				<xsl:apply-templates select="$pdf_links" mode="only_pdf">
					<xsl:with-param name="label" select="."/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$pdf_links[.='pt']">
					<xsl:apply-templates select="$pdf_links[.='pt']" mode="only_pdf">
						<xsl:with-param name="label" select="."/>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="$pdf_links[.!='en' and .!='pt']">
					<xsl:apply-templates select="$pdf_links[.!='en' and .!='pt']" mode="only_pdf">
						<xsl:with-param name="label" select="."/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	<xsl:template match="body/p[contains(text(),'Full text available only in PDF format')]">
		<xsl:choose>
			<xsl:when test="count($pdf_links)=1">
				<xsl:apply-templates select="$pdf_links" mode="only_pdf">
					<xsl:with-param name="label" select="."/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$pdf_links[.='en']">
					<xsl:apply-templates select="$pdf_links[.='en']" mode="only_pdf">
						<xsl:with-param name="label" select="."/>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="$pdf_links[.!='en' and .!='pt']">
					<xsl:apply-templates select="$pdf_links[.!='en' and .!='pt']" mode="only_pdf">
						<xsl:with-param name="label" select="."/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>			
	</xsl:template>
	<xsl:template match="*" mode="only_pdf">
		<xsl:param name="label"/>
		<p>
			<a href="/pdf/{@TRANSLATION}"><xsl:value-of select="$label"/></a>
		</p>
	</xsl:template>
</xsl:stylesheet>
