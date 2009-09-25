<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sci_common.xsl"/>
	<xsl:template name="NAVBAR">
		<xsl:param name="bar1"/>
		<xsl:param name="bar2"/>
		<xsl:param name="scope"/>
		<xsl:param name="home">0</xsl:param>
		<xsl:param name="alpha">0</xsl:param>
		<TABLE cellSpacing="0" cellPadding="7" width="100%" border="0">
			<TBODY>
				<TR>
					<xsl:call-template name="SCIELOLOGO"/>
					<TD vAlign="top" width="74%">
						<TABLE>
							<TBODY>
								<TR>
									<TD>
										<xsl:attribute name="NoWrap"/>
										<xsl:choose>
											<xsl:when test="$bar1='issues'">
												<xsl:call-template name="IssuesBarGroup"/>
											</xsl:when>
											<xsl:when test="$bar1='serials'">
												<xsl:call-template name="SerialsBarGroup"/>
											</xsl:when>
											<xsl:when test="$bar1='articles'">
												<xsl:call-template name="ArticlesBarGroup"/>
											</xsl:when>
											<xsl:when test="$bar1='articlesiah'">
												<xsl:call-template name="ArticlesIAHBarGroup">
													<xsl:with-param name="scope" select="$scope"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>&#160;<xsl:choose>
											<xsl:when test="$bar2='issues'">
												<xsl:call-template name="IssuesBarGroup"/>
											</xsl:when>
											<xsl:when test="$bar2='serials'">
												<xsl:call-template name="SerialsBarGroup"/>
											</xsl:when>
											<xsl:when test="$bar2='articles'">
												<xsl:call-template name="ArticlesBarGroup"/>
											</xsl:when>
											<xsl:when test="$bar2='articlesiah'">
												<xsl:call-template name="ArticlesIAHBarGroup">
													<xsl:with-param name="scope" select="$scope"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
										<BR/>
										<xsl:choose>
											<xsl:when test="$bar1='issues'">
												<xsl:call-template name="IssuesBar"/>
											</xsl:when>
											<xsl:when test="$bar1='serials'">
												<xsl:call-template name="SerialsBar"/>
											</xsl:when>
											<xsl:when test="$bar1='articles'">
												<xsl:call-template name="ArticlesBar"/>
											</xsl:when>
											<xsl:when test="$bar1='articlesiah'">
												<xsl:call-template name="ArticlesIAHBar">
													<xsl:with-param name="scope" select="$scope"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>&#160;<xsl:choose>
											<xsl:when test="$bar2='issues'">
												<xsl:call-template name="IssuesBar"/>
											</xsl:when>
											<xsl:when test="$bar2='serials'">
												<xsl:call-template name="SerialsBar"/>
											</xsl:when>
											<xsl:when test="$bar2='articles'">
												<xsl:call-template name="ArticlesBar"/>
											</xsl:when>
											<xsl:when test="$bar2='articlesiah'">
												<xsl:call-template name="ArticlesIAHBar">
													<xsl:with-param name="scope" select="$scope"/>
												</xsl:call-template>
												<xsl:if test="//CONTROLINFO/NO_SCI_SERIAL='yes'">
													<xsl:call-template name="ShowNavBarButton">
														<xsl:with-param name="file">all.gif</xsl:with-param>
														<xsl:with-param name="alttext">
                                                            <xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'articles']"/>
														</xsl:with-param>
														<xsl:with-param name="pid" select="//ISSN_AS_ID"/>
														<xsl:with-param name="script">sci_artlist</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
										</xsl:choose>
									</TD>
									<TD noWrap="" valign="bottom">
										<xsl:if test="$home = 1">
											<xsl:call-template name="HOME"/>
										</xsl:if>
										<xsl:if test="$alpha = 1">
											<xsl:call-template name="ALPHA"/>
										</xsl:if>
             &#160;
            </TD>
									<xsl:variable name="issuetoc">
										<xsl:apply-templates select="." mode="issuetoc"/>
									</xsl:variable>
									<xsl:variable name="sci_serial">
										<xsl:apply-templates select="." mode="sci_serial"/>
									</xsl:variable>
									<xsl:if test="//PAGE_NAME = $sci_serial or //PAGE_NAME = $issuetoc">
										<TD valign="bottom">
											<xsl:element name="a">
												<xsl:attribute name="href"><xsl:value-of select="concat('http://',CONTROLINFO/SCIELO_INFO/SERVER,'/rss.php?pid=',//PAGE_PID,'&amp;lang=',//LANGUAGE)"/></xsl:attribute>
												<xsl:attribute name="title"><xsl:value-of select="concat('RSS feed ',//TITLEGROUP/TITLE)"/></xsl:attribute>
												<xsl:attribute name="class"><xsl:value-of select="'rss'"/></xsl:attribute>
												<span>RSS</span>
											</xsl:element>
										</TD>
									</xsl:if>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
		<BR/>
	</xsl:template>
	<!-- Show group image -->
	<xsl:template name="ShowGroupIMG">
		<xsl:param name="file"/>
		<IMG>
			<xsl:attribute name="src"><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/><xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>/<xsl:value-of select="$file"/></xsl:attribute>
		</IMG>
	</xsl:template>
	<!-- Shows issues bar group -->
	<xsl:template name="IssuesBarGroup">
		<xsl:choose>
			<xsl:when test="//CONTROLINFO/NO_SCI_SERIAL = 'yes'"> 
				<span class="invisible">
					<xsl:call-template name="ShowGroupIMG">
						<xsl:with-param name="file">grp1a.gif</xsl:with-param>
					</xsl:call-template>
				</span>
			</xsl:when> 
			<xsl:otherwise>
				<xsl:call-template name="ShowGroupIMG">
						<xsl:with-param name="file">grp1a.gif</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		 </xsl:choose>
	</xsl:template>
	<!-- Show  issues bar -->
	<xsl:template name="IssuesBar">
		<xsl:choose>
			<xsl:when test="//CONTROLINFO/NO_SCI_SERIAL = 'yes'">
				<span class="invisible">
					<xsl:call-template name="ALLISSUES"/>
					<xsl:call-template name="PREVIOUS"/>
					<xsl:call-template name="CURRENT"/>
					<xsl:call-template name="NEXT"/>
				</span>
			</xsl:when>
		<xsl:otherwise>
				<xsl:call-template name="ALLISSUES"/>
				<xsl:call-template name="PREVIOUS"/>
				<xsl:call-template name="CURRENT"/>
				<xsl:call-template name="NEXT"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Shows articles IAH bar group -->
	<xsl:template name="ArticlesIAHBarGroup">
		<xsl:param name="scope"/>
		<xsl:call-template name="ShowGroupIMG">
			<xsl:with-param name="file">
				<xsl:choose>
					<xsl:when test="$scope='library'">artbrow.gif</xsl:when>
					<xsl:otherwise>artsrc.gif</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Show articles IAH bar -->
	<xsl:template name="ArticlesIAHBar">
		<xsl:param name="scope"/>
		<xsl:call-template name="AUTHOR">
			<xsl:with-param name="scope">
				<xsl:value-of select="$scope"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="SUBJECT">
			<xsl:with-param name="scope">
				<xsl:value-of select="$scope"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="FORM">
			<xsl:with-param name="scope">
				<xsl:value-of select="$scope"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Shows articles bar group -->
	<xsl:template name="ArticlesBarGroup">
		<xsl:call-template name="ShowGroupIMG">
			<xsl:with-param name="file">grp1c.gif</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Shows articles bar -->
	<xsl:template name="ArticlesBar">
		<xsl:call-template name="TOC"/>
		<xsl:call-template name="PREVIOUS"/>
		<xsl:call-template name="NEXT"/>
	</xsl:template>
	<!-- Shows serials bar group -->
	<xsl:template name="SerialsBarGroup">
		<xsl:call-template name="ShowGroupIMG">
			<xsl:with-param name="file">serbrow.gif</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Shows serials bar -->
	<xsl:template name="SerialsBar">
		<xsl:call-template name="ALPHA"/>
		<xsl:call-template name="SUBJECTLIST"/>
		<xsl:call-template name="FORMSERIALS"/>
	</xsl:template>
	<!-- Shows button for all issues -->
	<xsl:template name="ALLISSUES">
		<xsl:choose>
			<xsl:when test="//AVAILISSUES">
				<xsl:call-template name="ShowNavBarButtonDisabled">
					<xsl:with-param name="file">all0.gif</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ShowNavBarButton">
					<xsl:with-param name="file">all.gif</xsl:with-param>
					<xsl:with-param name="alttext">
                        <xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'available_issues']"/>
					</xsl:with-param>
					<xsl:with-param name="pid" select="//ISSN_AS_ID"/>
					<xsl:with-param name="script">
						<xsl:apply-templates select="." mode="issues"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Show the PREVIOUS button -->
	<xsl:template name="PREVIOUS">
		<xsl:choose>
			<xsl:when test="//PREVIOUS">
				<xsl:call-template name="ShowNavBarButton">
					<xsl:with-param name="file">prev.gif</xsl:with-param>
					<xsl:with-param name="alttext">
						<xsl:choose>
							<xsl:when test="//ABSTRACT or //BODY or //fulltext">
								<xsl:value-of select="normalize-space(//PREVIOUS)" disable-output-escaping="yes"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="GetStrip">
									<xsl:with-param name="vol" select="//PREVIOUS/@VOL"/>
									<xsl:with-param name="num" select="//PREVIOUS/@NUM"/>
									<xsl:with-param name="suppl" select="//PREVIOUS/@SUPPL"/>
									<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="pid" select="//PREVIOUS/@PID"/>
					<xsl:with-param name="script">
						<xsl:choose>
							<xsl:when test="//ABSTRACT">sci_abstract</xsl:when>
							<xsl:when test="//BODY or //fulltext">sci_arttext</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="." mode="issuetoc"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ShowNavBarButtonDisabled">
					<xsl:with-param name="file">prev0.gif</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Show the CURRENT button -->
	<xsl:template name="CURRENT">
		<xsl:choose>
			<xsl:when test="//CONTROLINFO/ISSUES/CURRENT">
				<xsl:call-template name="ShowNavBarButton">
					<xsl:with-param name="file">current.gif</xsl:with-param>
					<xsl:with-param name="alttext">
						<xsl:call-template name="GetStrip">
							<xsl:with-param name="vol" select="//CONTROLINFO/ISSUES/CURRENT/@VOL"/>
							<xsl:with-param name="num" select="//CONTROLINFO/ISSUES/CURRENT/@NUM"/>
							<xsl:with-param name="suppl" select="//CONTROLINFO/ISSUES/CURRENT/@SUPPL"/>
							<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="pid" select="//CONTROLINFO/ISSUES/CURRENT/@PID"/>
					<xsl:with-param name="script">
						<xsl:apply-templates select="." mode="issuetoc"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ShowNavBarButtonDisabled">
					<xsl:with-param name="file">current0.gif</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Show the NEXT button -->
	<xsl:template name="NEXT">
		<xsl:choose>
			<xsl:when test="//NEXT">
				<xsl:call-template name="ShowNavBarButton">
					<xsl:with-param name="file">next.gif</xsl:with-param>
					<xsl:with-param name="alttext">
						<xsl:choose>
							<xsl:when test="//ABSTRACT or //BODY or //fulltext">
								<xsl:value-of select="normalize-space(//NEXT)" disable-output-escaping="yes"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="GetStrip">
									<xsl:with-param name="vol" select="//NEXT/@VOL"/>
									<xsl:with-param name="num" select="//NEXT/@NUM"/>
									<xsl:with-param name="suppl" select="//NEXT/@SUPPL"/>
									<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="pid" select="//NEXT/@PID"/>
					<xsl:with-param name="script">
						<xsl:choose>
							<xsl:when test="//ABSTRACT">sci_abstract</xsl:when>
							<xsl:when test="//BODY or //fulltext">sci_arttext</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="." mode="issuetoc"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ShowNavBarButtonDisabled">
					<xsl:with-param name="file">next0.gif</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Show the SciELO logo -->
	<xsl:template name="SCIELOLOGO">
		<TD vAlign="top" width="26%">
			<P align="center">
				<A>
					<xsl:attribute name="href">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/><xsl:apply-templates select="." mode="repo_url_param_scielo"/></xsl:attribute>
					<IMG>
						<xsl:attribute name="src"><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/><xsl:apply-templates select="." mode="logoImg"/></xsl:attribute>
						<xsl:attribute name="border">0</xsl:attribute>
						<xsl:attribute name="alt"><xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'scientific_electronic_library_online']"/></xsl:attribute>
					</IMG>
				</A>
				<BR/>
			</P>
		</TD>
	</xsl:template>
	<xsl:template match="*" mode="logoImg">
		<xsl:choose>
			<xsl:when test="//PAGINATION[@rep]">repo/<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>/r<xsl:value-of select="normalize-space(//PAGINATION/@rep)"/>.gif</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>/fbpelogp.gif</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Shows a navigation bar button
      Parameters:
        file - file containing image
        alttext - text to be shown when image is not present
        pid - pid to next page 
        script - script to the next page -->
	<xsl:template name="ShowNavBarButton">
		<xsl:param name="file"/>
		<xsl:param name="alttext"/>
		<xsl:param name="pid"/>
		<xsl:param name="script"/>
		<A>
			<xsl:call-template name="AddScieloLink">
				<xsl:with-param name="seq" select="$pid"/>
				<xsl:with-param name="script" select="$script"/>
			</xsl:call-template>
			<IMG>
				<xsl:attribute name="src"><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/><xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>/<xsl:value-of select="$file"/></xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
				<xsl:attribute name="alt"><xsl:value-of select="$alttext"/></xsl:attribute>
			</IMG>
		</A>
	</xsl:template>
	<!-- Show Navigation Bar Button Disabled 
      Parameters:
        file - file containing image-->
	<xsl:template name="ShowNavBarButtonDisabled">
		<xsl:param name="file"/>
		<IMG>
			<xsl:attribute name="src"><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/><xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>/<xsl:value-of select="$file"/></xsl:attribute>
			<xsl:attribute name="border">0</xsl:attribute>
		</IMG>
	</xsl:template>
	<!-- Shows a navigation bar button for IAH
      Parameters:
        file - file containing image
        alttext - text to be shown when image is not present
        index - AU,etc
        scope - library | siglum  -->
	<xsl:template name="ShowNavBarButtonIAH">
		<xsl:param name="file"/>
		<xsl:param name="alttext"/>
		<xsl:param name="index"/>
		<xsl:param name="scope"/>
		<xsl:param name="base"/>
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
			<IMG>
				<xsl:attribute name="src"><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/><xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>/<xsl:value-of select="$file"/></xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
				<xsl:attribute name="alt"><xsl:value-of select="$alttext"/></xsl:attribute>
			</IMG>
		</A>
	</xsl:template>
	<!-- Show Author Button -->
	<xsl:template name="AUTHOR">
		<xsl:param name="scope"/>
		<xsl:call-template name="ShowNavBarButtonIAH">
			<xsl:with-param name="file">author.gif</xsl:with-param>
			<xsl:with-param name="alttext">
                <xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'author_index']"/>
			</xsl:with-param>
			<xsl:with-param name="index">AU</xsl:with-param>
			<xsl:with-param name="scope" select="$scope"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Show Subject Button -->
	<xsl:template name="SUBJECT">
		<xsl:param name="scope"/>
		<xsl:call-template name="ShowNavBarButtonIAH">
			<xsl:with-param name="file">subject.gif</xsl:with-param>
			<xsl:with-param name="alttext">
                <xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'subject_index']"/>
			</xsl:with-param>
			<xsl:with-param name="index">KW</xsl:with-param>
			<xsl:with-param name="scope">
				<xsl:value-of select="$scope"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Show Form Button  -->
	<xsl:template name="FORM">
		<xsl:param name="scope"/>
		<xsl:call-template name="ShowNavBarButtonIAH">
			<xsl:with-param name="file">search.gif</xsl:with-param>
			<xsl:with-param name="alttext">
                <xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'search_form']"/>
			</xsl:with-param>
			<xsl:with-param name="scope" select="$scope"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Show Home Button  -->
	<xsl:template name="HOME">
		<xsl:if test="not(//NO_SCI_SERIAL) or //NO_SCI_SERIAL!='yes'">
			<xsl:call-template name="ShowNavBarButton">
				<xsl:with-param name="file">home.gif</xsl:with-param>
				<xsl:with-param name="alttext">Home Page</xsl:with-param>
				<xsl:with-param name="pid" select="//ISSN_AS_ID"/>
				<xsl:with-param name="script">
					<xsl:apply-templates select="." mode="sci_serial"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- Show Alphabetic List Button -->
	<xsl:template name="ALPHA">
		<xsl:choose>
			<xsl:when test="//SERIALLIST">
				<xsl:call-template name="ShowNavBarButtonDisabled">
					<xsl:with-param name="file">alpha0.gif</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ShowNavBarButton">
					<xsl:with-param name="file">alpha.gif</xsl:with-param>
					<xsl:with-param name="alttext">
                        <xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'alphabetic_serial_listing']"/>
					</xsl:with-param>
					<xsl:with-param name="script">sci_alphabetic</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Show Table of Contents Button -->
	<xsl:template name="TOC">
		<xsl:choose>
			<xsl:when test="//CONTROLINFO/NO_SCI_SERIAL='yes'">
				<xsl:call-template name="ShowNavBarButton">
					<xsl:with-param name="file">toc.gif</xsl:with-param>
					<xsl:with-param name="alttext">
						<xsl:call-template name="GetStrip">
							<xsl:with-param name="vol" select="//CONTROLINFO/CURRENTISSUE/@VOL"/>
							<xsl:with-param name="num" select="//CONTROLINFO/CURRENTISSUE/@NUM"/>
							<xsl:with-param name="suppl" select="//CONTROLINFO/CURRENTISSUE/@SUPPL"/>
							<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
						</xsl:call-template>
					</xsl:with-param>					
					<xsl:with-param name="script">sci_artlist</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
		<xsl:call-template name="ShowNavBarButton">
			<xsl:with-param name="file">toc.gif</xsl:with-param>
			<xsl:with-param name="alttext">
				<xsl:call-template name="GetStrip">
					<xsl:with-param name="vol" select="//CONTROLINFO/CURRENTISSUE/@VOL"/>
					<xsl:with-param name="num" select="//CONTROLINFO/CURRENTISSUE/@NUM"/>
					<xsl:with-param name="suppl" select="//CONTROLINFO/CURRENTISSUE/@SUPPL"/>
					<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="pid" select="//CONTROLINFO/CURRENTISSUE/@PID"/>
					<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
		</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Show Subject List Button -->
	<xsl:template name="SUBJECTLIST">
		<xsl:choose>
			<xsl:when test="//SUBJECTLIST">
				<xsl:call-template name="ShowNavBarButtonDisabled">
					<xsl:with-param name="file">subject0.gif</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ShowNavBarButton">
					<xsl:with-param name="file">subject.gif</xsl:with-param>
					<xsl:with-param name="alttext">
                        <xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'subject_list_of_serials']"/>
					</xsl:with-param>
					<xsl:with-param name="script">sci_subject</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Show Form Serials  List Button -->
	<xsl:template name="FORMSERIALS">
		<xsl:call-template name="ShowNavBarButtonIAH">
			<xsl:with-param name="file">search.gif</xsl:with-param>
			<xsl:with-param name="alttext">
                <xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'serials_search']"/>
			</xsl:with-param>
			<xsl:with-param name="base">title</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

<xsl:template match="ERROR">
	<html>
	<head>
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
		<style type="text/css">
			a {  text-decoration: none}
		</style>
		<title>SciELO Error</title>
	</head>
	<body>
		<table cellspacing="0" border="0" cellpadding="7" width="600" align="center">
		<tr>
		<td valign="top" width="20%">
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of
					select="CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?lng=<xsl:value-of
					select="CONTROLINFO/LANGUAGE" /></xsl:attribute>

					<img>
						<xsl:attribute name="src"><xsl:value-of
							select="CONTROLINFO/SCIELO_INFO/PATH_GENIMG" /><xsl:value-of
							select="CONTROLINFO/LANGUAGE" />/fbpelogp.gif</xsl:attribute>
						<xsl:attribute name="border">0</xsl:attribute>
						<xsl:attribute name="alt"><xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'scientific_electronic_library_online']"/></xsl:attribute>
					</img><br/>

				<font size="1"><xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'browse_scielo']"/></font>
			</a>
		</td>
		<td width="80%">
			<font face="VERDANA" size="3" color="blue">
				<b><xsl:value-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'scielo_library_error_detector']"/></b>
			</font><br/><br/>
			<font face="verdana" size="2" color="#800000">
				<xsl:copy-of select="$translations/xslid[@id='sci_navegation']/text[@find = 'sentence_1']"/>
			</font>
		</td>
		</tr>
		</table><br/>
		<center>
		<a>
			<xsl:attribute name="href">mailto:<xsl:value-of select="EMAIL" /></xsl:attribute>
			<img>
				<xsl:attribute name="src"><xsl:value-of
					select="CONTROLINFO/SCIELO_INFO/PATH_GENIMG" /><xsl:value-of
					select="CONTROLINFO/LANGUAGE" />/e-mailt.gif</xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
				<xsl:attribute name="alt"><xsl:value-of select="EMAIL" /></xsl:attribute>
			</img>
		</a>
		</center>
</body>
</html>

</xsl:template>

</xsl:stylesheet>
