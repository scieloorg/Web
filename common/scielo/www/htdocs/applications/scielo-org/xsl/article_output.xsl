<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="article | citing">
		<xsl:param name="s"/>
		<xsl:param name="pos"/>
		<xsl:variable name="country" select="concat(@country,@code)"/>
		<xsl:variable name="nameCountry" select="$texts/text[find=$country]/replace"/>
		<xsl:variable name="domainCountry" select="$texts/text[find=$country]/url"/>
		<xsl:variable name="url" select="concat($domainCountry,'/scielo.php?script=sci_arttext&amp;pid=',@pid,'&amp;nrm=iso&amp;lng=',$lang)"/>
		<xsl:variable name="service_log" select="/root/service_log"/>
		<li>
			<div>
				<div class="articleHeader">
					<div class="count">
						<xsl:value-of select="$pos"/> / <xsl:value-of select="$total"/>
					</div>
					<div class="collection">
				        SciELO <xsl:value-of select="$nameCountry"/>
					</div>
				</div>
				<div style="clear: both; height: 1px; margin: 0px; padding: 0px;"/>
				<!--xsl:apply-templates select="." mode="old"><xsl:with-param name="url" select="$url"/></xsl:apply-templates-->
				<xsl:apply-templates select="." mode="standardized-reference"><xsl:with-param name="domain" select="$domainCountry"/><xsl:with-param name="LANG" select="$lang"/><xsl:with-param name="log" select="$service_log"/></xsl:apply-templates>
				<xsl:if test="$s != ''">
					<br/>
					<xsl:value-of select="$texts/text[find='similarity']/replace"/>
					<xsl:value-of select="$s"/>
				</xsl:if>
				<br/>
				<a href="{$url}" target="_blank">
					<xsl:value-of select="$texts/text[find='full_text']/replace"/>
				</a>
			</div>
		</li>
	</xsl:template>
	<xsl:template match="author">
		<xsl:param name="total"/>
		<xsl:value-of select="."/>
		<xsl:choose>
			<xsl:when test="position() = $total">. </xsl:when>
			<xsl:otherwise>, </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="title">
		<b>
			<xsl:value-of select="."/>
		</b>.
	</xsl:template>
	<xsl:template match="serial">
		<xsl:value-of select="."/> ,
	</xsl:template>
	<xsl:template match="year">
		<xsl:value-of select="."/>,
	</xsl:template>
	<xsl:template match="volume">
		vol.<xsl:value-of select="."/>,
	</xsl:template>
	<xsl:template match="number">
		no.<xsl:value-of select="."/>,
	</xsl:template>
	<xsl:template match="@pid" mode="issn">
		ISSN <xsl:value-of select="substring(.,2,9)"/>.
	</xsl:template>
	<xsl:template match="*" mode="old">
		<xsl:param name="url"/>
		<xsl:apply-templates select="authors/author">
			<xsl:with-param name="total" select="count(authors/author)"/>
		</xsl:apply-templates>
		<xsl:element name="a">
			<xsl:attribute name="target">_blank</xsl:attribute>
			<xsl:choose>
				<xsl:when test="titles/title[@lang=$lang] != '' ">
					<!--
									Se tem titulo com o idioma da interface corrente mostra o titulo e
									prepara a URL para a presentar a interface e texto nesse idioma
								-->
					<xsl:attribute name="href"><xsl:value-of select="concat($url,'&amp;tlng=',$lang)"/></xsl:attribute>
					<xsl:if test="$service_log = 1 ">
						<xsl:attribute name="OnClick">callUpdateArticleLog('similares_em_scielo');</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="titles/title[@lang=$lang]"/>
				</xsl:when>
				<xsl:otherwise>
					<!--
								Se nao tem titulo com o idioma da interface corrente mostra o primeiro titulo e
								prepara a URL para a presentar a interface e texto com o idioma corrente e o texto
								com o idioma do primeiro titulo
							-->
					<xsl:attribute name="href"><xsl:value-of select="concat($url,'&amp;tlng=',titles/title[1]/@lang)"/></xsl:attribute>
					<xsl:if test="$service_log = 1 ">
						<xsl:attribute name="OnClick">callUpdateArticleLog('similares_em_scielo');</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="titles/title[1]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>, 
                    <xsl:apply-templates select="serial"/>
		<xsl:apply-templates select="year"/>
		<xsl:apply-templates select="volume"/>
		<xsl:apply-templates select="number"/>
		<xsl:apply-templates select="@pid" mode="issn"/>
	</xsl:template>

</xsl:stylesheet>
