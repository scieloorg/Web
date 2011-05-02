<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mml="http://www.w3.org/1998/Math/MathML">
	<xsl:template match="ARTICLE" mode="related-documents">
		<xsl:apply-templates select="related" mode="item"/>
	</xsl:template>
	<xsl:template match="related" mode="item">
		<li>
			<xsl:apply-templates select="." mode="link"/>
		</li>
	</xsl:template>
	<xsl:template match="related[@type='pr']" mode="link">
		<xsl:variable name="relatedType" select="@type"/>
		<xsl:variable name="url">
			<xsl:call-template name="getScieloLink">
				<xsl:with-param name="seq" select="@pid"/>
				<xsl:with-param name="script">sci_arttext_pr</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="CREATE_ARTICLE_SERVICE_LINK">
			<xsl:with-param name="URL" select="$url"/>
			<xsl:with-param name="LABEL">
				<xsl:value-of select="$translations//xslid[@id='sci_toolbox']//text[@find=$relatedType]"/>
			</xsl:with-param>
			<xsl:with-param name="IMG" select="concat('/img/',$interfaceLang,'/fulltxt.gif')"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="related[@type='art' or @type='issue']" mode="link">
		<xsl:variable name="relatedType" select="@type"/>
		<xsl:variable name="url">
			<xsl:call-template name="getScieloLink">
				<xsl:with-param name="seq" select="@pid"/>
				<xsl:with-param name="script">
					<xsl:choose>
						<xsl:when test="@type='art'">sci_arttext</xsl:when>
						<xsl:otherwise>sci_issuetoc</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<a href="javascript:void(0);" class="nomodel" style="text-decoration: none;">
			<xsl:attribute name="onclick">window.opener.location.href = '<xsl:value-of select="$url"/>'; window.close();</xsl:attribute>
			<xsl:attribute name="rel">nofollow</xsl:attribute>
			<xsl:value-of select="$translations//xslid[@id='sci_toolbox']//text[@find=$relatedType]"/>
		</a>
	</xsl:template>
	<xsl:template match="related[@type='vi']" mode="link">
		<!--a>
			video FIXME
		</a-->
	</xsl:template>
	<xsl:template match="related[@type='au']" mode="link">
		<!--a>
			audio FIXME
		</a-->
	</xsl:template>
</xsl:stylesheet>
