<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="CONTROLINFO" select="//CONTROLINFO[1]" />
	
	<xsl:template match="text()" mode="cdata">
		<xsl:value-of select=" concat( '&lt;![CDATA[', . ,  ']]&gt;' ) " disable-output-escaping="yes"/>
	</xsl:template>
	
	<xsl:template name="escaped_element">
		<xsl:param name="name"/>
		<xsl:param name="value"/>

		<xsl:value-of select=" concat( '&lt;', $name, '&gt;', $value,  '&lt;/', $name, '&gt;' )" disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template match="ISSUEINFO" mode="datestamp">
		<datestamp>
			<xsl:call-template name="FormatDate">
				<xsl:with-param name="date">
					<xsl:choose>
						<xsl:when test="@MONTH"><xsl:value-of select=" concat(@YEAR, @MONTH) "/></xsl:when>
						<xsl:otherwise><xsl:value-of select=" concat(@YEAR, '01') "/></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</datestamp>
	</xsl:template>
	
	<xsl:template match="ISSN" mode="setSpec">
		<setSpec><xsl:value-of select="."/></setSpec>
	</xsl:template>

	<xsl:template name="OAI_DC_Header">
		<xsl:variable name="oai-dc">xmlns:oai-dc="http://www.openarchives.org/OAI/2.0/oai_dc/"</xsl:variable>
		<xsl:variable name="dc">xmlns:dc="http://purl.org/dc/elements/1.1/"</xsl:variable>
		<xsl:variable name="xsi">xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"</xsl:variable>
		<xsl:variable name="schemaLocation">xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd"</xsl:variable>

		<xsl:value-of select=" concat( '&lt;oai-dc:dc ', $oai-dc, ' ', $dc, ' ', $xsi, ' ', $schemaLocation, '&gt;' )" disable-output-escaping="yes" />	
	</xsl:template>
	
	<xsl:template name="OAI_DC_Footer">
		<xsl:value-of select=" '&lt;/oai-dc:dc&gt;' " disable-output-escaping="yes" />
	</xsl:template>

	<xsl:template match="TITLE">
		<xsl:variable name="elemento">
			dc:title xml:lang="teste"
		</xsl:variable>
		<xsl:call-template name="escaped_element">
			<xsl:with-param name="name">$elemento</xsl:with-param>
			<xsl:with-param name="value"><xsl:apply-templates select="text()" mode="cdata"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="AUTHORS">
		<xsl:apply-templates select="AUTH_PERS/AUTHOR" mode="pers"/>
	</xsl:template>
	
	<xsl:template match="AUTHOR" mode="pers">
		<xsl:call-template name="escaped_element">
			<xsl:with-param name="name">dc:creator</xsl:with-param>
			<xsl:with-param name="value" select="concat( '&lt;![CDATA[', SURNAME , ',' , NAME ,  ']]&gt;' )"></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="KEYWORD">
		<xsl:call-template name="escaped_element">
			<xsl:with-param name="name">dc:subject</xsl:with-param>
			<xsl:with-param name="value"><xsl:apply-templates select="KEY" /><xsl:if test="SUBKEY">/</xsl:if><xsl:apply-templates select="SUBKEY" /></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="KEY | SUBKEY">		
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
				<xsl:value-of select="@CONTROL"/>:<xsl:value-of select="@SET"/>:<xsl:value-of select="$from"/>:<xsl:value-of select="$until"/>
			</xsl:if>
		</xsl:variable>
		<resumptionToken><xsl:value-of select="normalize-space($resumptionToken)"/></resumptionToken>
	</xsl:template>
	
	<xsl:template name="FormatDate">
		<xsl:param name="date"/>
		<xsl:if test="$date">
			<xsl:choose>
				<xsl:when test=" substring($date,5,2) = '00' ">
					<xsl:value-of select="concat(substring($date,1,4),'-01-01') "/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(substring($date,1,4), '-', substring($date,5,2), '-01') "/>
				</xsl:otherwise>
			</xsl:choose>
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
		<xsl:call-template name="escaped_element">
			<xsl:with-param name="name">dc:identifier</xsl:with-param>
			<xsl:with-param name="value">http://<xsl:value-of select="concat(SCIELO_INFO/SERVER, SCIELO_INFO/PATH_DATA)"/>scielo.php?script=sci_arttext&amp;amp;pid=<xsl:value-of select="$PID"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="TITLEGROUP" mode="publisher">
		<xsl:call-template name="escaped_element">
			<xsl:with-param name="name">dc:publisher</xsl:with-param>
			<xsl:with-param name="value"><xsl:apply-templates select="TITLE/text()" mode="cdata"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="ARTICLE">
		<record>
			<header>
				<xsl:apply-templates select="@PID" mode="identifier"/>
				<xsl:apply-templates select="ISSUEINFO" mode="datestamp" />
				<xsl:apply-templates select="ISSUEINFO/ISSN" mode="setSpec" />
			</header>
			<metadata>
				<xsl:call-template name="OAI_DC_Header" />
					<xsl:apply-templates select="TITLE" />
					<xsl:apply-templates select="AUTHORS" />
					<xsl:apply-templates select="KEYWORDS" />
					<xsl:apply-templates select="ABSTRACT" />

					<xsl:apply-templates select="TITLEGROUP" mode="publisher" />

					<xsl:apply-templates select="ISSUEINFO" mode="pubdate" />
					<xsl:call-template name="escaped_element">
						<xsl:with-param name="name">dc:type</xsl:with-param>
						<xsl:with-param name="value">journal article</xsl:with-param>
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
				<xsl:call-template name="OAI_DC_Footer" />			
			</metadata>
		</record>
	</xsl:template>
	
	<xsl:template match="@PID" mode="identifier">
		<identifier>oai:scielo:<xsl:value-of select="."/></identifier>
	</xsl:template>
	
</xsl:stylesheet>
