<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" omit-xml-declaration="yes" indent="no"/>

	<xsl:include href="../applications/scielo-org/xsl/article_output.xsl"/>
	<xsl:include href="sci_common.xsl"/>

    <xsl:variable name="lang" select="//vars/lang"/>
	<xsl:variable name="texts" select="document('../applications/scielo-org/xml/texts.xml')/texts/language[@id = $lang]"/>
	<xsl:variable name="metaSearchInstances" select="document(concat('../applications/scielo-org/xml/',$lang,'/metaSearchInstances.xml'))"/>
	<xsl:variable name="links" select="//ARTICLE"/>
	<xsl:variable name="total" select="count(//citinglist/citing)"/>
	<xsl:template match="/">

								
	<div class="articleList">
		<xsl:choose>
			<xsl:when test="$total &gt; 0">
				<ul>
					<xsl:apply-templates select="//scielo/citinglist" mode="pre"/>
				</ul>
			</xsl:when>
			<xsl:otherwise>
                <xsl:value-of select="$translations/xslid[@id='cited']/text[@find = 'doesnt_cited']"/>
			</xsl:otherwise>
		</xsl:choose>
	</div>

								
	</xsl:template>
	
	<xsl:template match="citing" mode="pre">
					<xsl:apply-templates select="." >
							<xsl:with-param name="s" select="@s"/>
							<xsl:with-param name="pos" select="position()"/>
					</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
