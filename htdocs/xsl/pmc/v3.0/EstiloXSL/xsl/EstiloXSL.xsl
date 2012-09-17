<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet  [
	<!ENTITY nbsp   "&#160;">
	<!ENTITY copy   "&#169;">
	<!ENTITY reg    "&#174;">
	<!ENTITY trade  "&#8482;">
	<!ENTITY mdash  "&#8212;">
	<!ENTITY ldquo  "&#8220;">
	<!ENTITY rdquo  "&#8221;"> 
	<!ENTITY pound  "&#163;">
	<!ENTITY yen    "&#165;">
	<!ENTITY euro   "&#8364;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
							  xmlns:xlink="http://www.w3.org/1999/xlink"
         					  xmlns:mml="http://www.w3.org/1998/Math/MathML">
<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

	<!--
    A folha de estilos está configurada para que o xml e suas imagens estejam nas mesmas pastas e dentro delas uma pasta "css" contendo o arquivo "EstiloXML.css" e uma pasta "xsl" contendo o arquivo "EstiloXSL.xsl"
    -->

    <!--Define corpo da página
    	Nota: O título e a identificação da revista está inserço aqui
    -->
		<xsl:template match="/">
        	
        	<html><head>
                	<!--http://www.dynamicdrive.com/dynamicindex5/stickytooltip.htm-->
                	<script type="text/javascript" src="js/jquery.min.js"></script>
					<script type="text/javascript" src="js/stickytooltip.js">
                    /***********************************************
                    * Sticky Tooltip script- (c) Dynamic Drive DHTML code library (www.dynamicdrive.com)
                    * This notice MUST stay intact for legal use
                    * Visit Dynamic Drive at http://www.dynamicdrive.com/ for this script and 100s more
                    ***********************************************/
                    </script>
                    <script type="text/javascript" src="../js/executartooltip.js"></script>
                   	
                    <script type="text/javascript">
						function menu(id){
							/*this.location = "#" + anc;*/
							document.getElementById(id).className = "select";
						}
						
						
					
					
					</script>
                   
                    <link rel="stylesheet" type="text/css" href="css/EstiloXML.css" />
                    
                    <title>
                    	<xsl:apply-templates select="article/front/journal-meta/journal-id" />
						<xsl:apply-templates select="article/front/article-meta/volume" mode="id-vol"/>
                        <xsl:apply-templates select="article/front/article-meta/issue" mode="id-issue"/>
                        <xsl:apply-templates select="article/front/article-meta/fpage" mode="id-fp"/>
                        <xsl:apply-templates select="article/front/article-meta/lpage" mode="id-lp"/>.
                    </title>
                </head>
                <body>
                <!--Menu de Navegação a esqurda-->
				<div id="nav">
                	<ul id="nav">
                    	<!--Link para o topo da página-->
                    	<a href="#top"><li>TOP</li></a>
                        <xsl:for-each select="article/front/article-meta/abstract | article/front/article-meta/trans-abstract">
                        	<xsl:choose>
                              <xsl:when test="@xml:lang='en'">
                                  <a href="#abstract">
                                  	<li>
                                  		ABSTRACT
                                  	</li>
                                  </a>
                              </xsl:when>
                              <xsl:when test="@xml:lang='pt'">
                              		<a href="#resumo">
                                      <li>
                                        RESUMO
                                      </li>
                                    </a>
                              </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                        
                        
                        
                        <!--Lista e cria o link para os títulos de seções no artigo e Referências-->
                        <xsl:for-each select="article/body/sec/title | article/back/ref-list/title | article/back/ack/sec/title" >
                        	<a href="#{.}" id="li-{.}"><li><xsl:value-of select="." /></li></a>
                        </xsl:for-each>
                    </ul>
                </div>
                <div class="all">
                	<a name="top">
                        <xsl:apply-templates select="article/front/journal-meta/journal-title-group/journal-title" mode="tit-rev-top"/>
                        <xsl:apply-templates select="article/front/journal-meta/journal-id" mode="id-rev"/>
					</a>
                    <xsl:apply-templates select="* | text()"/>
                </div>
                
                
                <!--ToolTips
               	****************************************
                id e class da primeira div dos tooltips:
                ****************************************
                '
	            '<div id="mystickytooltip" class="stickytooltip">
                '
                -->
                <div id="mystickytooltip" class="stickytooltip">
                	<div style="padding:5px">
						<xsl:apply-templates select="*" mode="tooltip" />
                    </div>
                    <!--Mensagem de instrução, status da miniatura.-->
                    <div class="stickystatus"></div>
				</div>
                </body>
                
            </html>
		</xsl:template>
        
        <!--Insere o conteúdo para mostrar miniaturas ao se passar o mouse-->
        <xsl:template match="*" mode="tooltip">
        	<xsl:apply-templates mode="tooltip-body"/><!--Aplica todo o conteúdo para que apareça em miniatura-->
            <xsl:apply-templates mode="tooltip-tfn"/><!--Aplica todo o conteúdo, mas deve ser criado umnovo mode para as referências cruzadas de tabelas, pois não aparecem duas vezes no mode anterior(tooltip-body)-->
        </xsl:template>	
        <!--Elimina o texto desnecessário oculto na página(se esse texto não for eliminado as miniaturas não aparecem)-->
        <xsl:template match="text()" mode="tooltip-body"/>
        <xsl:template match="text()" mode="tooltip-tfn"/>
		
        
		<!--Aplica as miniaturas de tabelas-->
        <xsl:template match="table-wrap" mode="tooltip-body">
        	<div id="t{@id}" class="atip">
            	<div class="xref-tab">
	            	<xsl:apply-templates select="*" mode="tooltip-tab" />
                </div>
            </div>
        </xsl:template>
        
        <!--Tabela se estiver como imagem(Miniatura)-->
        <xsl:template match="table-wrap/graphic" mode="tooltip-body">
           	<div id="t{@id}" class="atip">
        		<img src="{@xlink:href}.jpg" class="fig" />
            </div>
        </xsl:template>
        

        <xsl:template match="table" mode="tooltip-tab">
			<table class="tab-tooltip"><xsl:apply-templates select="* | @*"/></table>
        </xsl:template>
        <!--Ignora a largura pré-definida da tabela e ajusta de acordo com o necessário para a miniatura-->
        <xsl:template match="table/@width" mode="tooltip-tab" />
        

        
        <xsl:template match="table-wrap-foot/fn" mode="tooltip-tab">
        	<p class="fn"><xsl:apply-templates select="*"/></p>
        </xsl:template>
        
		<!--Label e caption de miniatura de tabela-->
        <xsl:template match="table-wrap/label" mode="tooltip-tab">
        	<p class="label"><xsl:value-of select="text()"/></p>
        </xsl:template>

        <xsl:template match="caption" mode="tooltip-tab">
        	<p class="caption"><xsl:apply-templates select="* | text() | @*"/></p>
        </xsl:template>
        
		<!--Fim de label e caption de miniatura-->

        
        <!--Aplica as miniaturas das notas das tabelas-->
        <xsl:template match="table-wrap-foot/fn" mode="tooltip-tfn">
                  <div class="atip" id="t{@id}">
                    	<xsl:apply-templates select="* | text()"/>
                  </div>
        </xsl:template>
        
        <!--Aplica as miniaturas das referências-->
        <xsl:template match="ref" mode="tooltip-body">
              <div id="t{@id}" class="atip">
              	<div class="xref-ref">
                      <span class="ref-label"><xsl:value-of select="label" />.&nbsp;</span>
                      <xsl:apply-templates select="element-citation"/>.
                 </div>
              </div>
         </xsl:template>
         
         <!--Aplica as miniaturas de imagens-->
         <xsl:template match="fig" mode="tooltip-body">
         	<div class="atip" id="t{@id}">
              <div class="xref-img">
                    <xsl:apply-templates select="graphic" mode="img-div"/>
                    <xsl:apply-templates select="* | @* | text()"/>
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

	  		<xsl:template match="aff" mode="aff-author">
                <p class="aff">
                  <a name="{@id}">
                      <xsl:apply-templates select="* | text()"/>
                  </a>
                </p>
            </xsl:template>
            
          <!--Miniaturas das notas do artigo-->
          <xsl:template match="fn-group/fn" mode="tooltip-body">
          	<div class="atip" id="t{@id}">
                    <div class="xref-fn"><xsl:apply-templates select="*" mode="fn-group"/></div>
            </div>
          </xsl:template>
         
         
        
            
		
	        <!--Pré definições que estão no corpo-->
            <xsl:template match="journal-title" mode="tit-rev-top">
                <h1 id="tit-rev"><xsl:value-of select="." /></h1>
            </xsl:template>

			
            <!--Identificação do artigo
                Nome, volume, numero, pagina inicial e final e DOI
            -->
            <xsl:template match="journal-id" mode="id-rev">
                <div id="journal-id">
                    <p>
                        <xsl:value-of select="." />
                        <xsl:apply-templates select="../../article-meta/volume" mode="id-vol"/>
                        <xsl:apply-templates select="../../article-meta/issue" mode="id-issue"/>
                        <xsl:apply-templates select="../../article-meta/fpage" mode="id-fp"/>
                        <xsl:apply-templates select="../../article-meta/lpage" mode="id-lp"/>.
                    </p>
                    <xsl:apply-templates select="../../article-meta/article-id[@pub-id-type='doi']" mode="id-doi"/>
                </div>
            </xsl:template>
            
            <xsl:template match="volume" mode="id-vol">
                &nbsp;<xsl:value-of select="."/>
            </xsl:template>
            
            <xsl:template match="issue" mode="id-issue">
                (<xsl:value-of select="."/>)</xsl:template>
            
            <xsl:template match="fpage" mode="id-fp">:&nbsp;<xsl:value-of select="."/></xsl:template>
            
            <xsl:template match="lpage" mode="id-lp">-<xsl:value-of select="."/></xsl:template>
            
            <xsl:template match="article-id[@pub-id-type='doi']" mode="id-doi">
                <p>
                    <xsl:value-of select="@pub-id-type"/>:
                    <xsl:value-of select="." />
                </p>
            </xsl:template>
                
     	  <!--Fim da identificação do artigo-->
	
    		<xsl:template match="journal-meta"/>

		
        <!--Fim da definição do corpo inteiro da página-->
        
        
        
		<!--
        *********************************
        Imprime todo o conteúdo da página
        *********************************
        -->
        
        <xsl:template match="*">
        	<xsl:apply-templates select="* | text()"/>
        </xsl:template>

		<xsl:template match="@*">
			<xsl:attribute name="{name()}">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</xsl:template>

		<!--xsl:template match="body/text()">
			<xsl:value-of select="."/>
		</xsl:template-->
        
        <xsl:template match="text()">
			<xsl:value-of select="."/>
		</xsl:template>
        
        <xsl:template match="ref//text()">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:template>
        
		<!--
        *********************************
        -->
		
        
        <!--Define parágrafos, sobrescrito e subscrito
                Seleciona o nome da própria tag(xml) e coloca ao seu redor
        -->
        <xsl:template match="p | sub | sup ">
            <xsl:element name="{name()}">
                <xsl:apply-templates select="@* | * | text()"/>
            </xsl:element>
        </xsl:template>

		<!--Define itálicos e negritos-->
        <xsl:template match="italic">
        	<i><xsl:apply-templates select="*|text()"/></i>
    	</xsl:template>
   		<xsl:template match="bold">
        	<b><xsl:apply-templates select="*|text()"/></b>
  		</xsl:template>
        
        
        
        <!--
            ********************
            Definições do artigo
            ********************
        -->
		
        
        <!--Títulos do Artigo-->
        <xsl:template match="title-group/article-title">
            <div class="title">
                <p>
                    <xsl:apply-templates select="* | text() | @*"/>
                    <xsl:apply-templates select="../subtitle | ../trans-subtitle" mode="subtitle"/>
                </p>
            </div>
        </xsl:template>
        
        <xsl:template match="trans-title-group/trans-title">
            <div class="trans-title">
                <p>
                    <xsl:apply-templates select="* | text() | @*"/>
                    <xsl:apply-templates select="../subtitle | ../trans-subtitle" mode="subtitle"/>
                </p>
            </div>
        </xsl:template>
    
        <!--Subtitulos do artigo-->
        <xsl:template match="title-group/subtitle | trans-title-group/trans-subtitle" mode="subtitle">
            <span id="subtitle"><br />
                <xsl:apply-templates select="* | text() | @*"/>
            </span>
        </xsl:template>
        <xsl:template match="title-group/subtitle | trans-title-group/trans-subtitle"/>
        
        
    	<!--Categoria do artigo
        	Talvez seja desenecessária essa informação
        -->
        <xsl:template match="subj-group/subject">
            <p class="categoria"><xsl:value-of select="." /></p>
        </xsl:template>
    	
        <!--Remove o numero do DOI(Já foi aplicado anteriormente)-->
	        <xsl:template match="article-id" />
            
    
    	<!--Nome dos autores-->
        <xsl:template match="contrib-group">
            <div class="autores">
                <xsl:apply-templates select="contrib" mode="contrib" />
                <xsl:apply-templates select="*"/>
            </div>
        </xsl:template>
        <xsl:template match="contrib"/>
        <xsl:template match="contrib"  mode="contrib">
            <xsl:if test="position() != 1 and position() != last()">, </xsl:if>
            <xsl:if test="position() = last()"> and </xsl:if>
            <xsl:apply-templates select="name"/>
        </xsl:template>
        <xsl:template match="contrib/name">
            <xsl:apply-templates select="given-names"/>&nbsp;<xsl:apply-templates select="surname"/>
            <xsl:apply-templates select="../xref" mode="ref"/>
        </xsl:template>
        <xsl:template match="contrib/xref" mode="ref">
            <sup><xsl:if test="position() > 1">, </xsl:if><a href="#{@rid}" data-tooltip="t{@rid}"><xsl:apply-templates/></a></sup>
        </xsl:template>
        
    	
        
        
    	<!--Afiliações e notas do autor-->
        
            <xsl:template match="author-notes">
                <div class="author-note">
                    <xsl:apply-templates select="../aff | ../contrib-group/aff" mode="aff-author"/>
                    <xsl:apply-templates select="* | text()"/>
                </div>
                <div class="fn-author">
	                <xsl:apply-templates select="fn" mode="fn-author"/>
                </div>
            </xsl:template>
            
            
            <xsl:template match="author-notes/corresp">
                <p><xsl:apply-templates select="* | text() | @*"/></p>
            </xsl:template>
            
            <xsl:template match="author-notes/fn" mode="fn-author">
            	<p>
                	<a name="{@id}">
                		<xsl:apply-templates select="* | text()"/>
                    </a>
                </p>
            </xsl:template>
             <xsl:template match="author-notes/fn"/>
            
            <xsl:template match="author-notes/fn/label">
            	<sup><xsl:apply-templates select="* | text()"/></sup>
            </xsl:template>
            
            <xsl:template match="author-notes/fn/p">
            	<xsl:apply-templates select="* | text()"/>
            </xsl:template>
            
            
            <xsl:template match="aff" mode="aff-author">
                <p class="aff">
                  <a name="{@id}">
                      <xsl:apply-templates select="* | text()"/>
                  </a>
                </p>
            </xsl:template>
            <xsl:template match="aff/label">
		    	<sup><xsl:value-of select="." /></sup>
	        </xsl:template>
            <xsl:template match="aff"/>
            
            <!--
            *****
            Email
            **********************************************************************************
            Nota:Se houver algum e-mail no resto do artigo também serpa aplicado este template
            **********************************************************************************
            -->
            <xsl:template match="email">
                <a href="mailto:{text()}">
                    <xsl:value-of select="."/>
                </a>
	        </xsl:template>
            
        <!--Fim de Notas de autor-->
        
        <!--Remove ano e season de publicação-->
	    <xsl:template match="pub-date"/>
        
        <xsl:template match="volume" />
        <xsl:template match="issue" />
        <xsl:template match="fpage" />
        <xsl:template match="lpage" />
       	

        
        <!--Recebido e aceito-->
        	<xsl:template match="history">
            	<!--xsl:variable name="lang" select="@xml:lang"/>
				<xsl:apply-templates select="../kwd-group[@xml:lang=$lang]" mode="keywords-with-abstract" /-->
            	<div class="recebido">
                	<p>	
                    	<xsl:choose>
                        	<xsl:when test="../../../@xml:lang='en'">
                        	    <xsl:apply-templates select="date" mode="en"/>
                            </xsl:when>
                            <xsl:when test="../../../@xml:lang='pt'">
                        	    <xsl:apply-templates select="date" mode="pt"/>
                            </xsl:when>
                            <xsl:when test="../../../@xml:lang='es'">
                        	    <xsl:apply-templates select="date" mode="es"/>
                            </xsl:when>
                        </xsl:choose>
                    </p>
                </div>
            </xsl:template>
            
            		<!--
                    *********************************************************
                    Recebido e aceito quando o idioma do artigo for em INGLÊS
                    *********************************************************
                    -->
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
                            <xsl:when test="text() = 01">January </xsl:when>
                            <xsl:when test="text() = 02">February </xsl:when>
                            <xsl:when test="text() = 03">March </xsl:when>
                            <xsl:when test="text() = 04">April </xsl:when>
                            <xsl:when test="text() = 05">May </xsl:when>
                            <xsl:when test="text() = 06">June </xsl:when>
                            <xsl:when test="text() = 07">July </xsl:when>
                            <xsl:when test="text() = 08">August </xsl:when>
                            <xsl:when test="text() = 09">September </xsl:when>
                            <xsl:when test="text() = 10">October </xsl:when>
                            <xsl:when test="text() = 11">November </xsl:when>
                            <xsl:when test="text() = 12">December </xsl:when>
                        </xsl:choose>
                    </xsl:template>
                    <xsl:template match="day" mode="date-day-en">
                        <xsl:choose>
                            <xsl:when test="text() = 01">1, </xsl:when>
                            <xsl:when test="text() = 02">2, </xsl:when>
                            <xsl:when test="text() = 03">3, </xsl:when>
                            <xsl:when test="text() = 04">4, </xsl:when>
                            <xsl:when test="text() = 05">5, </xsl:when>
                            <xsl:when test="text() = 06">6, </xsl:when>
                            <xsl:when test="text() = 07">7, </xsl:when>
                            <xsl:when test="text() = 08">8, </xsl:when>
                            <xsl:when test="text() = 09">9, </xsl:when>
                            <xsl:otherwise><xsl:value-of select="."/>, </xsl:otherwise>
                        </xsl:choose>
                    </xsl:template>
                    <!--
                    ******************************************
                    fim de recebido e aceito em idioma 	INGLES
                    ******************************************
                    -->
                    
                    <!--
                    ************************************************************
                    Recebido e aceito quando o idioma do artigo for em PORGUGUÊS
                    ************************************************************
                    -->
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
                            <xsl:when test="text() = 01">Janeiro </xsl:when>
                            <xsl:when test="text() = 02">Fevereiro </xsl:when>
                            <xsl:when test="text() = 03">Março </xsl:when>
                            <xsl:when test="text() = 04">Abril </xsl:when>
                            <xsl:when test="text() = 05">Maio </xsl:when>
                            <xsl:when test="text() = 06">Junho </xsl:when>
                            <xsl:when test="text() = 07">Julho </xsl:when>
                            <xsl:when test="text() = 08">Agosto </xsl:when>
                            <xsl:when test="text() = 09">Setembro </xsl:when>
                            <xsl:when test="text() = 10">Outubro </xsl:when>
                            <xsl:when test="text() = 11">Novembro </xsl:when>
                            <xsl:when test="text() = 12">Dezembro </xsl:when>
                        </xsl:choose>
                    </xsl:template>
                    <xsl:template match="day" mode="date-pt">
                        <xsl:choose>
                            <xsl:when test="text() = 01">1 de </xsl:when>
                            <xsl:when test="text() = 02">2 de </xsl:when>
                            <xsl:when test="text() = 03">3 de </xsl:when>
                            <xsl:when test="text() = 04">4 de </xsl:when>
                            <xsl:when test="text() = 05">5 de </xsl:when>
                            <xsl:when test="text() = 06">6 de </xsl:when>
                            <xsl:when test="text() = 07">7 de </xsl:when>
                            <xsl:when test="text() = 08">8 de </xsl:when>
                            <xsl:when test="text() = 09">9 de </xsl:when>
                            <xsl:otherwise><xsl:value-of select="."/> de </xsl:otherwise>
                        </xsl:choose>
                    </xsl:template>
                    <xsl:template match="year" mode="date-pt">
                    	de <xsl:value-of select="."/>
                    </xsl:template>
                    <!--
                    *********************************************
                    fim de recebido e aceito em idioma 	PORTUGUES
                    *********************************************
                    -->
                    
                   <!--
                    ***********************************************************
                    Recebido e aceito quando o idioma do artigo for em ESPANHOL
                    ***********************************************************
                    -->
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
                            <xsl:when test="text() = 01">enero </xsl:when>
                            <xsl:when test="text() = 02">febrero </xsl:when>
                            <xsl:when test="text() = 03">marzo </xsl:when>
                            <xsl:when test="text() = 04">abril </xsl:when>
                            <xsl:when test="text() = 05">mayo </xsl:when>
                            <xsl:when test="text() = 06">junio </xsl:when>
                            <xsl:when test="text() = 07">julio </xsl:when>
                            <xsl:when test="text() = 08">agosto </xsl:when>
                            <xsl:when test="text() = 09">septiembre </xsl:when>
                            <xsl:when test="text() = 10">octubre </xsl:when>
                            <xsl:when test="text() = 11">noviembre </xsl:when>
                            <xsl:when test="text() = 12">diciembre </xsl:when>
                        </xsl:choose>
                    </xsl:template>
                    <xsl:template match="day" mode="date-es">
                        <xsl:choose>
                            <xsl:when test="text() = 01">1 de </xsl:when>
                            <xsl:when test="text() = 02">2 de </xsl:when>
                            <xsl:when test="text() = 03">3 de </xsl:when>
                            <xsl:when test="text() = 04">4 de </xsl:when>
                            <xsl:when test="text() = 05">5 de </xsl:when>
                            <xsl:when test="text() = 06">6 de </xsl:when>
                            <xsl:when test="text() = 07">7 de </xsl:when>
                            <xsl:when test="text() = 08">8 de </xsl:when>
                            <xsl:when test="text() = 09">9 de </xsl:when>
                            <xsl:otherwise><xsl:value-of select="."/> de </xsl:otherwise>
                        </xsl:choose>
                    </xsl:template>
                    <xsl:template match="year" mode="date-es">
                    	de <xsl:value-of select="."/>
                    </xsl:template>
                    <!--
                    ********************************************
                    fim de recebido e aceito em idioma 	ESPANHOL
                    ********************************************
                    -->
            
            
            <xsl:template match="month"/>
            <xsl:template match="date/day"/>
            
            
            
          	  <!--Licenças-->
                <xsl:template match="license-p">
                    <div class="lic">
                        <p>
                            <xsl:value-of select="text() |  @*"/>
                        </p>
                    </div>
                </xsl:template>
        

    
                <!--Resumos-->
                <xsl:template match="abstract | trans-abstract">
                    <xsl:variable name="lang" select="@xml:lang"/>
                    <div class="resumo">
                      <!--Apresenta o título da seção conforme a lingua existente-->
                      <xsl:choose>
                          <xsl:when test="@xml:lang='en'">
                              <p class="sec"><a name="abstract">ABSTRACT</a></p>
                          </xsl:when>
                          <xsl:when test="@xml:lang='pt'">
                              <p class="sec"><a name="resumo">RESUMO</a></p>
                          </xsl:when>
                          <xsl:otherwise>
                              <p class="sec">ABSTRACT</p>
                          </xsl:otherwise>
                      </xsl:choose>
                      <xsl:apply-templates select="* | @* | text()"/>
                      <xsl:apply-templates select="../kwd-group[@xml:lang=$lang]" mode="keywords-with-abstract" />
                    </div>
                </xsl:template>
                <!--Lilsta as palavras chave dentro de Abstract-->
                <xsl:template match="kwd-group" mode="keywords-with-abstract">
                <!--xsl:param name="test" select="1"/>
                <xsl:value-of select="$test"/-->
                <p>
                  <!--Define o nome a ser exibido a frente das palavras-chave conforme o idioma-->
                  <xsl:choose>
                      <xsl:when test="@xml:lang='en'">
                          <b>Keywords: </b> 
                      </xsl:when>
                      <xsl:when test="@xml:lang='pt'">
                          <b>Palavras-Chave: </b>
                      </xsl:when>
                  </xsl:choose>
                  <xsl:apply-templates select="../kwd[@xml:lang=$lang]" mode="keywords-with-abstract" />
                  <xsl:apply-templates select="kwd"/>.
                </p>
                </xsl:template>
                <xsl:template match="kwd-group" />
                <!--Adiciona vírgulas as palavras-chave-->
                <xsl:template match="kwd">
                	<xsl:apply-templates/><xsl:if test="position()!= last()">, </xsl:if>
                </xsl:template>
                
                
                <xsl:template match="body/sec | back/ref-list | ack/sec">
                    <div>
                       <xsl:apply-templates/>
                    </div>                   
                </xsl:template>
                
                <!--Exibe o título das seções classe 'sec' no css-->
                <xsl:template match="body/sec/title | back/ref-list/title | ack/sec/title">
                    <p class="sec">
                        <a name="{.}">
                          <xsl:apply-templates select="@* | * | text()"/>
                        </a>
                    </p>
                </xsl:template>
                
                77
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
                <xsl:template match="fig">
                <div class="xref-img">
                  <a name="{@id}">
                      <xsl:apply-templates select="graphic" mode="img-div"/>
                      <xsl:apply-templates select="* | @* | text()"/>
                  </a>
                </div>
                </xsl:template>
                
                <xsl:template match="graphic"  mode="img-div">
                	<img  src="{@xlink:href}.jpg" width="95%"/>
                </xsl:template>
                
                <!--Tabelas-->
                <xsl:template match="table-wrap">
                <div class="xref-tab">
                  <xsl:apply-templates select="* | @*"/>
                </div>
                </xsl:template>
                <!--Tabela se estiver como imagem-->
                <xsl:template match="table-wrap/graphic">
                <img src="{@xlink:href}.jpg" class="fig" />
                </xsl:template>
                
                <!--Tabela codificada-->
                <xsl:template match="table">
                	<table><xsl:apply-templates select="* | @*"/></table>
                </xsl:template>
				<xsl:template match="thead">
                	<thead><xsl:apply-templates select="* | @*"/></thead>
                </xsl:template>
                <xsl:template match="tbody">
                	<tbody><xsl:apply-templates select="* | @*"/></tbody>
                </xsl:template>
                <xsl:template match="tr">
					<tr><xsl:apply-templates select="* | @*"/></tr>
                </xsl:template>
                <xsl:template match="td">
                	<td><xsl:apply-templates select="* | @*| text()"/></td>
                </xsl:template>
	            <xsl:template match="th">
                	<th><xsl:apply-templates select="* | @*| text()"/></th>
                </xsl:template>
               
               
                <!--Label, caption e nota(Aplicado tanto as tabelas como as figuras)-->
                <xsl:template match="fig/label | table-wrap/label">
                  <p class="label"><xsl:value-of select="text()"/></p>
                </xsl:template>
                
                <xsl:template match="caption">
                  <p class="caption"><xsl:apply-templates select="* | text() | @*"/></p>
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
                
                <!--Fim dos labels e captions-->
                
                
                <!--SigBlock-->
                	<!--sig-block>
                        <sig>Joel <bold>FAINTUCH</bold>
                            <sup>1</sup>
                        </sig>
                        <sig>Ricardo Guilherme <bold>VIEBIG</bold>
                            <sup>2</sup>
                        </sig>
					</sig-block-->
                <xsl:template match="sig-block">
                	<p class="sec">&nbsp;</p>
                    <xsl:apply-templates select="* | text()"/>
                </xsl:template>
                <xsl:template match="sig">
                	<p class="sig"><xsl:apply-templates/></p>
                </xsl:template>
				<xsl:template match="sig/bold">
                	<b>&nbsp;<xsl:apply-templates/></b>
                </xsl:template>
                
                
                <!--Listas-->
                
                <!--Bullet sem estilo-->
                <xsl:template match="p/list[@list-type='simple']">
                	<ul class="list-none"><xsl:apply-templates select="list-item/p"/></ul>
                </xsl:template>
                
                <!--Lista Bullet Normal(Com marcador na frente)-->
                <xsl:template match="p/list[@list-type='bullet']">
                	<ul><xsl:apply-templates select="list-item/p"/></ul>
                </xsl:template>
                
                <!--Lista ordenada em letras maiúsculas-->
                <xsl:template match="p/list[@list-type='alpha-upper']">
                	<ol type="A"><xsl:apply-templates select="list-item/p"/></ol>
                </xsl:template>
                
                <!--Lista ordana em letras minúsculas-->
                <xsl:template match="p/list[@list-type='alpha-lower']">
                	<ol type="a"><xsl:apply-templates select="list-item/p"/></ol>
                </xsl:template>
                
                <!--Lista numerada-->
                <xsl:template match="p/list[@list-type='order']">
                	<ol><xsl:apply-templates select="list-item/p"/></ol>
                </xsl:template>
                
                
                <xsl:template match="list-item/p">
                	<li><xsl:apply-templates select="* | text()"/></li>
                </xsl:template>
                
                <!--
                ***********
                Referências
                ***********
                -->   
            	
               	<!--Define o TODO das referências-->
                <xsl:template match="ref">
                    <p class="ref">
                        <a name="{@id}">
                        	<!--Imprime o label das referências-->
                            <span class="ref-label"><xsl:value-of select="label" />.&nbsp;</span>
                            <xsl:apply-templates select="element-citation"/>
                        </a>.
                    </p>
                </xsl:template>
                
                <xsl:template match="element-citation">
                    <span class="ref-autor"><xsl:apply-templates select="person-group/name | person-group/collab" mode="name-autor" />.</span>
                    <xsl:apply-templates select="*" />
                </xsl:template>

                              
              
                <!--
                ********************
                Publication tipo Web
                ********************
                -->
                <xsl:template match="element-citation[@publication-type='web']">
                  <xsl:apply-templates select="person-group/collab" mode="collab-ref-web"/>
                  [<xsl:apply-templates select="date-in-citation" mode="date-ref-web" />];
                  <xsl:apply-templates select="*"/>
                </xsl:template>
                
                <xsl:template match="person-group/collab" mode="collab-ref-web">
                  <xsl:apply-templates select="."/>.
                </xsl:template>
                
                <xsl:template match="person-group" />
                <xsl:template match="date-in-citation" />
                
                <xsl:template mode="date-ref-web" match="date-in-citation">
                  <xsl:value-of select="."/>
                </xsl:template>
                
                
                <xsl:template match="name | collab" mode="name-autor">
                    <span class="ref-autor"><xsl:if test="position() != 1">, </xsl:if>
                        <xsl:apply-templates select="* | text()" /></span>
                </xsl:template>
                
                <xsl:template match="surname">
                    <xsl:value-of select="."/><xsl:text>&#160;</xsl:text>
                </xsl:template>
                
                <!--
                *********************
                Publication tipo Book
                *********************
                -->
                
                <xsl:template match="element-citation[@publication-type='book']">
					<xsl:apply-templates select="*" mode="book"/>
                </xsl:template>
                
                <xsl:template match="source" mode="book"><span class="ref-source"><xsl:value-of select=". | text()" />.</span></xsl:template>
                <xsl:template match="source" mode="book"><span class="ref-source"><xsl:value-of select=". | text()" />.</span>
                </xsl:template>
                <xsl:template match="edition" mode="book"><xsl:value-of select=". | text()" />.</xsl:template>
                <xsl:template match="publisher-loc" mode="book">&nbsp;<xsl:value-of select=". | text()" />:</xsl:template>
				<xsl:template match="publisher-name" mode="book">&nbsp;<xsl:value-of select=". | text()" />;</xsl:template>
				<xsl:template match="year" mode="book">&nbsp;<xsl:value-of select=". | text()" /></xsl:template>
                
                <!--Fim de Book-->
                
                
                
                
                
                
                <xsl:template match="element-citation/article-title | element-citation/chapter-title">
                    <span class="ref-title">&nbsp;<xsl:value-of select=". | text()" />.
                    </span>
                </xsl:template>
                
                <xsl:template match="element-citation/trans-title">
                    <span class="ref-title-t">
                    	<xsl:choose>
	        	            <xsl:when test="contains(., '[')">&nbsp;<xsl:value-of select="."/>.</xsl:when>
    	             		<xsl:otherwise>&nbsp;[<xsl:value-of select="."/>].</xsl:otherwise>
	        	    	</xsl:choose>
                    </span>
                </xsl:template>
                
                <xsl:template match="source">
                    <span class="ref-source">
                        <xsl:value-of select=". | text()" />.
                    </span>
                </xsl:template>
                
        
             
             <xsl:template match="element-citation/year"><span class="data">&nbsp;<xsl:value-of select="." />;</span></xsl:template>
             <xsl:template match="element-citation/volume"><span class="data"><xsl:value-of select="." />:</span></xsl:template>
             <xsl:template match="element-citation/supplement">
                 <xsl:choose>
                    <xsl:when test="contains(., '(')"><xsl:value-of select="."/></xsl:when>
                 	<xsl:otherwise>(<xsl:value-of select="."/>)</xsl:otherwise>
                 </xsl:choose>
             </xsl:template>
             <xsl:template match="element-citation/fpage"><span class="data"><xsl:value-of select="." /></span></xsl:template>
             <xsl:template match="element-citation/lpage"><span class="data">-<xsl:value-of select="." /></span></xsl:template>
             <xsl:template match="element-citation/series"><span class="data">&nbsp;<xsl:value-of select="."/>.</span></xsl:template>
          <!--
          Fim das referências
          -->
          
          <!--Notas do Artigo [foot notes]-->
          <xsl:template match="fn-group">
              <div>
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
                    <xsl:apply-templates/>
              </div>
          </xsl:template>
          
          
          <xsl:template match="fn-group/fn" >
          	<a name="{@id}">
          		<p class="a"><xsl:apply-templates select="*" mode="fn-group"/></p>
            </a>
          </xsl:template>
          
          <xsl:template match="fn-group/fn[@fn-type='supplementary-material']/label" mode="fn-group">
          		<sup><xsl:value-of select="."/></sup>
          </xsl:template>
          
         
         
         
            <xsl:template match="ext-link">
                <a href="{@xlink:href}" target="_blank"><xsl:value-of select=". | text()" /></a>&nbsp;
            </xsl:template>
            
            
            <xsl:template match="xref">
            	<xsl:choose>
                	<!--Referências de Notas do artigo sobrescritas-->
                	<xsl:when test="@ref-type='fn'">
                        <sup><a href="#{@rid}" data-tooltip="t{@rid}">
                            <xsl:apply-templates select="*|text() | @*"/>
                        </a></sup>
                    </xsl:when>
                    <!--*******************************************-->
                    <xsl:otherwise>
                    	<a href="#{@rid}" data-tooltip="t{@rid}">
                            <xsl:apply-templates select="*|text() | @*"/>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:template>
                    
			
            
            
</xsl:stylesheet>