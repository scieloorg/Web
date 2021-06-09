<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/">
	
	<xsl:include href="oai_scielo_common.xsl"/>
	
	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:template match="ERROR">
		<error code="idDoesNotExist">No matching identifier</error>
	</xsl:template>

	<xsl:template match="SERIAL">
		<GetRecord>
			<record>
				<header>
					<dc:identifier pub-id-type="publisher-id">
						<xsl:value-of select="ISSUE/ARTICLE/@PID"/>
					</dc:identifier>

					<dc:isPartOf>
						<xsl:value-of select="ISSN"/>
					</dc:isPartOf>

					<xsl:if test="ISSUE/ARTICLE/@PROCESSDATE != ''">
						<xsl:apply-templates select="ISSUE/ARTICLE/@PROCESSDATE" mode="date">
							<xsl:with-param name="date_type">process-date</xsl:with-param>
							<xsl:with-param name="value"><xsl:value-of select="ISSUE/ARTICLE/@PROCESSDATE"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:if>
				</header>

				<metadata>
					<dc:language>
						<xsl:value-of select="ISSUE/ARTICLE/@ORIGINALLANG"/>
					</dc:language>

					<dc:type>
						<xsl:value-of select="ISSUE/ARTICLE/@DOCTYPE"/>
					</dc:type>

					<dc:format>text/html</dc:format>

					<dc:rights>info:eu-repo/semantics/openAccess</dc:rights>

					<journal>
						<xsl:if test="ISSUE_ISSN">
							<xsl:call-template name="parameterized_escaped_element">
								<xsl:with-param name="param_name">publication-format</xsl:with-param>
								<xsl:with-param name="param_value">
									<xsl:value-of select="ISSUE_ISSN/@TYPE"/>
								</xsl:with-param>
								<xsl:with-param name="name">issn</xsl:with-param>
								<xsl:with-param name="value">
									<xsl:value-of select="ISSUE_ISSN"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>

						<xsl:call-template name="escaped_element">
							<xsl:with-param name="name">journal-title</xsl:with-param>
							<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="TITLEGROUP/TITLE"/></xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="escaped_element">
							<xsl:with-param name="name">abbrev-journal-title</xsl:with-param>
							<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="TITLEGROUP/SHORTTITLE"/></xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="parameterized_escaped_element">
							<xsl:with-param name="name">named-content</xsl:with-param>
							<xsl:with-param name="param_name">content-type</xsl:with-param>
							<xsl:with-param name="param_value">siglum</xsl:with-param>
							<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="TITLEGROUP/SIGLUM"/></xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="escaped_element">]
							<xsl:with-param name="name">subject</xsl:with-param>
							<xsl:with-param name="value">
								<xsl:apply-templates mode="cdata" select="TITLEGROUP/SUBJECT"/>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="escaped_element">
							<xsl:with-param name="name">volume</xsl:with-param>
							<xsl:with-param name="value">
								<xsl:apply-templates mode="cdata" select="ISSUE/@VOL"/>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="escaped_element">
							<xsl:with-param name="name">number</xsl:with-param>
							<xsl:with-param name="value">
								<xsl:apply-templates mode="cdata" select="ISSUE/@NUM"/>
							</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="parameterized_escaped_element">
							<xsl:with-param name="name">date</xsl:with-param>
							<xsl:with-param name="param_name">date-type</xsl:with-param>
							<xsl:with-param name="param_value">pubdate</xsl:with-param>
							<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="ISSUE/@PUBDATE"/></xsl:with-param>
						</xsl:call-template>
					</journal>

					<xsl:if test="ISSUE/ARTICLE/@DOI">
						<article-id pub-id-type="doi">
							<xsl:value-of select="ISSUE/ARTICLE/@DOI"/>
						</article-id>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/@oldpid">
						<article-id pub-id-type="old-publisher-id">
							<xsl:value-of select="ISSUE/ARTICLE/@oldpid"/>
						</article-id>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/@RECEIVED_DATE != ''">
						<xsl:apply-templates select="ISSUE/ARTICLE/@RECEIVED_DATE" mode="date">
							<xsl:with-param name="date_type">received-date</xsl:with-param>
							<xsl:with-param name="value"><xsl:value-of select="ISSUE/ARTICLE/@RECEIVED_DATE"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/@ACCEPTED_DATE != ''">
						<xsl:apply-templates select="ISSUE/ARTICLE/@ACCEPTED_DATE" mode="date">
							<xsl:with-param name="date_type">accepted-date</xsl:with-param>
							<xsl:with-param name="value"><xsl:value-of select="ISSUE/ARTICLE/@ACCEPTED_DATE"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/@REVIEWED_DATE != ''">
						<xsl:apply-templates select="ISSUE/ARTICLE/@REVIEWED_DATE" mode="date">
							<xsl:with-param name="date_type">reviewed-date</xsl:with-param>
							<xsl:with-param name="value"><xsl:value-of select="ISSUE/ARTICLE/@REVIEWED_DATE"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/@ahpdate != ''">
						<xsl:apply-templates select="ISSUE/ARTICLE/@ahpdate" mode="date">
							<xsl:with-param name="date_type">ahead-of-print-date</xsl:with-param>
							<xsl:with-param name="value"><xsl:value-of select="ISSUE/ARTICLE/@ahpdate"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/CONTRACT != ''">
						<award-id><xsl:value-of select="ISSUE/ARTICLE/CONTRACT"/></award-id>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/TITLE != ''">
						<article-title>
							<xsl:if test="ISSUE/ARTICLE/@ORIGINALLANG != ''">
								<xsl:attribute name="xml:lang">
									<xsl:value-of select="ISSUE/ARTICLE/@ORIGINALLANG"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:apply-templates mode="cdata" select="ISSUE/ARTICLE/TITLE"/>
						</article-title>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/trans-title != ''">
						<xsl:apply-templates select="ISSUE/ARTICLE/trans-title" />
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/SUBTITLE != ''">
						<subtitle>
							<xsl:value-of select="ISSUE/ARTICLE/SUBTITLE" />
						</subtitle>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/@FPAGE != ''">
						<fpage>
							<xsl:value-of select="ISSUE/ARTICLE/@FPAGE"/>
						</fpage>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/@LPAGE != ''">
						<lpage>
							<xsl:value-of select="ISSUE/ARTICLE/@LPAGE"/>
						</lpage>
					</xsl:if>

					<xsl:if test="ISSUE/ARTICLE/@ELOCATION_ID != ''">
						<elocation-id>
							<xsl:value-of select="ISSUE/ARTICLE/@ELOCATION_ID"/>
						</elocation-id>
					</xsl:if>

					<xsl:apply-templates select="ISSUE/ARTICLE/ABSTRACT"/>

					<xsl:apply-templates select="ISSUE/ARTICLE/KEYWORD"/>

					<xsl:apply-templates select="ISSUE/ARTICLE/LANGUAGES/PDF_LANGS"/>

					<contrib-group>
						<xsl:apply-templates select="ISSUE/ARTICLE/AUTHORS" mode="pers" />
					</contrib-group>

					<xsl:apply-templates select="ISSUE/ARTICLE/LATTES/AUTHOR" mode="lattes" />

					<xsl:apply-templates select="ISSUE/ARTICLE/AFFILIATIONS" />

					<ref-list>
						<xsl:apply-templates select="ISSUE/ARTICLE/REFERENCES" />
					</ref-list>
				</metadata>
			</record>
		</GetRecord>
	</xsl:template>
			
</xsl:stylesheet>
