<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML">


	<xsl:variable name="HOWTODISPLAY"><xsl:choose>
		<xsl:when test="//SIGLUM='bjmbr'">THUMBNAIL</xsl:when><xsl:otherwise>STANDARD</xsl:otherwise>
	</xsl:choose></xsl:variable>
	
	<xsl:variable name="refpos">
		<xsl:choose>
			<xsl:when test="$xml_article">
				<xsl:apply-templates select="document($xml_article)//ref" mode="scift-position"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select=".//ref" mode="scift-position"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="issue_label">
		<xsl:choose>
			<xsl:when test="//ISSUE/@NUM = 'AHEAD'">
				<xsl:value-of select="substring(//ISSUE/@PUBDATE,1,4)"/>
				<xsl:if test="//ISSUE/@NUM">nahead</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="//ISSUE/@VOL">v<xsl:value-of select="//ISSUE/@VOL"/>
				</xsl:if>
				<xsl:if test="//ISSUE/@NUM">n<xsl:value-of select="//ISSUE/@NUM"/>
				</xsl:if>
				<xsl:if test="//ISSUE/@SUPPL">s<xsl:value-of select="//ISSUE/@SUPPL"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="var_IMAGE_PATH">
		<xsl:choose>
			<xsl:when test="//PATH_SERIMG and //SIGLUM and //ISSUE">
				<xsl:value-of select="//PATH_SERIMG"/>
				<xsl:value-of select="//SIGLUM"/>/<xsl:value-of select="$issue_label"/>/</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="//image-path"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="article_lang">
		<xsl:value-of select="$xml_article_lang"/>
	</xsl:variable>

	<xsl:variable name="display_objects">
		<xsl:value-of select="$xml_display_objects"/>
	</xsl:variable>

	<xsl:template match="ref" mode="scift-position">{<xsl:value-of select="@id"/>}<xsl:value-of
			select="position()"/>{/<xsl:value-of select="@id"/>}</xsl:template>
	<xsl:template match="ref" mode="scift-get_position">
		<xsl:variable name="id" select="@id"/>
		<xsl:value-of
			select="substring-after(substring-before($refpos,concat('{/',$id,'}')),concat('{',$id,'}'))"
		/>
	</xsl:template>


	<xsl:template match="article" mode="text-content">
		<xsl:call-template name="scift-make-article"/>		
	</xsl:template>
	
	<xsl:template name="scift-make-article">
		<!-- Generates a series of (flattened) divs for contents of any
	       article, sub-article or response -->
		
		<!-- variable to be used in div id's to keep them unique -->
		<xsl:variable name="this-article">
			<xsl:apply-templates select="." mode="id"/>
		</xsl:variable>
		
		<div id="{$this-article}-front" class="front">
			<xsl:apply-templates select="front | front-stub"/>
		</div>
		
		<!-- body -->
		<xsl:for-each select="body">
			<div id="{$this-article}-body" class="body">
				<xsl:apply-templates/>
			</div>
		</xsl:for-each>
		
		<xsl:if test="back | $loose-footnotes">
			<!-- $loose-footnotes is defined below as any footnotes outside
           front matter or fn-group -->
			<div id="{$this-article}-back" class="back">
				<xsl:call-template name="make-back"/>
			</div>
		</xsl:if>
		
		<xsl:for-each select="floats-group">
			<div id="{$this-article}-floats" class="back">
				<xsl:call-template name="main-title">
					<xsl:with-param name="contents">
						<span class="generated">Floating objects</span>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:apply-templates/>
			</div>
		</xsl:for-each>
		
		
		<!-- sub-article or response (recursively calls
		     this template) -->
		<xsl:apply-templates select="sub-article | response"/>
		
		
		<div class="foot-notes">
			<xsl:apply-templates select="front//article-meta//history"/>
			<xsl:apply-templates select="front//article-meta//author-notes"/>
		</div>
		<xsl:apply-templates select="sub-article"/>
		<div class="foot-notes">
			<xsl:apply-templates select="front//article-meta//permissions"/>
		</div>
	</xsl:template>
	<xsl:template match="front">
		<xsl:apply-templates select="article-meta//article-categories"/>
		<xsl:apply-templates select="article-meta//title-group"/>
		<xsl:apply-templates select="../sub-article[@article-type='translation']//title-group"/>
		<xsl:apply-templates select="article-meta//contrib-group"/>
		<xsl:apply-templates select="article-meta//aff"/>
		<xsl:apply-templates
			select="article-meta//abstract | ../sub-article[@article-type='translation']//abstract"/>
		<xsl:apply-templates select="article-meta//trans-abstract"/>
	</xsl:template>
	<xsl:template match="front-stub">
	</xsl:template>
	
	<xsl:template name="main-title"
		match="abstract/title | body/*/title |
		back/title | back[not(title)]/*/title">
		<xsl:param name="contents">
			<xsl:apply-templates/>
		</xsl:param>
		<xsl:if test="normalize-space($contents)">
			<!-- coding defensively since empty titles make glitchy HTML -->
			<p class="sec">
				<xsl:copy-of select="$contents"/>
			</p>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="section-title"
		match="abstract/*/title | body/*/*/title |
		back[title]/*/title | back[not(title)]/*/*/title">
		<xsl:param name="contents">
			<xsl:apply-templates/>
		</xsl:param>   
		<xsl:if test="normalize-space($contents)">
			<!-- coding defensively since empty titles make glitchy HTML -->
			<p class="sub-subsec">
				<xsl:copy-of select="$contents"/>
			</p>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="xref[@ref-type='bibr']">
		
		<xsl:choose>
			<xsl:when test="not(sup)"><sup>
				<a href="#{@rid}">
					<xsl:apply-templates select="key('element-by-id',@rid)"
						mode="label-text">
						<xsl:with-param name="warning" select="true()"/>
					</xsl:apply-templates>
				</a>
				
			</sup></xsl:when>
			<xsl:otherwise>
				<a href="#{@rid}">
					<xsl:apply-templates select="key('element-by-id',@rid)"
						mode="label-text">
						<xsl:with-param name="warning" select="true()"/>
					</xsl:apply-templates>
				</a>
				
			</xsl:otherwise>
		</xsl:choose>				
	</xsl:template>
	<xsl:template match="body[//graphic]">
	</xsl:template>
	<xsl:template match="fig | table-wrap">
		<xsl:choose>
			<xsl:when test="$HOWTODISPLAY = 'THUMBNAIL'">
				<!--xsl:apply-templates select="." mode="scift-thumbnail"></xsl:apply-templates-->				
			</xsl:when>
			<xsl:when test="$HOWTODISPLAY = 'STANDARD'">				
				<xsl:apply-templates select="." mode="scift-standard"/>
			</xsl:when>			
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="fig" mode="scift-standard">
		<div class="figure">
			
			<xsl:call-template name="named-anchor"/>
			<xsl:apply-templates select="graphic"/>
			<div class="label_caption">
				<xsl:apply-templates select="label" mode="scift-label-caption-graphic"/>
				<xsl:if test="label and caption"> - <xsl:apply-templates select="caption" mode="scift-label-caption-graphic"/>
				</xsl:if>
			</div>
			
		</div>
	</xsl:template>
	<xsl:template match="table-wrap" mode="scift-standard">
		<div class="table-wrap">
			
			<xsl:call-template name="named-anchor"/>
			
			<div class="label_caption">
				<xsl:apply-templates select="label" mode="scift-label-caption-graphic"/>
				<xsl:if test="label and caption"> - <xsl:apply-templates select="caption" mode="scift-label-caption-graphic"/>
				</xsl:if>
			</div>
			<xsl:apply-templates select="graphic | table"/>
				<xsl:apply-templates mode="footnote"
					select="self::table-wrap//fn[not(ancestor::table-wrap-foot)]"/>
		</div>
	</xsl:template>
	<xsl:template match="fig/label | table-wrap/label | fig/caption | table-wrap/caption">
		<span class="{name()}">
			<xsl:apply-templates select="* | text()"/>
		</span>
	</xsl:template>
	<xsl:template match="table-wrap[not(.//graphic)]" mode="scift-thumbnail">
		<xsl:apply-templates select="." mode="scift-standard"></xsl:apply-templates>
	</xsl:template>
	<xsl:template match="fig | table-wrap[.//graphic]" mode="scift-thumbnail">
		<div class="{local-name()} panel">
			<xsl:call-template name="named-anchor"/>
			<table class="table_thumbnail">
				<tr>
					<td class="td_thumbnail"><xsl:apply-templates select=".//graphic" mode="scift-thumbnail"/></td>
					<td class="td_label_caption">
						<div class="label_caption">
							<xsl:apply-templates select="label" mode="scift-label-caption-graphic"/>
							<xsl:if test="label and caption"> - <xsl:apply-templates select="caption" mode="scift-label-caption-graphic"/>
							</xsl:if>
						</div>
						<xsl:apply-templates mode="footnote"
							select="self::table-wrap//fn[not(ancestor::table-wrap-foot)]"/>
					</td>					
				</tr>				
			</table>
		</div>
	</xsl:template>
	<xsl:template match="disp-formula">
		<p class="{local-name()} panel">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="graphic">
		<a target="_blank">			
			<xsl:apply-templates select="@xlink:href" mode="scift-attribute-href"/>
			<img class="graphic">
				<xsl:apply-templates select="@xlink:href" mode="scift-attribute-src"/>
			</img>
		</a>
	</xsl:template>
	
	<xsl:template match="inline-graphic | disp-formula/graphic">
		<a target="_blank">			
			<xsl:apply-templates select="@xlink:href" mode="scift-attribute-href"/>
			<img class="formula">
				<xsl:apply-templates select="@xlink:href" mode="scift-attribute-src"/>
			</img>
		</a>
	</xsl:template>
	<xsl:template match="graphic" mode="scift-thumbnail">
		<a target="_blank">			
			<xsl:apply-templates select="@xlink:href" mode="scift-attribute-href"/>
			<img class="thumbnail">
				<xsl:apply-templates select="@xlink:href" mode="scift-attribute-src"/>
			</img>
		</a>
	</xsl:template>
	<xsl:template match="@href | @xlink:href" mode="scift-fix-href">		
		<xsl:variable name="src"><xsl:value-of select="$var_IMAGE_PATH"/><xsl:choose><xsl:when
		test="contains(., '.tif')"><xsl:value-of select="substring-before(.,'.tif')"
		/></xsl:when><xsl:otherwise><xsl:value-of select="."
		/></xsl:otherwise></xsl:choose></xsl:variable>
		<xsl:value-of select="$src"/><xsl:if test="not(contains($src,'.jpg'))">.jpg</xsl:if>
	</xsl:template>
	<xsl:template match="@href | @xlink:href" mode="scift-attribute-href">
		<xsl:attribute name="href">
			<xsl:apply-templates select="." mode="scift-fix-href"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="@href | @xlink:href" mode="scift-attribute-src">
		<xsl:attribute name="src">
			<xsl:apply-templates select="." mode="scift-fix-href"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="label|caption" mode="scift-label-caption-graphic">
		<span class="{name()}"><xsl:apply-templates select="text() | *" mode="scift-label-caption-graphic"/></span>
	</xsl:template>
	<xsl:template match="title" mode="scift-label-caption-graphic">
		<xsl:apply-templates select="text() | *" />			
	</xsl:template>
	
	
	<xsl:template match="sec[@sec-type]">
		<div class="section">
			<xsl:call-template name="named-anchor"/>
			<xsl:apply-templates select="title"/>
			<xsl:apply-templates select="sec-meta"/>
			<xsl:apply-templates mode="drop-title"/>
		</div>
		<xsl:choose>
			<xsl:when test="$HOWTODISPLAY= 'STANDARD'"></xsl:when>
			<xsl:when test="$HOWTODISPLAY= 'THUMBNAIL'">
				<xsl:apply-templates select=".//fig|.//table-wrap[.//graphic]" mode="scift-thumbnail">
					<xsl:sort select="@id"/>
				</xsl:apply-templates>
			<hr/>
			</xsl:when>
		</xsl:choose>		
		
	</xsl:template>
	
	<xsl:template match=" back/ref-list">
		<div>
			<a name="references"></a>
			<p class="sec">
			<xsl:apply-templates select="title"/>
			
			<xsl:if test="not(title)">
				<xsl:choose>					
					<xsl:when test="$article_lang='pt'"> REFERÊNCIAS </xsl:when>
					<xsl:when test="$article_lang='es'"> REFERENCIAS </xsl:when>
					<xsl:otherwise> REFERENCES </xsl:otherwise>
				</xsl:choose>
			</xsl:if>			</p>
			<xsl:apply-templates select="ref"/>
		</div>
	</xsl:template>
	
	<xsl:template match="ref">
		<p class="ref">
			<a name="{@id}"></a>
			<xsl:choose>
				<xsl:when test="label and mixed-citation">
					<xsl:if test="substring(mixed-citation,1,string-length(label))!=label">
						<xsl:value-of select="label"/>.&#160; 
					</xsl:if>
				</xsl:when>
				<xsl:when test="label"><xsl:value-of select="label"/>.&#160; </xsl:when>
				<!--xsl:otherwise><xsl:value-of select="position()"/>.&#160; </xsl:otherwise-->
			</xsl:choose> 
			
				<xsl:choose>
					<xsl:when test="mixed-citation">						
						<xsl:apply-templates select="mixed-citation"/>
					</xsl:when>
					<!--xsl:when test="element-citation">
						<xsl:apply-templates select="element-citation"/>
					</xsl:when>
					<xsl:when test="citation">
						<xsl:apply-templates select="citation"/>
					</xsl:when>
					<xsl:when test="nlm-citation">
						<xsl:apply-templates select="nlm-citation"/>
					</xsl:when-->
					<xsl:otherwise><xsl:comment>missing mixed-citation</xsl:comment></xsl:otherwise>
				</xsl:choose>
			
			<xsl:variable name="aref">000000<xsl:apply-templates select="." mode="scift-get_position"
			/></xsl:variable>
			<xsl:variable name="ref"><xsl:value-of
				select="substring($aref, string-length($aref) - 5)"/></xsl:variable>
			<xsl:variable name="pid"><xsl:value-of select="$PID"/><xsl:value-of
				select="substring($ref,2)"/></xsl:variable> [&#160;<a href="javascript:void(0);"
					onclick="javascript: window.open('/scielo.php?script=sci_nlinks&amp;pid={$pid}&amp;lng=en','','width=640,height=500,resizable=yes,scrollbars=1,menubar=yes,');"
					>Links</a>&#160;] </p>
	</xsl:template>
	
	
	<xsl:template match="mixed-citation | element-citation | nlm-citation | citation ">
		<xsl:apply-templates select="* | text()"/>
	</xsl:template>
	
	<xsl:template match="table">
		<div class="table">
			<xsl:copy-of select="."/>
		</div>
	</xsl:template>
	<xsl:template match="thead">
		<thead>
			<xsl:apply-templates select="@* | *"/>
		</thead>
	</xsl:template>
	<xsl:template match="tbody">
		<tbody>
			<xsl:apply-templates select="@* | *"/>
		</tbody>
	</xsl:template>
	<xsl:template match="tr">
		<tr>
			<xsl:apply-templates select="@* | *"/>
		</tr>
	</xsl:template>
	<xsl:template match="td">
		<td>
			<xsl:apply-templates select="@* | *| text()"/>
		</td>
	</xsl:template>
	<xsl:template match="th">
		<th>
			<xsl:apply-templates select="@* | *| text()"/>
		</th>
	</xsl:template>
	
	<xsl:template match="table-wrap-foot/fn">
		<p class="fn">
			<a name="{@id}">
				<xsl:apply-templates select="* | text()"/>
			</a>
		</p>
	</xsl:template>
	<xsl:template match="table-wrap-foot/fn/p">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="history">
		<div class="history">
			<p>
				<xsl:apply-templates select="date"></xsl:apply-templates>
			</p>
		</div>
	</xsl:template>
	<xsl:template match="history/date/month" mode="month">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="history/date">
		{<xsl:value-of select="."></xsl:value-of>}
		<xsl:choose>
			<xsl:when test="$article_lang='en'">
				<xsl:value-of select="@date-type"/>: <xsl:apply-templates select="month" mode="month"/> <xsl:value-of select="day"/>,  <xsl:value-of select="year"/>
			</xsl:when>
			<xsl:when test="$article_lang='pt'">
				<xsl:value-of select="@date-type"/>: <xsl:apply-templates select="month" mode="month"/> <xsl:value-of select="day"/>,  <xsl:value-of select="year"/>
			</xsl:when>
			<xsl:when test="$article_lang='es'">
				<xsl:value-of select="@date-type"/>: <xsl:apply-templates select="month" mode="month"/> <xsl:value-of select="day"/>,  <xsl:value-of select="year"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@date-type"/>: <xsl:apply-templates select="month" mode="month"/> <xsl:value-of select="day"/>,  <xsl:value-of select="year"/>
			</xsl:otherwise>
		</xsl:choose><xsl:if test="position()!=last()">; </xsl:if>
	</xsl:template>
</xsl:stylesheet>
