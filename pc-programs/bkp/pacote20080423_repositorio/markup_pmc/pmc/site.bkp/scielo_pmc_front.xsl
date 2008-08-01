<?xml version="1.0"?>
<xsl:transform version="1.0" id="ViewNLM-v2-04_scielo.xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:util="http://dtd.nlm.nih.gov/xsl/util" xmlns:mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="util xsl">
	<xsl:template match="*" mode="make-front">
		<!-- FIXME nao tem article-categories no XML -->
		<xsl:apply-templates select=".//article-categories"/>
		<xsl:apply-templates select=".//title-group/article-title" mode="format"/>
		<xsl:apply-templates select=".//trans-title" mode="format"/>
		<xsl:choose>
			<xsl:when test=".//contrib-group">
				<!--xsl:apply-templates select=".//contrib"/-->
				<xsl:apply-templates select="AUTHORS" mode="format"/>

				<xsl:if test=".//contrib-group//aff">
				<p>
				<xsl:apply-templates select=".//aff" mode="format"/>
				</p>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="AUTHORS" mode="format"/>
				<xsl:apply-templates select="AFFILIATIONS" mode="format"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="//author-notes" mode="format"/>
		<hr/>
		<xsl:apply-templates select="//fulltext//abstract" mode="format"/>
		<hr/>
	</xsl:template>
	<xsl:template match="TITLE | article-title" mode="format">
		<a name="top">&#160;</a>
		<p class="scielo-article-title">
			<!--xsl:value-of select="." disable-output-escaping="yes"/-->
			<xsl:apply-templates/>
			<xsl:apply-templates select="../SUBTITLE | ../subtitle" mode="format"/>
		</p>
	</xsl:template>
	<xsl:template match="AUTHORS" mode="format">
		<p class="scielo-authors">
			<xsl:apply-templates select=".//AUTHOR" mode="format"/>
		</p>
	</xsl:template>
	<xsl:template match="AUTHOR" mode="format">
		<xsl:apply-templates select="NAME" mode="format"/>&#160;
		<xsl:apply-templates select="SURNAME" mode="format"/>
		<xsl:apply-templates select="AFF" mode="format"/>
		<xsl:if test="position()!=last()">; </xsl:if>
	</xsl:template>
	<xsl:template match="AFF[@xref]" mode="format">
		<sup>
			<xsl:apply-templates select="@xref" mode="format"/>
		</sup>
	</xsl:template>
	<xsl:template match="AFF/@xref|AFFILIATION/@ID | aff/@id" mode="format">
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
	<xsl:template match="AFFILIATIONS" mode="format">
		<p>
			<xsl:apply-templates select=".//AFFILIATION" mode="format"/>
		</p>
	</xsl:template>
	<xsl:template match="AFFILIATION" mode="format">
		<xsl:call-template name="make-id"/>
		<sup>
			<xsl:apply-templates select="@ID" mode="format"/>
		</sup>
		<xsl:apply-templates select="ORGNAME | ORGDIV"/>
		<xsl:apply-templates select="." mode="addr"/>
		<br/>
	</xsl:template>
	<xsl:template match="ORGDIV[.!='']">,<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="AFFILIATION" mode="addr">
		<xsl:if test="CITY">, 
		</xsl:if>
		<xsl:value-of select="CITY"/>
		<xsl:if test="CITY and STATE">, 
		</xsl:if>
		<xsl:value-of select="STATE"/>
		<xsl:if test="(CITY or STATE) and COUNTRY">, 
		</xsl:if>
		<xsl:value-of select="COUNTRY"/>
		<xsl:if test="(CITY or STATE or COUNTRY) and EMAIL">, 
		</xsl:if>
		<xsl:apply-templates select="EMAIL"/>
	</xsl:template>
	
	
	<xsl:template match="aff" mode="format">
		
		<sup>
			<xsl:apply-templates select="@id" mode="format"/>
		</sup>
		<xsl:apply-templates select="*[name()!='label']" mode="format"/>
		<br/>
	</xsl:template>
	<xsl:template match="aff/*" mode="format"><xsl:apply-templates/><xsl:if test="position()!=last()">, </xsl:if>
	</xsl:template>
	
	
	<xsl:template match="EMAIL">
		<a href="mailto:{.}">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="author-notes" mode="format">
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
	<xsl:template match="kwd-group">
		<p>
			<span class="scielo-authors">
				<xsl:call-template name="make-id"/>
				<xsl:text>Key words: </xsl:text>
			</span>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
</xsl:transform>
