<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:template match="text()" mode="cdata">
		<xsl:value-of select=" concat( '&lt;![CDATA[', . ,  ']]&gt;' ) " disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template name="escaped_element">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:if test="$value != ''">
			<xsl:value-of select=" concat( '&lt;', $name, '&gt;', $value,  '&lt;/', $name, '&gt;' )" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="parameterized_escaped_element">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="param_name"/>
		<xsl:param name="param_value"/>

		<xsl:if test="$value != ''">
			<xsl:value-of select=" concat( '&lt;', $name, ' ', $param_name, '= &quot;', $param_value, '&quot; &gt;', $value,  '&lt;/', $name, '&gt;' )" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="format_date">
		<xsl:param name="date"/>
		<xsl:if test="$date">
			<xsl:variable name="complete_date"><xsl:value-of select="$date"/>00000000</xsl:variable>

			<xsl:variable name="fixed_month_and_day">
				<xsl:choose>
					<xsl:when test="substring($complete_date,5,2)='00'">01</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($complete_date,5,2)"/>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:choose>
					<xsl:when test="substring($complete_date,7,2)='00'">01</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($complete_date,7,2)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:value-of select="concat(substring($complete_date,1,4), '-', substring($fixed_month_and_day,1,2), '-', substring($fixed_month_and_day,3,2)) "/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="format_issue_type">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="$type = 'PRINT'">print</xsl:when>
			<xsl:when test="$type = 'ONLIN'">online</xsl:when>
			<xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@PROCESSDATE|@REVIEWED_DATE|@ACCEPTED_DATE|@RECEIVED_DATE|@ahpdate|@PUBDATE" mode="date">
		<xsl:param name="date_type"/>
		<xsl:param name="value"/>
		<date>
			<xsl:attribute name="date-type"><xsl:value-of select="$date_type"/></xsl:attribute>
			<xsl:call-template name="format_date"><xsl:with-param name="date" select="$value"/></xsl:call-template>
		</date>
	</xsl:template>

	<xsl:template match="AUTHORS">
		<xsl:apply-templates select="AUTH_PERS/AUTHOR" mode="pers"/>
	</xsl:template>

	<xsl:template match="AUTHOR" mode="pers">
		<contrib contrib-type="author">
			<name><xsl:value-of select="NAME"/></name>
			<surname><xsl:value-of select="SURNAME"/></surname>
			<xsl:if test="ORCID">
				<name-content content-type="orcid">
					<xsl:value-of select="ORCID"/>
				</name-content>
			</xsl:if>
			<xsl:if test="AFF">
				<xref ref-type="aff">
					<xsl:attribute name="rid">
						<xsl:value-of select="AFF/@xref"/>
					</xsl:attribute>
				</xref>
			</xsl:if>
		</contrib>
	</xsl:template>

	<xsl:template match="AUTHOR" mode="lattes">
		<named-content content-type="lattes-identifier">
			<xsl:attribute name="fullname">
				<xsl:value-of select="."/>
			</xsl:attribute>
			<xsl:value-of select="concat( '&lt;![CDATA[', @HREF ,']]&gt;' )"/>
		</named-content>
	</xsl:template>

	<xsl:template match="AUTHOR" mode="reference">
		<xsl:param name="type"/>
		<person-group>
			<xsl:attribute name="person-group-type">
				<xsl:value-of select="$type"/>
			</xsl:attribute>
			<name><xsl:value-of select="NAME"/></name>
			<surname><xsl:value-of select="SURNAME"/></surname>
		</person-group>
	</xsl:template>

	<xsl:template match="ORGNAME" mode="reference">
		<collab-group collab-group-type="author">
			<xsl:value-of select="concat( '&lt;![CDATA[ ', ., ' ]]&gt;' )"/>
		</collab-group>
	</xsl:template>

	<xsl:template match="ARTICLE/KEYWORD">
		<kwd>
			<xsl:attribute name="xml:lang">
				<xsl:value-of select="@LANG"/>
			</xsl:attribute>
			<xsl:apply-templates select="KEY" />
			<xsl:if test="SUBKEY">/</xsl:if>
			<xsl:apply-templates select="SUBKEY" />
		</kwd>
	</xsl:template>

	<xsl:template match="ARTICLE/AFFILIATIONS/AFFILIATION">
		<aff>
			<xsl:attribute name="id">
				<xsl:value-of select="@ID"/>
			</xsl:attribute>

			<xsl:if test="E-MAIL != ''">
				<email>
					<xsl:apply-templates mode="cdata" select="E-MAIL"/>
				</email>
			</xsl:if>

			<xsl:if test="ORGNAME != ''">
				<institution>
					<xsl:apply-templates mode="cdata" select="ORGNAME"/>
				</institution>
			</xsl:if>

			<xsl:if test="ORDDIV != ''">
				<named-content content-type="orgdiv">
					<xsl:apply-templates mode="cdata" select="ORDDIV"/>
				</named-content>
			</xsl:if>

			<xsl:if test="CITY != ''">
				<city>
					<xsl:apply-templates mode="cdata" select="CITY"/>
				</city>
			</xsl:if>

			<xsl:if test="STATE != ''">
				<state>
					<xsl:apply-templates mode="cdata" select="STATE"/>
				</state>
			</xsl:if>

			<xsl:if test="COUNTRY != ''">
				<country>
					<xsl:apply-templates mode="cdata" select="COUNTRY"/>
				</country>
			</xsl:if>
		</aff>
	</xsl:template>

	<xsl:template match="KEY | SUBKEY">
		<xsl:apply-templates select="text()" mode="cdata"/>
	</xsl:template>

	<xsl:template match="ARTICLE/ABSTRACT">
		<abstract>
			<xsl:attribute name="xml:lang">
				<xsl:value-of select="@LANG"/>
			</xsl:attribute>
			<xsl:value-of disable-output-escaping="yes" select="concat( '&lt;![CDATA[', . ,  ']]&gt;' )"/>
		</abstract>
	</xsl:template>

	<xsl:template match="ARTICLE/LANGUAGES/PDF_LANGS/LANG">
		<named-content content-type="pdf-file">
			<xsl:attribute name="xml:lang">
				<xsl:value-of select="."/>
			</xsl:attribute>
			<xsl:value-of select="@TRANSLATION"/>
		</named-content>
	</xsl:template>

	<xsl:template match="ARTICLE/trans-title">
		<article-title>
			<xsl:attribute name="xml:lang">
				<xsl:value-of select="@xml:lang"/>
			</xsl:attribute>
			<xsl:apply-templates mode="cdata" select="."/>
		</article-title>
	</xsl:template>

	<xsl:template match="ARTICLE/REFERENCES/REFERENCE">
		<ref>
			<xsl:if test="@NUM != ''">
				<xsl:attribute name="id"><xsl:value-of select="@NUM"/></xsl:attribute>
			</xsl:if>

			<element-citation>
				<xsl:attribute name="publication-type">
					<xsl:value-of select="PUBLICATION_TYPE_REFERENCE"/>
				</xsl:attribute>

				<xsl:if test="TITLE_REFERENCE">
					<xsl:variable name="ref_title">
						<xsl:choose>
							<xsl:when test="PUBLICATION_TYPE_REFERENCE = 'book'">chapter-title</xsl:when>
							<xsl:otherwise>article-title</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:call-template name="parameterized_escaped_element">
						<xsl:with-param name="name"><xsl:value-of select="$ref_title"/></xsl:with-param>
						<xsl:with-param name="param_name">xml:lang</xsl:with-param>
						<xsl:with-param name="param_value">
							<xsl:value-of select="TITLE_REFERENCE/@LANG"/>
						</xsl:with-param>
						<xsl:with-param name="value">
							<xsl:apply-templates mode="cdata" select="TITLE_REFERENCE"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>

				<xsl:for-each select="AUTHORS_REFERENCE">
					<xsl:variable name="author_type"><xsl:value-of select="@TYPE"/></xsl:variable>
					<xsl:for-each select="AUTHOR">
						<xsl:apply-templates select="." mode="reference">
							<xsl:with-param name="type">
								<xsl:value-of select="$author_type"/>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:for-each>

				<xsl:apply-templates select="AUTHORS_REFERENCE/ORGNAME" mode="reference">
					<xsl:with-param name="type">
						<xsl:value-of select="AUTHORS_REFERENCE/@TYPE"/>
					</xsl:with-param>
				</xsl:apply-templates>

				<xsl:call-template name="parameterized_escaped_element">
					<xsl:with-param name="param_name">xml:lang</xsl:with-param>
					<xsl:with-param name="param_value"><xsl:value-of select="SOURCE_REFERENCE/@LANG"/></xsl:with-param>
					<xsl:with-param name="name">source</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="SOURCE_REFERENCE" /></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">volume</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="VOLUME_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">page-range</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="PAGE_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">year</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="YEAR_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">uri</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="URL_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">issn</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="ISSN_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">isbn</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="ISBN_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="parameterized_escaped_element">
					<xsl:with-param name="name">object-id</xsl:with-param>
					<xsl:with-param name="param_name">pub-id-type</xsl:with-param>
					<xsl:with-param name="param_value">doi</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="DOI_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="parameterized_escaped_element">
					<xsl:with-param name="name">date</xsl:with-param>
					<xsl:with-param name="param_name">date-type</xsl:with-param>
					<xsl:with-param name="param_value">access-date</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="ACCESS_DATE_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="parameterized_escaped_element">
					<xsl:with-param name="name">date</xsl:with-param>
					<xsl:with-param name="param_name">date-type</xsl:with-param>
					<xsl:with-param name="param_value">link-access-date</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="LINK_ACCESS_DATE_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">conf-sponsor</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="CONFERENCE_SPONSOR_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">conf-name</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="CONFERENCE_NAME_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">conf-num</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="CONFERENCE_EDITION_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">conf-date</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="CONFERENCE_DATE_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:if test="CONFERENCE_ADDRESS_REFERENCE">
					<conf-loc>
						<xsl:call-template name="escaped_element" >
							<xsl:with-param name="name">city</xsl:with-param>
							<xsl:with-param name="value"><xsl:apply-templates select="CONFERENCE_ADDRESS_REFERENCE/CITY" mode="cdata"/></xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="escaped_element">
							<xsl:with-param name="name">state</xsl:with-param>
							<xsl:with-param name="value"><xsl:apply-templates select="CONFERENCE_ADDRESS_REFERENCE/STATE" mode="cdata"/></xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="escaped_element">
							<xsl:with-param name="name">country</xsl:with-param>
							<xsl:with-param name="value"><xsl:apply-templates select="CONFERENCE_ADDRESS_REFERENCE/COUNTRY" mode="cdata"/></xsl:with-param>
						</xsl:call-template>
					</conf-loc>
				</xsl:if>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">edition</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="EDITION_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

					<xsl:call-template name="parameterized_escaped_element">
						<xsl:with-param name="name">named-content</xsl:with-param>
						<xsl:with-param name="param_name">content-type</xsl:with-param>
						<xsl:with-param name="param_value">thesis-date</xsl:with-param>
						<xsl:with-param name="value"><xsl:apply-templates select="THESIS_DATE_REFERENCE" mode="cdata"/></xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="parameterized_escaped_element">
						<xsl:with-param name="name">named-content</xsl:with-param>
						<xsl:with-param name="param_name">content-type</xsl:with-param>
						<xsl:with-param name="param_value">thesis-institution</xsl:with-param>
						<xsl:with-param name="value"><xsl:apply-templates select="THESIS_INSTITUTION_REFERENCE" mode="cdata"/></xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="parameterized_escaped_element">
						<xsl:with-param name="name">named-content</xsl:with-param>
						<xsl:with-param name="param_name">content-type</xsl:with-param>
						<xsl:with-param name="param_value">thesis-institution-department</xsl:with-param>
						<xsl:with-param name="value"><xsl:apply-templates select="THESIS_INSTITUTION_DEPARTMENT" mode="cdata"/></xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="parameterized_escaped_element">
						<xsl:with-param name="name">named-content</xsl:with-param>
						<xsl:with-param name="param_name">content-type</xsl:with-param>
						<xsl:with-param name="param_value">thesis-degree</xsl:with-param>
						<xsl:with-param name="value"><xsl:apply-templates select="THESIS_DEGREE_REFERENCE" mode="cdata"/></xsl:with-param>
					</xsl:call-template>

					<xsl:if test="THESIS_ADDRESS_REFERENCE">
						<named-content content-type="thesis-publisher-loc">
							<xsl:call-template name="escaped_element">
								<xsl:with-param name="name">city</xsl:with-param>
								<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="THESIS_ADDRESS_REFERENCE/CITY"/></xsl:with-param>
							</xsl:call-template>

							<xsl:call-template name="escaped_element">
								<xsl:with-param name="name">state</xsl:with-param>
								<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="THESIS_ADDRESS_REFERENCE/STATE"/></xsl:with-param>
							</xsl:call-template>

							<xsl:call-template name="escaped_element">
								<xsl:with-param name="name">country</xsl:with-param>
								<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="THESIS_ADDRESS_REFERENCE/COUNTRY"/></xsl:with-param>
							</xsl:call-template>
						</named-content>
					</xsl:if>

					<xsl:call-template name="parameterized_escaped_element">
						<xsl:with-param name="name">patent</xsl:with-param>
						<xsl:with-param name="param_name">country</xsl:with-param>
						<xsl:with-param name="param_value"><xsl:value-of select="PATENT_COUNTRY_REFERENCE"/></xsl:with-param>
						<xsl:with-param name="value"><xsl:apply-templates select="PATENT_NAME_REFERENCE" mode="cdata"/></xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="parameterized_escaped_element">
						<xsl:with-param name="name">named-content</xsl:with-param>
						<xsl:with-param name="param_name">content-type</xsl:with-param>
						<xsl:with-param name="param_value">patent-source</xsl:with-param>
						<xsl:with-param name="value">
							<xsl:apply-templates select="PATENT_ORGNAME_REFERENCE" mode="cdata"/>
						</xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="parameterized_escaped_element">
						<xsl:with-param name="name">named-content</xsl:with-param>
						<xsl:with-param name="param_name">content-type</xsl:with-param>
						<xsl:with-param name="param_value">patent-date</xsl:with-param>
						<xsl:with-param name="value"><xsl:apply-templates select="PATENT_DATE_REFERENCE" mode="cdata"/></xsl:with-param>
					</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">issue</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="ISSUE_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">issue-title</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="ISSUE_TITLE_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">issue-part</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="ISSUE_PART_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">series</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="SERIE_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">volume-series</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="SERIE_VOLUME" mode="cdata"/></xsl:with-param>
				</xsl:call-template>


				<xsl:call-template name="parameterized_escaped_element">
					<xsl:with-param name="name">volume</xsl:with-param>
					<xsl:with-param name="param_name">type</xsl:with-param>
					<xsl:with-param name="param_value">analytic-volume</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="ANALYTIC_VOLUME" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="parameterized_escaped_element">
					<xsl:with-param name="name">volume</xsl:with-param>
					<xsl:with-param name="param_name">type</xsl:with-param>
					<xsl:with-param name="param_value">monographic-volume</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="MONOGRAPHIC_VOLUME" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:if test="EXTENT_REFERENCE">
					<size>
						<xsl:if test="EXTENT_REFERENCE/@TYPE != ''">
							<xsl:attribute name="units"><xsl:value-of select="EXTENT_REFERENCE/@TYPE"/></xsl:attribute>
						</xsl:if>
						<xsl:apply-templates mode="cdata" select="EXTENT_REFERENCE"/>
					</size>
				</xsl:if>

				<xsl:call-template name="parameterized_escaped_element">
					<xsl:with-param name="name">named-content</xsl:with-param>
					<xsl:with-param name="param_name">content-type</xsl:with-param>
					<xsl:with-param name="param_value">tome</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="TOME_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:if test="PUBLISHER_REFERENCE != ''">
					<xsl:call-template name="escaped_element">
						<xsl:with-param name="name">publisher-name</xsl:with-param>
						<xsl:with-param name="value"><xsl:apply-templates select="PUBLISHER_REFERENCE" mode="cdata"/></xsl:with-param>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="PUBLISHER_ADDRESS_REFERENCE != ''">
					<publisher-loc>
						<xsl:if test="PUBLISHER_ADDRESS_REFERENCE">
							<xsl:call-template name="escaped_element">
								<xsl:with-param name="name">city</xsl:with-param>
								<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="PUBLISHER_ADDRESS_REFERENCE/CITY"/></xsl:with-param>
							</xsl:call-template>

							<xsl:call-template name="escaped_element">
								<xsl:with-param name="name">state</xsl:with-param>
								<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="PUBLISHER_ADDRESS_REFERENCE/STATE"/></xsl:with-param>
							</xsl:call-template>

							<xsl:call-template name="escaped_element">
								<xsl:with-param name="name">country</xsl:with-param>
								<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="PUBLISHER_ADDRESS_REFERENCE/COUNTRY"/></xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</publisher-loc>
				</xsl:if>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">sponsor</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="SPONSOR_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="parameterized_escaped_element">
					<xsl:with-param name="name">named-content</xsl:with-param>
					<xsl:with-param name="param_name">content-type</xsl:with-param>
					<xsl:with-param name="param_value">editor</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="EDITOR_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">comment</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="COMMENT_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>


				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">version</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="VERSION_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="parameterized_escaped_element">
					<xsl:with-param name="name">named-content</xsl:with-param>
					<xsl:with-param name="param_name">content-type</xsl:with-param>
					<xsl:with-param name="param_value">pmid</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="PMID_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="parameterized_escaped_element">
					<xsl:with-param name="name">named-content</xsl:with-param>
					<xsl:with-param name="param_name">content-type</xsl:with-param>
					<xsl:with-param name="param_value">pmcid</xsl:with-param>
					<xsl:with-param name="value"><xsl:apply-templates select="PMCID_REFERENCE" mode="cdata"/></xsl:with-param>
				</xsl:call-template>
			</element-citation>
		</ref>
	</xsl:template>

	<xsl:template match="RESUME">
		<xsl:variable name="from">
			<xsl:call-template name="format_date">
				<xsl:with-param name="date" select="@FROM"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="until">
			<xsl:call-template name="format_date">
				<xsl:with-param name="date" select="@UNTIL"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="resumptionToken">
			<xsl:if test="@CONTROL">
				<xsl:value-of select="@CONTROL"/>:<xsl:value-of select="@SET"/>:<xsl:value-of select="$from"/>:<xsl:value-of select="$until"/>:<xsl:value-of select="@METADATAPREFIX"/>
			</xsl:if>
		</xsl:variable>
		<resumptionToken><xsl:value-of select="normalize-space($resumptionToken)"/></resumptionToken>
	</xsl:template>

	<xsl:template match="ARTICLE" name="format_article">
		<record>
			<header>
				<dc:identifier pub-id-type="publisher-id">
					<xsl:value-of select="@PID"/>
				</dc:identifier>

				<dc:isPartOf>
					<xsl:value-of select="ISSN"/>
				</dc:isPartOf>

				<xsl:if test="@PROCESSDATE != ''">
					<xsl:apply-templates select="@PROCESSDATE" mode="date">
						<xsl:with-param name="date_type">process-date</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@PROCESSDATE"/></xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
			</header>

			<metadata>
				<journal>
					<xsl:for-each select="ISSUE_ISSN">
						<xsl:call-template name="parameterized_escaped_element">
							<xsl:with-param name="param_name">publication-format</xsl:with-param>
							<xsl:with-param name="param_value">
								<xsl:call-template name="format_issue_type">
									<xsl:with-param name="type">
										<xsl:value-of select="./@TYPE"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="name">issn</xsl:with-param>
							<xsl:with-param name="value">
								<xsl:value-of select="."/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:call-template name="escaped_element">
						<xsl:with-param name="name">journal-title</xsl:with-param>
						<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="TITLEGROUP/TITLE"/></xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="escaped_element">
						<xsl:with-param name="name">abbrev-journal-title</xsl:with-param>
						<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="TITLEGROUP/SHORTTILE"/></xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="parameterized_escaped_element">
						<xsl:with-param name="name">named-content</xsl:with-param>
						<xsl:with-param name="param_name">content-type</xsl:with-param>
						<xsl:with-param name="param_value">siglum</xsl:with-param>
						<xsl:with-param name="value"><xsl:apply-templates mode="cdata" select="TITLEGROUP/SIGLUM"/></xsl:with-param>
					</xsl:call-template>

					<xsl:for-each select="TITLEGROUP/SUBJECT">
						<xsl:call-template name="escaped_element">
							<xsl:with-param name="name">subject</xsl:with-param>
							<xsl:with-param name="value">
								<xsl:apply-templates mode="cdata" select="."/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>

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

				<dc:language>
					<xsl:value-of select="@ORIGINALLANG"/>
				</dc:language>

				<dc:type>
					<xsl:value-of select="@DOCTYPE"/>
				</dc:type>

				<dc:format>text/html</dc:format>

				<dc:rights>info:eu-repo/semantics/openAccess</dc:rights>

				<xsl:if test="@DOI">
					<article-id pub-id-type="doi">
						<xsl:value-of select="@DOI"/>
					</article-id>
				</xsl:if>

				<xsl:if test="@oldpid">
					<article-id pub-id-type="old-publisher-id">
						<xsl:value-of select="@oldpid"/>
					</article-id>
				</xsl:if>

			</metadata>
		</record>
	</xsl:template>

</xsl:stylesheet>
