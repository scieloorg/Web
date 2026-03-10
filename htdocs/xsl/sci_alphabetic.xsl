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
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css"/>
			</head>
			<body class="serials-page" link="#0000ff" vlink="#800080" bgcolor="#ffffff">
				<header class="serials-top-header">
					<div class="serials-topbar">
						<button class="serials-ghost-btn" type="button">&#9776; Menu</button>
						<a class="serials-about-link" href="#">&#9432; <xsl:value-of select="$translations/xslid[@id='sci_alphabetic']/text[@find='library_collection']"/></a>
						<div class="serials-lang-menu">
							<button class="serials-ghost-btn serials-lang-btn" type="button">
								&#127760;
								<xsl:text> </xsl:text>
								<xsl:choose>
									<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='pt'">Português</xsl:when>
									<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Español</xsl:when>
									<xsl:otherwise>English</xsl:otherwise>
								</xsl:choose>
								<xsl:text> &#9662;</xsl:text>
							</button>
							<ul class="serials-lang-dropdown">
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}scielo.php?script=sci_alphabetic&amp;lng=pt&amp;nrm=iso">
										<xsl:choose>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Portuguese</xsl:when>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Portugués</xsl:when>
											<xsl:otherwise>Português</xsl:otherwise>
										</xsl:choose>
									</a>
								</li>
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}scielo.php?script=sci_alphabetic&amp;lng=es&amp;nrm=iso">
										<xsl:choose>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Spanish</xsl:when>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='pt'">Espanhol</xsl:when>
											<xsl:otherwise>Español</xsl:otherwise>
										</xsl:choose>
									</a>
								</li>
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}scielo.php?script=sci_alphabetic&amp;lng=en&amp;nrm=iso">
										<xsl:choose>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='pt'">Inglês</xsl:when>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Inglés</xsl:when>
											<xsl:otherwise>English</xsl:otherwise>
										</xsl:choose>
									</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="serials-branding">
						<img alt="SciELO">
							<xsl:attribute name="src">
								<xsl:choose>
									<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='pt'">/img/revistas/scielobrp.gif</xsl:when>
									<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">/img/revistas/scielobre.gif</xsl:when>
									<xsl:otherwise>/img/revistas/scielobri.gif</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</img>
						<div class="serials-brand-subtitle">Scientific Electronic Library Online</div>
					</div>
				</header>
				<main class="serials-content">
				<xsl:apply-templates select="//LIST"/>
				<br/>
				<xsl:call-template name="SERIALS_FOOTER"/>
				</main>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="LIST">
		<section class="journal-list-wrapper">
			<h1 class="journal-list-page-title">
				<xsl:choose>
					<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Journals</xsl:when>
					<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Revistas</xsl:when>
					<xsl:otherwise>Peri&#243;dicos</xsl:otherwise>
				</xsl:choose>
			</h1>
			<div class="journal-list-tabs">
				<span class="journal-tab active">
					<xsl:choose>
						<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Alphabetic</xsl:when>
						<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Alfab&#233;tica</xsl:when>
						<xsl:otherwise>Alfab&#233;tica</xsl:otherwise>
					</xsl:choose>
				</span>
				<a class="journal-tab">
					<xsl:attribute name="href">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php?script=sci_subject&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/></xsl:attribute>
					<xsl:choose>
						<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Thematic</xsl:when>
						<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Tem&#225;tica</xsl:when>
						<xsl:otherwise>Tem&#225;tica</xsl:otherwise>
					</xsl:choose>
				</a>
			</div>
			<div class="journal-list-toolbar">
				<div class="journal-filters">
					<span class="filter-pill">
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">All</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Todos</xsl:when>
							<xsl:otherwise>Todos</xsl:otherwise>
						</xsl:choose>
					</span>
					<span class="filter-pill active"><span class="dot active">&#9679;</span> 
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Active</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Activos</xsl:when>
							<xsl:otherwise>Ativos</xsl:otherwise>
						</xsl:choose>
					</span>
					<span class="filter-pill"><span class="dot discontinued">&#9679;</span> 
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Discontinued</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Descontinuados</xsl:when>
							<xsl:otherwise>Descontinuados</xsl:otherwise>
						</xsl:choose>
					</span>
				</div>
				<input class="journal-filter-input" type="text">
					<xsl:attribute name="placeholder">
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Type to filter the list</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Escriba para filtrar la lista</xsl:when>
							<xsl:otherwise>Digite para filtrar a lista</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</input>
			</div>
			<div class="journal-list-header">
				<div class="journal-list-title">
					<xsl:choose>
						<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Titles (total <xsl:value-of select="count(SERIAL)"/>)</xsl:when>
						<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">T&#237;tulos (total <xsl:value-of select="count(SERIAL)"/>)</xsl:when>
						<xsl:otherwise>T&#237;tulos (total <xsl:value-of select="count(SERIAL)"/>)</xsl:otherwise>
					</xsl:choose>
				</div>
				<button class="serials-ghost-btn small" type="button">&#8681;</button>
			</div>
			<xsl:apply-templates select="." mode="display-list"/>
		</section>
	</xsl:template>
	<xsl:template match="*" mode="display-list">
		<ul class="journal-catalog">
			<xsl:apply-templates select="SERIAL"/>
		</ul>
	</xsl:template>
	<xsl:template match="*" mode="classified">
		<xsl:variable name="count" select="count(SERIAL[.//current-status/@status='C'])"/>
		<xsl:variable name="c" select="count(SERIAL[.//current-status/@status!='C' or not(journal-status-history)])"/>
		<xsl:apply-templates select="." mode="display-msg-current-list">
			<xsl:with-param name="count" select="$count"/>
		</xsl:apply-templates>
		<ul class="journal-catalog">
			<xsl:apply-templates select="SERIAL[.//current-status/@status='C']"/>
		</ul>
		<xsl:if test="SERIAL[.//current-status/@status!='C'  or not(journal-status-history)]">
			<xsl:apply-templates select="." mode="display-msg-not-current-list">
				<xsl:with-param name="count" select="$c"/>
			</xsl:apply-templates>
			<ul class="journal-catalog">
				<xsl:apply-templates select="SERIAL[.//current-status/@status!='C' or not(journal-status-history)]"/>
			</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template match="SERIAL">
		<li class="journal-item">
			<div class="journal-main-line">
				<span>
					<xsl:attribute name="class">
						<xsl:text>journal-status-dot</xsl:text>
						<xsl:if test=".//current-status/@status='C' or not(.//current-status/@status) or .//current-status/@status=''">
							<xsl:text> is-active</xsl:text>
						</xsl:if>
					</xsl:attribute>
				</span>
				<a class="journal-title">
					<xsl:attribute name="href">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php?script=<xsl:apply-templates select="." mode="sci_serial"/>&amp;pid=<xsl:value-of select="TITLE/@ISSN"/>&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/><xsl:apply-templates select="." mode="repo_url_param"/></xsl:attribute>
					<xsl:value-of select="TITLE" disable-output-escaping="yes"/>
				</a>
				<xsl:if test="not(//NO_SCI_SERIAL='yes')">
					<span class="journal-meta">
						<xsl:text>, </xsl:text><xsl:value-of select="@QTYISS"/>&#160;<xsl:value-of select="$translations/xslid[@id='sci_alphabetic']/text[@find='issue']"/><xsl:if test="@QTYISS &gt; 1">s</xsl:if>
					</span>
				</xsl:if>
				<xsl:if test=".//current-status/@status!='' and .//current-status/@status!='C'">
					<span class="journal-meta"> - <xsl:apply-templates select=".//journal-status-history" mode="display-status-info"/></span>
				</xsl:if>
			</div>
		</li>
	</xsl:template>
	<xsl:template match="COPYRIGHT">
		<xsl:call-template name="COPYRIGHTSCIELO"/>
	</xsl:template>
	<xsl:template name="SERIALS_FOOTER">
		<footer class="serials-footer">
			<div class="serials-footer-top">
				<div class="serials-footer-brand">
					<img alt="SciELO" src="https://www.scielo.br/static/img/logo-scielo-no-label.svg"/>
				</div>
				<div class="serials-footer-meta">
					<div class="name"><strong>SciELO - Scientific Electronic Library Online</strong></div>
					<div>Rua Dr. Diogo de Faria, 1087 - 9º andar - Vila Clementino 04037-003 São Paulo/SP - Brasil</div>
					<div>E-mail: scielo@scielo.org</div>
					<div class="social">
						<a class="social-link" aria-label="Bluesky" href="https://bsky.app/" target="_blank" rel="noopener noreferrer"><span class="social-icon social-bluesky"></span></a>
						<a class="social-link" aria-label="LinkedIn" href="https://www.linkedin.com/company/scielo" target="_blank" rel="noopener noreferrer"><span class="social-icon social-linkedin"></span></a>
						<a class="social-link" aria-label="Facebook" href="https://www.facebook.com/scielo.br" target="_blank" rel="noopener noreferrer"><span class="social-icon social-facebook"></span></a>
						<a class="social-link" aria-label="YouTube" href="https://www.youtube.com/" target="_blank" rel="noopener noreferrer"><span class="social-icon social-youtube"></span></a>
					</div>
				</div>
				<div class="serials-footer-license">
					<img alt="CC BY 4.0" src="https://licensebuttons.net/l/by/4.0/88x31.png"/>
				</div>
			</div>
			<div class="serials-footer-logos">
				<img alt="CAPES" src="/design-system/1.0.0/img/logo-footer-capes.svg"/>
				<img alt="CNPq" src="/design-system/1.0.0/img/logo-footer-cnpq.svg"/>
				<img alt="FAPESP" src="/design-system/1.0.0/img/logo-footer-fapesp.svg"/>
				<img alt="BVS" src="/design-system/1.0.0/img/logo-footer-bvs.svg"/>
				<img alt="OPAS BIREME" src="/design-system/1.0.0/img/logo-footer-bireme.svg"/>
				<img alt="FapUNIFESP" src="/design-system/1.0.0/img/logo-footer-fap.svg"/>
			</div>
			<div class="serials-footer-open-access">
				<img alt="Open Access" src="/design-system/1.0.0/img/logo-open-access.svg"/>
				<span>Leia a Declaração de Acesso Aberto</span>
			</div>
		</footer>
	</xsl:template>
</xsl:stylesheet>
