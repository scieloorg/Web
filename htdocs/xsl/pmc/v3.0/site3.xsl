<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML">
	<xsl:import href="jpub/main/jpub3-html.xsl"/>
    

    <xsl:variable name="issue_label">
		<xsl:choose>
			<xsl:when test="//ISSUE/@NUM = 'AHEAD'"><xsl:value-of select="substring(//ISSUE/@PUBDATE,1,4)"/>
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

	<xsl:variable name="article_lang"><xsl:value-of select="$xml_article_lang"/></xsl:variable>
	
	<xsl:variable name="display_objects"><xsl:value-of select="$xml_display_objects"/></xsl:variable>
	
	<xsl:template match="article" mode="text-content">
		
			<xsl:apply-templates select=".//article-meta//article-categories"/>
			
			<xsl:apply-templates select=".//article-meta//title-group"/>
			
			<xsl:apply-templates select=".//article-meta//contrib-group"/>
			
			<xsl:apply-templates select=".//article-meta//aff"/>
			
			<xsl:apply-templates select=".//article-meta//abstract"/>
			
			<xsl:apply-templates select=".//article-meta//trans-abstract"/>
			
			<xsl:apply-templates select=".//body"/>
			
			<xsl:apply-templates select=".//back "/>
			
			<div class="foot-notes">
				<xsl:apply-templates select=".//article-meta//history"/>
				
				<xsl:apply-templates select=".//article-meta//author-notes"/>
				
				<xsl:apply-templates select=".//article-meta//permissions"/>
				
			</div>
		
		<!--ToolTips        	****************************************         id e class da primeira div dos tooltips:         ****************************************         '         '<div id="mystickytooltip" class="stickytooltip">         '         -->
		<div id="mystickytooltip" class="stickytooltip">
			<div style="padding:5px">
				<xsl:apply-templates select="*" mode="tooltip"/>
				
			</div>
			<!--Mensagem de instrução,status da miniatura.-->
			<div class="stickystatus"/>
		</div>
	</xsl:template>
	<xsl:template match="@*" mode="labeled">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="@*[.='ppub']" mode="labeled">
		Print
	</xsl:template>
	<xsl:template match="issn" mode="labeled">
		<p class="{name()}">
			<xsl:apply-templates select="@*" mode="labeled"/>
			version ISSN<xsl:value-of select="."/></p>
	</xsl:template>
	<xsl:template match="article-id" mode="labeled">
	</xsl:template>
	<!--xsl:template match="article" mode="text-header">
		<p class="journal-title"><a>
			<xsl:apply-templates select="." mode="journal-link"/>
						<xsl:value-of select=".//journal-meta//journal-title"/></a></p>
		<xsl:apply-templates select=".//journal-meta/issn" mode="labeled"/>
				<p class="bib-strip"><xsl:value-of select=".//journal-meta//abbrev-journal-title"/>&#160;<xsl:value-of select=".//article-meta//volume"/>
			<xsl:if test=".//article-meta/issue">(<xsl:value-of select=".//article-meta/issue"/>)
					</xsl:if>
			:<xsl:value-of select=".//article-meta/fpage"/>
			<xsl:if test=".//article-meta/lpage">
						-<xsl:value-of select=".//article-meta/lpage"/>
					</xsl:if>,<xsl:apply-templates select=".//article-meta/pub-date" mode="bib-strip"/>.</p>
		<p class="doi">http://dx.doi.org/<xsl:value-of select=".//article-meta/article-id[@pub-id-type='doi']"/></p>
	</xsl:template-->
	<xsl:template match="pub-date" mode="bib-strip">
		<xsl:value-of select="season"/><xsl:value-of select="year"/>
	</xsl:template>
	<xsl:template match="article" mode="sections-navegation">
		<div class="nav">
			<ul class="nav-ul">
				<!--Link para o topo da página--><a href="#top">
				<li class="nav-ul-li">TOP</li>
				</a>
				<xsl:apply-templates select=".//article-meta/abstract" mode="sections-navegation"/>
								<!--Lista e cria o link para os títulos de seções no artigo e Referências-->
								<xsl:apply-templates select=".//body/sec/title |.//back/ref-list |.//back/ack/sec/title |.//back/sec/title " mode="sections-navegation"/>
								<xsl:apply-templates select=".//fn-group" mode="sections-navegation"/>
			</ul>
		</div>
	</xsl:template>
	<xsl:template match="article" mode="sections-navegation">
	</xsl:template>
	<xsl:template match="abstract" mode="sections-navegation">
		<xsl:choose>
			<xsl:when test="../trans-abstract">
				<li class="nav-ul-li">
					<xsl:choose>
						<xsl:when test="@xml:lang='pt'">
							<a href="#resumo">RESUMO</a>
						</xsl:when>
						<xsl:when test="@xml:lang='es'">
							<a href="#resumen">RESUMÉN</a>
						</xsl:when>
						<xsl:otherwise>
							<a href="#abstract">ABSTRACT</a>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="../trans-abstract[@xml:lang]" mode="sections-navegation"/>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@xml:lang='pt'">
						<a href="#resumo">
						<li class="nav-ul-li">RESUMO</li>
						</a>
					</xsl:when>
					<xsl:when test="@xml:lang='es'">
						<a href="#resumen">
						<li class="nav-ul-li">RESUMÉN</li>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="#abstract">
						<li class="nav-ul-li">ABSTRACT</li>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="trans-abstract[@xml:lang]" mode="sections-navegation">
		<xsl:choose>
			<xsl:when test="@xml:lang='en'">
				<a href="#abstract">|&#160;ABSTRACT></a>
			</xsl:when>
			<xsl:when test="@xml:lang='pt'">
				<a href="#resumo">|&#160;RESUMO</a>
			</xsl:when>
			<xsl:when test="@xml:lang='es'">
				<a href="#resumen">|&#160;RESUMÉN</a>
			</xsl:when>
			<xsl:otherwise><a href="#{@xml:lang}">|&#160;<xsl:value-of select="@xml:lang"/></a></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="title" mode="sections-navegation">
		<a href="#{.}">
		<li class="nav-ul-li"><xsl:value-of select="."/></li>
		</a>
	</xsl:template>
	<xsl:template match="ref-list" mode="sections-navegation">
		<xsl:choose>
			<xsl:when test="title">
				<a href="#{title}">
				<li class="nav-ul-li"><xsl:value-of select="title"/></li>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="#references">
				<xsl:choose>
					<xsl:when test="$article_lang='pt'">
						<li class="nav-ul-li">REFERENCIAS</li>
					</xsl:when>
					<xsl:when test="$article_lang='es'">
						<li class="nav-ul-li">REFERENCIAS</li>
					</xsl:when>
					<xsl:otherwise>
						<li class="nav-ul-li">REFERENCES</li>
					</xsl:otherwise>
				</xsl:choose>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="fn-group" mode="sections-navegation">
		<a href="#footnotes-nav">
		<xsl:choose>
			<xsl:when test="../../@xml:lang='en'">
				<li class="nav-ul-li">FOOTNOTES</li>
			</xsl:when>
			<xsl:when test="../../@xml:lang='pt'">
				<li class="nav-ul-li">NOTAS DE RODAPÉ</li>
			</xsl:when>
			<xsl:when test="../../@xml:lang='es'">
				<li class="nav-ul-li">NOTAS AL PIE</li>
			</xsl:when>
		</xsl:choose>
		</a>
	</xsl:template>
	<!--Insere o conteúdo para mostrar miniaturas ao se passar o mouse-->
	<xsl:template match="*" mode="tooltip">
		<xsl:apply-templates mode="tooltip-body"/>
				<!--Aplica todo o conteúdo para que apareça em miniatura-->
				<xsl:apply-templates mode="tooltip-tfn"/>
				<!--Aplica todo o conteúdo,mas deve ser criado umnovo mode para as referências cruzadas de tabelas,pois não aparecem duas vezes no mode anterior(tooltip-body)-->
	</xsl:template>
	<!--Elimina o texto desnecessário oculto na página(se esse texto não for eliminado as miniaturas não aparecem)-->
	<xsl:template match="text()" mode="tooltip-body"/>
		<xsl:template match="text()" mode="tooltip-tfn"/>
		<!--Aplica as miniaturas de tabelas-->
	<xsl:template match="table-wrap" mode="tooltip-body">
		<div id="t{@id}" class="atip">
			<div class="xref-tab-tooltip">
				<xsl:apply-templates select="*" mode="tooltip-tab"/>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="supplementary-material" mode="tooltip-body">
		<div id="t{@id}" class="atip">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!--Tabela se estiver como imagem(Miniatura)-->
	<xsl:template match="table-wrap/graphic" mode="tooltip-body">
		<div id="t{@id}" class="atip"><img class="thumbnail"><xsl:apply-templates select="@xlink:href" mode="src"/></img></div>



	</xsl:template>
	<xsl:template match="table" mode="tooltip-tab">
		<table class="tab-tooltip">
			<xsl:apply-templates select="@* | *"/>
		</table>
	</xsl:template>
	<!--Ignora a largura pré-definida da tabela e ajusta de acordo com o necessário para a miniatura-->
	<xsl:template match="table/@width" mode="tooltip-tab"/>
		<xsl:template match="table-wrap-foot/fn" mode="tooltip-tab">
		<p class="fn">
				<xsl:apply-templates select="*"/>
		</p>
	</xsl:template>
	<!--Label e caption de miniatura de tabela-->
	<xsl:template match="table-wrap/label" mode="tooltip-tab">
		<p class="label"><xsl:value-of select="text()"/></p>
	</xsl:template>
	<xsl:template match="caption" mode="tooltip-tab">
		<p class="caption">
			<xsl:apply-templates select="* | text() | @*"/>
		</p>
	</xsl:template>
	<!--Fim de label e caption de miniatura--><!--Aplica as miniaturas das notas das tabelas-->
	<xsl:template match="table-wrap-foot/fn" mode="tooltip-tfn">
		<div class="atip" id="t{@id}">
			<xsl:apply-templates select="* | text()"/>
		</div>
	</xsl:template>
	<!--Aplica as miniaturas das referências--><!--xsl:template match="ref"> 		<p class="ref"> 			<a name="{@id}"> 				 			</a> 		</p> 	</xsl:template-->
	<xsl:template match="back/ref-list" mode="tooltip-body">
		<xsl:apply-templates select="ref" mode="tooltip-body-ref"/>
	</xsl:template>
	<xsl:template match="ref" mode="tooltip-body-ref">
		<div id="t{@id}" class="atip">
			<div class="xref-ref">
				<xsl:if test=".//label">
					<xsl:choose>
					<xsl:when test="mixed-citation">
						<xsl:apply-templates select="mixed-citation"/>			
					</xsl:when>
					<xsl:when test="element-citation">
                        <xsl:apply-templates select="element-citation"/>			
					</xsl:when>
					<xsl:when test="citation">
                        <xsl:apply-templates select="citation"/>			
					</xsl:when>
					<xsl:when test="nlm-citation">
                        <xsl:apply-templates select="nlm-citation"/>			
					</xsl:when>

				</xsl:choose>

				</xsl:if>
				<xsl:if test="not(.//label)">
					<xsl:value-of select="position()"/>.&#160;
				<xsl:choose>
					<xsl:when test="mixed-citation">
                        <xsl:apply-templates select="mixed-citation"/>			
					</xsl:when>
					<xsl:when test="element-citation">
                        <xsl:apply-templates select="element-citation"/>			
					</xsl:when>
					<xsl:when test="citation">
                        <xsl:apply-templates select="citation"/>			
					</xsl:when>
					<xsl:when test="nlm-citation">
                        <xsl:apply-templates select="nlm-citation"/>			
					</xsl:when>

				</xsl:choose>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	
	
	<!--Aplica as miniaturas das notas de autor e afiliações-->
	<xsl:template match="author-notes/fn | aff" mode="tooltip-body">
		<div class="atip" id="t{@id}">
			<div class="xref-autornote">
				<xsl:apply-templates select="* | text()"/>
			</div>
		</div>
	</xsl:template>
	<!--Miniaturas das notas do artigo-->
	<xsl:template match="fn-group/fn" mode="tooltip-body">
		<div class="atip" id="t{@id}">
			<div class="xref-fn">
				<xsl:apply-templates select="*" mode="fn-group"/>
			</div>
		</div>
	</xsl:template>
	<!--Aplica as miniaturas de imagens-->
	<xsl:template match="fig" mode="tooltip-body">
		<div class="atip" id="t{@id}">
			<div class="xref-img">
				<xsl:apply-templates select="@* | * | text()"/>
								<xsl:apply-templates select="graphic" mode="thumbnail"/>
			</div>
		</div>
	</xsl:template>
	<!--Aplica as miniaturas das notas de autor e afiliações-->
	<xsl:template match="author-notes/fn | aff" mode="tooltip-body">
		<div class="atip" id="t{@id}">
			<div class="xref-autornote">
				<xsl:apply-templates select="* | text()"/>
			</div>
		</div>
	</xsl:template>
	<!--Miniaturas das notas do artigo-->
	<xsl:template match="fn-group/fn" mode="tooltip-body">
		<div class="atip" id="t{@id}">
			<div class="xref-fn">
				<xsl:apply-templates select="*" mode="fn-group"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="article-id[@pub-id-type]" mode="display-id">
		<p><xsl:value-of select="@pub-id-type"/>:<xsl:value-of select="."/></p>
	</xsl:template>
	<!--Fim da identificação do artigo--><!--Fim da definição do corpo inteiro da página--><!--     *********************************     Imprime todo o conteúdo da página     *********************************     -->
	<!--xsl:template match="*">
		<xsl:comment>
			<xsl:value-of select="name()"/>
		</xsl:comment>
		<xsl:apply-templates select="* | text()"/>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template-->
	<!--     *********************************     --><!--Define parágrafos,sobrescrito e subscrito             Seleciona o nome da própria tag(xml) e coloca ao seu redor     -->
	<xsl:template match="sub | sup ">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@* | * | text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="p">
		<xsl:choose>
			<xsl:when test="$display_objects = 'false'">
				<xsl:element name="{name()}">
					<xsl:apply-templates select="@* | * | text()"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$display_objects = 'true'">
				<xsl:element name="{name()}">
					<xsl:apply-templates select="@* | * | text()"/>
				</xsl:element>
				<!--xsl:if test=".//@ref-type='fig'">
					<xsl:apply-templates select="..//fig"/>
				</xsl:if-->
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!--Define itálicos e negritos-->
	<xsl:template match="italic">
		<i>
		<xsl:apply-templates select="*|text()"/>
		</i>
	</xsl:template>
	<xsl:template match="bold">
		<b>
		<xsl:apply-templates select="*|text()"/>
		</b>
	</xsl:template>
	<xsl:template match="disp-quote">
		<blockquote>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>
	<!-- inibe -->
	<xsl:template match="article-meta/article-id"/>
		<xsl:template match="article-meta//pub-date"/>
		<xsl:template match="article-meta/fpage"/>
		<xsl:template match="article-meta/lpage"/>
		<xsl:template match="article-meta/volume"/>
		<xsl:template match="article-meta/issue"/>
		<!--Títulos do Artigo-->
	<xsl:template match="title-group/article-title">
		<div>
			<p class="title">
				<xsl:apply-templates select="* | text() "/>
								<xsl:apply-templates select="../subtitle" mode="subtitle"/>
			</p>
		</div>
	</xsl:template>
	<xsl:template match="trans-title-group/trans-title">
		<div>
			<p class="trans-title">
				<xsl:apply-templates select="* | text() "/>
								<xsl:apply-templates select="../trans-subtitle" mode="subtitle"/>
			</p>
		</div>
	</xsl:template>
	<!--Subtitulos do artigo-->
	<xsl:template match="title-group/subtitle | trans-title-group/trans-subtitle" mode="subtitle">
		<span>
		<xsl:apply-templates select="* | text()"/>
		</span>
	</xsl:template>
	<xsl:template match="title-group/subtitle | trans-title-group/trans-subtitle"/>
		<!--Categoria do artigo     	Talvez seja desenecessária essa informação     -->
	<xsl:template match="subj-group/subject">
		<p class="categoria"><xsl:value-of select="."/></p>
	</xsl:template>
	<!--Div contendo nome dos autores-->
	<xsl:template match="contrib-group">
		<div class="autores">
			<xsl:apply-templates select="contrib"/>
		</div>
	</xsl:template>
	<xsl:template match="contrib">
		<xsl:if test="position()!=1">, </xsl:if><xsl:apply-templates select="name"/><xsl:apply-templates select="." mode="xref-list"/>
	</xsl:template>
	<xsl:template match="contrib/name">
		<xsl:apply-templates select="given-names"/>&#160;<xsl:apply-templates select="surname"/>
	</xsl:template>
	
	<xsl:template match="*[xref]" mode="xref-list">
		<sup>
		<xsl:apply-templates select="xref"  mode="xref"/>
		</sup>
	</xsl:template>
	<xsl:template match="xref" mode="xref">
		<xsl:if test="position() &gt; 1">,</xsl:if>
		<a href="#{@rid}" data-tooltip="t{@rid}"><!--FIXME-->
		<xsl:apply-templates select="label|text()"/>
		</a>
		
	</xsl:template>
	<!--Afiliações e notas do autor-->
	<xsl:template match="author-notes">
		<div class="author-note">
			<xsl:apply-templates select="* | text()"/>
		</div>
		<div class="fn-author">
			<xsl:apply-templates select="fn" mode="fn-author"/>
		</div>
	</xsl:template>
	<xsl:template match="author-notes/corresp">
		<p class="corresp">
			<xsl:apply-templates select="* | text() | @*"/>
		</p>
	</xsl:template>
	<xsl:template match="author-notes/fn" mode="fn-author">
		<p class="fn-author-p"><a name="{@id}">
			<xsl:apply-templates select="* | text()"/>
			</a></p>
	</xsl:template>
	<xsl:template match="author-notes/fn"/>
		<xsl:template match="fn/label">
		<sup>
			<xsl:apply-templates select="* | text()"/>
		</sup>
	</xsl:template>
	<xsl:template match="author-notes/fn/p">
		<xsl:apply-templates select="* | text()"/>
	</xsl:template>
	<xsl:template match="aff">
		<p class="aff"><a name="aff{@id}">
			<xsl:apply-templates select="label"/>
			</a>
			<xsl:apply-templates select="institution[@content-type='orgdiv3']"/><xsl:if test="institution[@content-type='orgdiv3']">, </xsl:if>
			<xsl:apply-templates select="institution[@content-type='orgdiv2']"/><xsl:if test="institution[@content-type='orgdiv2']">, </xsl:if>
			<xsl:apply-templates select="institution[@content-type='orgdiv1']"/><xsl:if test="institution[@content-type='orgdiv1']">, </xsl:if>
			<xsl:apply-templates select="institution[@content-type='orgname']"/>
			</p>
	</xsl:template>
	<xsl:template match="aff/label">
		<sup><xsl:value-of select="."/></sup>
	</xsl:template>
	<!--     *****     Email     **********************************************************************************     Nota:Se houver algum e-mail no resto do artigo também serpa aplicado este template     **********************************************************************************     -->
	<xsl:template match="email">
		<a href="mailto:{text()}"><xsl:value-of select="."/></a>
	</xsl:template>
	<xsl:template match="email" mode="element-content">
		&#160;<a href="mailto:{text()}"><xsl:value-of select="."/></a>
	</xsl:template>
	<xsl:template match="email" mode="mixed-content">
		<a href="mailto:{text()}"><xsl:value-of select="."/></a>
	</xsl:template>
	<!--Fim de Notas de autor--><!--Recebido e aceito-->
	<xsl:template match="history">
		<!--xsl:variable name="lang" select="@xml:lang"/> 		<xsl:apply-templates select="../kwd-group[@xml:lang=$lang]" mode="keywords-with-abstract" /-->
		<div class="recebido">
			<p>
				<xsl:choose>
					<xsl:when test="$article_lang='en'">
						<xsl:apply-templates select="date" mode="en"/>
					</xsl:when>
					<xsl:when test="$article_lang='pt'">
						<xsl:apply-templates select="date" mode="pt"/>
					</xsl:when>
					<xsl:when test="$article_lang='es'">
						<xsl:apply-templates select="date" mode="es"/>
					</xsl:when>
				</xsl:choose>
			</p>
		</div>
	</xsl:template>
	<!--     *********************************************************     Recebido e aceito quando o idioma do artigo for em INGLÊS     *********************************************************     -->
	<xsl:template match="date" mode="en">
		<xsl:choose>
			<xsl:when test="@date-type='received'">
				Received
			</xsl:when>
			<xsl:when test="@date-type='accepted'">
				Accepted
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="month" mode="date-month-en"/>
				<xsl:apply-templates select="day" mode="date-day-en"/>
				<xsl:apply-templates select="*"/>
				<xsl:choose>
			<xsl:when test="@date-type='received'">;</xsl:when>
			<xsl:when test="@date-type='accepted'">.</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="month" mode="date-month-en">
		<xsl:choose>
			<xsl:when test="text() = 01">
				January
			</xsl:when>
			<xsl:when test="text() = 02">
				February
			</xsl:when>
			<xsl:when test="text() = 03">
				March
			</xsl:when>
			<xsl:when test="text() = 04">
				April
			</xsl:when>
			<xsl:when test="text() = 05">
				May
			</xsl:when>
			<xsl:when test="text() = 06">
				June
			</xsl:when>
			<xsl:when test="text() = 07">
				July
			</xsl:when>
			<xsl:when test="text() = 08">
				August
			</xsl:when>
			<xsl:when test="text() = 09">
				September
			</xsl:when>
			<xsl:when test="text() = 10">
				October
			</xsl:when>
			<xsl:when test="text() = 11">
				November
			</xsl:when>
			<xsl:when test="text() = 12">
				December
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="day" mode="date-day-en">
		<xsl:choose>
			<xsl:when test="text() = 01">
				1,</xsl:when>
			<xsl:when test="text() = 02">
				2,</xsl:when>
			<xsl:when test="text() = 03">
				3,</xsl:when>
			<xsl:when test="text() = 04">
				4,</xsl:when>
			<xsl:when test="text() = 05">
				5,</xsl:when>
			<xsl:when test="text() = 06">
				6,</xsl:when>
			<xsl:when test="text() = 07">
				7,</xsl:when>
			<xsl:when test="text() = 08">
				8,</xsl:when>
			<xsl:when test="text() = 09">
				9,</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>,</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--     ******************************************     fim de recebido e aceito em idioma 	INGLES     ******************************************     --><!--     ************************************************************     Recebido e aceito quando o idioma do artigo for em PORGUGUÊS     ************************************************************     -->
	<xsl:template match="date" mode="pt">
		<xsl:choose>
			<xsl:when test="@date-type='received'">
				Recebido em
			</xsl:when>
			<xsl:when test="@date-type='accepted'">
				Aceito em
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="*" mode="date-pt"/>
				<xsl:choose>
			<xsl:when test="@date-type='received'">;</xsl:when>
			<xsl:when test="@date-type='accepted'">.</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="month" mode="date-pt">
		<xsl:choose>
			<xsl:when test="text() = 01">
				Janeiro
			</xsl:when>
			<xsl:when test="text() = 02">
				Fevereiro
			</xsl:when>
			<xsl:when test="text() = 03">
				Março
			</xsl:when>
			<xsl:when test="text() = 04">
				Abril
			</xsl:when>
			<xsl:when test="text() = 05">
				Maio
			</xsl:when>
			<xsl:when test="text() = 06">
				Junho
			</xsl:when>
			<xsl:when test="text() = 07">
				Julho
			</xsl:when>
			<xsl:when test="text() = 08">
				Agosto
			</xsl:when>
			<xsl:when test="text() = 09">
				Setembro
			</xsl:when>
			<xsl:when test="text() = 10">
				Outubro
			</xsl:when>
			<xsl:when test="text() = 11">
				Novembro
			</xsl:when>
			<xsl:when test="text() = 12">
				Dezembro
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="day" mode="date-pt">
		<xsl:choose>
			<xsl:when test="text() = 01">
				1 de
			</xsl:when>
			<xsl:when test="text() = 02">
				2 de
			</xsl:when>
			<xsl:when test="text() = 03">
				3 de
			</xsl:when>
			<xsl:when test="text() = 04">
				4 de
			</xsl:when>
			<xsl:when test="text() = 05">
				5 de
			</xsl:when>
			<xsl:when test="text() = 06">
				6 de
			</xsl:when>
			<xsl:when test="text() = 07">
				7 de
			</xsl:when>
			<xsl:when test="text() = 08">
				8 de
			</xsl:when>
			<xsl:when test="text() = 09">
				9 de
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>de
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="year" mode="date-pt">
		de<xsl:value-of select="."/>
	</xsl:template>
	<!--     *********************************************     fim de recebido e aceito em idioma 	PORTUGUES     *********************************************     --><!--     ***********************************************************     Recebido e aceito quando o idioma do artigo for em ESPANHOL     ***********************************************************     -->
	<xsl:template match="date" mode="es">
		<xsl:choose>
			<xsl:when test="@date-type='received'">
				Recebido el
			</xsl:when>
			<xsl:when test="@date-type='accepted'">
				Aceptado el
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="*" mode="date-es"/>
				<xsl:choose>
			<xsl:when test="@date-type='received'">;</xsl:when>
			<xsl:when test="@date-type='accepted'">.</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="month" mode="date-es">
		<xsl:choose>
			<xsl:when test="text() = 01">
				enero
			</xsl:when>
			<xsl:when test="text() = 02">
				febrero
			</xsl:when>
			<xsl:when test="text() = 03">
				marzo
			</xsl:when>
			<xsl:when test="text() = 04">
				abril
			</xsl:when>
			<xsl:when test="text() = 05">
				mayo
			</xsl:when>
			<xsl:when test="text() = 06">
				junio
			</xsl:when>
			<xsl:when test="text() = 07">
				julio
			</xsl:when>
			<xsl:when test="text() = 08">
				agosto
			</xsl:when>
			<xsl:when test="text() = 09">
				septiembre
			</xsl:when>
			<xsl:when test="text() = 10">
				octubre
			</xsl:when>
			<xsl:when test="text() = 11">
				noviembre
			</xsl:when>
			<xsl:when test="text() = 12">
				diciembre
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="day" mode="date-es">
		<xsl:choose>
			<xsl:when test="text() = 01">
				1 de
			</xsl:when>
			<xsl:when test="text() = 02">
				2 de
			</xsl:when>
			<xsl:when test="text() = 03">
				3 de
			</xsl:when>
			<xsl:when test="text() = 04">
				4 de
			</xsl:when>
			<xsl:when test="text() = 05">
				5 de
			</xsl:when>
			<xsl:when test="text() = 06">
				6 de
			</xsl:when>
			<xsl:when test="text() = 07">
				7 de
			</xsl:when>
			<xsl:when test="text() = 08">
				8 de
			</xsl:when>
			<xsl:when test="text() = 09">
				9 de
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>de
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="year" mode="date-es">
		de<xsl:value-of select="."/>
	</xsl:template>
	<!--     ********************************************     fim de recebido e aceito em idioma 	ESPANHOL     ********************************************     -->
	<xsl:template match="month"/>
		<xsl:template match="date/day"/>
		<!--Licenças-->
	<xsl:template match="license-p">
		<div>
			<p class="lic"><xsl:value-of select="text() |  @*"/></p>
		</div>
	</xsl:template>
	<!--Resumos-->
	<xsl:template match="abstract | trans-abstract">
		<xsl:variable name="lang" select="@xml:lang"/>
		<div class="resumo"><!--Apresenta o título da seção conforme a lingua existente-->
			<xsl:choose>
				<xsl:when test="$lang='pt'">
					<p class="sec"><a name="resumo">RESUMO</a></p>
				</xsl:when>
				<xsl:when test="$lang='es'">
					<p class="sec"><a name="resumen">RESUMÉN</a></p>
				</xsl:when>
				<xsl:otherwise>
					<p class="sec"><a name="abstract">ABSTRACT</a></p>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="* | text()"/>
						<xsl:apply-templates select="..//kwd-group[normalize-space(@xml:lang)=normalize-space($lang)]" mode="keywords-with-abstract"/>
		</div>
	</xsl:template>
	<!--Lilsta as palavras chave dentro de Abstract-->
	<xsl:template match="@* | text()" mode="debug">
		|<xsl:value-of select="."/>|
	</xsl:template>
	<!--Lilsta as palavras chave dentro de Abstract-->
	<xsl:template match="kwd-group" mode="keywords-with-abstract">
		<xsl:variable name="lang" select="normalize-space(@xml:lang)"/>
		<!--xsl:param name="test" select="1"/>     <xsl:value-of select="$test"/-->
		<p><!--Define o nome a ser exibido a frente das palavras-chave conforme o idioma-->
			<xsl:choose>
				<xsl:when test="$lang='es'">
					<b>Palabras-clave: </b>
				</xsl:when>
				<xsl:when test="$lang='pt'">
					<b>Palavras-Chave: </b>
				</xsl:when>
				<xsl:otherwise>
					<b>Keywords: </b>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select=".//kwd"/>
		</p>
	</xsl:template>
	<xsl:template match="kwd-group"/>
		<!--Adiciona vírgulas as palavras-chave-->
	<xsl:template match="kwd">
		<xsl:if test="position()!= 1">, </xsl:if> 
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="body/sec | ack/sec">
		<div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!--Exibe o título das seções classe 'sec' no css-->
	<xsl:template match="body/sec/title | ack/sec/title | back/sec/title">
		<p class="sec"><a name="{.}">
			<xsl:apply-templates select="@* | * | text()"/>
			</a></p>
	</xsl:template>
	<!--Exibe uma subseção dos artigos-->
	<xsl:template match="body/sec/sec/title | abstract/sec/title |trans-abstract/sec/title">
		<p class="subsec">
			<xsl:apply-templates select="@* | * | text()"/>
		</p>
	</xsl:template>
	<!--Exibe uma subseção de terceiro nível-->
	<xsl:template match="body/sec/sec/sec/title">
		<p class="sub-subsec">
			<xsl:apply-templates select="@* | * | text()"/>
		</p>
	</xsl:template>
	<!--Imagens e referências cruzadas entre as mesmas-->
	<xsl:template match="supplementary-material">
		<div class="xref-img"><a name="{@id}">
			<xsl:apply-templates/>
			</a></div>
	</xsl:template>
	<xsl:template match="fig">
		<div class="figure"><a name="{@id}"></a>
		    <xsl:apply-templates select="graphic"/>
			<div class="label_caption">
			    <xsl:apply-templates select="label"/><xsl:if test="label and caption"> - <xsl:apply-templates select="caption"/>
			     </xsl:if>
		    </div>
			
		</div>
	</xsl:template>
	<xsl:template match="caption/title | caption/title ">
		<xsl:apply-templates select="*|text()"/>
	</xsl:template>
	<xsl:template match="fig/label | table-wrap/label">
		<span class="label"><xsl:apply-templates select="* | text()"/></span>
	</xsl:template>
	<xsl:template match="fig/caption | table-wrap/caption">
		<span class="caption"><xsl:apply-templates select="* | text()"/></span>
	</xsl:template>
	<xsl:template match="graphic">
		<img class="graphic"><xsl:apply-templates select="@xlink:href" mode="src"/></img>		
	</xsl:template>
	<xsl:template match="graphic" mode="thumbnail">
		<img class="thumbnail"><xsl:apply-templates select="@xlink:href" mode="src"/></img>		
	</xsl:template>
	<!--Tabelas-->
	<xsl:template match="table-wrap">
		<div class="xref-tab">
			<div class="label_caption">
			    <xsl:apply-templates select="label"/><xsl:if test="label and caption"> - <xsl:apply-templates select="caption"/>
			     </xsl:if>
		    </div>
		    <xsl:apply-templates select="table | graphic"/>
		</div>
	</xsl:template>
	<!--Tabela se estiver como imagem-->
	<xsl:template match="table-wrap/graphic">
		<img class="graphic"><xsl:apply-templates select="@xlink:href" mode="src"/></img>
	</xsl:template>

	<xsl:template match="@href" mode="src">
        <xsl:variable name="src"><xsl:value-of select="$var_IMAGE_PATH"/>/<xsl:choose><xsl:when test="contains(., '.tif')"><xsl:value-of select="substring-before(.,'.tif')"/></xsl:when><xsl:otherwise><xsl:value-of select="."/></xsl:otherwise></xsl:choose></xsl:variable>
        <xsl:attribute name="src"><xsl:value-of select="$src"/>.jpg</xsl:attribute>
	</xsl:template>
	<!--Tabela codificada-->
	<xsl:template match="table"><div class="table">
		<xsl:copy-of select="."/></div>
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
		<td><xsl:apply-templates select="@* | *| text()"/>
		</td>
	</xsl:template>
	<xsl:template match="th">
		<th><xsl:apply-templates select="@* | *| text()"/>
		</th>
	</xsl:template>
	
	<xsl:template match="table-wrap-foot/fn">
		<p class="fn"><a name="{@id}">
			<xsl:apply-templates select="* | text()"/>
			</a></p>
	</xsl:template>
	<xsl:template match="table-wrap-foot/fn/p">
		<xsl:apply-templates/>
	</xsl:template>
	<!--Fim dos labels e captions--><!--SigBlock--><!--sig-block>             <sig>Joel <bold>FAINTUCH</bold>                 <sup>1</sup>             </sig>             <sig>Ricardo Guilherme <bold>VIEBIG</bold>                 <sup>2</sup>             </sig> 		</sig-block-->
	<xsl:template match="sig-block">
		<xsl:apply-templates select="* | text()"/>
	</xsl:template>
	<xsl:template match="sig">
		<p class="sig">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="sig/bold">
		<b>&#160;
		<xsl:apply-templates/>
		</b>
	</xsl:template>
	<!--Listas--><!--Bullet sem estilo-->
	<xsl:template match="p/list[@list-type='simple']">
		<ul class="list-none">
			<xsl:apply-templates select="list-item/p"/>
		</ul>
	</xsl:template>
	<!--Lista Bullet Normal(Com marcador na frente)-->
	<xsl:template match="p/list[@list-type='bullet']">
		<ul>
			<xsl:apply-templates select="list-item/p"/>
		</ul>
	</xsl:template>
	<!--Lista ordenada em letras maiúsculas-->
	<xsl:template match="p/list[@list-type='alpha-upper']">
		<ol type="A">
			<xsl:apply-templates select="list-item/p"/>
		</ol>
	</xsl:template>
	<!--Lista ordana em letras minúsculas-->
	<xsl:template match="p/list[@list-type='alpha-lower']">
		<ol type="a">
			<xsl:apply-templates select="list-item/p"/>
		</ol>
	</xsl:template>
	<!--Lista numerada-->
	<xsl:template match="p/list[@list-type='order']">
		<ol>
			<xsl:apply-templates select="list-item/p"/>
		</ol>
	</xsl:template>
	<xsl:template match="list-item/p">
		<li>
			<xsl:apply-templates select="* | text()"/>
		</li>
	</xsl:template>
	<!--     *****************************     Referências     *****************************     --><!--Define referências-->
	<xsl:template match=" back/ref-list">
		<div>
			<xsl:choose>
				<xsl:when test="title">
					<p class="sec">
						<xsl:apply-templates select="title" mode="reflist-title"/>
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p class="sec"><a name="references">
						<xsl:choose>
							<xsl:when test="$article_lang='pt'">
								REFERÊNCIAS
							</xsl:when>
							<xsl:when test="$article_lang='es'">
								REFERENCIAS
							</xsl:when>
							<xsl:otherwise>
								REFERENCES
							</xsl:otherwise>
						</xsl:choose>
						</a></p>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="ref"/>
		</div>
	</xsl:template>
	<xsl:template match="ref-list/title"/>
		<xsl:template match="ref-list/title" mode="reflist-title">
		<a name="{.}"><xsl:value-of select="."/></a>
	</xsl:template>
	<xsl:template match="ref">
		<p class="ref">
			<a name="{@id}"><!--Imprime o label das referências-->
			<xsl:if test=".//label">
					<xsl:choose>
					<xsl:when test="mixed-citation">
						<xsl:apply-templates select="mixed-citation"/>			
					</xsl:when>
					<xsl:when test="element-citation">
                        <xsl:apply-templates select="element-citation"/>			
					</xsl:when>
					<xsl:when test="citation">
                        <xsl:apply-templates select="citation"/>			
					</xsl:when>
					<xsl:when test="nlm-citation">
                        <xsl:apply-templates select="nlm-citation"/>			
					</xsl:when>

				</xsl:choose>

				</xsl:if>
				<xsl:if test="not(.//label)">
					<xsl:value-of select="position()"/>.&#160;
				<xsl:choose>
					<xsl:when test="mixed-citation">
                        <xsl:apply-templates select="mixed-citation"/>			
					</xsl:when>
					<xsl:when test="element-citation">
                        <xsl:apply-templates select="element-citation"/>			
					</xsl:when>
					<xsl:when test="citation">
                        <xsl:apply-templates select="citation"/>			
					</xsl:when>
					<xsl:when test="nlm-citation">
                        <xsl:apply-templates select="nlm-citation"/>			
					</xsl:when>

				</xsl:choose>
				</xsl:if>
			</a>
		</p>
	</xsl:template>
	<!--mixed-citation-->
	<xsl:template match="mixed-citation">
		<xsl:apply-templates select="* | text()" mode="mixed-content"/>
	</xsl:template>
	<xsl:template match="name" mode="mixed-content">
		<xsl:apply-templates select="surname"/>&#160;<xsl:apply-templates select="given-names"/>
		<xsl:if test="suffix">&#160;<xsl:apply-templates select="suffix"/></xsl:if>
	</xsl:template>
	<!--element-citation e citation-->
	<xsl:template match="text()" mode="element-content">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
	<xsl:template match="element-citation | citation">
		<xsl:choose>
			<xsl:when test="name">
				<xsl:apply-templates select="." mode="name-element-citation"/>
				<xsl:apply-templates select="*[name()!='name']" mode="element-content"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*" mode="element-content"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--Lista de autores,tanto mixed como element citation--><!--xsl:template match="person-group" mode="mixed-content"> 		<xsl:apply-templates select="name | collab" mode="list-author-ref"/>     </xsl:template-->
	<xsl:template match="element-citation" mode="name-element-citation">
		<xsl:apply-templates select="name" mode="element-content"/>
	</xsl:template>
	<xsl:template match="person-group" mode="element-content">
		<xsl:apply-templates select="*" mode="element-content"/>
	</xsl:template>
	<xsl:template match="name" mode="element-content">
		<span class="ref-autor">
		<xsl:if test="position() &gt; 1">, </xsl:if>
		<xsl:apply-templates select="surname"/>&#160;<xsl:apply-templates select="given-names"/>
		<xsl:if test="suffix">&#160;<xsl:apply-templates select="suffix"/></xsl:if>
		<xsl:if test="position() = last()">
			<xsl:choose>
				<xsl:when test="..//etal"/>
				<xsl:when test="../@person-group-type='transed'">,translator and editor.</xsl:when>
				<xsl:when test="../@person-group-type != 'author'">
					<xsl:choose>
						<xsl:when test="position() = 1 and position() = last()">, <xsl:value-of select="../@person-group-type"/>.
						</xsl:when>
						<xsl:otherwise>,<xsl:value-of select="../@person-group-type"/>s.</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		</span>
	</xsl:template>
	<xsl:template match="collab" mode="element-content">
		<span class="ref-autor">
		<xsl:if test="position() &gt; 1">;
		</xsl:if>
		<xsl:apply-templates select="* | text()"/>
				<xsl:if test="@collab-type">
			<xsl:choose>
						<xsl:when test="position() = 1 and position() = last()">,<xsl:value-of select="@collab-type"/>
				</xsl:when>
						<xsl:otherwise>,<xsl:value-of select="@collab-type"/>s
				</xsl:otherwise>
					</xsl:choose>
		</xsl:if>
		<xsl:if test="position() = last()">
			<xsl:choose>
				<xsl:when test="..//etal">
					<xsl:apply-templates select="etal"/>
				</xsl:when>
				<xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		</span>
	</xsl:template>
	<xsl:template match="string-name" mode="element-content">
		<span class="ref-autor">
		<xsl:if test="position() &gt; 1">;
		</xsl:if>
		<xsl:apply-templates select="* | text()"/>
				<xsl:if test="suffix">
			&#160;
			<xsl:apply-templates select="suffix"/>
				</xsl:if>
		<xsl:if test="position() = last()">
			<xsl:choose>
				<xsl:when test="..//etal">
					<xsl:apply-templates select="etal"/>
				</xsl:when>
				<xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		</span>
	</xsl:template>
	<xsl:template match="aff" mode="element-content">(<xsl:apply-templates/>
		)
	</xsl:template>
	<xsl:template match="article-title | chapter-title" mode="element-content">
		<span class="ref-title">&#160;
		<xsl:apply-templates/>
			<xsl:choose>
				<xsl:when test="../trans-title"/>
				<xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template match="trans-title | trans-source" mode="element-content">
		<span class="ref-title-t">
		<xsl:choose>
			<xsl:when test="contains(.,'[')">&#160;
				<xsl:apply-templates/>.</xsl:when>
			<xsl:otherwise>&#160;[
				<xsl:apply-templates/>
				].
			</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template match="source" mode="element-content">
		<span class="ref-source">&#160;
		<xsl:apply-templates/>
				<xsl:choose>
			<xsl:when test="../@publication-type='confproc'">
						<xsl:choose>
					<xsl:when test="../conf-name">.</xsl:when>
					<xsl:when test="../conf-loc |../conf-date">;</xsl:when>
				</xsl:choose>
					</xsl:when>
			<xsl:when test="../@publication-type='journal'">
						<xsl:choose>
							<xsl:when test="../edition |../trans-source"/>
														<xsl:otherwise>.</xsl:otherwise>
				</xsl:choose>
					</xsl:when>
			<xsl:when test="../@publication-type='patent'"/>
										<xsl:otherwise>.</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template match="patent" mode="element-content">
		&#160;<xsl:value-of select="."/>.
	</xsl:template>
	<xsl:template match="edition" mode="element-content">
		<xsl:choose>
			<xsl:when test="../@publication-type='journal' |../@publication-type='newspaper' |../@citation-type='journal' |../@citation-type='newspaper'">(<xsl:apply-templates/>
				).
			</xsl:when>
			<xsl:when test="../@publication-type='book' |../@publication-type='report' |../@citation-type='book' |../@citation-type='report'">&#160;
				<xsl:apply-templates/>.</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="publisher-loc" mode="element-content">
		<xsl:choose>
			<xsl:when test="../@publication-type='journal'">(<xsl:apply-templates/>
				).
			</xsl:when>
			<xsl:when test="../@publication-type='book'">&#160;
				<xsl:apply-templates/>
				:
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="publisher-name" mode="element-content">&#160;<xsl:apply-templates/>
		;
	</xsl:template>
	<xsl:template match="conf-name" mode="element-content">&#160;<xsl:apply-templates/>
				<xsl:choose>
			<xsl:when test="../conf-date | conf-loc">;</xsl:when>
			<xsl:otherwise>.</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="conf-date" mode="element-content">&#160;<xsl:apply-templates/>
				<xsl:choose>
			<xsl:when test="../conf-loc">;</xsl:when>
			<xsl:otherwise>.</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="conf-loc" mode="element-content">&#160;<xsl:apply-templates/>.</xsl:template>
	<xsl:template match="year" mode="element-content">
		<span class="data">&#160;
		<xsl:apply-templates/>
				<xsl:choose>
			<xsl:when test="../month |../day |../season">&#160;</xsl:when>
			<xsl:when test="../size[@units='page']">.</xsl:when>
			<xsl:otherwise>;</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template match="month" mode="element-content">
		<span class="data">
		<xsl:apply-templates/>
				<xsl:choose>
			<xsl:when test="../day |../season ">&#160;</xsl:when>
			<xsl:when test="../volume |../issue | issue-part |../supplement">;</xsl:when>
			<xsl:when test="../size[@units='page']">.</xsl:when>
			<xsl:otherwise>:</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template match="day | season" mode="element-content">
		<xsl:apply-templates/>
				<xsl:choose>
			<xsl:when test="../size[@units='page']">.</xsl:when>
			<xsl:otherwise>;</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="volume" mode="element-content">
		<span class="data">
		<xsl:apply-templates/>
				<xsl:choose>
					<xsl:when test="../issue |../supplement"/>
										<xsl:otherwise>:</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template match="issue" mode="element-content">
		<span class="data">
		<xsl:choose>
			<xsl:when test="../issue-title">(<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>(<xsl:apply-templates/>):</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template match="issue-part" mode="element-content">(<xsl:apply-templates/>):</xsl:template>
	<xsl:template match="issue-title" mode="element-content">&#160;<xsl:apply-templates/>):</xsl:template>
	<xsl:template match="supplement" mode="element-content">&#160;<xsl:apply-templates/>
				<xsl:choose>
			<xsl:when test="../fpage |../lpage">:</xsl:when>
			<xsl:otherwise/>
				</xsl:choose>
	</xsl:template>
	<xsl:template match="fpage" mode="element-content">
		<xsl:choose>
			<xsl:when test="../page-range"/>
						<xsl:otherwise>
				<span class="data"><xsl:value-of select="."/></span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="lpage" mode="element-content">
		<xsl:choose>
			<xsl:when test="../page-range"/>
						<xsl:when test="../fpage =.">.</xsl:when>
			<xsl:otherwise>
				<span class="data">-<xsl:value-of select="."/>.</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="page-range" mode="element-content">
		<span class="data"><xsl:value-of select="."/>.</span>
	</xsl:template>
	<xsl:template match="size" mode="element-content">
		&#160;<xsl:value-of select="."/>.
	</xsl:template>
	<xsl:template match="series" mode="element-content">
		<span class="data">&#160;(<xsl:value-of select="."/>).</span>
	</xsl:template>
	<xsl:template match="date-in-citation" mode="element-content">
		<xsl:choose>
			<xsl:when test="@content-type='epub'">&#160;
				<xsl:apply-templates/>.</xsl:when>
			<xsl:otherwise>
				[
				<xsl:apply-templates/>
				];
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="etal" mode="element-content">
		&#160;<i>et al.</i>
	</xsl:template>
	<xsl:template match="comment" mode="element-content">&#160;<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="isbn" mode="element-content">
		&#160;ISBN:<xsl:value-of select="."/>.
	</xsl:template>
	<xsl:template match="uri">
		&#160;<a href="{.}" target="_blank"><xsl:value-of select="."/></a>
	</xsl:template>
	<xsl:template match="ext-link" mode="mixed-content">
		<a href="{@xlink:href}" target="_blank">
		<xsl:apply-templates/>
		</a>
	</xsl:template>
	<xsl:template match="uri" mode="mixed-content">
		<a href="{.}"><xsl:value-of select="."/></a>
	</xsl:template>
	<xsl:template match="pub-id" mode="element-content">
		<xsl:choose>
			<xsl:when test="@pub-id-type='pmid'">&#160;PMID<a href="http://www.ncbi.nlm.nih.gov/pubmed/{normalize-space(.)}" target="_blank"><xsl:value-of select="."/></a>
			</xsl:when>
			<xsl:when test="@pub-id-type='doi'">&#160;doi:<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>&#160;<xsl:value-of select="."/>.
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="pub-id" mode="mixed-content">
		<xsl:choose>
			<xsl:when test="@pub-id-type='pmid'">&#160;PMID<a href="http://www.ncbi.nlm.nih.gov/pubmed/{normalize-space(.)}" target="_blank"><xsl:value-of select="."/></a>
			</xsl:when>
			<xsl:when test="@pub-id-type='doi'">&#160;doi:<xsl:value-of select="."/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--   Fim das referências 3.0   --><!--     ************************************     Referências na versão citation (2.?)     ************************************     --><!--     **********************     Fim de referências 2.?     **********************     --><!--Notas do Artigo [foot notes]-->
	<xsl:template match="fn-group">
		<div><a name="footnotes-nav">
			<xsl:choose>
				<!--Exibição das notas para o artigo para título em inglês-->
				<xsl:when test="../../@xml:lang='en'">
					<p class="sec">Footnotes</p>
				</xsl:when>
				<!--Exibição para artigo em português-->
				<xsl:when test="../../@xml:lang='pt'">
					<p class="sec">Notas de Rodapé</p>
				</xsl:when>
				<!--Exibição para artigo em espanhol-->
				<xsl:when test="../../@xml:lang='es'">
					<p class="sec">Notas al pie</p>
				</xsl:when>
			</xsl:choose>
			</a>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="fn-group/fn">
		<a name="{@id}">
		<p class="a">
			<xsl:apply-templates select="*" mode="fn-group"/>
		</p>
		</a>
	</xsl:template>
	<xsl:template match="fn-group/fn[@fn-type='supplementary-material']/label" mode="fn-group">
		<sup><xsl:value-of select="."/></sup>
	</xsl:template>
	<xsl:template match="ext-link">
		<a href="{@xlink:href}" target="_blank"><xsl:value-of select="text()"/></a>
	</xsl:template>
	<xsl:template match="xref">
		<xsl:if test="text()!='' or label">
            <sup>
            	<a href="#{@rid}" data-tooltip="t{@rid}">
				    <xsl:apply-templates select=".//text()"/>
				</a>
			</sup>
		</xsl:if>
	</xsl:template>

    <xsl:template match="ack//title">
    	<p class="subsec">
            	<xsl:apply-templates select="*|text()"/></p>
    </xsl:template>

    <xsl:template match="ack">
        <xsl:if test="not(.//title)">
            <p class="subsec">
            	Acknowledgements</p>
            </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
