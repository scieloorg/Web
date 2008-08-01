<?xml version="1.0" encoding="utf-8"?>
<xsl:transform version="1.0" id="ViewNLM-v2-04_scielo.xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:util="http://dtd.nlm.nih.gov/xsl/util" xmlns:doc="http://www.dcarlisle.demon.co.uk/xsldoc" xmlns:ie5="http://www.w3.org/TR/WD-xsl" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:fns="http://www.w3.org/2002/Math/preference" xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:pref="http://www.w3.org/2002/Math/preference" pref:renderer="mathplayer" exclude-result-prefixes="util xsl">
	<xsl:template match="*" mode="make-a-piece">
		<!-- variable to be used in div id's to keep them unique -->
		<xsl:variable name="which-piece">
			<xsl:value-of select="concat(local-name(), '-level-', count(ancestor::*))"/>
		</xsl:variable>
		<!-- front matter, in table -->
		<xsl:call-template name="nl-2"/>
		<div id="{$which-piece}-front" class="fm">
			<!-- class is repeated on contained table elements -->
			<xsl:call-template name="nl-1"/>
			<xsl:apply-templates select="." mode="make-front"/>
			<xsl:call-template name="nl-1"/>
		</div>
		<xsl:call-template name="nl-2"/>
		<div id="{$which-piece}-body" class="body">
			<xsl:call-template name="nl-1"/>
			<xsl:apply-templates select="." mode="make-body"/>
			<xsl:call-template name="nl-1"/>
		</div>
		<xsl:call-template name="nl-2"/>
		<div id="{$which-piece}-back" class="bm">
			<!-- class is repeated on contained table elements -->
			<xsl:call-template name="nl-1"/>
			<xsl:apply-templates select="." mode="make-back"/>
			<xsl:call-template name="nl-1"/>
		</div>
		<!-- retrieval metadata, at end -->
		<xsl:call-template name="nl-2"/>
	</xsl:template>
	<xsl:template match="abstract" mode="format">
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
	<xsl:template match="*" mode="make-body">
		<xsl:apply-templates select=".//body/*"/>
	</xsl:template>
	<xsl:template match="*" mode="make-back">
		<xsl:apply-templates select=".//back"/>
		<xsl:apply-templates select=".//back/ref-list"/>
		<xsl:apply-templates select="//author-notes" mode="text"/>
		<xsl:apply-templates select="//history" mode="text"/>
		<xsl:apply-templates select="//fn-group" mode="text"/>
	</xsl:template>
	<xsl:template match="author-notes" mode="text">
		<p>
			<br/>
		</p>
		<p>
			<br/>
		</p>
		<a>
			<xsl:attribute name="href">#top</xsl:attribute>
			<img src="/img/seta.gif" alt="" border="0" align="middle"/>
		</a>
		<xsl:text> </xsl:text>
		<a name="{corresp/@id}">
			<xsl:apply-templates select="//corresp" mode="copyValue"/>
		</a>
	</xsl:template>
	<xsl:template match="//corresp" mode="copyValue">
		<xsl:copy-of select="."/>
	</xsl:template>
	<!-- ScELO -->
	<xsl:template match="history" mode="text">
		<p>	</p>
		<xsl:apply-templates select="date" mode="text"/>
		<xsl:text>.</xsl:text>
	</xsl:template>
	<xsl:template match="date" mode="text">
		<xsl:if test="position()!=1">; </xsl:if>
		<xsl:variable name="the-type">
			<xsl:choose>
				<xsl:when test="@date-type='accepted'">Accepted: </xsl:when>
				<xsl:when test="@date-type='received'">Received: </xsl:when>
				<xsl:when test="@date-type='rev-request'">Revision Requested: </xsl:when>
				<xsl:when test="@date-type='rev-recd'">Revision Received: </xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="@date-type">
			<!--span class="gen"-->
			<xsl:value-of select="$the-type"/>
			<xsl:text/>
			<!--/span-->
		</xsl:if>
		<xsl:variable name="the-month">
			<xsl:choose>
				<xsl:when test="month='01'">January</xsl:when>
				<xsl:when test="month='02'">February</xsl:when>
				<xsl:when test="month='03'">March</xsl:when>
				<xsl:when test="month='04'">April</xsl:when>
				<xsl:when test="month='05'">May</xsl:when>
				<xsl:when test="month='06'">June</xsl:when>
				<xsl:when test="month='07'">July</xsl:when>
				<xsl:when test="month='08'">August</xsl:when>
				<xsl:when test="month='09'">September</xsl:when>
				<xsl:when test="month='10'">October</xsl:when>
				<xsl:when test="month='11'">November</xsl:when>
				<xsl:when test="month='12'">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$the-month"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="day"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="year"/>
	</xsl:template>
	<xsl:template match="fn-group" mode="text">
		<p>
			<br/>
		</p>
		<p>
			<br/>
		</p>
		<p>
			<br/>
		</p>
		<xsl:value-of select="fn"/>
	</xsl:template>
	<xsl:template match="fn" mode="text">
		
	</xsl:template>
	<xsl:template match="back">
		<xsl:apply-templates select="*[not(self::title) and not(self::fn-group) and not(self::ref-list)]"/>
		<xsl:apply-templates select="title"/>
		<xsl:if test="preceding-sibling::body//fn-group | .//fn-group">
			<xsl:apply-templates select="preceding-sibling::body//fn-group | .//fn-group"/>
			<xsl:call-template name="nl-1"/>
		</xsl:if>
		<xsl:call-template name="nl-1"/>
	</xsl:template>
	<xsl:template match="*" mode="make-end-metadata">
		<xsl:apply-templates select=".//article-meta"/>
	</xsl:template>
	<xsl:template match="article-meta">
		<xsl:apply-templates select="article-categories"/>
		<xsl:apply-templates select="related-article"/>
		<xsl:apply-templates select="conference"/>
	</xsl:template>
	<xsl:template match="mml:math">
		<xsl:comment>pmc</xsl:comment>
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="tex-math">
		<xsl:variable name="f">
			<xsl:choose>
				<xsl:when test="contains(.,'\begin{document}')">
					<xsl:value-of select="substring-before(substring-after(.,'\begin{document} $$'),'$$ \end{document}')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<img src="{concat(//MIMETEX,'?',$f)}" alt="" border="0" align="middle"/>
	</xsl:template>
	<xsl:template match="trans-title" mode="format">
		<xsl:variable name="lang" select="@xml:lang"/>
		<p class="scielo-article-other-titles{$languages//language[@id=$lang]/@view}">
			<xsl:value-of select="."/>
		</p>
	</xsl:template>
	<xsl:template match="email">
		<a href="mailto:{.}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	<xsl:template match="author-notes" mode="translate">
		<xsl:param name="lang" select="../../../../..//ARTICLE/@TEXTLANG"/>
		<xsl:choose>
			<xsl:when test="$lang='pt' ">Correspondência</xsl:when>
			<xsl:when test="$lang='es' ">Correspondencia</xsl:when>
			<xsl:when test="$lang='en' ">Send correspondence to</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" mode="back">
	<a href="javascript: back()">_</a>
	</xsl:template>
</xsl:transform>
