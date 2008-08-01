<?xml version="1.0"?>
<xsl:transform version="1.0" id="ViewNLM-v2-04_scielo.xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:util="http://dtd.nlm.nih.gov/xsl/util" xmlns:mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="util xsl">
	<xsl:template match="*" mode="make-front">
		<!-- FIXME nao tem article-categories no XML -->
		<xsl:apply-templates select=".//article-categories"/>
		<xsl:apply-templates select=".//title-group/article-title" mode="front"/>
		<xsl:apply-templates select=".//trans-title" mode="front"/>
		<xsl:apply-templates select=".//contrib-group/contrib" mode="front"/>
		<xsl:if test=".//contrib-group//aff">
			<p>
				<xsl:apply-templates select=".//aff" mode="front"/>
			</p>
		</xsl:if>
		<xsl:apply-templates select="//author-notes" mode="front"/>
		<hr/>
		<xsl:apply-templates select=".//abstract" mode="front"/>
		<hr/>
	</xsl:template>
	<!--
	
	-->
	<xsl:template match="article-title" mode="front">
		<a name="top">&#160;</a>
		<p class="scielo-article-title">
			<!--xsl:value-of select="." disable-output-escaping="yes"/-->
			<xsl:apply-templates/>
			<xsl:apply-templates select="../subtitle" mode="front"/>
		</p>
	</xsl:template>
	<xsl:template match="trans-title" mode="front">
		<xsl:variable name="lang" select="@xml:lang"/>
		<p class="scielo-article-other-titles{$languages//language[@id=$lang]/@view}">
			<xsl:value-of select="."/>
		</p>
	</xsl:template>
	<xsl:template match="contrib" mode="front">
		<p class="scielo-authors">
			<xsl:apply-templates select="*" mode="front"/>
			<xsl:if test="position()!=last()">; </xsl:if>
		</p>
	</xsl:template>
	<xsl:template match="name" mode="front">
		<xsl:apply-templates select="given-names" mode="front"/>&#160;
		<xsl:apply-templates select="surname" mode="front"/>
	</xsl:template>
	<xsl:template match="xref[@ref-type='aff']/@rid | aff/@id" mode="front">
		<sup>
			<xsl:apply-templates select="."/>
		</sup>
	</xsl:template>
	<xsl:template match="xref" mode="front">
		<xsl:apply-templates select="@rid" mode="front"/>
	</xsl:template>
	<xsl:template match="xref[@ref-type='aff']/@rid | aff/@id">
		<xsl:variable name="xref" select="substring-after(.,'aff')"/>
		<xsl:choose>
			<xsl:when test="$xref='1'">I</xsl:when>
			<xsl:when test="$xref='2'">II</xsl:when>
			<xsl:when test="$xref='3'">III</xsl:when>
			<xsl:when test="$xref='4'">IV</xsl:when>
			<xsl:when test="$xref='5'">V</xsl:when>
			<xsl:when test="$xref='6'">VI</xsl:when>
			<xsl:when test="$xref='7'">VII</xsl:when>
			<xsl:when test="$xref='8'">VIII</xsl:when>
			<xsl:when test="$xref='9'">IX</xsl:when>
			<xsl:when test="$xref='10'">X</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$xref"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="aff" mode="front">
		<xsl:apply-templates select="@id" mode="front"/>
		<xsl:apply-templates select="*[name()!='label']" mode="front"/>
		<br/>
	</xsl:template>
	<xsl:template match="aff/*" mode="front">
		<xsl:apply-templates />
		<xsl:if test="position()!=last()">, </xsl:if>
	</xsl:template>
	<xsl:template match="author-notes" mode="front">
		<xsl:variable name="xref" select="corresp/@id"/>
		<p>
			<a>
				<xsl:attribute name="href">#<xsl:value-of select="$xref"/></xsl:attribute>
				<xsl:apply-templates select="." mode="translate"/>
			</a>
		</p>
		<p>
			<br/>
		</p>
		<p>
			<br/>
		</p>
	</xsl:template>
	<xsl:template match="abstract" mode="front">
		<xsl:variable name="lang" select="@xml:lang"/>
		<span class="abstract-title">
			<!-- if there's no title, create one -->
			<xsl:apply-templates select="." mode="words-for-abstract-title"/>
		</span>
		<div class="abstract{$languages//language[@id=$lang]/@view}">
			<xsl:apply-templates select="*[not(self::title)]|text()"/>
		</div>
		<xsl:apply-templates select="..//kwd-group[@xml:lang=$lang or not(@*)]"/>
		<xsl:if test="position()!=last()">
			<hr/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="words-for-abstract-title">
		<xsl:choose>
			<!-- if there's a title, use it -->
			<xsl:when test="title">
				<xsl:apply-templates select="title"/>
			</xsl:when>
			<!-- abstract with no title -->
			<xsl:when test="self::abstract">
				<xsl:text>Abstract</xsl:text>
			</xsl:when>
			<!-- trans-abstract with no title -->
			<xsl:when test="self::trans-abstract">
				<span class="gen">
					<xsl:text>Abstract, Translated</xsl:text>
				</span>
			</xsl:when>
			<!-- there is no logical otherwise -->
		</xsl:choose>
	</xsl:template>
	<xsl:template match="kwd-group">
		<p>
			<span class="scielo-authors">
				<xsl:text>[traduzir]Key words: </xsl:text>
			</span>
			<xsl:apply-templates select=".//kwd" mode="list-item"/>.
		</p>
	</xsl:template>
</xsl:transform>
