<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sci_common.xsl"/>
	<xsl:variable name="otherLangs">
		<langs>
			<lang id="pt">
				<other id="es">español</other>
				<other id="en">english</other>
			</lang>
			<lang id="es">
				<other id="pt">portugués</other>
				<other id="en">english</other>
			</lang>
			<lang id="en">
				<other id="es">español</other>
				<other id="pt">portugués</other>
			</lang>
		</langs>
	</xsl:variable>
	<xsl:template match="lang/other" mode="link">
		<xsl:param name="seq"/>
		<xsl:param name="script"/>
		<span>
			<a>
				<xsl:call-template name="AddScieloLink">
					<xsl:with-param name="seq" select="$seq"/>
					<xsl:with-param name="lang" select="@id"/>
					<xsl:with-param name="script" select="$script"/>
				</xsl:call-template>
				<xsl:value-of select="."/>
			</a>
		</span>
		<xsl:if test="position()=1"> | </xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="navButton">
		<xsl:param name="script"/>
		<xsl:param name="text"/>
		<xsl:param name="seq"/>
		<xsl:param name="disable"/>
		<xsl:choose>
			<xsl:when test="$disable='Disable'">
			<div class="navButton{$disable}">

				<a href="#">
					<xsl:value-of select="$text"/>
				</a></div>

			</xsl:when>
			<xsl:otherwise>
				<div class="navButton{$disable}">
					<a>
						<xsl:call-template name="AddScieloLink">
							<xsl:with-param name="script" select="$script"/>
							<xsl:with-param name="seq"><xsl:choose>
								<xsl:when test="@PID"><xsl:value-of select="@PID"/></xsl:when>
								<xsl:when test="$seq"><xsl:value-of select="$seq"/></xsl:when>
							</xsl:choose></xsl:with-param>
						</xsl:call-template>
						<xsl:value-of select="$text"/>
					</a>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="searchButton">
		<xsl:param name="file"/>
		<xsl:param name="alttext"/>
		<xsl:param name="index"/>
		<xsl:param name="scope"/>
		<xsl:param name="base"/>
		<div class="navButton">
			<A>
				<xsl:choose>
					<xsl:when test="$base">
						<xsl:call-template name="AddIAHLink">
							<xsl:with-param name="index" select="$index"/>
							<xsl:with-param name="scope" select="$scope"/>
							<xsl:with-param name="base" select="$base"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="AddIAHLink">
							<xsl:with-param name="index" select="$index"/>
							<xsl:with-param name="scope" select="$scope"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="$alttext"/>
			</A>
		</div>
	</xsl:template>
	<xsl:template match="*" mode="tableless-navbar">
		<xsl:param name="bar1"/>
		<xsl:param name="bar2"/>
		<xsl:param name="scope"/>
		<xsl:param name="home">0</xsl:param>
		<xsl:param name="alpha">0</xsl:param>
		<!-- FIXME -->
		<h1>
			<a>
				<xsl:call-template name="AddScieloLink">
					<xsl:with-param name="script">sci_home</xsl:with-param>
				</xsl:call-template>
				<span>SciELO Brasil
				</span>
			</a>
		</h1>
		<div class="bar">
			<div id="otherVersions">
				<xsl:apply-templates select="$otherLangs//lang[@id=$interfaceLang]//other" mode="link">
					<xsl:with-param name="seq" select="//PAGE_PID"/>
					<xsl:with-param name="script" select="//PAGE_NAME"/>
				</xsl:apply-templates>
			</div>
			<div id="contact">
				<span>
					<a href="#contacts">
						<xsl:value-of select="$translations/xslid[@id='sci_common']/text[@find = 'contact']"/>
					</a>
					<!--xsl:choose>
						<xsl:when test="//CONTACT/EMAILS/EMAIL">
							<a href="mailto:{//CONTACT/EMAILS/EMAIL}">
								<xsl:value-of select="$translations/xslid[@id='sci_common']/text[@find = 'contact']"/>&#160;
								<xsl:value-of select="//CONTACT/EMAILS/EMAIL"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a href="mailto:{//CONTACT}">
								<xsl:value-of select="$translations/xslid[@id='sci_common']/text[@find = 'contact']"/>&#160;
								<xsl:value-of select="//CONTACT"/>
							</a>
						</xsl:otherwise>
					</xsl:choose-->
				</span>
			</div>
		</div>
		<!-- FIXME -->
		<div id="globalNav">
			<h2>Navegação</h2>
			<div id="issueNav">
				<div class="navlabel" id="issuesLabel">
					<span>
						<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = concat('grp_',$bar1)]"/>
					</span>
					<!-- FIXME -->
				</div>
				<xsl:if test="$bar1!='serials'">
					<xsl:apply-templates select="." mode="navButton">
						<xsl:with-param name="script">
							<xsl:choose>
								<xsl:when test="$bar1='issues'">sci_issues</xsl:when>
								<xsl:when test="$bar1='articles'">sci_issuetoc</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="text">
							<xsl:choose>
								<xsl:when test="$bar1='issues'">
									<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'all_issues']"/>
								</xsl:when>
								<xsl:when test="$bar1='articles'">
									<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'table_of_contents']"/>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="seq">
							<xsl:choose>
								<xsl:when test="$bar1='issues'">
									<xsl:value-of select="substring(//PAGE_PID,1,9)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring(//PAGE_PID,2,17)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$bar1='serials'">
						<xsl:apply-templates select="." mode="navButton">
							<xsl:with-param name="script">sci_alphabetic</xsl:with-param>
							<xsl:with-param name="text">
								<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'buttonAlpha']"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<xsl:apply-templates select="." mode="navButton">
							<xsl:with-param name="script">sci_subject</xsl:with-param>
							<xsl:with-param name="text">
								<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'buttonSubject']"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<xsl:apply-templates select="." mode="searchButton">
							<xsl:with-param name="alttext">
								<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'buttonSearch']"/>
							</xsl:with-param>
							<xsl:with-param name="base" select="'title'"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="//ARTICLES/PREVIOUS | //ISSUES/PREVIOUS" mode="navButton">
							<xsl:with-param name="script">
								<xsl:choose>
									<xsl:when test="$bar1='issues'">sci_issuetoc</xsl:when>
									<xsl:when test="$bar1='articles'">sci_arttext</xsl:when>
									<xsl:otherwise/>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="text">
								<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'previous']"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<xsl:if test="not (//ARTICLES/PREVIOUS) and not(//ISSUES/PREVIOUS)">
							<xsl:apply-templates select="." mode="navButton">
								<xsl:with-param name="script">
									<xsl:choose>
										<xsl:when test="$bar1='issues'">sci_issuetoc</xsl:when>
										<xsl:when test="$bar1='articles'">sci_arttext</xsl:when>
										<xsl:otherwise/>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="text">
									<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'previous']"/>
								</xsl:with-param>
								<xsl:with-param name="disable">Disable</xsl:with-param>
							</xsl:apply-templates>
						</xsl:if>
						<xsl:apply-templates select="//ISSUES/CURRENT" mode="navButton">
							<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
							<xsl:with-param name="text">
								<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'current']"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<xsl:if test="not(//ISSUES/CURRENT) and $bar1!='articles'">
							<xsl:apply-templates select="." mode="navButton">
								<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
								<xsl:with-param name="text">
									<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'current']"/>
								</xsl:with-param>
								<xsl:with-param name="disable">Disable</xsl:with-param>
							</xsl:apply-templates>
						</xsl:if>
						<xsl:apply-templates select="//ARTICLES/NEXT | //ISSUES/NEXT" mode="navButton">
							<xsl:with-param name="script">
								<xsl:choose>
									<xsl:when test="$bar1='issues'">sci_issuetoc</xsl:when>
									<xsl:when test="$bar1='articles'">sci_arttext</xsl:when>
									<xsl:otherwise/>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="text">
								<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'next']"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<xsl:if test="not(//ARTICLES/NEXT) and not(//ISSUES/NEXT)">
							<xsl:apply-templates select="." mode="navButton">
								<xsl:with-param name="script">
									<xsl:choose>
										<xsl:when test="$bar1='issues'">sci_issuetoc</xsl:when>
										<xsl:when test="$bar1='articles'">sci_arttext</xsl:when>
										<xsl:otherwise/>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="text">
									<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'next']"/>
								</xsl:with-param>
								<xsl:with-param name="disable">Disable</xsl:with-param>
							</xsl:apply-templates>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<xsl:if test="$bar1='issues' and .//FUTURE_ISSUE">
				<xsl:variable name="ahp" select=".//FUTURE_ISSUE[@NUM='AHEAD']"/>
				<xsl:variable name="prov" select=".//FUTURE_ISSUE[@NUM='REVIEW']"/>
				<div id="searchArticles">
					<div class="navlabel" id="searchLabel">
						<span>
							<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'grp_advanced']"/>
						</span>
						<!-- FIXME -->
					</div>
					<xsl:apply-templates select="$ahp[1]" mode="navButton">
						<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
						<xsl:with-param name="text">
							<xsl:if test="not($prov[1])">&#160;&#160;&#160;&#160;</xsl:if>
							<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'ahead_of_print']"/>
							<xsl:if test="not($prov[1])">&#160;&#160;&#160;&#160;</xsl:if>
						</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates select="$prov[1]" mode="navButton">
						<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
						<xsl:with-param name="text">
							<xsl:if test="not($ahp[1])">&#160;&#160;&#160;&#160;&#160;</xsl:if>
							<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'provisional']"/>
							<xsl:if test="not($ahp[1])">&#160;&#160;&#160;&#160;&#160;</xsl:if>
						</xsl:with-param>
					</xsl:apply-templates>
				</div>
			</xsl:if>
			<div id="searchArticles">
				<div class="navlabel" id="searchLabel">
					<span>
						<xsl:choose>
							<xsl:when test="$bar1='serials'">
								<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'grp_articles']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'search_form']"/>
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<!-- FIXME -->
				</div>
				<xsl:apply-templates select="." mode="searchButton">
					<xsl:with-param name="alttext">
						<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'buttonAuthor']"/>
					</xsl:with-param>
					<xsl:with-param name="index">AU</xsl:with-param>
					<xsl:with-param name="scope" select="$scope"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="." mode="searchButton">
					<xsl:with-param name="alttext">
						<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'buttonSubject']"/>
					</xsl:with-param>
					<xsl:with-param name="index">KW</xsl:with-param>
					<xsl:with-param name="scope" select="$scope"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="." mode="searchButton">
					<xsl:with-param name="alttext">
						<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'buttonSearch']"/>
					</xsl:with-param>
					<xsl:with-param name="scope" select="$scope"/>
				</xsl:apply-templates>
			</div>
			<div id="alfabeticList">
				<xsl:if test="$home='1' and //PAGE_NAME!='sci_serial'">
					<xsl:apply-templates select="." mode="navButton">
						<xsl:with-param name="script">sci_serial</xsl:with-param>
						<xsl:with-param name="text">home</xsl:with-param>
						<xsl:with-param name="seq">
							<xsl:choose>
								<xsl:when test="$bar1='articles'">
									<xsl:value-of select="substring(//PAGE_PID,2,9)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring(//PAGE_PID,1,9)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="$alpha='1'">
					<xsl:apply-templates select="." mode="navButton">
						<xsl:with-param name="script">sci_alphabetic</xsl:with-param>
						<xsl:with-param name="text">
							<xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'buttonAlpha']"/>
						</xsl:with-param>
						<xsl:with-param name="seq"/>
					</xsl:apply-templates>
				</xsl:if>
			</div>
			<xsl:if test="string-length(.//PAGE_PID)&gt;=9">
				<div id="feedSection">
					<a class="rss" title="RSS feed {//TITLEGROUP/TITLE}" href="/rss.php?pid={.//PAGE_PID}&amp;lang={$interfaceLang}">
						<span>RSS</span>
					</a>
				</div>
			</xsl:if>
		</div>
	</xsl:template>
</xsl:stylesheet>
