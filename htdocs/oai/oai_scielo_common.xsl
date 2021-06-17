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
		<xsl:apply-templates select="text()" mode="cdata"/>
	</xsl:template>
	
	<xsl:template match="ABSTRACT">
		<xsl:call-template name="escaped_element">
			<xsl:with-param name="name">dc:description</xsl:with-param>
			<xsl:with-param name="value"><xsl:apply-templates select="text()" mode="cdata"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="RESUME">
		<xsl:variable name="from">
			<xsl:call-template name="FormatDate">
				<xsl:with-param name="date" select="@FROM"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="until">
			<xsl:call-template name="FormatDate">
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
	
	<xsl:template name="FormatDate">
		<xsl:param name="date"/>
		<xsl:if test="$date">
			<xsl:variable name="complete_date"><xsl:value-of select="$date"/>00000000</xsl:variable>
			
			<xsl:variable name="fixed_month_and_day"><xsl:choose>
				<xsl:when test="substring($complete_date,5,2)='00'">01</xsl:when><xsl:otherwise><xsl:value-of select="substring($complete_date,5,2)"/></xsl:otherwise>
			</xsl:choose><xsl:choose>
				<xsl:when test="substring($complete_date,7,2)='00'">01</xsl:when><xsl:otherwise><xsl:value-of select="substring($complete_date,7,2)"/></xsl:otherwise>
			</xsl:choose></xsl:variable>
			<xsl:value-of select="concat(substring($complete_date,1,4), '-', substring($fixed_month_and_day,1,2), '-', substring($fixed_month_and_day,3,2)) "/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ISSUEINFO" mode="pubdate">
		<xsl:call-template name="escaped_element">
			<xsl:with-param name="name">dc:date</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:call-template name="FormatDate">
					<xsl:with-param name="date">
						<xsl:choose>
							<xsl:when test="@MONTH"><xsl:value-of select=" concat(@YEAR, @MONTH) "/></xsl:when>
							<xsl:otherwise><xsl:value-of select=" concat(@YEAR, '01') "/></xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>							
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="CONTROLINFO" mode="identifier">
		<xsl:param name="PID" select="PAGE_PID" />

		<dc:identifier>http://<xsl:value-of select="concat(SCIELO_INFO/SERVER, SCIELO_INFO/PATH_DATA)"/>scielo.php?script=sci_arttext<xsl:text  disable-output-escaping="no">&amp;</xsl:text>pid=<xsl:value-of select="$PID"/></dc:identifier>

	</xsl:template>
	
	<xsl:template match="PUBLISHER">
		<xsl:call-template name="escaped_element">
			<xsl:with-param name="name">dc:publisher</xsl:with-param>
			<xsl:with-param name="value"><xsl:apply-templates select="NAME/text()" mode="cdata"/></xsl:with-param>		
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="TITLEGROUP" mode="source">
		<xsl:param name="vol" />
		<xsl:param name="num" />
		<xsl:param name="suppl" />
		<xsl:param name="year" />
		<xsl:param name="source">
			<xsl:if test="$vol != ''"><xsl:value-of select="concat(' v.',$vol)"/></xsl:if>
			<xsl:if test="$num != ''"><xsl:value-of select="concat(' n.',$num)"/></xsl:if>
			<xsl:if test="$suppl != ''"><xsl:value-of select="concat(' suppl.',$suppl)"/></xsl:if>
			<xsl:if test="$year != ''"><xsl:value-of select="concat(' ',$year)"/></xsl:if>
		</xsl:param>
		<xsl:call-template name="escaped_element">
			<xsl:with-param name="name">dc:source</xsl:with-param>
			<xsl:with-param name="value"><xsl:value-of select="concat('&lt;![CDATA[',TITLE/text(),' ',$source,']]&gt;')"/> </xsl:with-param>		
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="ARTICLE">
		<xsl:variable name="doctype" select="@DOC_TYPE" />
		<record>
			<header>
				<xsl:apply-templates select="@PID" mode="identifier"/>
				<!--FIXME OAI usar data de atualizacao -->
				<xsl:apply-templates select="@PROCESSDATE" mode="datestamp" />
				<xsl:apply-templates select="ISSUEINFO/ISSN" mode="setSpec" />
			</header>
			<metadata>
				<xsl:call-template name="OAI_DC_Header" />
				<xsl:apply-templates select="TITLE" />
				<xsl:apply-templates select="AUTHORS" />
				<xsl:apply-templates select="KEYWORDS" />
				<xsl:apply-templates select="ABSTRACT" />
				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">dc:rights</xsl:with-param>
					<xsl:with-param name="value">info:eu-repo/semantics/openAccess</xsl:with-param>			
				</xsl:call-template>
				<xsl:apply-templates select="PUBLISHERS/PUBLISHER" />
				<xsl:apply-templates select="TITLEGROUP" mode="source">
					<xsl:with-param name="vol"><xsl:value-of select="ISSUEINFO/@VOL"/></xsl:with-param>
					<xsl:with-param name="num"><xsl:value-of select="ISSUEINFO/@NUM"/></xsl:with-param>
					<xsl:with-param name="suppl"><xsl:value-of select="ISSUEINFO/@SUPPL"/></xsl:with-param>
					<xsl:with-param name="year"><xsl:value-of select="ISSUEINFO/@YEAR"/></xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="ISSUEINFO" mode="pubdate" />
                <xsl:call-template name="escaped_element">
                        <xsl:with-param name="name">dc:type</xsl:with-param>
                        <xsl:with-param name="value"><xsl:value-of select="$doc_type_conversor/item[@key = $doctype]" /></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="escaped_element">
					<xsl:with-param name="name">dc:format</xsl:with-param>
					<xsl:with-param name="value">text/html</xsl:with-param>						
				</xsl:call-template>
				<xsl:apply-templates select="$CONTROLINFO" mode="identifier">
					<xsl:with-param name="PID" select="@PID"/>
				</xsl:apply-templates>
				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">dc:language</xsl:with-param>
					<xsl:with-param name="value" select="@TEXT_LANG"/>						
				</xsl:call-template>
				<xsl:call-template name="escaped_element">
					<xsl:with-param name="name">dc:relation</xsl:with-param>
					<xsl:with-param name="value" select="@DOI"/>
				</xsl:call-template>
				<xsl:call-template name="OAI_DC_Footer" />			
			</metadata>
		</record>
	</xsl:template>
	
	<xsl:template match="@PID" mode="identifier">
		<identifier>oai:scielo:<xsl:value-of select="."/></identifier>
	</xsl:template>
	
</xsl:stylesheet>
