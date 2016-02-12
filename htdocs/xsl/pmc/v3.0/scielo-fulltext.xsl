<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML">
	
	
	<xsl:variable name="trans"
		select="$original//sub-article[@article-type='translation' and @xml:lang=$TEXT_LANG]"/>
	
	<xsl:variable name="use_original_aff" select="count($original//institution[@content-type='original'])&gt;0"/>
	<xsl:variable name="affiliations" select="$original//aff"/>
	
	<xsl:template match="article-meta/permissions | PERMISSIONS[@source]/permissions">
		<xsl:apply-templates select="." mode="permissions-footnote">
			<xsl:with-param name="style">article-license</xsl:with-param>
			<xsl:with-param name="text_lang" select="$langtext"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="id">
		<xsl:value-of select="@id"/>
		<xsl:if test="not(@id)">
			<xsl:value-of select="name()"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="italic">
		<em>
			<xsl:apply-templates/>
		</em>
	</xsl:template>
	<xsl:template match="bold">
		<strong>
			<xsl:apply-templates/>
		</strong>
	</xsl:template>
	<xsl:template match="sup|sub">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:variable name="HOWTODISPLAY">
		<xsl:choose>
			<xsl:when test="//SIGLUM='bjmbr'">STANDARD</xsl:when>
			<xsl:otherwise>STANDARD</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="refpos">
		<xsl:choose>
			<xsl:when test="$xml_article">
				<xsl:apply-templates select="$original/back/refs/ref" mode="scift-position"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select=".//ref" mode="scift-position"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="back/ref-list" mode="ref_list_before">
		<xsl:apply-templates select="following-sibling::node()[1]" mode="node-name"/>
	</xsl:template>
	
	<xsl:template match="back/ref-list" mode="ref_list_after">
		<xsl:apply-templates select="preceding-sibling::node()[1]" mode="node-name"/>
	</xsl:template>
	
	<xsl:template match="*" mode="node-name">
		<xsl:value-of select="name()"/>
	</xsl:template>

	

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
		<xsl:choose>
			<xsl:when test="$trans">
				<xsl:apply-templates select="$trans" mode="MAIN"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="MAIN"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="scift-make-article">
		<xsl:apply-templates select="." mode="MAIN"/>
	</xsl:template>

	<xsl:template match="@id">
		<a name="{.}"/>
	</xsl:template>

	<xsl:template match="sub-article | response" mode="MORE">
		<hr class="part-rule"/>

		<!-- Generates a series of (flattened) divs for contents of any
	       article, sub-article or response -->

		<!-- variable to be used in div id's to keep them unique -->
		<xsl:variable name="this-article">
			<xsl:apply-templates select="." mode="id"/>
		</xsl:variable>
		<div id="{$this-article}-front" class="front">
			<xsl:apply-templates select="front-stub | front"/>
		</div>
		<div id="{$this-article}-body" class="body">
			<xsl:apply-templates select="body"/>
		</div>
		<div id="{$this-article}-back" class="back">
			<xsl:choose>
				<xsl:when test="back | $loose-footnotes">
					<xsl:apply-templates select="back"/>
				</xsl:when>
				<xsl:when test="name()='sub-article' and not(back) and $original/back">
					<div id="{$this-article}-back" class="back">
						<xsl:apply-templates select="$original/back"/>
					</div>
				</xsl:when>
				<xsl:when test="name()='response' and not(back) and $original/response/back">
					<div id="{$this-article}-back" class="back">
						<xsl:apply-templates select="$original/response/back"/>
					</div>
				</xsl:when>
			</xsl:choose>
		</div>
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

		<div class="foot-notes">
			<xsl:apply-templates select=".//history"/>
			<xsl:apply-templates select=".//author-notes"/>
		</div>
			<xsl:apply-templates select=".//permissions"/>
	</xsl:template>
	<xsl:template match="sub-article | article" mode="MAIN">
		<!-- Generates a series of (flattened) divs for contents of any
	       article, sub-article or response -->

		<!-- variable to be used in div id's to keep them unique -->
		<xsl:variable name="this-article">
			<xsl:apply-templates select="." mode="id"/>
		</xsl:variable>
		<div id="{$this-article}-front" class="front">
			<xsl:apply-templates select="front-stub | front"/>
		</div>
		<div id="{$this-article}-body" class="body">
			<xsl:apply-templates select="body"/>
		</div>
		
		<xsl:choose>
			<xsl:when test="back | $loose-footnotes">
				<div id="{$this-article}-back" class="back">
					<xsl:apply-templates select="back"/>
				</div>
			</xsl:when>
			<xsl:when test="not(back) and $original/back">
				<div id="{$this-article}-back" class="back">
					<xsl:apply-templates select="$original/back"/>
				</div></xsl:when>
		</xsl:choose>
		
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
		<div class="foot-notes">
			<xsl:choose>
				<xsl:when test=".//front//history">
					<xsl:apply-templates select=".//front//history"/>
				</xsl:when>
				<xsl:when test=".//history">
					<xsl:apply-templates select=".//front//history"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$original//front//history"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test=".//front//author-notes">
					<xsl:apply-templates select=".//front//author-notes"/>
				</xsl:when>
				<xsl:when test=".//author-notes">
					<xsl:apply-templates select=".//author-notes"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$original//front//author-notes"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>

		<xsl:apply-templates select="sub-article[@article-type!='translation'] | response"
			mode="MORE"/>
			<xsl:choose>
				<xsl:when test=".//front//permissions">
					<xsl:apply-templates select=".//front//permissions"/>
				</xsl:when>
				<xsl:when test=".//permissionss">
					<xsl:apply-templates select=".//permissions"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$original//front//permissions"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>


	<xsl:template match="sub-article[@article-type='translation']//front-stub">
		<xsl:apply-templates select=".//article-categories"/>
		<xsl:if test="not(.//article-categories)">
			<xsl:apply-templates select="../..//front//article-categories"/>
		</xsl:if>
		<xsl:apply-templates select=".//title-group | .//trans-title"/>
		<xsl:if test="not(.//title-group)">
			<xsl:apply-templates select="../..//front//title-group | ../..//front//trans-title"/>
		</xsl:if>
		<xsl:apply-templates select=".//contrib-group"/>
		<xsl:if test="not(.//contrib-group)">
			<xsl:apply-templates select="../..//front//contrib-group"/>
		</xsl:if>
		<xsl:apply-templates select=".//aff"/>
		<xsl:if test="not(.//aff)">
			<xsl:apply-templates select="../..//front//aff"/>
		</xsl:if>
		<xsl:apply-templates select="../..//front//supplementary-material"/>
		<xsl:apply-templates select=".//abstract"/>
		
	</xsl:template>

	<xsl:template
		match="sub-article[@article-type!='translation']//front-stub | response//front-stub">
		<xsl:apply-templates select=".//article-categories"/>
		<xsl:apply-templates select=".//article-title | .//trans-title"/>
		<xsl:apply-templates select=".//contrib-group"/>
		<xsl:apply-templates select=".//aff"/>
		<xsl:apply-templates select=".//abstract | .//trans-abstract"/>
		<xsl:apply-templates select=".//supplementary-material"/>
	</xsl:template>

	<xsl:template match="front">
		<xsl:apply-templates select=".//article-categories"/>
		<xsl:apply-templates select=".//article-title | .//trans-title"/>
		<xsl:apply-templates select=".//contrib-group"/>
		<xsl:apply-templates select=".//aff"/>
		
		<p><xsl:apply-templates select=".//supplementary-material"/></p>
		<p><xsl:apply-templates select=".//product"/></p>
		<xsl:apply-templates select=".//abstract | .//trans-abstract"/>
		
	</xsl:template>

	<xsl:template match="abstract | trans-abstract">
		<xsl:variable name="lang"><xsl:choose>
			<xsl:when test="@xml:lang"><xsl:value-of select="@xml:lang"/></xsl:when>
			<xsl:when test="$trans"><xsl:value-of select="$trans/@xml:lang"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$original/@xml:lang"/></xsl:otherwise>
		</xsl:choose></xsl:variable>
		<div>
			<!--Apresenta o título da seção conforme a lingua existente-->
			<xsl:attribute name="class">
				<xsl:value-of select="name()"/>
			</xsl:attribute>
			<p class="sec">
				<xsl:choose>
					<xsl:when test="title">
						<a name="{title}"><xsl:value-of select="title"/></a>
					</xsl:when>
					<xsl:when test="$lang='pt'">
						<a name="resumo">RESUMO</a>
					</xsl:when>
					<xsl:when test="$lang='es'">
						<a name="resumen">RESUMEN</a>
					</xsl:when>
					<xsl:otherwise>
						<a name="abstract">ABSTRACT</a>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			
			<xsl:apply-templates select="*[name()!='title'] | text()"/>
			<xsl:apply-templates
				select="..//kwd-group[normalize-space(@xml:lang)=normalize-space($lang)]"
				mode="keywords-with-abstract"/>
			<xsl:if test="not(..//kwd-group[normalize-space(@xml:lang)=normalize-space($lang)])">
				<xsl:apply-templates
						select="..//kwd-group[not(@xml:lang)]"
						mode="keywords-with-abstract"/>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="kwd-group" mode="keywords-with-abstract">
		<xsl:variable name="lang" select="normalize-space(@xml:lang)"/>
		<!--xsl:param name="test" select="1"/>     <xsl:value-of select="$test"/-->
		<p>
			<!--Define o nome a ser exibido a frente das palavras-chave conforme o idioma-->
			<xsl:choose>
				<xsl:when test="$lang='es'">
					<b>Palabras-clave: </b>
				</xsl:when>
				<xsl:when test="$lang='pt'">
					<b>Palavras-Chave: </b>
				</xsl:when>
				<xsl:otherwise>
					<b>Key words: </b>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select=".//kwd"/>
		</p>
	</xsl:template>
	<xsl:template match="kwd-group"/>
	<!--Adiciona vírgulas as palavras-chave-->
	<xsl:template match="kwd">
		<xsl:if test="position()!= 1">; </xsl:if>
		<xsl:value-of select="."/>
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
		match="abstract/*/title | trans-abstract/*/title | body/*/*/title |
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

	<xsl:template name="subsection-title"
		match="abstract/*/*/title | body/*/*/*/title |
		back[title]/*/*/title | back[not(title)]/*/*/*/title">
		<xsl:param name="contents">
			<xsl:apply-templates/>
		</xsl:param>
		<xsl:if test="normalize-space($contents)">
			<!-- coding defensively since empty titles make glitchy HTML -->
			<p class="subsection-title">
				<xsl:copy-of select="$contents"/>
			</p>
		</xsl:if>
	</xsl:template>

	<xsl:template match="title-group/article-title">
		<div>
			<p class="title">
				<xsl:apply-templates select="* | text() "/>
				<xsl:apply-templates select="../subtitle" mode="scift-subtitle"/>
			</p>
		</div>
	</xsl:template>
	<xsl:template match="trans-title-group/trans-title">
		<div>
			<p class="trans-title">
				<xsl:apply-templates select="* | text() "/>
				<xsl:apply-templates select="../trans-subtitle" mode="scift-subtitle"/>
			</p>
		</div>
	</xsl:template>
	<!--Subtitulos do artigo-->
	<xsl:template match="title-group/subtitle | trans-title-group/trans-subtitle"
		mode="scift-subtitle">
		<span>
			<xsl:apply-templates select="* | text()"/>
		</span>
	</xsl:template>
	<xsl:template match="title-group/subtitle | trans-title-group/trans-subtitle"/>
	<!--Categoria do artigo     	Talvez seja desenecessária essa informação     -->
	<xsl:template match="subj-group/subject">
		<p class="categoria">
			<xsl:value-of select="."/>
		</p>
	</xsl:template>
	<!--Div contendo nome dos autores-->
	<xsl:template match="contrib-group">
		<div class="autores">
			<xsl:apply-templates select="contrib[not(@contrib-type) or @contrib-type='author']"/>
			<xsl:if test="not(contrib[@contrib-type!='author'])">
				<xsl:apply-templates select="role"></xsl:apply-templates>
			</xsl:if>
		</div>
		<div class="autores">
			<xsl:if test="not(role) and contrib[@contrib-type!='author']">
				<xsl:variable name="contribtype" select=".//contrib[@contrib-type!='author']/@contrib-type"></xsl:variable>
				<xsl:variable name="lang"><xsl:value-of select="$TEXT_LANG"/><xsl:if test="not(contains('en es pt',$TEXT_LANG))">en</xsl:if></xsl:variable>
				<xsl:variable name="label"><xsl:value-of select="document(concat('../../../xml/',$lang,'/translation.xml'))/translations//text[@find=$contribtype]"/></xsl:variable>
				<xsl:if test="$label!=''"><xsl:value-of select="$label"/>:</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="contrib[@contrib-type!='author']"/>
			<xsl:if test="contrib[@contrib-type!='author']">
				<xsl:apply-templates select="role"></xsl:apply-templates>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template match="contrib/role | contrib/degrees"><xsl:value-of select="concat(', ',.)"/>
	</xsl:template>
	<xsl:template match="contrib-group/role">
		<p class="role">
			<xsl:value-of select="."/>
		</p>
	</xsl:template>
	<xsl:template match="contrib">
		<xsl:variable name="sep"><xsl:choose>
			<xsl:when test="role or degrees">;</xsl:when>
			<xsl:otherwise>,</xsl:otherwise>
		</xsl:choose></xsl:variable>
		<xsl:if test="position()!=1"><xsl:value-of select="concat($sep,' ')"/></xsl:if>
		<xsl:apply-templates select="*|text()"/>
	</xsl:template>
	<xsl:template match="contrib/name">
		<xsl:if test="prefix"><xsl:apply-templates select="prefix"/>&#160;</xsl:if>
		<xsl:apply-templates select="given-names"/>&#160;<xsl:apply-templates select="surname"/>
		<xsl:if test="suffix">&#160;<xsl:apply-templates select="suffix"/></xsl:if>
	</xsl:template>
	<xsl:template match="text()" mode="normalize">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
	<xsl:template match="contrib/xref">
		<xsl:variable name="rid" select="@rid"/>
		<xsl:variable name="doit"><xsl:choose>
			<xsl:when test="normalize-space(.)=''">
				<xsl:choose>
					<xsl:when test="$use_original_aff">
						<xsl:if test="normalize-space($affiliations[@id=$rid]/institution[@content-type='original'])!=''">
							doit
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>doit</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>doit</xsl:otherwise>
		</xsl:choose></xsl:variable>
		<xsl:if test="normalize-space($doit)='doit'">
			<sup>
				<a href="#{@rid}"><xsl:value-of select="."/>
					<xsl:if test="normalize-space(.)=''">
						<xsl:variable name="label">
							<xsl:choose>
								<xsl:when test="contains(@rid,'aff')"><xsl:value-of select="substring-after(@rid,'aff')"/></xsl:when>
								<xsl:when test="contains(@rid,'a')"><xsl:value-of select="substring-after(@rid,'a')"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="@rid"/></xsl:otherwise>
							</xsl:choose></xsl:variable>
						<xsl:if test="string(number($label)) != 'NaN'">
							<xsl:value-of select="string(number($label))"/>
						</xsl:if>
					</xsl:if>
				</a>&#160;
			</sup>
		</xsl:if>
		
	</xsl:template>
	<xsl:template match="aff">
		<xsl:choose>
			<xsl:when test="$use_original_aff">
				<xsl:if test="normalize-space(institution[@content-type='original'])!=''">
					<xsl:apply-templates select="." mode="aff-parag"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="aff-parag"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="aff" mode="aff-parag">
		<p class="aff"><a name="{@id}"/>
			<xsl:apply-templates select="." mode="aff-label"/>
			<xsl:choose>
				<xsl:when test="normalize-space(institution[@content-type='original'])!=''">
					<xsl:apply-templates select="institution[@content-type='original']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="inst">
						<xsl:value-of select="normalize-space(institution[@content-type='orgname'])"
						/>
					</xsl:variable>
					<xsl:variable name="text">
						<xsl:apply-templates
							select="text()[string-length(normalize-space(.))&gt;=string-length($inst)]"
							mode="normalize"/>
					</xsl:variable>
					<xsl:comment>inst=<xsl:value-of select="$inst"/></xsl:comment>
					<xsl:comment>text=<xsl:value-of select="$text"/></xsl:comment>
					<xsl:choose>
						<xsl:when test="contains($text, $inst)">
							<xsl:comment>full</xsl:comment>
							<xsl:value-of select="$text"/>
							<xsl:apply-templates select="email"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:comment>parts</xsl:comment>
							<xsl:apply-templates
								select="text()[normalize-space(.)!='' and normalize-space(.)!=','] | institution | addr-line | country | email"
								mode="aff-insert-separator"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</p>
	</xsl:template>
	<xsl:template match="aff" mode="aff-label">
		<sup><xsl:choose>
			<xsl:when test="label">	
				<xsl:apply-templates select="label"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="label">
				<xsl:choose>
					<xsl:when test="contains(@id,'aff')"><xsl:value-of select="substring-after(@id,'aff')"/></xsl:when>
					<xsl:when test="contains(@id,'a')"><xsl:value-of select="substring-after(@id,'a')"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise>
				</xsl:choose></xsl:variable>
				<xsl:if test="string(number($label)) != 'NaN'">
					<xsl:value-of select="string(number($label))"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose></sup>
	</xsl:template>
	
	<xsl:template match="institution[@content-type='original']">
		<xsl:apply-templates select="*|text()" mode="aff-original"/>
	</xsl:template>

	<xsl:template match="named-content[@content-type='email']" mode="aff-original">
		<a href="mailto:{.}">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>

	<xsl:template match="aff/* | addr-line/* " mode="aff-insert-separator">
		<xsl:if test="position()!=1">, </xsl:if>
		<xsl:apply-templates select="*|text()[normalize-space(.)!='' and normalize-space(.)!=',']"
			mode="aff-insert-separator"/>
	</xsl:template>

	<xsl:template match="aff/text() | addr-line/text()" mode="aff-insert-separator">
		<xsl:variable name="text" select="normalize-space(.)"/>
		<xsl:comment>_ <xsl:value-of select="$text"/>  _</xsl:comment>

		<xsl:if test="position()!=1">, </xsl:if>

		<xsl:choose>
			<xsl:when test="substring($text,string-length($text),1)=','">
				<xsl:value-of select="substring($text,1,string-length($text)-1)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<xsl:template match="email" mode="aff-insert-separator">
		<xsl:if test="position()!=1">, </xsl:if>
		<a href="mailto:{text()}">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>


	<!--xsl:template match="text()[normalize-space(.)=',']" mode="aff-insert-separator"> </xsl:template>
	<xsl:template match="aff/*" mode="aff-insert-separator">
		<xsl:if test="position()!=1">, </xsl:if>
		<xsl:apply-templates select="*|text()" mode="aff-insert-separator"/>
	</xsl:template>
	<xsl:template match="aff/addr-line" mode="aff-insert-separator">
		<xsl:if test="position()!=1">, </xsl:if>
		<xsl:apply-templates select="*|text()" mode="aff-insert-separator"/>
	</xsl:template>
	<xsl:template match="addr-line/*">
		<xsl:apply-templates select="*|text()"/>
	</xsl:template>

	<xsl:template match="addr-line/*" mode="aff-insert-separator">
		<xsl:if test="position()!=1">, </xsl:if>
		<xsl:apply-templates select="*|text()" mode="aff-insert-separator"/>
	</xsl:template-->

	<xsl:template match="aff/label">
		<sup>
			<xsl:value-of select="."/>
		</sup>
	</xsl:template>
	<!--     *****     Email     **********************************************************************************     Nota:Se houver algum e-mail no resto do artigo também serpa aplicado este template     **********************************************************************************     -->
	<xsl:template match="email">
		<a href="mailto:{text()}">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="email" mode="element-content"> &#160;<a href="mailto:{text()}"
				><xsl:value-of select="."/></a>
	</xsl:template>
	<xsl:template match="email" mode="mixed-content">
		<a href="mailto:{text()}">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>

	<xsl:template match="xref">
		<a href="#{@rid}">
			<xsl:apply-templates select="*|text()"/>
		</a>
	</xsl:template>
	
	<xsl:template match="xref[@ref-type='fn']">
		<sup><a href="#back_{@rid}">
			<xsl:apply-templates select="*|text()"/>
		</a></sup>
	</xsl:template>
	
	<xsl:template match="xref[@ref-type='bibr']">
		<xsl:choose>
			<xsl:when test="normalize-space(.//text())=''">
				<sup>
					<a href="#{@rid}">
						<xsl:apply-templates select="key('element-by-id',@rid)" mode="label-text">
							<xsl:with-param name="warning" select="true()"/>
						</xsl:apply-templates>
					</a>
				</sup>
			</xsl:when>
			<xsl:when test="not(.//sup)">
				<sup>
					<a href="#{@rid}">
						<xsl:apply-templates select="*|text()"/>
					</a>
				</sup>
			</xsl:when>
			<xsl:otherwise>
				<a href="#{@rid}">
					<xsl:apply-templates select="*|text()"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="fig | table-wrap | fig-group | table-wrap-group">
		<xsl:comment>_ <xsl:value-of select="$HOWTODISPLAY"/>  _</xsl:comment>
		<xsl:choose>
			<xsl:when test="$HOWTODISPLAY = 'THUMBNAIL'">
				<!--xsl:apply-templates select="." mode="scift-thumbnail"></xsl:apply-templates-->
			</xsl:when>
			<xsl:when test="$HOWTODISPLAY = 'STANDARD'">
				<xsl:apply-templates select="." mode="scift-standard"/>
			</xsl:when>

		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="fig-group" mode="scift-standard">
		<div class="figure-group">
			<xsl:call-template name="named-anchor"/>
			<xsl:apply-templates select="graphic|media"/>
			<xsl:apply-templates select="attrib"/>
			<xsl:choose>
				<xsl:when test="fig[@xml:lang=$TEXT_LANG] and $trans">
					<xsl:apply-templates select="fig[@xml:lang=$TEXT_LANG]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="fig"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="fig" mode="scift-standard">
		<div class="figure">
			<xsl:call-template name="named-anchor"/>
			<xsl:apply-templates select="graphic|media"/>
			<xsl:apply-templates select="attrib"/>
			<p class="label_caption">
				<xsl:apply-templates select="label | caption" mode="scift-label-caption-graphic"/>
			</p>
		</div>
	</xsl:template>
	
	<xsl:template match="table-wrap-group" mode="scift-standard">
		<div class="table-wrap-group">
			<xsl:call-template name="named-anchor"/>
			<xsl:choose>
				<xsl:when test="table-wrap[@xml:lang=$TEXT_LANG] and $trans">
					<xsl:apply-templates select="table-wrap[@xml:lang=$TEXT_LANG]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="table-wrap"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="*[name()!='table-wrap']"/>
		</div>
	</xsl:template>
	
	<xsl:template match="table-wrap" mode="scift-standard">
		<div class="table-wrap">

			<xsl:call-template name="named-anchor"/>

			<p class="label_caption">
				<xsl:apply-templates select="label | caption" mode="scift-label-caption-graphic"/>

			</p>
			<xsl:apply-templates select="graphic | table | table-wrap-foot"/>
			
		</div>
	</xsl:template>
	<xsl:template match="table-wrap-foot">
		<xsl:apply-templates select="attrib"/>
		<xsl:apply-templates mode="footnote" select=".//fn"/>
	</xsl:template>
	<xsl:template match="fig/label | table-wrap/label | fig/caption | table-wrap/caption | attrib">
		<span class="{name()}">
			<xsl:apply-templates select="* | text()"/>
		</span>
	</xsl:template>
	<xsl:template match="table-wrap[not(.//graphic)]" mode="scift-thumbnail">
		<xsl:apply-templates select="." mode="scift-standard"/>
	</xsl:template>
	<xsl:template match="fig | table-wrap[.//graphic]" mode="scift-thumbnail">
		<div class="{local-name()} panel">
			<xsl:call-template name="named-anchor"/>
			<table class="table_thumbnail">
				<tr>
					<td class="td_thumbnail">
						<xsl:apply-templates select=".//graphic" mode="scift-thumbnail"/>
					</td>
					<td class="td_label_caption">
						<xsl:apply-templates select="attrib"/>
						<p class="label_caption">
							<xsl:apply-templates select="label | caption"
								mode="scift-label-caption-graphic"/>

						</p>
						<xsl:apply-templates mode="footnote" select=".//fn"/>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="table">
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="$version='xml'">dotted_table</xsl:when>
				<xsl:otherwise>table</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="table">
			<table class="{$class}">
				<xsl:apply-templates select="@*|*|text()"/>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="table//@*">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="table//*">
		<xsl:element name="{name()}">
			<xsl:if test=" name() = 'td' and $version='xml'">
				<xsl:attribute name="class">td</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates select="@* | * | text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="table//break"><br/>
	</xsl:template>
	<xsl:template match="table//xref">
		<xsl:if test="@ref-type='fn'">
			<a name="back_{@rid}"/>
		</xsl:if>
		<a href="#{@rid}">
			<xsl:apply-templates select="*|text()"/>
		</a>
	</xsl:template>
	<xsl:template match="table-wrap//fn" mode="footnote">
		<a name="{@id}"/>
		<p>
			<xsl:apply-templates select="* | text()"/>
		</p>
	</xsl:template>
	<xsl:template match="table-wrap//fn//label">
		<sup>
			<xsl:value-of select="."/>
		</sup>
	</xsl:template>
	<xsl:template match="table-wrap//fn/p">
		<xsl:apply-templates select="*|text()"/>
	</xsl:template>
	<xsl:template match="inline-formula">
		<span class="inline-formula">
			<xsl:apply-templates select="*|text()"/>
		</span>
	</xsl:template>
	<xsl:template match="disp-formula/label">
		<span class="label"><xsl:value-of select="."/></span>
	</xsl:template>
	<xsl:template match="disp-formula">
		<div class="disp-formula">
			<span class="formula">
				<xsl:apply-templates select="*[name()!='label']|text()"></xsl:apply-templates>
			</span>
			<xsl:apply-templates select="label"></xsl:apply-templates>			
		</div>
	</xsl:template>
	<xsl:template match="alternatives">
		<xsl:choose>
			<xsl:when test="mml:math">
				<xsl:apply-templates select="mml:math"/>
			</xsl:when>
			<xsl:when test="graphic">
				<xsl:apply-templates select="graphic"/>
			</xsl:when>
			<xsl:when test="tex-math">
				<xsl:apply-templates select="tex-math"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="graphic">
		<a target="_blank">
			<xsl:apply-templates select="." mode="scift-attribute-href"/>
			<img class="graphic">
				<xsl:apply-templates select="." mode="scift-attribute-src"/>
			</img>
		</a>
	</xsl:template>

	<xsl:template match="table//inline-graphic |inline-graphic | disp-formula/graphic">
		<a target="_blank">
			<xsl:apply-templates select="." mode="scift-attribute-href"/>
			<img class="inline-formula">
				<xsl:apply-templates select="." mode="scift-attribute-src"/>
			</img>
		</a>
	</xsl:template>
	<xsl:template match="graphic" mode="scift-thumbnail">
		<a target="_blank">
			<xsl:apply-templates select="." mode="scift-attribute-href"/>
			<img class="thumbnail">
				<xsl:apply-templates select="." mode="scift-attribute-src"/>
			</img>
		</a>
	</xsl:template>
	<xsl:template match="*" mode="scift-fix-href"><xsl:value-of select="$var_IMAGE_PATH"/>/<xsl:apply-templates select="." mode="fix_img_extension"/></xsl:template>
	<xsl:template match="*" mode="scift-attribute-href">
		<xsl:attribute name="href">
			<xsl:apply-templates select="." mode="scift-fix-href"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="*" mode="scift-attribute-src">
		<xsl:attribute name="src">
			<xsl:apply-templates select="." mode="scift-fix-href"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="label|caption" mode="scift-label-caption-graphic">
		<span class="{name()}"><xsl:apply-templates select="text() | *"
				mode="scift-label-caption-graphic"/>&#160;</span>
	</xsl:template>
	<xsl:template match="title" mode="scift-label-caption-graphic">
		<xsl:apply-templates select="text() | *"/>
	</xsl:template>
	<xsl:template match="sec[title]/label"></xsl:template>
	<xsl:template match="sec[@sec-type]/title">
		<p class="sec">
			<xsl:value-of select="../label"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="sec[not(@sec-type)]/title">
		<p class="sub-subsec">
			<xsl:value-of select="../label"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="sec/@sec-type">
		<a name="{.}"/>
	</xsl:template>
	<xsl:template match="p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="boxed-text">
		<div class="boxed-text">
			<xsl:apply-templates select="*|text()"></xsl:apply-templates>
		</div>
	</xsl:template>
	<xsl:template match="back/ref-list">
		<xsl:param name="title"></xsl:param>
		<div>
			<a name="references"/>
			<p class="sec">
				<xsl:choose>
					<xsl:when test="$title">
						<xsl:value-of select="$title"/>
					</xsl:when>
					<xsl:when test="not(title)">
						<xsl:choose>
							<xsl:when test="$TEXT_LANG='pt'"> REFERÊNCIAS </xsl:when>
							<xsl:when test="$TEXT_LANG='es'"> REFERENCIAS </xsl:when>
							<xsl:otherwise> REFERENCES </xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="title"/>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			<xsl:apply-templates select="ref"/>
		</div>
	</xsl:template>
	<xsl:template match="sub-article[@article-type='translation']/back/ref-list">
		<xsl:param name="title"></xsl:param>
		<div>
			<a name="references"/>
			<p class="sec">
				<xsl:apply-templates select="title"/>
				<xsl:if test="not(title)">
					<xsl:apply-templates select="$title"></xsl:apply-templates>
				</xsl:if>
			</p>
			<xsl:apply-templates select="$original/back/ref-list/ref"/>
		</div>
	</xsl:template>
	<xsl:template match="sub-article[@article-type='translation']/response/back/ref-list">
		<xsl:param name="title"></xsl:param>
		<div>
			<a name="references"/>
			<p class="sec">
				<xsl:apply-templates select="title"/>
				<xsl:if test="not(title)">
					<xsl:apply-templates select="$title"></xsl:apply-templates>
				</xsl:if>
			</p>
			<xsl:apply-templates select="$original/response/back/ref-list/ref"/>
		</div>
	</xsl:template>
	
	<xsl:template match="ref">
		<p class="ref" onclick="window.history.back();">
			<a name="{@id}"/>
			<xsl:choose>
				<xsl:when test="mixed-citation">
					<xsl:apply-templates select="mixed-citation"/>
				</xsl:when>
				<xsl:when test="citation">
					<xsl:apply-templates select="citation"/>
				</xsl:when>
				
				<xsl:otherwise><xsl:comment>_missing mixed-citation _</xsl:comment>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:variable name="aref">000000<xsl:apply-templates select="."
					mode="scift-get_position"/></xsl:variable>
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

	<xsl:template match="label" mode="display-only-if-number">
		<xsl:if test="number(translate(., '.', '')) = translate(., '.', '')">
			<xsl:value-of select="."/>
			<xsl:if test="not(contains(.,'.'))">.</xsl:if>&#160;
		</xsl:if>
	</xsl:template>
	<xsl:template match="mixed-citation[*]">
		<xsl:apply-templates select="text()|*"/>
	</xsl:template>
	<xsl:template match="mixed-citation[*]/*/text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="mixed-citation/text()">
		<xsl:variable name="text">
			<xsl:choose>
				<xsl:when test="../../label">
					<xsl:choose>
						<xsl:when test="position()=1 and starts-with(.,'.')">
							<xsl:apply-templates select="../../label" mode="display-only-if-number"/>
							<xsl:value-of select="substring-after(.,'.')"/>
						</xsl:when>
						<xsl:when test="position()=1 and starts-with(., concat(../../label,'.'))">
							<xsl:apply-templates select="../../label" mode="display-only-if-number"/>
							<xsl:value-of select="substring-after(.,concat(../../label,'.'))"/>
						</xsl:when>
						<xsl:when test="position()=1 and starts-with(., ../../label)">
							<xsl:apply-templates select="../../label" mode="display-only-if-number"/>
							<xsl:value-of select="substring-after(.,../../label)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="../../label" mode="display-only-if-number"/>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="position()=1 and starts-with(.,'.')">
					<xsl:value-of select="substring-after(.,'.')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="../../element-citation/*[@xlink:href]">
				<xsl:apply-templates select="../../element-citation/*[@xlink:href]" mode="insert_link_in_text">
					<xsl:with-param name="text" select="$text"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[@xlink:href]" mode="insert_link_in_text">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text,text())">
				<xsl:value-of select="substring-before($text,text())"/>
				<xsl:apply-templates select="."/>
				<xsl:value-of select="substring-after($text,text())"/>
			</xsl:when>
			<xsl:when test="contains($text,@xlink:href)">
				<xsl:value-of select="substring-before($text,@xlink:href)"/>
				<xsl:apply-templates select="."/>
				<xsl:value-of select="substring-after($text,@xlink:href)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="history">
		<div class="history">
			<p>
				<xsl:apply-templates select="date"/>
			</p>
		</div>
	</xsl:template>
	<xsl:template match="month" mode="date-month-en">
		<xsl:choose>
			<xsl:when test="text() = '01' or text() = '1'">January</xsl:when>
			<xsl:when test="text() = '02' or text() = '2'">February</xsl:when>
			<xsl:when test="text() = '03' or text() = '3'">March</xsl:when>
			<xsl:when test="text() = '04' or text() = '4'">April</xsl:when>
			<xsl:when test="text() = '05' or text() = '5'">May</xsl:when>
			<xsl:when test="text() = '06' or text() = '6'">June</xsl:when>
			<xsl:when test="text() = '07' or text() = '7'">July</xsl:when>
			<xsl:when test="text() = '08' or text() = '8'">August</xsl:when>
			<xsl:when test="text() = '09' or text() = '9'">September</xsl:when>
			<xsl:when test="text() = '10'">October</xsl:when>
			<xsl:when test="text() = '11'">November</xsl:when>
			<xsl:when test="text() = '12'">December</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="month" mode="date-month-es">
		<xsl:choose>
			<xsl:when test="text() = '01' or text() = '1'">Enero</xsl:when>
			<xsl:when test="text() = '02' or text() = '2'">Febrero</xsl:when>
			<xsl:when test="text() = '03' or text() = '3'">Marzo</xsl:when>
			<xsl:when test="text() = '04' or text() = '4'">Abril</xsl:when>
			<xsl:when test="text() = '05' or text() = '5'">Mayo</xsl:when>
			<xsl:when test="text() = '06' or text() = '6'">Junio</xsl:when>
			<xsl:when test="text() = '07' or text() = '7'">Julio</xsl:when>
			<xsl:when test="text() = '08' or text() = '8'">Agosto</xsl:when>
			<xsl:when test="text() = '09' or text() = '9'">Septiembre</xsl:when>
			<xsl:when test="text() = '10'">Octubre</xsl:when>
			<xsl:when test="text() = '11'">Noviembre</xsl:when>
			<xsl:when test="text() = '12'">Diciembre</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="month" mode="date-month-pt">
		<xsl:choose>
			<xsl:when test="text() = '01' or text() = '1'">Janeiro</xsl:when>
			<xsl:when test="text() = '02' or text() = '2'">Fevereiro</xsl:when>
			<xsl:when test="text() = '03' or text() = '3'">Março</xsl:when>
			<xsl:when test="text() = '04' or text() = '4'">Abril</xsl:when>
			<xsl:when test="text() = '05' or text() = '5'">Maio</xsl:when>
			<xsl:when test="text() = '06' or text() = '6'">Junho</xsl:when>
			<xsl:when test="text() = '07' or text() = '7'">Julho</xsl:when>
			<xsl:when test="text() = '08' or text() = '8'">Agosto</xsl:when>
			<xsl:when test="text() = '09' or text() = '9'">Setembro</xsl:when>
			<xsl:when test="text() = '10'">Outubro</xsl:when>
			<xsl:when test="text() = '11'">Novembro</xsl:when>
			<xsl:when test="text() = '12'">Dezembro</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="history/date/@date-type" mode="scift-as-label-en">
		<xsl:choose>
			<xsl:when test=". = 'rev-recd'">Revised</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(substring(.,1,1), 'ar', 'AR')"/>
				<xsl:value-of select="substring(.,2)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="history/date/@date-type" mode="scift-as-label-pt">
		<xsl:choose>
			<xsl:when test=". = 'rev-recd'">Revisado</xsl:when>
			<xsl:when test=". = 'accepted'">Aceito</xsl:when>
			<xsl:when test=". = 'received'">Recebido</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="history/date/@date-type" mode="scift-as-label-es">
		<xsl:choose>
			<xsl:when test=". = 'rev-recd'">Revisado</xsl:when>
			<xsl:when test=". = 'accepted'">Aprobado</xsl:when>
			<xsl:when test=". = 'received'">Recibido</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="history/date">
		<xsl:choose>
			<xsl:when test="$TEXT_LANG='pt'">
				<xsl:apply-templates select="@date-type" mode="scift-as-label-pt"/>:
				<xsl:if test="day">
					<xsl:value-of select="concat(day,' de ')"/>
				</xsl:if><xsl:apply-templates
					select="month" mode="date-month-pt"/> de <xsl:value-of select="year"/>
			</xsl:when>
			<xsl:when test="$TEXT_LANG='es'">
				<xsl:apply-templates select="@date-type" mode="scift-as-label-es"/>:
				<xsl:if test="day">
					<xsl:value-of select="concat(day,' de ')"/>
				</xsl:if><xsl:apply-templates
					select="month" mode="date-month-es"/> de <xsl:value-of select="year"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="@date-type" mode="scift-as-label-en"/>:
				<xsl:apply-templates select="month" mode="date-month-en"/><xsl:if test="day"><xsl:value-of select="concat(' ',day,',')"/></xsl:if><xsl:value-of select="concat(' ',year)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="position()!=last()">; </xsl:if>
	</xsl:template>

	<xsl:template match="author-notes">
		<div class="author-notes">
			<xsl:apply-templates select=" corresp | .//fn | text()"/>
		</div>
	</xsl:template>

	<xsl:template match="author-notes//@id">
		<a name="{.}"/>
	</xsl:template>
	<xsl:template match="author-notes/corresp">
		<p class="corresp">
			<xsl:apply-templates select="@* | *|text()"/>
		</p>
	</xsl:template>

	<xsl:template match="author-notes/fn">
		<xsl:apply-templates select="@* | *|text()"/>
	</xsl:template>

	<xsl:template match="corresp/label | author-notes/fn/label">
		<sup>
			<xsl:value-of select="."/>
		</sup>
	</xsl:template>

	<xsl:template match="author-notes//fn/@fn-type"> </xsl:template>
	<xsl:template match="author-notes//fn/p">
		<p class="fn-author">
			<xsl:apply-templates select="*|text()"/>
		</p>
	</xsl:template>
	<xsl:template match="back/fn-group">
		<div class="foot-notes">
			<xsl:apply-templates select="@*| *|text()"/>
		</div>
	</xsl:template>
	<xsl:template match="back/fn-group/fn">
		<div class="fn">
			<xsl:apply-templates select="title"/>
		<xsl:choose>
			<xsl:when test="count(p)&gt;1">
				<xsl:choose>
					<xsl:when test="label">
						<p>
							<xsl:apply-templates select="label"/>
						</p>
						<div class="fn-block">
							<xsl:apply-templates select="@*|*[name()!='label' and name()!='title']|text()"/>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@*|*[name()!='label' and name()!='title']|text()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="@*|*[name()!='label' and name()!='title']|text()"/>
			</xsl:otherwise>
		</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template match="back/fn-group/fn/@fn-type"> </xsl:template>
	<xsl:template match="back/fn-group/fn/@id">
		<a name="back_{../@id}"/>
	</xsl:template>
	<xsl:template match="back/fn-group/fn/label">
		<xsl:choose>
			<xsl:when test="number(.)=.">
				<sup><xsl:value-of select="."/></sup>
			</xsl:when>
			<xsl:otherwise>
				<strong><xsl:value-of select="."/></strong>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="back/fn-group/fn/title">
		<p class="sub-subsec"><xsl:value-of select="."/></p>
	</xsl:template>
	<xsl:template match="back/fn-group/fn/p">
		<p>
			<xsl:if test="count(..//p)=1">
			<xsl:apply-templates select="../label"/>
			</xsl:if>
			<xsl:apply-templates select="*|text()"/>
		</p>
	</xsl:template>
	
	
	<xsl:template match="sub-article[@article-type!='translation' or not(@article-type)]">
		<div class="sub-article" id="{@id}">
			<xsl:apply-templates select=".//title-group"/>
			<xsl:apply-templates select=".//abstract"/>
			<xsl:apply-templates select=".//trans-abstract"/>
			<div class="body">
				<xsl:apply-templates select="body"/>
			</div>
			<xsl:apply-templates select="back "/>
			<div class="sig-block">
				<xsl:apply-templates select=".//contrib-group"/>
				<xsl:apply-templates select=".//aff"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="sub-article[@article-type='translation']/back">

		<xsl:variable name="this-article">
			<xsl:apply-templates select="." mode="id"/>
		</xsl:variable>
		<!-- (label?, title*, (ack | app-group | bio | fn-group | glossary | ref-list | notes | sec)*) -->
		<div id="{$this-article}-back" class="back">
			<xsl:choose>
				<xsl:when test="not(ref-list/*) and ($original/back/ref-list/*)">
					<xsl:variable name="before"><xsl:apply-templates select="$original/back/ref-list" mode="ref_list_before"/></xsl:variable>
					<xsl:comment><xsl:value-of select="$before"/></xsl:comment>
					<xsl:variable name="after"><xsl:apply-templates select="$original/back/ref-list" mode="ref_list_after"/></xsl:variable>
					<xsl:comment><xsl:value-of select="$after"/></xsl:comment>
					
					<xsl:choose>
						<xsl:when test="$before!='' and *[name()=$before]">
							<xsl:apply-templates select="*" mode="insert-ref-list-in-correct-location">
								<xsl:with-param name="before"><xsl:value-of select="$before"/></xsl:with-param>
								<xsl:with-param name="ref_list" select="$original/back/ref-list"/>
								<xsl:with-param name="title">
									<xsl:choose>
										<xsl:when test="$TEXT_LANG='pt'"> REFERÊNCIAS </xsl:when>
										<xsl:when test="$TEXT_LANG='es'"> REFERENCIAS </xsl:when>
										<xsl:otherwise> REFERENCES </xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$after!='' and *[name()=$after]">
							<xsl:apply-templates select="*" mode="insert-ref-list-in-correct-location">
								<xsl:with-param name="after"><xsl:value-of select="$after"/></xsl:with-param>
								<xsl:with-param name="ref_list" select="$original/back/ref-list"/>
								<xsl:with-param name="title">
									<xsl:choose>
										<xsl:when test="$TEXT_LANG='pt'"> REFERÊNCIAS </xsl:when>
										<xsl:when test="$TEXT_LANG='es'"> REFERENCIAS </xsl:when>
										<xsl:otherwise> REFERENCES </xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="*"/>
							<xsl:apply-templates select="$original/back/ref-list">
								<xsl:with-param name="title">
									<xsl:choose>
										<xsl:when test="$TEXT_LANG='pt'"> REFERÊNCIAS </xsl:when>
										<xsl:when test="$TEXT_LANG='es'"> REFERENCIAS </xsl:when>
										<xsl:otherwise> REFERENCES </xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="response/back">		
		<xsl:variable name="this-article">
			<xsl:apply-templates select="." mode="id"/>
		</xsl:variable>
		<!-- (label?, title*, (ack | app-group | bio | fn-group | glossary | ref-list | notes | sec)*) -->
		<div id="{$this-article}-back" class="back">
			<xsl:apply-templates select="*"/>
		</div>
	</xsl:template>
	<xsl:template match="sub-article[@article-type='translation']//response/back">		
		<xsl:variable name="this-article">
			<xsl:apply-templates select="." mode="id"/>
		</xsl:variable>
		<!-- (label?, title*, (ack | app-group | bio | fn-group | glossary | ref-list | notes | sec)*) -->
		<div id="{$this-article}-back" class="back">
			<xsl:choose>
				<xsl:when test="not(ref-list/*) and ($original/response/back/ref-list/*)">
					<xsl:variable name="before"><xsl:apply-templates select="$original/response/back/ref-list" mode="ref_list_before"/></xsl:variable>
					<xsl:comment><xsl:value-of select="$before"/></xsl:comment>
					<xsl:variable name="after"><xsl:apply-templates select="$original/response/back/ref-list" mode="ref_list_after"/></xsl:variable>
					<xsl:comment><xsl:value-of select="$after"/></xsl:comment>
					
					<xsl:choose>
						<xsl:when test="$before!='' and *[name()=$before]">
							<xsl:apply-templates select="*" mode="insert-ref-list-in-correct-location">
								<xsl:with-param name="before"><xsl:value-of select="$before"/></xsl:with-param>
								<xsl:with-param name="ref_list" select="$original/response/back/ref-list"/>
								<xsl:with-param name="title">
									<xsl:choose>
										<xsl:when test="$TEXT_LANG='pt'"> REFERÊNCIAS </xsl:when>
										<xsl:when test="$TEXT_LANG='es'"> REFERENCIAS </xsl:when>
										<xsl:otherwise> REFERENCES </xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$after!='' and *[name()=$after]">
							<xsl:apply-templates select="*" mode="insert-ref-list-in-correct-location">
								<xsl:with-param name="after"><xsl:value-of select="$after"/></xsl:with-param>
								<xsl:with-param name="ref_list" select="$original/response/back/ref-list"/>
								<xsl:with-param name="title">
									<xsl:choose>
										<xsl:when test="$TEXT_LANG='pt'"> REFERÊNCIAS </xsl:when>
										<xsl:when test="$TEXT_LANG='es'"> REFERENCIAS </xsl:when>
										<xsl:otherwise> REFERENCES </xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="*"/>
							<xsl:apply-templates select="$original/response/back/ref-list">
								<xsl:with-param name="title">
									<xsl:choose>
										<xsl:when test="$TEXT_LANG='pt'"> REFERÊNCIAS </xsl:when>
										<xsl:when test="$TEXT_LANG='es'"> REFERENCIAS </xsl:when>
										<xsl:otherwise> REFERENCES </xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<!--xsl:template match="article/back/*" mode="old-translation-back">
		<xsl:param name="sub-article-back"/>
		<xsl:variable name="name"><xsl:value-of select="name()"></xsl:value-of></xsl:variable>
		<xsl:comment>_<xsl:value-of select="$name"/> _</xsl:comment>  
		<xsl:apply-templates select="$sub-article-back/*[name()=$name]"></xsl:apply-templates>
		<xsl:if test="name()='ref-list' and not($sub-article-back/ref-list)">
			<xsl:apply-templates select="."></xsl:apply-templates>
		</xsl:if>
	</xsl:template-->
	<xsl:template match="sub-article[@article-type='translation']"> </xsl:template>

	<xsl:template match="sub-article[@article-type='translation']">
		<!--div class="sub-article" id="{@id}">
			<xsl:apply-templates select=".//title-group"/>

			<div class="body">
				<xsl:apply-templates select="body"/>
			</div>

			<xsl:apply-templates select="back "/>


		</div-->
	</xsl:template>

	<xsl:template match="back/*" mode="insert-ref-list-in-correct-location">
		<xsl:param name="after"/>
		<xsl:param name="before"/>
		
		<xsl:param name="ref_list"/>
		<xsl:param name="title"/>
		
		<xsl:if test="name()=$before">
			<xsl:apply-templates select="$ref_list">
				<xsl:with-param name="title"><xsl:value-of select="$title"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:if test="name()=$after">
			<xsl:apply-templates select="$ref_list">
				<xsl:with-param name="title"><xsl:value-of select="$title"/></xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="disp-quote">
		<blockquote>
			<xsl:apply-templates select="*|text()"/>
		</blockquote>
	</xsl:template>
	<xsl:template match="ext-link|uri">
		<a href="{@xlink:href}" target="_blank">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	
	<xsl:template match="media">
		<xsl:variable name="relative_path"><xsl:choose><xsl:when test="contains(@xlink:href,'.pdf')">/pdf<xsl:value-of
			select="substring-after($var_IMAGE_PATH,'/img/revistas')"/></xsl:when><xsl:otherwise><xsl:value-of select="$var_IMAGE_PATH"/></xsl:otherwise></xsl:choose></xsl:variable>
		
		<xsl:variable name="src"><xsl:if test="not(contains(@xlink:href,':'))"><xsl:value-of select="$relative_path"/></xsl:if><xsl:value-of
			select="@xlink:href"/></xsl:variable>
		
		<xsl:choose>
			<xsl:when test="contains(@xlink:href,'.pdf')">
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="$src"/></xsl:attribute>
					<xsl:choose>
						<xsl:when test="normalize-space(text())=''"><xsl:value-of select="@xlink:href"/></xsl:when>
						<xsl:otherwise><xsl:apply-templates select="*|text()"></xsl:apply-templates></xsl:otherwise>
					</xsl:choose>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<embed width="100%" height="400">
					<xsl:if test="contains(@xlink:href,'.avi')"><xsl:attribute name="type">video/x-msvideo</xsl:attribute></xsl:if>
					<xsl:attribute name="src"><xsl:value-of select="$src"/></xsl:attribute> 
				</embed>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mml:math|math">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="app-group">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	
	<xsl:template match="app">
		<xsl:if test="@id">
			<a name="{@id}"/>
		</xsl:if>
		<div class="app">
			<xsl:apply-templates select="@*|*|text()"></xsl:apply-templates>
		</div>
	</xsl:template>
	<xsl:template match="app/title | app/label">
		<p class="sec">
			<xsl:apply-templates></xsl:apply-templates>
		</p>
	</xsl:template>
	<xsl:template match="ack">
		<xsl:variable name="lang"><xsl:choose>
			<xsl:when test="$trans"><xsl:value-of select="$trans/@xml:lang"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$original/@xml:lang"/></xsl:otherwise>
		</xsl:choose></xsl:variable>
		<div class="ack">
			<xsl:if test="not(title)"><p class="sec">
				<xsl:choose>
					<xsl:when test="$lang='pt'">Agradecimentos</xsl:when>
					<xsl:when test="$lang='es'">Agradecimientos</xsl:when>
					<xsl:otherwise>Acknowledgements</xsl:otherwise>
				</xsl:choose></p>
			</xsl:if>
			<xsl:apply-templates></xsl:apply-templates>
		</div>
	</xsl:template>
	
	<xsl:template match="supplementary-material|inline-supplementary-material">
		<a name="{@id}"/>
		<xsl:choose>
			<xsl:when test="media">
				<xsl:apply-templates select="label|media"/>
			</xsl:when>
			<xsl:when test="@xlink:href">
				<xsl:variable name="relative_path"><xsl:choose><xsl:when test="contains(@xlink:href,'pdf')">/pdf<xsl:value-of
					select="substring-after($var_IMAGE_PATH,'/img/revistas')"/></xsl:when><xsl:otherwise><xsl:value-of select="$var_IMAGE_PATH"/></xsl:otherwise></xsl:choose></xsl:variable>
				
				<xsl:variable name="src"><xsl:if test="not(contains(@xlink:href,':'))"><xsl:value-of select="$relative_path"/></xsl:if><xsl:value-of
							select="@xlink:href"/></xsl:variable>
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:value-of select="$src"/>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="not(*) and normalize-space(text())=''">
							<xsl:value-of select="@xlink:href"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="*|text()" mode="HTML-TEXT"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="supplementary-material/label">
		<p class="label"><xsl:apply-templates select="*|text()"/></p>
	</xsl:template>
	<xsl:template match="supplementary-material/caption">
		<p class="caption"><xsl:apply-templates select="*|text()"/></p>
	</xsl:template>
	<xsl:template match="supplementary-material//title">
		<span class="caption"><xsl:apply-templates select="*|text()"/></span>
	</xsl:template>
	
	
	<xsl:template match="product">
		<p class="product">
		<xsl:apply-templates select="person-group"/>. <xsl:apply-templates select="source"/>. <xsl:apply-templates select="year"/>. 
		<xsl:apply-templates select="publisher-name"/> (<xsl:apply-templates select="publisher-loc"/>). <xsl:apply-templates select="size"/>. </p>	
	</xsl:template>
	<xsl:template match="product[@product-type='book']">
		<p class="product">
		<xsl:apply-templates select="source"/>. <xsl:apply-templates select="person-group"/>. (<xsl:apply-templates select="year"/>). <xsl:apply-templates select="publisher-loc"/>: 
		<xsl:apply-templates select="publisher-name"/>, <xsl:apply-templates select="year"/>, <xsl:apply-templates select="size"/>. <xsl:apply-templates select="isbn"/>		
		</p>
	</xsl:template>
	<xsl:template match="product/person-group">
		<xsl:apply-templates select="name"/>
	</xsl:template>
	<xsl:template match="product/person-group/name">
		<xsl:if test="position()!=1">; </xsl:if><xsl:apply-templates select="surname"/>, <xsl:apply-templates select="given-names"/>
	</xsl:template>
	<xsl:template match="size">
		<xsl:value-of select="."/>
		<xsl:choose>
			<xsl:when test="@units='pages'">p</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="product/isbn">
		ISBN: <xsl:value-of select="."/>.
	</xsl:template>
	<xsl:template match="product[comment]">
		<p class="product">
		<xsl:apply-templates select="*|text()"/> 
		</p>
	</xsl:template>
	<xsl:template match="product[comment]/*">
		<xsl:variable name="last_char"><xsl:value-of select="substring(.,string-length(.))"/></xsl:variable>
		<xsl:comment><xsl:value-of select="$last_char"/></xsl:comment>
		<xsl:value-of select="."/><xsl:if test="position()!=last() and $last_char!='.'">. </xsl:if> 
	</xsl:template>
	<xsl:template match="product[comment]/person-group">
		<xsl:apply-templates select="name"/>.
	</xsl:template>
	
	<xsl:template match="list-item[label and p]">
		<xsl:apply-templates select="p"/>
	</xsl:template>
	
	<xsl:template match="list-item[label]/p">
		<p>
			<xsl:value-of select="../label"/>. 
			<xsl:apply-templates select="*|text()"/>
		</p>
	</xsl:template>
	<xsl:template match="attrib">
		<xsl:apply-templates select="*|text()"></xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
