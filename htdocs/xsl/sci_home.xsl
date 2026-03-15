<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="SCIELO_REGIONAL_DOMAIN" select="//SCIELO_REGIONAL_DOMAIN"/>
	<xsl:variable name="show_toolbox" select="//toolbox"/>
	<xsl:variable name="show_login" select="//show_login"/>
	<xsl:variable name="login_url" select="//loginURL"/>
	<xsl:variable name="show_home_journal_evaluation" select="//show_home_journal_evaluation"/>
	<xsl:variable name="show_home_scieloorg" select="//show_home_scieloorg"/>
	<xsl:variable name="show_home_help" select="//show_home_help"/>
	<xsl:variable name="show_home_about" select="//show_home_about"/>
	<xsl:variable name="show_home_scielo_news" select="//show_home_scielo_news"/>
	<xsl:variable name="show_home_scielo_team" select="//show_home_scielo_team"/>
	<xsl:variable name="show_home_scielo_signature" select="//show_home_scielo_signature"/>
	<xsl:variable name="analytics_code" select="//ANALYTICS_CODE"/>
	<xsl:output method="html" indent="no"/>
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:template match="HOMEPAGE">
		<html>
			<head>
				<title><xsl:value-of select="//SCIELOINFOGROUP/SITE_NAME" /></title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<xsl:if test="//NEW_HOME">
					<xsl:variable name="X" select="//NEW_HOME"/>
					<meta HTTP-EQUIV="REFRESH">
						<xsl:attribute name="Content"><xsl:value-of select="concat('0;URL=',$X)"/></xsl:attribute>
					</meta>
				</xsl:if>
				<link rel="STYLESHEET" type="text/css" href="/css/scielo.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css"/>
			</head>
			<xsl:if test="not(//NEW_HOME)">
				<body class="home-page" link="#000080" vlink="#800080" bgcolor="#ffffff">
					<xsl:apply-templates select="CONTROLINFO"/>
				</body>
			</xsl:if>
		</html>
	</xsl:template>
	<xsl:template name="link-ext">
</xsl:template>
	<xsl:template match="CONTROLINFO">
		<header class="home-top-header">
			<div class="home-topbar">
				<button class="serials-ghost-btn" type="button">&#9776; Menu</button>
				<a class="serials-about-link">
					<xsl:attribute name="href">/about/?lang=<xsl:value-of select="normalize-space(LANGUAGE)"/></xsl:attribute>
					&#9432;
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='pt'">Sobre este site</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Sobre este sitio</xsl:when>
						<xsl:otherwise>About this site</xsl:otherwise>
					</xsl:choose>
				</a>
				<div class="serials-lang-menu">
					<button class="serials-ghost-btn serials-lang-btn" type="button">
						&#127760;
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='pt'">Português</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Español</xsl:when>
							<xsl:otherwise>English</xsl:otherwise>
						</xsl:choose>
						<xsl:text> &#9662;</xsl:text>
					</button>
					<ul class="serials-lang-dropdown">
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}scielo.php?lng=pt">
								<xsl:choose>
									<xsl:when test="normalize-space(LANGUAGE)='en'">Portuguese</xsl:when>
									<xsl:when test="normalize-space(LANGUAGE)='es'">Portugués</xsl:when>
									<xsl:otherwise>Português</xsl:otherwise>
								</xsl:choose>
							</a>
						</li>
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}scielo.php?lng=es">
								<xsl:choose>
									<xsl:when test="normalize-space(LANGUAGE)='en'">Spanish</xsl:when>
									<xsl:when test="normalize-space(LANGUAGE)='pt'">Espanhol</xsl:when>
									<xsl:otherwise>Español</xsl:otherwise>
								</xsl:choose>
							</a>
						</li>
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}scielo.php?lng=en">
								<xsl:choose>
									<xsl:when test="normalize-space(LANGUAGE)='pt'">Inglês</xsl:when>
									<xsl:when test="normalize-space(LANGUAGE)='es'">Inglés</xsl:when>
									<xsl:otherwise>English</xsl:otherwise>
								</xsl:choose>
							</a>
						</li>
					</ul>
				</div>
			</div>
			<div class="home-branding">
				<img alt="SciELO" src="/img/revistas/scielobrp.gif"/>
				<div class="home-brand-subtitle">Scientific Electronic Library Online</div>
			</div>
		</header>
		<section class="home-search-wrap">
			<form class="home-search-form" method="get" action="/search_mvp.php">
				<input type="hidden" name="lang">
					<xsl:attribute name="value"><xsl:value-of select="normalize-space(LANGUAGE)"/></xsl:attribute>
				</input>
				<input type="hidden" name="field" value="all"/>
				<input type="hidden" name="page" value="1"/>
				<input class="home-search-input" type="text" name="q">
					<xsl:attribute name="placeholder">
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='en'">Enter one or more words</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Ingrese una o m&#225;s palabras</xsl:when>
							<xsl:otherwise>Entre uma ou mais palavras</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</input>
				<button class="home-search-btn" type="submit">
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='en'">Search</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Buscar</xsl:when>
						<xsl:otherwise>Buscar</xsl:otherwise>
					</xsl:choose>
				</button>
			</form>
			<input type="hidden" id="home-current-lang" value="{normalize-space(LANGUAGE)}"/>
		</section>
		<section class="home-journal-links">
			<h2>
				<xsl:choose>
					<xsl:when test="normalize-space(LANGUAGE)='en'">Journal list</xsl:when>
					<xsl:when test="normalize-space(LANGUAGE)='es'">Lista de revistas</xsl:when>
					<xsl:otherwise>Lista de peri&#243;dicos</xsl:otherwise>
				</xsl:choose>
			</h2>
			<div class="home-journal-links-box">
				<a class="home-journal-link">
					<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_alphabetic&amp;lng=<xsl:value-of select="LANGUAGE"/>&amp;nrm=iso</xsl:attribute>
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='en'">Alphabetic</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Alfab&#233;tica</xsl:when>
						<xsl:otherwise>Alfab&#233;tica</xsl:otherwise>
					</xsl:choose>
				</a>
				<a class="home-journal-link">
					<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_subject&amp;lng=<xsl:value-of select="LANGUAGE"/>&amp;nrm=iso</xsl:attribute>
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='en'">Thematic</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Tem&#225;tica</xsl:when>
						<xsl:otherwise>Tem&#225;tica</xsl:otherwise>
					</xsl:choose>
				</a>
				<div class="home-journal-search-box">
					<input id="home-journal-filter" class="home-journal-filter" type="text">
						<xsl:attribute name="placeholder">
							<xsl:choose>
								<xsl:when test="normalize-space(LANGUAGE)='en'">Search journals</xsl:when>
								<xsl:when test="normalize-space(LANGUAGE)='es'">Buscar revistas</xsl:when>
								<xsl:otherwise>Busca por peri&#243;dicos</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</input>
					<div id="home-journal-results" class="home-journal-results"></div>
				</div>
			</div>
		</section>
		<section class="home-press-releases">
			<h2>SciELO Press Releases</h2>
			<div class="home-pr-carousel">
				<button id="home-pr-prev" class="home-pr-nav" type="button" aria-label="Anterior">&#8249;</button>
				<div id="home-pr-grid" class="home-pr-grid">
					<div class="home-pr-loading">Carregando posts...</div>
				</div>
				<button id="home-pr-next" class="home-pr-nav" type="button" aria-label="Próximo">&#8250;</button>
			</div>
			<div id="home-pr-dots" class="home-pr-dots"></div>
		</section>
		<section class="home-press-releases home-perspective">
			<h2>SciELO em perspectiva</h2>
			<div class="home-pr-carousel">
				<button id="home-sp-prev" class="home-pr-nav" type="button" aria-label="Anterior">&#8249;</button>
				<div id="home-sp-grid" class="home-pr-grid">
					<div class="home-pr-loading">Carregando posts...</div>
				</div>
				<button id="home-sp-next" class="home-pr-nav" type="button" aria-label="Próximo">&#8250;</button>
			</div>
			<div id="home-sp-dots" class="home-pr-dots"></div>
		</section>
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
		<script><![CDATA[
		(function () {
		  var input = document.getElementById('home-journal-filter');
		  var results = document.getElementById('home-journal-results');
		  var langInput = document.getElementById('home-current-lang');
		  var currentLang = (langInput && langInput.value) ? langInput.value : 'pt';
		  var prGrid = document.getElementById('home-pr-grid');
		  var prPrev = document.getElementById('home-pr-prev');
		  var prNext = document.getElementById('home-pr-next');
		  var prDots = document.getElementById('home-pr-dots');
		  var spGrid = document.getElementById('home-sp-grid');
		  var spPrev = document.getElementById('home-sp-prev');
		  var spNext = document.getElementById('home-sp-next');
		  var spDots = document.getElementById('home-sp-dots');
		  var prPosts = [];
		  var prPage = 0;
		  var spPosts = [];
		  var spPage = 0;
		  var prPerPage = 4;
		  var journals = [];
		  var loaded = false;
		  var loading = false;

		  function escapeHtml(str) {
		    return String(str)
		      .replace(/&/g, '&amp;')
		      .replace(/</g, '&lt;')
		      .replace(/>/g, '&gt;')
		      .replace(/"/g, '&quot;')
		      .replace(/'/g, '&#39;');
		  }

		  function render(items) {
		    if (!items.length) {
		      results.style.display = 'none';
		      results.innerHTML = '';
		      return;
		    }
		    results.innerHTML = '<ul>' + items.map(function (item) {
		      return '<li><a href="' + item.href + '">' + escapeHtml(item.title) + '</a></li>';
		    }).join('') + '</ul>';
		    results.style.display = 'block';
		  }

		  function filterAndRender() {
		    var q = (input.value || '').trim().toLowerCase();
		    if (q.length < 2) {
		      results.style.display = 'none';
		      results.innerHTML = '';
		      return;
		    }
		    var filtered = journals.filter(function (j) {
		      return j.title.toLowerCase().indexOf(q) !== -1;
		    }).slice(0, 20);
		    render(filtered);
		  }

		  function loadJournals() {
		    if (loaded || loading) {
		      return;
		    }
		    loading = true;
		    fetch('/scielo.php?script=sci_alphabetic&lng=en&nrm=iso', { credentials: 'same-origin' })
		      .then(function (r) { return r.text(); })
		      .then(function (html) {
		        var doc = new DOMParser().parseFromString(html, 'text/html');
		        var links = doc.querySelectorAll('a.journal-title');
		        var seen = {};
		        journals = Array.prototype.map.call(links, function (a) {
		          return {
		            title: (a.textContent || '').trim(),
		            href: a.getAttribute('href')
		          };
		        }).filter(function (j) {
		          if (!j.title || !j.href || seen[j.href]) {
		            return false;
		          }
		          seen[j.href] = true;
		          return true;
		        });
		        loaded = true;
		        filterAndRender();
		      })
		      .catch(function () {
		        results.style.display = 'none';
		      })
		      .finally(function () {
		        loading = false;
		      });
		  }

		  input.addEventListener('focus', loadJournals);
		  input.addEventListener('input', function () {
		    if (!loaded) {
		      loadJournals();
		      return;
		    }
		    filterAndRender();
		  });
		  document.addEventListener('click', function (e) {
		    if (!results.contains(e.target) && e.target !== input) {
		      results.style.display = 'none';
		    }
		  });

		  function readMoreLabel() {
		    if (currentLang === 'en') {
		      return 'Continue reading';
		    }
		    if (currentLang === 'es') {
		      return 'Seguir leyendo';
		    }
		    return 'Continue lendo';
		  }

		  function formatDate(value) {
		    if (!value) {
		      return '';
		    }
		    var date = new Date(value);
		    if (isNaN(date.getTime())) {
		      return value;
		    }
		    var locale = currentLang === 'en' ? 'en-US' : (currentLang === 'es' ? 'es-ES' : 'pt-BR');
		    return date.toLocaleDateString(locale, {
		      year: 'numeric',
		      month: '2-digit',
		      day: '2-digit'
		    });
		  }

		  function renderPressReleases(posts) {
		    if (!prGrid) {
		      return;
		    }
		    if (!posts || !posts.length) {
		      prGrid.innerHTML = '<div class="home-pr-loading">Nenhum post encontrado.</div>';
		      if (prDots) {
		        prDots.innerHTML = '';
		      }
		      if (prPrev) {
		        prPrev.style.visibility = 'hidden';
		      }
		      if (prNext) {
		        prNext.style.visibility = 'hidden';
		      }
		      return;
		    }
		    var totalPages = Math.ceil(posts.length / prPerPage);
		    if (prPage >= totalPages) {
		      prPage = 0;
		    }
		    var start = prPage * prPerPage;
		    var end = start + prPerPage;
		    var visiblePosts = posts.slice(start, end);
		    var btn = readMoreLabel();
		    prGrid.innerHTML = visiblePosts.map(function (post) {
		      var image = post.image ? post.image : '/design-system/1.0.0/img/list.loading.gif';
		      return (
		        '<article class="home-pr-card">' +
		          '<a class="home-pr-image-link" href="' + post.link + '" target="_blank" rel="noopener noreferrer">' +
		            '<img src="' + image + '" alt="">' +
		          '</a>' +
		          '<div class="home-pr-body">' +
		            '<div class="home-pr-date">' + escapeHtml(formatDate(post.date)) + '</div>' +
		            '<a class="home-pr-title" href="' + post.link + '" target="_blank" rel="noopener noreferrer">' + escapeHtml(post.title) + '</a>' +
		            '<a class="home-pr-readmore" href="' + post.link + '" target="_blank" rel="noopener noreferrer">' + btn + '</a>' +
		          '</div>' +
		        '</article>'
		      );
		    }).join('');
		    if (prPrev) {
		      prPrev.style.visibility = totalPages > 1 ? 'visible' : 'hidden';
		    }
		    if (prNext) {
		      prNext.style.visibility = totalPages > 1 ? 'visible' : 'hidden';
		    }
		    if (prDots) {
		      var dotsHtml = '';
		      for (var i = 0; i < totalPages; i++) {
		        dotsHtml += '<button type="button" class="home-pr-dot' + (i === prPage ? ' active' : '') + '" data-page="' + i + '" aria-label="Página ' + (i + 1) + '"></button>';
		      }
		      prDots.innerHTML = dotsHtml;
		    }
		  }

		  function renderPerspective(posts) {
		    if (!spGrid) {
		      return;
		    }
		    if (!posts || !posts.length) {
		      spGrid.innerHTML = '<div class="home-pr-loading">Nenhum post encontrado.</div>';
		      if (spDots) {
		        spDots.innerHTML = '';
		      }
		      if (spPrev) {
		        spPrev.style.visibility = 'hidden';
		      }
		      if (spNext) {
		        spNext.style.visibility = 'hidden';
		      }
		      return;
		    }
		    var totalPages = Math.ceil(posts.length / prPerPage);
		    if (spPage >= totalPages) {
		      spPage = 0;
		    }
		    var start = spPage * prPerPage;
		    var end = start + prPerPage;
		    var visiblePosts = posts.slice(start, end);
		    var btn = readMoreLabel();
		    spGrid.innerHTML = visiblePosts.map(function (post) {
		      var image = post.image ? post.image : '/design-system/1.0.0/img/list.loading.gif';
		      var excerpt = post.excerpt ? escapeHtml(post.excerpt) : '';
		      return (
		        '<article class="home-pr-card">' +
		          '<a class="home-pr-image-link" href="' + post.link + '" target="_blank" rel="noopener noreferrer">' +
		            '<img src="' + image + '" alt="">' +
		          '</a>' +
		          '<div class="home-pr-body">' +
		            '<div class="home-pr-date">' + escapeHtml(formatDate(post.date)) + '</div>' +
		            '<a class="home-pr-title" href="' + post.link + '" target="_blank" rel="noopener noreferrer">' + escapeHtml(post.title) + '</a>' +
		            '<div class="home-pr-excerpt">' + excerpt + '</div>' +
		            '<a class="home-pr-readmore" href="' + post.link + '" target="_blank" rel="noopener noreferrer">' + btn + '</a>' +
		          '</div>' +
		        '</article>'
		      );
		    }).join('');
		    if (spPrev) {
		      spPrev.style.visibility = totalPages > 1 ? 'visible' : 'hidden';
		    }
		    if (spNext) {
		      spNext.style.visibility = totalPages > 1 ? 'visible' : 'hidden';
		    }
		    if (spDots) {
		      var dotsHtml = '';
		      for (var i = 0; i < totalPages; i++) {
		        dotsHtml += '<button type="button" class="home-pr-dot' + (i === spPage ? ' active' : '') + '" data-page="' + i + '" aria-label="Página ' + (i + 1) + '"></button>';
		      }
		      spDots.innerHTML = dotsHtml;
		    }
		  }

		  function loadPressReleases() {
		    if (!prGrid) {
		      return;
		    }
		    fetch('/pressreleases_proxy.php?lang=' + encodeURIComponent(currentLang) + '&limit=8', { credentials: 'same-origin' })
		      .then(function (r) { return r.json(); })
		      .then(function (data) {
		        prPosts = data.posts || [];
		        prPage = 0;
		        renderPressReleases(prPosts);
		      })
		      .catch(function () {
		        prGrid.innerHTML = '<div class="home-pr-loading">Falha ao carregar posts.</div>';
		      });
		  }

		  function loadPerspective() {
		    if (!spGrid) {
		      return;
		    }
		    fetch('/perspectiva_proxy.php?lang=' + encodeURIComponent(currentLang) + '&limit=8', { credentials: 'same-origin' })
		      .then(function (r) { return r.json(); })
		      .then(function (data) {
		        spPosts = data.posts || [];
		        spPage = 0;
		        renderPerspective(spPosts);
		      })
		      .catch(function () {
		        spGrid.innerHTML = '<div class="home-pr-loading">Falha ao carregar posts.</div>';
		      });
		  }

		  if (prPrev) {
		    prPrev.addEventListener('click', function () {
		      if (!prPosts.length) {
		        return;
		      }
		      var total = Math.ceil(prPosts.length / prPerPage);
		      prPage = (prPage - 1 + total) % total;
		      renderPressReleases(prPosts);
		    });
		  }

		  if (prNext) {
		    prNext.addEventListener('click', function () {
		      if (!prPosts.length) {
		        return;
		      }
		      var total = Math.ceil(prPosts.length / prPerPage);
		      prPage = (prPage + 1) % total;
		      renderPressReleases(prPosts);
		    });
		  }

		  if (prDots) {
		    prDots.addEventListener('click', function (event) {
		      var target = event.target;
		      if (!target || !target.getAttribute) {
		        return;
		      }
		      var page = target.getAttribute('data-page');
		      if (page === null) {
		        return;
		      }
		      prPage = parseInt(page, 10) || 0;
		      renderPressReleases(prPosts);
		    });
		  }

		  if (spPrev) {
		    spPrev.addEventListener('click', function () {
		      if (!spPosts.length) {
		        return;
		      }
		      var total = Math.ceil(spPosts.length / prPerPage);
		      spPage = (spPage - 1 + total) % total;
		      renderPerspective(spPosts);
		    });
		  }

		  if (spNext) {
		    spNext.addEventListener('click', function () {
		      if (!spPosts.length) {
		        return;
		      }
		      var total = Math.ceil(spPosts.length / prPerPage);
		      spPage = (spPage + 1) % total;
		      renderPerspective(spPosts);
		    });
		  }

		  if (spDots) {
		    spDots.addEventListener('click', function (event) {
		      var target = event.target;
		      if (!target || !target.getAttribute) {
		        return;
		      }
		      var page = target.getAttribute('data-page');
		      if (page === null) {
		        return;
		      }
		      spPage = parseInt(page, 10) || 0;
		      renderPerspective(spPosts);
		    });
		  }

		  loadPressReleases();
		  loadPerspective();
		})();
		]]></script>
	</xsl:template>
	<xsl:template match="SCIELOINFOGROUP">
		<p align="center">
			<font class="nomodel" color="#0000A0" size="-1">
				<xsl:value-of select="normalize-space(SITE_NAME)"/>
				<br/>
				<xsl:value-of select="normalize-space(ORGANIZATION)"/>
				<br/>
				<xsl:value-of select="normalize-space(ADDRESS/ADDRESS_1)"/>
				<br/>
				<xsl:value-of select="normalize-space(ADDRESS/ADDRESS_2)"/> - <xsl:value-of select="normalize-space(ADDRESS/COUNTRY)"/>
				<br/>
				<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='phone']"/>: <xsl:value-of select="normalize-space(PHONE)"/>
				<br/>
				<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='fax']"/>: <xsl:value-of select="normalize-space(FAX)"/>
			</font>
			<br/>
			<a class="email">
				<xsl:attribute name="href">mailto:<xsl:value-of select="normalize-space(EMAIL)"/></xsl:attribute>
				<img>
					<xsl:attribute name="src"><xsl:value-of select="//PATH_GENIMG"/>e-mailt.gif</xsl:attribute>
					<xsl:attribute name="border">0</xsl:attribute>
				</img>
				<br/>
				<font color="#0000A0" size="2">
					<xsl:value-of select="normalize-space(EMAIL)"/>
				</font>
			</a>
		</p>
		<xsl:call-template name="UpdateLog"/>
	</xsl:template>
	<xsl:template match="USERINFO" mode="box">
		<xsl:param name="lang"/>
		<xsl:variable name="STATUS" select="@status"/>
		<xsl:if test="$STATUS = 'logout' and $show_login=1">
			<p>
				<a href="http://{$SCIELO_REGIONAL_DOMAIN}/{$login_url}?lang={$lang}">
					<span>
						<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='register_free']"/>
					</span>
				</a>
			</p>
		</xsl:if>
		<xsl:if test="$STATUS = 'login'">
			<p>
				<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='welcome']"/>: <xsl:value-of select="."/>
			</p>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
