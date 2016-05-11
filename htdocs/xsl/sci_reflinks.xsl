<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8" omit-xml-declaration="yes" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<xsl:variable name="lang" select="//vars/lang"/>
	<xsl:variable name="pathhtdocs" select="/root/vars/htdocs"/>
	<xsl:variable name="texts" select="document(concat('file://',$pathhtdocs,'applications/scielo-org/xml/texts.xml'))/texts/language[@id = $lang]"/>
	<xsl:variable name="links" select="//ARTICLE"/>
	<xsl:variable name="total" select="count(//similarlist/similar/article)"/>
	<xsl:variable name="service_log" select="/root/vars/service_log"/>
	<xsl:template match="/">
		<!-- start html -->
		<html>
			<head>
				<link rel="stylesheet" href="/applications/scielo-org/css/public/style-{$lang}.css" type="text/css" media="screen"/>
				<!-- Adicionado script para passa a utilizar o serviço de log comentado por Jamil Atta Junior (jamil.atta@bireme.org)-->
				<script language="javascript" src="/../../applications/scielo-org/js/httpAjaxHandler.js"/>
				<title>SciELO.org - Scientific Electronic Library Online</title>
			</head>
			<body>
				<div class="container">
					<div class="level2">
						<div class="bar">
						</div>
						<div class="top">
							<div id="parent">
								<img src="{concat('/img/',$lang,'/scielobre.gif')}" alt="SciELO - Scientific Electronic Library Online"/>
							</div>
							<div id="identification">
								<h1>
									<span>
										<xsl:value-of select="$texts/text[find='scielo.org']/replace"/>
									</span>
								</h1>
							</div>
						</div>
						<div class="middle">
							<div id="collection">
								<h3>
									<span>
										<xsl:value-of select="$texts/text[find='findReferenceOnLine']/replace"/>
									</span>
								</h3>
								<h3>
									<span style="font-size: 70%; font-weight:normal;">
										<xsl:value-of select="//ref_TITLE"/>
										<xsl:if test="string-length(//vars/refid)&gt;0">
											<script language="javascript">
										var x = window.opener.document.getElementById('x<xsl:value-of select="//vars/refid"/>').innerHTML;
										document.write(x);</script>
										</xsl:if>
									</span>
								</h3>
								<div class="content">
									<div class="articleList">
										<xsl:if test="//medline or //lilacs or //scielo or //crossref">
											<xsl:value-of select="$texts/text[find='linksTo']/replace"/>
											<b>
												<ul>
													<li>
														<xsl:if test="//medline">
															<xsl:value-of select="//medline" disable-output-escaping="yes"/>&#160;&#160;
												
											</xsl:if>
														<xsl:if test="//scielo">
															<xsl:value-of select="//scielo" disable-output-escaping="yes"/>&#160;&#160;
												
											</xsl:if>
														<xsl:if test="//lilacs">
															<xsl:value-of select="//lilacs" disable-output-escaping="yes"/>&#160;&#160;
												
											</xsl:if>
														<xsl:if test="//adolec">
															<xsl:value-of select="//adolec" disable-output-escaping="yes"/>&#160;&#160;
											
											</xsl:if>
														<xsl:if test="//crossref">
															<!-- pega a string de antes de > e criamos o link para abrir em nova janela -->
															<xsl:variable name="url" select="substring-after(substring-before(//crossref,'&quot;&gt;CrossRef'),'&quot;')"/>
															<a href="{$url}" target="_blank">CrossRef</a>
															<xsl:if test="$service_log = 1">
																<xsl:attribute name="onClick">callUpdateArticleLog('crossref');</xsl:attribute>
															</xsl:if>
														</xsl:if>
													</li>
												</ul>
											</b>
										</xsl:if>
										<xsl:value-of select="$texts/text[find='tryLink']/replace"/>
										<ul>
											<!-- Search in Google Scholar -->
											<li>
												<a>
													<xsl:attribute name="href">http://scholar.google.com.br/scholar?q=<xsl:value-of select="//TITLE" disable-output-escaping="yes"/></xsl:attribute>
													<xsl:attribute name="target">_blank</xsl:attribute>
													<xsl:if test="$service_log = 1">
														<xsl:attribute name="onClick">callUpdateArticleLog('similares_em_google');</xsl:attribute>
													</xsl:if>
													<b>Google</b>
												</a>
											</li>
										</ul>
										<xsl:value-of select="$texts/text[find='similarLink']/replace"/>
										<ul>
											<li>
												<a>
													<xsl:attribute name="href">/scieloOrg/php/similar.php?text=<xsl:value-of select="//TITLE" disable-output-escaping="yes"/>&amp;lang=<xsl:value-of select="$lang"/></xsl:attribute>
													<xsl:attribute name="target">_blank</xsl:attribute>
													<xsl:if test="$service_log = 1">
														<xsl:attribute name="onClick">callUpdateArticleLog('similares_em_scielo');</xsl:attribute>
													</xsl:if>
													<b>
														<xsl:value-of select="$texts/text[find='scieloNetwork']/replace"/>
													</b>
												</a>
											</li>
										</ul>
									</div>
								</div>
								<div style="clear: both;float: none;width: 100%;"/>
							</div>
						</div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="similar">
		<xsl:apply-templates select="article">
			<xsl:with-param name="s" select="@s"/>
			<xsl:with-param name="pos" select="position()"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
