<?xml version="1.0"?>
<xsl:transform version="1.0" id="ViewNLM-v2-04_scielo.xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:util="http://dtd.nlm.nih.gov/xsl/util" xmlns:mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="util xsl">
	<xsl:template match="ref-list">
		<xsl:if test="position()>1">
			<hr class="section-rule"/>
		</xsl:if>
		<xsl:if test="not(title)">
			<span class="tl-main-part">References</span>
			<xsl:call-template name="nl-1"/>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:call-template name="nl-1"/>
	</xsl:template>
	<xsl:template match="ref">
		<p id="{@id}">
			<xsl:apply-templates select="label"/>
			<xsl:apply-templates select="citation|nlm-citation"/>
			<xsl:apply-templates select="citation/pub-id|nlm-citation/pub-id" mode="link"/>
			<xsl:call-template name="nl-1"/>
		</p>
	</xsl:template>
	<xsl:template match="ref//label">
		<b>
			<i>
				<xsl:apply-templates/>
				<xsl:text>. </xsl:text>
			</i>
		</b>
	</xsl:template>
	<xsl:template match="ref//label | ref//ext-link" mode="nscitation">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="ref//label | ref//ext-link" mode="none">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="pub-id" mode="none"/>
	<xsl:template match="pub-id" mode="nscitation"/>
	<xsl:template match="pub-id" mode="link">
		<xsl:if test="position()=1">
			<br/>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:if>
		[&#160;<xsl:apply-templates select="." mode="link-value"/>&#160;]&#160;
	</xsl:template>
	<xsl:template match="pub-id[@pub-id-type='pmid']" mode="link-value">
	
		<a  target="_blank"><xsl:attribute name="href"><xsl:apply-templates select="../../node()" mode="medline-link-src"/></xsl:attribute>Medline</a>
	</xsl:template>
	<xsl:template match="pub-id[@pub-id-type='doi']" mode="link-value">
		<a href="http://dx.doi.org/{.}" target="_blank">CrossRef</a>
	</xsl:template>
	<xsl:template match="lpage" mode="none"/>
	<xsl:template match="*[.//pub-id]" mode="medline-link-src">
		<xsl:variable name="year-range">
			<xsl:choose>
				<xsl:when test=".//year &lt; 1997">1966-1996</xsl:when>
				<xsl:when test=".//year &gt;= 1997">1997-2007</xsl:when>
			</xsl:choose>
		</xsl:variable>http://bases.bireme.br/cgi-bin/wxislind.exe/iah/online/?IsisScript=iah/iah.xis&amp;nextAction=lnk&amp;base=MEDLINE_<xsl:value-of select="$year-range"/>&amp;exprSearch=<xsl:value-of select=".//pub-id[@pub-id-type='pmid']"/>&amp;indexSearch=UI&amp;lang=i</xsl:template>
</xsl:transform>
