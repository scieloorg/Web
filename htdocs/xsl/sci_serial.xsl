<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="journalStatus.xsl"/>
	<xsl:variable name="analytics_code" select="//ANALYTICS_CODE"/>
	<xsl:variable name="forceType" select="//CONTROLINFO/ENABLE_FORCETYPE"/>
	<xsl:variable name="ISSN_AS_ID" select="concat(substring-before(/SERIAL/ISSN_AS_ID,'-'),substring-after(/SERIAL/ISSN_AS_ID,'-'))"/>
	<xsl:variable name="show_scimago" select="//show_scimago"/>
	
	<xsl:variable name="scimago_status" select="//scimago_status"/>
	<xsl:variable name="has_article_pr">
		<xsl:choose>
			<xsl:when test="//PRESSRELEASE/article[@prpid != '']">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="has_issue_pr">
		<xsl:choose>
			<xsl:when test="//PRESSRELEASE/issue[@pid != '']">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pref">
		<xsl:choose>
			<xsl:when test="//CONTROLINFO/LANGUAGE='en' ">i</xsl:when>
			<xsl:when test="//CONTROLINFO/LANGUAGE='es' ">e</xsl:when>
			<xsl:when test="//CONTROLINFO/LANGUAGE='pt' ">p</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:output method="html" indent="no" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<xsl:template match="SERIAL">
		<html>
			<head>
				<title>
					<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/> - <xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='home_page']"/>
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<xsl:if test="//NO_SCI_SERIAL='yes'">
					<xsl:variable name="X">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/>
						<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_artlist&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/>
						<xsl:apply-templates select="." mode="repo_url_param"/>
					</xsl:variable>
					<meta HTTP-EQUIV="REFRESH">
						<xsl:attribute name="Content"><xsl:value-of select="concat('0;URL=',$X)"/></xsl:attribute>
					</meta>
				</xsl:if>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/scielo.css"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_layout.css"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_styles.css"/>
				<!-- link pro RSS aparecer automaticamente no Browser -->
				<xsl:call-template name="AddRssHeaderLink">
					<xsl:with-param name="pid" select="//CURRENT/@PID"/>
					<xsl:with-param name="lang" select="//LANGUAGE"/>
					<xsl:with-param name="server" select="CONTROLINFO/SCIELO_INFO/SERVER"/>
					<xsl:with-param name="script">rss.php</xsl:with-param>
				</xsl:call-template>
				<script type="text/javascript" src="/applications/scielo-org/js/functions.js"/>
				<script type="text/javascript" src="/article.js"/>
			</head>
			<body>
				<xsl:if test="//NO_SCI_SERIAL!='yes' or not(//NO_SCI_SERIAL)">
					<div class="container">
						<div class="top">
							<!--
                                monta a barra de navegacao
                            -->
							<xsl:call-template name="NAVBAR">
								<xsl:with-param name="bar1">issues</xsl:with-param>
								<xsl:with-param name="bar2">articlesiah</xsl:with-param>
								<xsl:with-param name="alpha">
									<xsl:choose>
										<xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' ">0</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="scope" select="TITLEGROUP/SIGLUM"/>
							</xsl:call-template>
						</div>
						<div class="middle">
							<!--
                                monta as divs: leftCol e mainContent
                            -->
							<xsl:apply-templates select="CONTROLINFO">
								<xsl:with-param name="YEAR" select="substring(@LASTUPDT,1,4)"/>
								<xsl:with-param name="MONTH" select="substring(@LASTUPDT,5,2)"/>
								<xsl:with-param name="DAY" select="substring(@LASTUPDT,7,2)"/>
							</xsl:apply-templates>
							<!--
                                monta a div: rightCol
                            -->
							<xsl:choose>
								<xsl:when test="$journal_manager='1'">
									<div class="rightCol" style="display: none;" id="rightCol">
										<h2 class="sectionHeading">
											<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='press_releases']"/>
										</h2>
										<span id="pr_issue_area" style="display: none;">
											<strong>
												<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='numbers']"/>
											</strong>
											<span class="PressReleases" id="issuePressRelease"></span>
										</span>
										<span id="pr_article_area" style="display: none;">
											<strong>
												<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='articles']"/>
											</strong>
											<span class="PressReleases" id="articlePressRelease"></span>
										</span>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="rightCol">
										<xsl:if test="($has_issue_pr = 'false') and ($has_article_pr = 'false')">
											<xsl:attribute name="style">display: none;</xsl:attribute>
										</xsl:if>
										<h2 class="sectionHeading">
											<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='press_releases']"/>
										</h2>
										<xsl:if test="$has_issue_pr != 'false'">
											<strong>
												<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='numbers']"/>
											</strong>
											<ul class="pressReleases">
												<xsl:apply-templates select="//PRESSRELEASE/issue" mode="pr">
													<xsl:sort select="@data" order="descending"/>
												</xsl:apply-templates>
											</ul>
										</xsl:if>
										<xsl:if test="$has_article_pr != 'false'">
											<strong>
												<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='articles']"/>
											</strong>
											<ul class="pressReleases">
												<xsl:apply-templates select="//PRESSRELEASE/article" mode="pr">
													<xsl:sort select="@data" order="descending"/>
												</xsl:apply-templates>
											</ul>
										</xsl:if>
									</div>
								</xsl:otherwise>
							</xsl:choose>
							
						</div>
						<div class="spacer">&#160;</div>
						<!--
                            monta a div: footer
                        -->
						<xsl:apply-templates select="." mode="footer-journal"/>

                    <!-- display google scholar metrics (h5 e m5 index) -->
                    <script type="text/javascript">                            
                        function print_h5_m5(data) { 
                        	var html_data = '';
                            if (data != null) {
                            	for (year in data){
                            		url = data[year]['url'];
                            		var text_h5 =  '<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='google_scholar_h5_index']"/>';
                            		var text_m5 = '<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='google_scholar_m5_index']"/>';
                            		html_data +='<div><strong>'+year+'</strong></div>';
	                                html_data +='<div><strong>'+text_h5+':</strong> '+data[year]['h5']+'</div>';
	                                html_data +='<div><strong>'+text_m5+':</strong> '+data[year]['m5']+'</div>';
									html_data +='<div style="margin-top: 5px"><a href="'+url+'" id="h5_m5_see_more" target="_blank"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='more_details']"/></a></div>';
                            	}
                            	document.getElementById('google_metrics_years').innerHTML = html_data;
                                document.getElementById('google_metrics').style.display = 'block';
                            }
                        }

                        var script = document.createElement('script');
                        script.src = "google_metrics/get_h5_m5.php" + '?issn=<xsl:value-of select="//PAGE_PID"/>&amp;callback=print_h5_m5';
                        document.getElementsByTagName('head')[0].appendChild(script);
                    </script>

					</div>
				</xsl:if>
				<xsl:if test="$journal_manager=1">
				  <script type="text/javascript" src="/js/jquery-1.9.1.min.js" />
				  <script type="text/javascript">
				  var lng = '<xsl:value-of select="CONTROLINFO/LANGUAGE"/>';
				  var pid = '<xsl:value-of select="//PAGE_PID"/>';
				  function qry_prs() {
				    var url = "pressrelease/pressreleases_from_pid.php?lng="+lng+"&amp;pid="+pid;
				    $.ajax({
				      url: url,
				      success: function (data) {
				      	jdata = jQuery.parseJSON(data);

				      	if (jdata['issue'].length > 0 || jdata['article'].length > 0) {
				      		$("#rightCol").show();
				      	}
				      	if (jdata['issue'].length > 0){
				      		$("#pr_issue_area").show();
				      	}
				      	if (jdata['article'].length > 0){
				      		$("#pr_article_area").show();
				      	}
				      	var issue_html = '<ul class="PressReleases" style="padding-left: 20px; margin-left: 0px;">';
				      	for (var item in jdata['issue']){
				      	    var pr_url = 'pressrelease/pressrelease_display.php?lng='+lng+'&amp;id='+jdata['issue'][item]['id']+'&amp;pid='+jdata['issue'][item]['pid'];
				      		issue_html += '<li><a href="'+pr_url+'"><b>'
				      		           +jdata['issue'][item]['issue_label']
				      		           +'</b><br/>'
				      		           +jdata['issue'][item]['title']
				      		           +'</a></li>';
				      	}
				      	issue_html += '</ul>';

				      	var article_html = '<ul class="PressReleases" style="padding-left: 20px; margin-left: 0px;">';
				      	for (var item in jdata['article']){
				      		var pr_url = 'pressrelease/pressrelease_display.php?lng='+lng+'&amp;id='+jdata['article'][item]['id']+'&amp;pid='+jdata['article'][item]['pid'];
				      		article_html += '<li><a href="'+pr_url+'"> <b>'
				      					 +jdata['article'][item]['issue_label']
				      					 +'</b><br/> '
				      					 +jdata['article'][item]['title']
				      					 +'</a></li>';
				      	}
				      	article_html += '</ul>';

				      	$("#issuePressRelease").html(issue_html);
				      	$("#articlePressRelease").html(article_html);
				      }
				    });
				  }
				  $(document).ready(function() {
				      qry_prs();
				  });
				</script>
			</xsl:if>
			</body>
		</html>
	</xsl:template>
	<!--
press release do issue
-->
	<xsl:template match="issue" mode="pr">
		<xsl:variable name="supl">
			<xsl:value-of select="string-length(normalize-space(@sup))"/>
		</xsl:variable>
		<xsl:variable name="voll">
			<xsl:value-of select="string-length(normalize-space(@vol))"/>
		</xsl:variable>
		<xsl:variable name="numl">
			<xsl:value-of select="string-length(normalize-space(@num))"/>
		</xsl:variable>
		<xsl:variable name="year" select="substring(@data,1,4)"/>
		<xsl:variable name="month" select="substring(@data,5,2)"/>
		<xsl:variable name="day" select="substring(@data,7,2)"/>
		<xsl:variable name="currlang" select="//CONTROLINFO/LANGUAGE"/>
		<li>
			<a href="javascript:void();" onClick="OpenArticleInfoWindow(850,500,'/scielo.php?script=sci_arttext_pr&amp;pid={@pid}&amp;lng={$currlang}&amp;nrm=iso&amp;tlng={@lang}');">
				<strong>
					<xsl:if test="$currlang='pt'">
						<xsl:value-of select="concat($month,'/',$year)"/>
					</xsl:if>
					<xsl:if test="$currlang='es'">
						<xsl:value-of select="concat($month,'/',$year)"/>
					</xsl:if>
					<xsl:if test="$currlang='en'">
						<xsl:value-of select="concat($year,'/',$month)"/>
					</xsl:if>
     -
    <xsl:if test="$voll != 0">v<xsl:value-of select="@vol"/>&#160;</xsl:if>
					<xsl:if test="$numl != 0">n.<xsl:value-of select="@num"/>&#160;</xsl:if>
					<xsl:if test="$supl != 0">s.<xsl:value-of select="@sup"/>
					</xsl:if>
				</strong>
				<span>
					<xsl:value-of select="title"/>
				</span>
			</a>
		</li>
	</xsl:template>
	<!--
press release do artigo
-->
	<xsl:template match="article" mode="pr">
		<xsl:variable name="supl">
			<xsl:value-of select="string-length(normalize-space(@sup))"/>
		</xsl:variable>
		<xsl:variable name="voll">
			<xsl:value-of select="string-length(normalize-space(@vol))"/>
		</xsl:variable>
		<xsl:variable name="numl">
			<xsl:value-of select="string-length(normalize-space(@num))"/>
		</xsl:variable>
		<xsl:variable name="year" select="substring(@data,1,4)"/>
		<xsl:variable name="month" select="substring(@data,5,2)"/>
		<xsl:variable name="day" select="substring(@data,7,2)"/>
		<xsl:variable name="currlang" select="//CONTROLINFO/LANGUAGE"/>
		<li>
			<a href="javascript:void();" onClick="OpenArticleInfoWindow(850,500,'/scielo.php?script=sci_arttext_pr&amp;pid={@prpid}&amp;lng={$currlang}&amp;nrm=iso&amp;tlng={title/@lang}');">
				<strong>
					<xsl:if test="$currlang='pt'">
						<xsl:value-of select="concat($month,'/',$year)"/>
					</xsl:if>
					<xsl:if test="$currlang='es'">
						<xsl:value-of select="concat($month,'/',$year)"/>
					</xsl:if>
					<xsl:if test="$currlang='en'">
						<xsl:value-of select="concat($year,'/',$month)"/>
					</xsl:if>
    -
    <xsl:if test="$voll != 0">v<xsl:value-of select="@vol"/>&#160;</xsl:if>
					<xsl:if test="$numl != 0">n.<xsl:value-of select="@num"/>&#160;</xsl:if>
					<xsl:if test="$supl != 0">s.<xsl:value-of select="@sup"/>
					</xsl:if>
				</strong>
				<span>
					<xsl:value-of select="title"/>
				</span>
			</a>
		</li>
	</xsl:template>
	<!--
        nome do publicador
    -->
	<xsl:template match="PUBLISHER">
		<xsl:value-of select="NAME" disable-output-escaping="yes"/>
		<br/>
	</xsl:template>
	<!--
        missao da revista
    -->
	<xsl:template match="MISSION">
		<font color="#000080">
			<xsl:value-of select="." disable-output-escaping="yes"/>
			<br/>
		</font>
		<br/>
	</xsl:template>
	<!--
		links dos idiomas da interface
	-->
	<xsl:template match="CONTROLINFO" mode="change-language">
		<br/>
		<xsl:if test="//CONTROLINFO/LANGUAGE != 'pt'">
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="//PAGE_NAME"/>&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=pt&amp;nrm=iso</xsl:attribute>
				<font class="linkado" size="-1">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='portuguese']"/>
				</font>
			</a>
			<br/>
		</xsl:if>
		<xsl:if test="//CONTROLINFO/LANGUAGE != 'en'">
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="//PAGE_NAME"/>&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=en&amp;nrm=iso</xsl:attribute>
				<font class="linkado" size="-1">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='english']"/>
				</font>
			</a>
			<br/>
		</xsl:if>
		<xsl:if test="//CONTROLINFO/LANGUAGE != 'es'">
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="//PAGE_NAME"/>&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=es&amp;nrm=iso</xsl:attribute>
				<font class="linkado" size="-1">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='spanish']"/>
				</font>
			</a>
			<br/>
		</xsl:if>
	</xsl:template>
	<!--
		formacao do link de pagina secundaria
	-->
	<xsl:template match="CONTROLINFO" mode="link_to_secondary_page">
		<xsl:param name="itemName"/>
		<xsl:param name="itemName2"/>
		<xsl:param name="label"/>
		<li>
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_SERIAL_HTML"/><xsl:value-of select="/SERIAL/TITLEGROUP/SIGLUM"/>/<xsl:value-of select="$pref"/><xsl:if test="$itemName2"><xsl:value-of select="$itemName2"/></xsl:if><xsl:if test="not($itemName2)"><xsl:value-of select="$itemName"/></xsl:if>.htm</xsl:attribute>
				<xsl:value-of select="$label"/>
			</a>
		</li>
	</xsl:template>
	<!--
		formacao dos links das paginas secundarias
	-->
	<xsl:template match="CONTROLINFO" mode="links">
		<ul class="contextMenu">
			<!--link de submissao-->
			<xsl:apply-templates select="..//link"/>
			<xsl:apply-templates select="." mode="link_to_secondary_page">
				<xsl:with-param name="itemName" select="'aboutj'"/>
				<xsl:with-param name="label">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='about_the_journal']"/>
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="." mode="link_to_secondary_page">
				<xsl:with-param name="itemName" select="'edboard'"/>
				<xsl:with-param name="label">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='editorial_board']"/>
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="." mode="link_to_secondary_page">
				<xsl:with-param name="itemName" select="'instruc'"/>
				<xsl:with-param name="label">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='instructions_to_authors']"/>
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="." mode="link_to_secondary_page">
				<xsl:with-param name="itemName" select="'subscri'"/>
				<xsl:with-param name="itemName2" select="'subscrp'"/>
				<xsl:with-param name="label">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='subscription']"/>
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:if test=" ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 ">
				<li>
    				<strong><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='statistics']"/></strong>
	                <ul>
                        <li>
                            <a href="{SCIELO_INFO/SERVER_SCIELO}/statjournal.php?lang={LANGUAGE}&amp;issn={/SERIAL/ISSN_AS_ID}&amp;collection={$analytics_code}">SciELO</a>
                        </li>

                        <!-- monta o grafico scimago -->
                        
                        <!--xsl:variable name="graphMago" select="document('file:///../../bases/scimago/scimago.xml')/SCIMAGOLIST/title[@ISSN = $ISSN_AS_ID]/@SCIMAGO_ID"/-->
                        <xsl:variable name="graphMago" select="document('../../bases/scimago/scimago.xml')/SCIMAGOLIST/title[@ISSN = $ISSN_AS_ID]/@SCIMAGO_ID"/>
                        <xsl:if test="$show_scimago!=0 and normalize-space($scimago_status) = normalize-space('online')">
                            <xsl:if test="$graphMago">
                                <li>
                                    <strong>
                                        <a>
                                            <xsl:attribute name="href">http://www.scimagojr.com/journalsearch.php?q=<xsl:value-of select="$ISSN_AS_ID"/>&amp;tip=iss&amp;exact=yes></xsl:attribute>
                                            <xsl:attribute name="target">_blank</xsl:attribute>
                                            Scimago    
                                        </a>
                                    </strong>
                                    <a>
                                        <xsl:attribute name="href">http://www.scimagojr.com/journalsearch.php?q=<xsl:value-of select="$ISSN_AS_ID"/>&amp;tip=iss&amp;exact=yes></xsl:attribute>
                                        <xsl:attribute name="target">_blank</xsl:attribute>
                                        <img>
                                            <xsl:attribute name="src">/img/scimago/<xsl:value-of select="$ISSN_AS_ID"/>.gif</xsl:attribute>
                                            <xsl:attribute name="alt"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='scimago_journal_country_rank']"/></xsl:attribute>
                                            <xsl:attribute name="border">0</xsl:attribute>
                                            <xsl:attribute name="width">185</xsl:attribute>
                                        </img>
                                    </a>
                                </li>
                            </xsl:if>
                        </xsl:if>                           

                        <!-- google analytics metrics -->
                        <div id="google_metrics" style="display:none; margin-top: 10px;">
                            <li>                
                                <div style="margin-bottom: 5px">
                                    <a href="#" id="h5_m5_link" target="_blank"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='google_scholar_metrics']"/></a>
                                </div>
                                <div id="google_metrics_years">
                                </div>
                            </li>
                        </div>
                    </ul>
				</li>
			</xsl:if>
		</ul>
	</xsl:template>
	<!--
        submissao online
    -->
	<xsl:template match="link">
		<xsl:variable name="t" select="@type"/>
		<xsl:variable name="label">
			<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find=$t]"/><xsl:value-of select="@label"/>
		</xsl:variable>
		<xsl:if test="$label!=''">
			<li>
				<xsl:if test="$t='online_submission'">
					<xsl:attribute name="id">btn_submission</xsl:attribute>
				</xsl:if>
				<a href="{.}" target="{$t}">
					<xsl:choose>
					<xsl:when test="$t != 'online_submission'">
						<xsl:value-of select="$label"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class"><xsl:value-of select="$interfaceLang"/>_button</xsl:attribute>
					</xsl:otherwise>
					
					</xsl:choose>
				</a>
				<br/>
			</li>
		</xsl:if>
	</xsl:template>
	<!--
		textos traduzidos
	-->
	<!-- 
	CONTROLINFO
	-->
	<xsl:template match="CONTROLINFO">
		<xsl:param name="YEAR"/>
		<xsl:param name="MONTH"/>
		<xsl:param name="DAY"/>
		<div class="leftCol">
			<small>
				<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='updated_on']"/>
			</small>
			<span id="lastUpdate">
				<xsl:call-template name="GET_MONTH_NAME">
					<xsl:with-param name="LANG" select="LANGUAGE"/>
					<xsl:with-param name="MONTH" select="$MONTH"/>
				</xsl:call-template>&#160;<xsl:value-of select="$DAY"/>,&#160;<xsl:value-of select="$YEAR"/>
			</span>
			<xsl:apply-templates select="." mode="change-language"/>
			<xsl:apply-templates select="." mode="links"/>


		</div>
		<div class="mainContent">
			<xsl:if test="($has_issue_pr = 'false') and ($has_article_pr = 'false')">
				<xsl:attribute name="style">border-right: none;</xsl:attribute>
			</xsl:if>
			<div class="journalLogo">
				<xsl:call-template name="ImageLogo">
					<xsl:with-param name="src">
						<xsl:value-of select="SCIELO_INFO/PATH_SERIMG"/>
						<xsl:value-of select="/SERIAL/TITLEGROUP/SIGLUM"/>/glogo.gif</xsl:with-param>
					<xsl:with-param name="alt">
						<xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/>
					</xsl:with-param>
				</xsl:call-template>
			</div>
			<div class="search">
				<h2 class="sectionHeading">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='search']"/>
				</h2>
				<form name="searchForm" action="http://{//SCIELO_INFO/SERVER}/cgi-bin/wxis.exe/iah/" method="post">
					<input type="hidden" value="iah/iah.xis" name="IsisScript"/>
					<input type="hidden" value="{$pref}" name="lang"/>
					<input type="hidden" value="article^dlibrary" name="base"/>
					<input type="hidden" value="extSearch" name="nextAction"/>
					<input id="textEntry1" name="exprSearch" class="expression midium defaultValue" value="{$translations/xslid[@id='sci_serial']/text[@find='enter_search_term']}" onfocus="clearDefault('textEntry1', 'expression midium'); this.value= (this.value=='{$translations/xslid[@id='sci_serial']/text[@find='enter_search_term']}')? '' : this.value" onblur="clearDefault('textEntry1', 'expression midium defaultValue'); this.value= (this.value=='')? '{$translations/xslid[@id='sci_serial']/text[@find='enter_search_term']}' : this.value" type="text"/>
					<select class="inputText mini" name="indexSearch">
						<option selected="true" value="^nTo^pTodos os índices^eTodos los indices^iAll indexes^d*^xTO ^yFULINV">
							<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='all_indexes']"/>
						</option>
						<option value="^nTi^pPalavras do título^ePalabras del título^iTitle words^xTI ^yPREINV^uTI_^mTI_">
							<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='title']"/>
						</option>
						<option value="^nAu^pAutor^eAutor^iAuthor^xAU ^yPREINV^uAU_^mAU_">
							<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='author']"/>
						</option>
						<option value="^nKw^pAssunto^eMateria^iSubject^xKW ^yPREINV^uKW_^mKW_">
							<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='subject']"/>
						</option>
					</select>
					<select class="inputText mini" name="limit">
						<option value="{/SERIAL/ISSN_AS_ID}">
							<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='this_journal']"/>
						</option>
						<option value="">
							<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='scielo_instance']"/>
						</option>
					</select>
					<input value="{$translations/xslid[@id='sci_serial']/text[@find='search']}" name="submit" class="submit" type="submit"/>
				</form>
			</div>
			<div class="journalInfo">
				<small>
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='publication_of']"/>
				</small>
				<strong class="journalTitle">
					<xsl:apply-templates select="/SERIAL/PUBLISHERS/PUBLISHER"/>
				</strong>
				<span class="issn">
					<xsl:apply-templates select="/SERIAL/TITLE_ISSN"/>
				</span>
				<br/>
				<br/>
				<small>
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='mission']"/>
				</small>
				<p>
					<xsl:apply-templates select="/SERIAL/MISSION"/>
				</p>
				<xsl:if test="/SERIAL/CHANGESINFO">
					<xsl:apply-templates select="/SERIAL/CHANGESINFO">
						<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
					</xsl:apply-templates>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
