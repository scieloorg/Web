<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Adds a link to a SciELO page 
        Parameters: seq - Issue PID
                             script - Name of the script to be called -->

  <xsl:template name="AddScieloLink">
   <xsl:param name="seq"/>
   <xsl:param name="script"/>   
   <xsl:param name="txtlang" />


     <xsl:attribute name="href">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="$script"/>&amp;<xsl:if test="$seq">pid=<xsl:value-of select="$seq"/>&amp;</xsl:if>lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/><xsl:if test="$txtlang">&amp;tlng=<xsl:value-of select="normalize-space($txtlang)" /></xsl:if>
     </xsl:attribute>
  </xsl:template>


 <!-- Adds a LINK to the IAH search interface
        Parameters:
           index - AU,etc
           scope - library | siglum  -->

  <xsl:template name="AddIAHLink">
   <xsl:param name="index"/>
   <xsl:param name="scope"/>
   <xsl:param name="base">article</xsl:param>

      <xsl:attribute name="href">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_WXIS"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA_IAH"/>?IsisScript=<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_CGI_IAH"/>iah.xis&amp;base=<xsl:value-of select="$base"/><xsl:if test="$scope">^d<xsl:value-of select="$scope"/></xsl:if>&amp;<xsl:if test="$index">index=<xsl:value-of select="$index"/>&amp;</xsl:if>format=<xsl:value-of select="//CONTROLINFO/STANDARD"/>.pft&amp;lang=<xsl:choose><xsl:when test="//CONTROLINFO/LANGUAGE='en'">i</xsl:when><xsl:when test="//CONTROLINFO/LANGUAGE='es'">e</xsl:when><xsl:when test="//CONTROLINFO/LANGUAGE='pt'">p</xsl:when></xsl:choose><xsl:if test="$scope and $scope!='library'">&amp;limit=<xsl:value-of select="//ISSN"/></xsl:if>
      </xsl:attribute>
</xsl:template>

<!-- Get Vol. No. Suppl. Strip
      Parameter:
        Element - Name of Element   -->

 <xsl:template name="GetStrip">
  <xsl:param name="vol" />
  <xsl:param name="num" />
  <xsl:param name="suppl" />
  <xsl:param name="lang" />

  <xsl:if test="$vol">vol.<xsl:value-of select="$vol"/></xsl:if>
  <xsl:if test="$num">&#160;<xsl:call-template name="GetNumber">
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="lang" select="$lang"/> 
        <xsl:with-param name="strip" select="1"/>      
      </xsl:call-template> 
  </xsl:if><xsl:if test="$suppl">&#160;<xsl:call-template name="GetSuppl">
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="suppl" select="$suppl"/>
        <xsl:with-param name="lang" select="$lang"/>      
        <xsl:with-param name="strip" select="1"/>      
     </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!-- Get Number in specified language -->
 <xsl:template name="GetNumber">
  <xsl:param name="num" />
  <xsl:param name="lang" />
  <xsl:param name="strip" />
   <xsl:choose>
        <xsl:when test="starts-with($num,'SPE')">
          <xsl:choose>
            <xsl:when test="$lang='en'">special<xsl:if test="$strip">&#160;issue</xsl:if></xsl:when>
            <xsl:otherwise><xsl:if test="$strip">no.</xsl:if>especial</xsl:otherwise>
          </xsl:choose>
          <xsl:if test="string-length($num) > 3">
           <xsl:value-of select="concat(' ',substring($num,4))"/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="starts-with($num,'MON')"> 
          <xsl:choose>
            <xsl:when test="$lang='en'">monograph<xsl:if test="$strip">&#160;issue</xsl:if></xsl:when>
            <xsl:otherwise><xsl:if test="$strip">no.</xsl:if>monográfico</xsl:otherwise>
          </xsl:choose>
          <xsl:if test="string-length($num) > 3">
           <xsl:value-of select="concat(' ',substring($num,4))"/>
          </xsl:if>
        </xsl:when>
	<xsl:otherwise>
	  <xsl:if test="$strip">no.</xsl:if><xsl:value-of select="$num"/>
	</xsl:otherwise>	
    </xsl:choose>
</xsl:template>

 <!-- Get Supplement in specified language -->
<xsl:template name="GetSuppl">
  <xsl:param name="num" />
  <xsl:param name="suppl" />
  <xsl:param name="lang" />
  <xsl:param name="strip" />
   <xsl:if test="$suppl">
       <xsl:if test="$num">&#160;</xsl:if>
       <xsl:choose>
	    <xsl:when test="$lang='en'">suppl.</xsl:when>
	    <xsl:otherwise>supl.</xsl:otherwise>
	 </xsl:choose>
       <xsl:if test="$suppl!=0"><xsl:value-of select="$suppl"/></xsl:if>
    </xsl:if> 
</xsl:template>

<!-- Shows Title Group -->
<xsl:template match="TITLEGROUP">
   <CENTER>
    <FONT class="nomodel" color="#000080" size="+1"><xsl:value-of select="TITLE" disable-output-escaping="yes" /></FONT><br/>
   </CENTER>
</xsl:template>

<!-- Shows copyright information -->
<xsl:template match="COPYRIGHT">
  <font class="normal">&#169;&#160;</font>
  <FONT color="#000080" class="negrito"><I>
    <xsl:value-of select="@YEAR"/>&#160;
    <xsl:value-of select="." disable-output-escaping="yes"/><br/></I></FONT>   
  <br/>
 </xsl:template>

 <!-- Shows contact information -->
 <xsl:template match="CONTACT">
   <xsl:apply-templates select="LINES"/>    
   <br/><br/>
   <xsl:apply-templates select="EMAILS"/> 
    <xsl:call-template name="UpdateLog" />
 </xsl:template>

 <!-- Shows lines from contact information -->
 <xsl:template match="LINES">
    <FONT color="#000080" class="negrito"><xsl:apply-templates select="LINE"/></FONT>
 </xsl:template>

  <xsl:template match="LINE">
    <xsl:value-of  select="." disable-output-escaping="yes"/><br/>
  </xsl:template>

  <!-- Shows e-mail links -->
  <xsl:template match="EMAILS">
    <IMG>
      <xsl:attribute name="src"><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/>
                          <xsl:value-of select="//CONTROLINFO/LANGUAGE"/>/e-mailt.gif</xsl:attribute>
      <xsl:attribute name="border">0</xsl:attribute>
    </IMG>
    <br/>
    <xsl:apply-templates select="EMAIL"/>
  </xsl:template>

  <!-- Show E-Mail -->
  <xsl:template match="EMAIL">
    <A class="email">
     <xsl:attribute name="href">mailto:<xsl:value-of select="."/></xsl:attribute>
     <xsl:value-of select="."/>   
    </A>
  </xsl:template>
 
  <!-- Gets the month name in selected language
         Parameters:
           LANG    language code
           MONTH (01..12)
           ABREV  1: abbreviated name (Optional) -->
<xsl:template name="GET_MONTH_NAME">
 <xsl:param name="LANG" />
 <xsl:param name="MONTH" />
 <xsl:param name="ABREV" />

 <xsl:choose>
   <xsl:when test="$LANG='en'">
    <xsl:call-template name="MONTH_NAME_EN">
     <xsl:with-param name="MONTH" select="$MONTH" />
     <xsl:with-param name="ABREV" select="$ABREV" />
    </xsl:call-template>
   </xsl:when>
   <xsl:when test="$LANG='pt'">
    <xsl:call-template name="MONTH_NAME_PT">
     <xsl:with-param name="MONTH" select="$MONTH" />
     <xsl:with-param name="ABREV" select="$ABREV" />
    </xsl:call-template>
   </xsl:when>
   <xsl:when test="$LANG='es'">
    <xsl:call-template name="MONTH_NAME_ES">
     <xsl:with-param name="MONTH" select="$MONTH" />
     <xsl:with-param name="ABREV" select="$ABREV" />
    </xsl:call-template>
   </xsl:when>
  </xsl:choose>
 </xsl:template>

<!-- Auxiliary function - Gets the month name in english. See GET_MONTH_NAME function -->
 <xsl:template name="MONTH_NAME_EN">
  <xsl:param name="MONTH" />
  <xsl:param name="ABREV" />

  <xsl:choose>
   <xsl:when test=" $MONTH='01' ">Jan<xsl:if test="not($ABREV)">uary</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='02' ">Feb<xsl:if test="not($ABREV)">ruary</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='03' ">Mar<xsl:if test="not($ABREV)">ch</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='04' ">Apr<xsl:if test="not($ABREV)">il</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='05' ">May</xsl:when>
   <xsl:when test=" $MONTH='06' ">June</xsl:when>
   <xsl:when test=" $MONTH='07' ">July</xsl:when>
   <xsl:when test=" $MONTH='08' ">Aug<xsl:if test="not($ABREV)">ust</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='09' ">Sep<xsl:if test="not($ABREV)">tember</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='10' ">Oct<xsl:if test="not($ABREV)">ober</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='11' ">Nov<xsl:if test="not($ABREV)">ember</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='12' ">Dec<xsl:if test="not($ABREV)">ember</xsl:if></xsl:when>
  </xsl:choose>
 </xsl:template>

<!-- Auxiliary function - Gets the month name in portuguese. See GET_MONTH_NAME function -->
 <xsl:template name="MONTH_NAME_PT">
  <xsl:param name="MONTH" />
  <xsl:param name="ABREV" />
 
  <xsl:choose>
   <xsl:when test=" $MONTH='01' ">Jan<xsl:if test="not($ABREV)">eiro</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='02' ">Fev<xsl:if test="not($ABREV)">ereiro</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='03' ">Mar<xsl:if test="not($ABREV)">ço</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='04' ">Abr<xsl:if test="not($ABREV)">il</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='05' ">Maio</xsl:when>
   <xsl:when test=" $MONTH='06' ">Jun<xsl:if test="not($ABREV)">ho</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='07' ">Jul<xsl:if test="not($ABREV)">ho</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='08' ">Ago<xsl:if test="not($ABREV)">sto</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='09' ">Set<xsl:if test="not($ABREV)">embro</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='10' ">Out<xsl:if test="not($ABREV)">ubro</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='11' ">Nov<xsl:if test="not($ABREV)">embro</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='12' ">Dez<xsl:if test="not($ABREV)">embro</xsl:if></xsl:when>
  </xsl:choose> 
 </xsl:template>

<!-- Auxiliary function - Gets the month name in spanish. See GET_MONTH_NAME function -->
 <xsl:template name="MONTH_NAME_ES">
  <xsl:param name="MONTH" />
  <xsl:param name="ABREV" />

  <xsl:choose>
   <xsl:when test=" $MONTH='01' ">Ene<xsl:if test="not($ABREV)">ro</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='02' ">Feb<xsl:if test="not($ABREV)">rero</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='03' ">Mar<xsl:if test="not($ABREV)">zo</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='04' ">Abr<xsl:if test="not($ABREV)">il</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='05' ">Mayo</xsl:when>
   <xsl:when test=" $MONTH='06' ">Jun<xsl:if test="not($ABREV)">io</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='07' ">Jul<xsl:if test="not($ABREV)">io</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='08' ">Ago<xsl:if test="not($ABREV)">sto</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='09' ">Sep<xsl:if test="not($ABREV)">tiembre</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='10' ">Oct<xsl:if test="not($ABREV)">ubre</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='11' ">Nov<xsl:if test="not($ABREV)">iembre</xsl:if></xsl:when>
   <xsl:when test=" $MONTH='12' ">Dic<xsl:if test="not($ABREV)">iembre</xsl:if></xsl:when>
  </xsl:choose>
 </xsl:template>

<!-- Gets the type of the ISSN
         Parameters:
           TYPE - Type Code (PRINT | CDROM | DISKE | ONLIN)  
           LANG - language code   -->
 <xsl:template name="GET_ISSN_TYPE">
  <xsl:param name="TYPE" />
  <xsl:param name="LANG" />
	
  <xsl:choose>
   <xsl:when test=" $LANG = 'en' ">
    <xsl:choose>
     <xsl:when test=" $TYPE = 'PRINT' ">Print</xsl:when>
     <xsl:when test=" $TYPE = 'CDROM' ">CDROM</xsl:when>
     <xsl:when test=" $TYPE = 'DISKE' ">Diskette</xsl:when>
     <xsl:when test=" $TYPE = 'ONLIN' ">On-line</xsl:when>
    </xsl:choose>
   </xsl:when>
   <xsl:when test=" $LANG = 'pt' ">
    <em>versão
     <xsl:choose>
      <xsl:when test=" $TYPE = 'PRINT' "> impressa</xsl:when>
      <xsl:when test=" $TYPE = 'CDROM' "> em CDROM</xsl:when>
      <xsl:when test=" $TYPE = 'DISKE' "> em disquete</xsl:when>
      <xsl:when test=" $TYPE = 'ONLIN' "> on-line</xsl:when>
     </xsl:choose>
    </em>
   </xsl:when>
   <xsl:when test=" $LANG = 'es' ">
    <em>versión
     <xsl:choose>
      <xsl:when test=" $TYPE = 'PRINT' "> impresa</xsl:when>
      <xsl:when test=" $TYPE = 'CDROM' "> en CDROM</xsl:when>
      <xsl:when test=" $TYPE = 'DISKE' "> en disquete</xsl:when>
      <xsl:when test=" $TYPE = 'ONLIN' "> on-line</xsl:when>
     </xsl:choose>
    </em>
   </xsl:when>
  </xsl:choose>
 </xsl:template>

<!-- Displays former title and new title
         Parameter:
           LANG - language code   -->
 <xsl:template match="CHANGESINFO">
  <xsl:param name="LANG" />

  <xsl:if test="FORMERTITLE/TITLE">
   <br/><font color="#000000">
    <xsl:choose>
     <xsl:when test="$LANG='en'">Former Title:</xsl:when>
     <xsl:when test="$LANG='pt'">Título anterior:</xsl:when>
     <xsl:when test="$LANG='es'">Título anterior:</xsl:when>
    </xsl:choose>		
   </font><br/>	
   <font color="#000080">
    <em><xsl:apply-templates select="FORMERTITLE" /></em>
   </font>
  </xsl:if>
  <xsl:if test="NEWTITLE/TITLE">
   <br/><font color="#000000">
    <xsl:choose>
     <xsl:when test="$LANG='en'">New title:</xsl:when>
     <xsl:when test="$LANG='pt'">Título novo:</xsl:when>
     <xsl:when test="$LANG='es'">Título nuevo:</xsl:when>
    </xsl:choose>		
   </font><br/>	
   <font color="#000080">
    <em><xsl:apply-templates select="NEWTITLE" /></em>
   </font>		
  </xsl:if>	
 </xsl:template>

<!-- Gets the former title -->
 <xsl:template match="FORMERTITLE">
  <xsl:choose>
   <xsl:when test="TITLE/@ISSN">
    <a>
     <xsl:call-template name="AddScieloLink">
      <xsl:with-param name="seq" select="TITLE/@ISSN" />
      <xsl:with-param name="script">sci_serial</xsl:with-param>
     </xsl:call-template>
     <xsl:value-of select="normalize-space(TITLE)" disable-output-escaping="yes" />
    </a>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="normalize-space(TITLE)" disable-output-escaping="yes" />
   </xsl:otherwise>
  </xsl:choose><br/>
 </xsl:template>

<!-- Gets the New title -->
 <xsl:template match="NEWTITLE">
  <xsl:choose>
   <xsl:when test="TITLE/@ISSN">
    <a>
     <xsl:call-template name="AddScieloLink">
      <xsl:with-param name="seq" select="TITLE/@ISSN" />
      <xsl:with-param name="script">sci_serial</xsl:with-param>
     </xsl:call-template>
    <xsl:value-of select="normalize-space(TITLE)" disable-output-escaping="yes" />
    </a>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="normalize-space(TITLE)" disable-output-escaping="yes" />
   </xsl:otherwise>
  </xsl:choose><br/>
 </xsl:template>

<!-- Prints the issn and its type
         Parameters:
           LANG: language code
           SERIAL: 1 - serial home page style (Optional)
                         otherwise - all other pages style        -->
 <xsl:template match="ISSN">
  <xsl:param name="LANG" />
  <xsl:param name="SERIAL" />

  <font class="nomodel" color="#000080">
  <xsl:choose>
   <xsl:when test=" $LANG='en' ">
    <xsl:choose>
     <xsl:when test="$SERIAL">
      <font color="#000000">
       <xsl:call-template name="GET_ISSN_TYPE">
        <xsl:with-param name="TYPE" select="@TYPE" />
        <xsl:with-param name="LANG" select="$LANG" />
       </xsl:call-template>&#160;ISSN</font>&#160;<xsl:value-of select="normalize-space(.)"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:call-template name="GET_ISSN_TYPE">
        <xsl:with-param name="TYPE" select="@TYPE" />
        <xsl:with-param name="LANG" select="$LANG" />
       </xsl:call-template>&#160;ISSN&#160;<xsl:value-of select="normalize-space(.)"/>		
      </xsl:otherwise>				
     </xsl:choose>
    </xsl:when>			
   <xsl:when test=" $LANG='pt' ">
    <xsl:choose>
     <xsl:when test="$SERIAL"><font color="#000000">ISSN</font></xsl:when>
     <xsl:otherwise>ISSN</xsl:otherwise>
    </xsl:choose>&#160;<xsl:value-of select="normalize-space(.)"/>&#160;<xsl:if test="$SERIAL">
     <br/>
    </xsl:if><xsl:call-template name="GET_ISSN_TYPE">
     <xsl:with-param name="TYPE" select="@TYPE" />
     <xsl:with-param name="LANG" select="$LANG" />
    </xsl:call-template>
   </xsl:when>
   <xsl:when test=" $LANG='es' ">
    <xsl:choose>
     <xsl:when test="$SERIAL"><font color="#000000">ISSN</font></xsl:when>
     <xsl:otherwise>ISSN</xsl:otherwise>
    </xsl:choose>&#160;<xsl:value-of select="normalize-space(.)"/>&#160;<xsl:if test="$SERIAL">
     <br/>
    </xsl:if><xsl:call-template name="GET_ISSN_TYPE">
     <xsl:with-param name="TYPE" select="@TYPE" />
     <xsl:with-param name="LANG" select="$LANG" />
    </xsl:call-template>
   </xsl:when>
  </xsl:choose>	
  </font>
 </xsl:template>

<!-- Creates Links for abstract, full-text or pdf file
          Parameters:
              TYPE: (abstract | full | pdf)
              INTLANG: interface language code
              TXTLANG: text language code
              PID: Article's pid
-->
<xsl:template name="CREATE_ARTICLE_LINK">
 <xsl:param name="TYPE" />
 <xsl:param name="INTLANG" />
 <xsl:param name="TXTLANG" />
 <xsl:param name="PID" />
 <xsl:param name="FIRST_LABEL">0</xsl:param>

  <!-- xsl:if test=" $TYPE !='abstract' ">
   <font face="Symbol" color="#000080">&#183; </font>
  </xsl:if -->
  <a>
   <xsl:choose>
    <xsl:when test=" $TYPE='abstract' ">
     <xsl:call-template name="AddScieloLink">
      <xsl:with-param name="seq" select="$PID"/>
      <xsl:with-param name="script">sci_abstract</xsl:with-param>
      <xsl:with-param name="txtlang" select="$TXTLANG"></xsl:with-param>
     </xsl:call-template>
     <xsl:choose>
	<xsl:when test=" $INTLANG = 'en' "><xsl:if test="$FIRST_LABEL='1'">abstract in</xsl:if>
        <xsl:choose>
         <xsl:when test=" $TXTLANG = 'en' "> english</xsl:when>
         <xsl:when test=" $TXTLANG = 'pt' "> portuguese</xsl:when>
         <xsl:when test=" $TXTLANG = 'es' "> spanish</xsl:when>
         <xsl:when test=" $TXTLANG = 'fr' "> french</xsl:when>
         <xsl:when test=" $TXTLANG = 'de' "> german</xsl:when>
         <xsl:when test=" $TXTLANG = 'it' "> italian</xsl:when>
        </xsl:choose>
	</xsl:when>
	<xsl:when test=" $INTLANG = 'pt' "><xsl:if test="$FIRST_LABEL='1'">resumo em</xsl:if>
        <xsl:choose>
         <xsl:when test=" $TXTLANG = 'en' "> inglês</xsl:when>
         <xsl:when test=" $TXTLANG = 'pt' "> português</xsl:when>
         <xsl:when test=" $TXTLANG = 'es' "> espanhol</xsl:when>
         <xsl:when test=" $TXTLANG = 'fr' "> francês</xsl:when>
         <xsl:when test=" $TXTLANG = 'de' "> alemão</xsl:when>
         <xsl:when test=" $TXTLANG = 'it' "> italiano</xsl:when>
        </xsl:choose>	
	</xsl:when>
	<xsl:when test=" $INTLANG = 'es' "><xsl:if test="$FIRST_LABEL='1'">resumen en</xsl:if>
        <xsl:choose>
         <xsl:when test=" $TXTLANG = 'en' "> inglés</xsl:when>
         <xsl:when test=" $TXTLANG = 'pt' "> portugués</xsl:when>
         <xsl:when test=" $TXTLANG = 'es' "> español</xsl:when>
         <xsl:when test=" $TXTLANG = 'fr' "> francés</xsl:when>
         <xsl:when test=" $TXTLANG = 'de' "> alemán</xsl:when>
         <xsl:when test=" $TXTLANG = 'it' "> italiano</xsl:when>
        </xsl:choose>	
	</xsl:when>
     </xsl:choose>
    </xsl:when>

    <xsl:when test=" $TYPE='full' ">
     <xsl:call-template name="AddScieloLink">
      <xsl:with-param name="seq" select="$PID"/>
      <xsl:with-param name="script">sci_arttext</xsl:with-param>
      <xsl:with-param name="txtlang" select="$TXTLANG"></xsl:with-param>
     </xsl:call-template>
     <xsl:choose>
      <!-- fixed acrescenti first_label -->
      <xsl:when test=" $INTLANG = 'en' "><xsl:if test="$FIRST_LABEL='1'">text in</xsl:if>
       <xsl:choose>
        <xsl:when test=" $TXTLANG = 'en' "> english</xsl:when>
        <xsl:when test=" $TXTLANG = 'pt' "> portuguese</xsl:when>
        <xsl:when test=" $TXTLANG = 'es' "> spanish</xsl:when>
        <xsl:when test=" $TXTLANG = 'fr' "> french</xsl:when>
        <xsl:when test=" $TXTLANG = 'de' "> german</xsl:when>
        <xsl:when test=" $TXTLANG = 'it' "> italian</xsl:when>
       </xsl:choose>
      </xsl:when>
      <!-- fixed acrescenti first_label -->
      <xsl:when test=" $INTLANG = 'pt' "><xsl:if test="$FIRST_LABEL='1'">texto em</xsl:if>
       <xsl:choose>
        <xsl:when test=" $TXTLANG = 'en' "> inglês</xsl:when>
        <xsl:when test=" $TXTLANG = 'pt' "> português</xsl:when>
        <xsl:when test=" $TXTLANG = 'es' "> espanhol</xsl:when>
        <xsl:when test=" $TXTLANG = 'fr' "> francês</xsl:when>
        <xsl:when test=" $TXTLANG = 'de' "> alemão</xsl:when>
        <xsl:when test=" $TXTLANG = 'it' "> italiano</xsl:when>        
       </xsl:choose>
      </xsl:when>
      <!-- fixed acrescenti first_label -->
      <xsl:when test=" $INTLANG = 'es' "><xsl:if test="$FIRST_LABEL='1'">texto en</xsl:if>
       <xsl:choose>
        <xsl:when test=" $TXTLANG = 'en' "> inglés</xsl:when>
        <xsl:when test=" $TXTLANG = 'pt' "> portugués</xsl:when>
        <xsl:when test=" $TXTLANG = 'es' "> español</xsl:when>
        <xsl:when test=" $TXTLANG = 'fr' "> francés</xsl:when>
        <xsl:when test=" $TXTLANG = 'de' "> alemán</xsl:when>
        <xsl:when test=" $TXTLANG = 'it' "> italiano</xsl:when>        
       </xsl:choose>
      </xsl:when>
     </xsl:choose>
    </xsl:when>

    <xsl:when test=" $TYPE='pdf' ">
     <xsl:call-template name="AddScieloLink">
      <xsl:with-param name="seq" select="$PID"/>
      <xsl:with-param name="script">sci_pdf</xsl:with-param>
      <xsl:with-param name="txtlang" select="$TXTLANG"></xsl:with-param>
     </xsl:call-template>
     <xsl:choose>
      <xsl:when test=" $INTLANG = 'en' "><xsl:if test="$FIRST_LABEL='1'">pdf in
</xsl:if>
       <xsl:choose>
        <xsl:when test=" $TXTLANG = 'en' "> english</xsl:when>
        <xsl:when test=" $TXTLANG = 'pt' "> portuguese</xsl:when>
        <xsl:when test=" $TXTLANG = 'es' "> spanish</xsl:when>
        <xsl:when test=" $TXTLANG = 'fr' "> french</xsl:when>
        <xsl:when test=" $TXTLANG = 'de' "> german</xsl:when>
        <xsl:when test=" $TXTLANG = 'it' "> italian</xsl:when>        
       </xsl:choose>
      </xsl:when>
      <xsl:when test=" $INTLANG = 'pt' "><xsl:if test="$FIRST_LABEL='1'">pdf em</xsl:if>
       <xsl:choose>
        <xsl:when test=" $TXTLANG = 'en' "> inglês</xsl:when>
        <xsl:when test=" $TXTLANG = 'pt' "> português</xsl:when>
        <xsl:when test=" $TXTLANG = 'es' "> espanhol</xsl:when>
        <xsl:when test=" $TXTLANG = 'fr' "> francês</xsl:when>
        <xsl:when test=" $TXTLANG = 'de' "> alemão</xsl:when>
        <xsl:when test=" $TXTLANG = 'it' "> italiano</xsl:when>                
       </xsl:choose>
      </xsl:when>
      <xsl:when test=" $INTLANG = 'es' "><xsl:if test="$FIRST_LABEL='1'">pdf en</xsl:if>

       <xsl:choose>
        <xsl:when test=" $TXTLANG = 'en' "> inglés</xsl:when>
        <xsl:when test=" $TXTLANG = 'pt' "> portugués</xsl:when>
        <xsl:when test=" $TXTLANG = 'es' "> español</xsl:when>
        <xsl:when test=" $TXTLANG = 'fr' "> francés</xsl:when>
        <xsl:when test=" $TXTLANG = 'de' "> alemán</xsl:when>
        <xsl:when test=" $TXTLANG = 'it' "> italiano</xsl:when>        
       </xsl:choose>
      </xsl:when>
     </xsl:choose>
    </xsl:when>
   </xsl:choose>
  </a><!-- &#160;&#160;&#160; -->
 </xsl:template>

<!-- Shows bibliografic strip -->
<xsl:template name="SHOWSTRIP">
  <xsl:param name="SHORTTITLE" />
  <xsl:param name="VOL" />
  <xsl:param name="NUM" />
  <xsl:param name="SUPPL"  />
  <xsl:param name="CITY" />
  <xsl:param name="MONTH" />
  <xsl:param name="YEAR" />

  <xsl:if  test ="$SHORTTITLE"><xsl:value-of select="normalize-space($SHORTTITLE)" disable-output-escaping="yes"/></xsl:if>
  <xsl:if  test ="$VOL">&#160;<xsl:value-of select="normalize-space($VOL)" /></xsl:if>
  <xsl:if  test ="$NUM">&#160;<xsl:value-of select="normalize-space($NUM)" /></xsl:if>
  <xsl:if  test ="$SUPPL">&#160;<xsl:value-of select="normalize-space($SUPPL)" /></xsl:if>
  <xsl:if  test ="$CITY">&#160;<xsl:value-of  select ="normalize-space($CITY)" /></xsl:if>
  <xsl:if  test ="$MONTH">&#160;<xsl:value-of select="normalize-space($MONTH)" /></xsl:if>
  <xsl:if  test ="$YEAR">&#160;<xsl:value-of select ="normalize-space($YEAR)" /></xsl:if>
</xsl:template>


<!-- Invisible Image To Update Log File -->
<xsl:template name="UpdateLog">
 <xsl:if test="//CONTROLINFO/SCIELO_INFO/SERVER_LOG">
  <img>
   <xsl:attribute name="src">http://<xsl:value-of 
    select="//CONTROLINFO/SCIELO_INFO/SERVER_LOG"/>/<xsl:value-of 
    select="//CONTROLINFO/SCIELO_INFO/SCRIPT_LOG_NAME"/>?app=<xsl:value-of select="normalize-space(//CONTROLINFO/APP_NAME)" />&amp;page=<xsl:value-of 
    select="//CONTROLINFO/PAGE_NAME"/>&amp;<xsl:if test="//CONTROLINFO/PAGE_PID">pid=<xsl:value-of
    select="//CONTROLINFO/PAGE_PID"/>&amp;</xsl:if>lang=<xsl:value-of 
    select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;norm=<xsl:value-of
    select="normalize-space(//CONTROLINFO/STANDARD)"/>   
   </xsl:attribute>
   <xsl:attribute name="border">0</xsl:attribute>
   <xsl:attribute name="height">1</xsl:attribute>
   <xsl:attribute name="width">1</xsl:attribute>
  </img>
 </xsl:if>
</xsl:template>

<xsl:template name="ImageLogo">
 <xsl:param name="src" />
  <xsl:param name="alt" />	
	
  <img>
   <xsl:attribute name="src"><xsl:value-of select="$src"/></xsl:attribute>
   <xsl:attribute name="alt"><xsl:value-of select="$alt" /></xsl:attribute>
   <xsl:attribute name="border">0</xsl:attribute>
  </img>
 </xsl:template>

<xsl:template name="COPYRIGHTSCIELO">
	<center>
		&#169;&#160;<xsl:value-of select="@YEAR" />&#160;
		<i><font color="#000080"><xsl:value-of select="OWNER" /></font><br/></i>
		<img>
			<xsl:attribute name="src" ><xsl:value-of select="//PATH_GENIMG"/><xsl:value-of 						select="normalize-space(//CONTROLINFO/LANGUAGE)"/>/e-mailt.gif</xsl:attribute>
			<xsl:attribute name="alt" ><xsl:value-of select="CONTACT" /></xsl:attribute>
			<xsl:attribute name="border">0</xsl:attribute>
		</img>
		<br/>
		<xsl:call-template name="UpdateLog" />		
		<a class="email">
			<xsl:attribute name="href">mailto:<xsl:value-of select="CONTACT" /></xsl:attribute>
			<xsl:value-of select="CONTACT" />
		</a>
	</center>
</xsl:template>

<!-- Shows the formatted date
   DATEISO : Date in format yyyymmdd
   LANG : display language   
   ABREV : 1 - Abreviated -->
<xsl:template name="ShowDate">
    <xsl:param name="DATEISO" />
    <xsl:param name="LANG" />
    <xsl:param name="ABREV" />

    <xsl:choose>
        <xsl:when test=" $LANG = 'en' ">
            <xsl:call-template name="GET_MONTH_NAME">
                <xsl:with-param name="LANG" select="$LANG" />
                <xsl:with-param name="MONTH" select="substring($DATEISO,5,2)" />
                <xsl:with-param name="ABREV" select="$ABREV" />
            </xsl:call-template><xsl:text> </xsl:text><xsl:value-of 
              select=" substring($DATEISO,7,2) " />, <xsl:value-of select=" substring($DATEISO,1,4) " />
        </xsl:when>
        <xsl:when test=" $LANG != 'en' and $ABREV">
            <xsl:value-of select=" substring($DATEISO,7,2) " />-<xsl:call-template name="GET_MONTH_NAME">
                <xsl:with-param name="LANG" select="$LANG" />
                <xsl:with-param name="MONTH" select="substring($DATEISO,5,2)" />
                <xsl:with-param name="ABREV" select="$ABREV" />
            </xsl:call-template>-<xsl:value-of select=" substring($DATEISO,1,4) " />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select=" substring($DATEISO,7,2) " /> de <xsl:call-template name="GET_MONTH_NAME">
                <xsl:with-param name="LANG" select="$LANG" />
                <xsl:with-param name="MONTH" select="substring($DATEISO,5,2)" />
                <xsl:with-param name="ABREV" select="$ABREV" />
            </xsl:call-template> de <xsl:value-of select=" substring($DATEISO,1,4)" />
        </xsl:otherwise>
    </xsl:choose>        
</xsl:template>

<!-- Adds a link to a SciELO Log page 
     Parameters: pid - PID
                 script - Name of the script to be called -->
<xsl:template name="AddScieloLogLink">
    <xsl:param name="pid"/>
    <xsl:param name="script"/>   
    <xsl:param name="order"/>   
    <xsl:param name="dti"/>   
    <xsl:param name="dtf"/>   
    <xsl:param name="access"/>   
    <xsl:param name="cpage"/>   
    <xsl:param name="nlines"/>   
    <xsl:param name="tpages"/>   
    <xsl:param name="maccess"/>   

    <xsl:attribute name="href">http://<xsl:value-of 
        select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of 
        select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielolog.php?script=<xsl:value-of 
        select="$script"/>&amp;lng=<xsl:value-of 
        select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of 
        select="normalize-space(//CONTROLINFO/STANDARD)"/><xsl:if 
        test="$pid">&amp;pid=<xsl:value-of select="$pid" /></xsl:if><xsl:if 
        test="$order">&amp;order=<xsl:value-of select="$order" /></xsl:if><xsl:if 
        test="$dti">&amp;dti=<xsl:value-of select="$dti" /></xsl:if><xsl:if 
        test="$dtf">&amp;dtf=<xsl:value-of select="$dtf" /></xsl:if><xsl:if 
        test="$access">&amp;access=<xsl:value-of select="$access" /></xsl:if><xsl:if 
        test="$cpage">&amp;cpage=<xsl:value-of select="$cpage" /></xsl:if><xsl:if 
        test="$nlines">&amp;nlines=<xsl:value-of select="$nlines" /></xsl:if><xsl:if 
        test="$tpages">&amp;tpages=<xsl:value-of select="$tpages" /></xsl:if><xsl:if 
        test="$maccess">&amp;maccess=<xsl:value-of select="$maccess" /></xsl:if></xsl:attribute>
</xsl:template>

<!-- Prints message with the log start date (count started at..) 
     Parameters: date - log start date
-->
<xsl:template name="PrintLogStartDate">
    <xsl:param name="date" />
    
    <xsl:choose>
        <xsl:when test=" //CONTROLINFO/LANGUAGE = 'en' ">
            * &#160;Count started in 
            <xsl:call-template name="ShowDate">
                <xsl:with-param name="DATEISO" select="$date" />
                <xsl:with-param name="LANG">en</xsl:with-param>
            </xsl:call-template>
        </xsl:when>        
        <xsl:when test=" //CONTROLINFO/LANGUAGE = 'pt' ">
            * &#160;A contagem iniciou-se em 
            <xsl:call-template name="ShowDate">
                <xsl:with-param name="DATEISO" select="$date" />
                <xsl:with-param name="LANG">pt</xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test=" //CONTROLINFO/LANGUAGE = 'es' ">
            * &#160;La cuenta se empezo el 
            <xsl:call-template name="ShowDate">
                <xsl:with-param name="DATEISO" select="$date" />
                <xsl:with-param name="LANG">es</xsl:with-param>
            </xsl:call-template>
        </xsl:when>
    </xsl:choose>                                
</xsl:template>

<!-- Inserts javascript code in header
-->
<xsl:template name="SetLogJavascriptCode">
    <script>
        <xsl:attribute name="language">JavaScript</xsl:attribute>
        <xsl:attribute name="src">stat.js</xsl:attribute>
    </script>
</xsl:template>

<!-- Generates the main_form Form
    Parameters:
        script - php script to be called
        pid    - issn
-->
<xsl:template name="GenerateLogForm">
    <xsl:param name="script" />
    <xsl:param name="pid" />
    
    <xsl:attribute name="name">main_form</xsl:attribute>
    <xsl:attribute name="action">http://<xsl:value-of 
        select="CONTROLINFO/SCIELO_INFO/SERVER" /><xsl:value-of select="CONTROLINFO/SCIELO_INFO/PATH_DATA" />scielolog.php</xsl:attribute>
    <xsl:attribute name="method">GET</xsl:attribute>
    <xsl:attribute name="onSubmit">return validate();</xsl:attribute>
       
    <input type="hidden" name="script">
        <xsl:attribute name="value"><xsl:value-of select="$script" /></xsl:attribute>
    </input>
    
    <input type="hidden" name="pid">
        <xsl:attribute name="value"><xsl:value-of select="$pid" /></xsl:attribute>
    </input>

    <input type="hidden" name="lng">
        <xsl:attribute name="value"><xsl:value-of select="//CONTROLINFO/LANGUAGE" /></xsl:attribute>
    </input>

    <input type="hidden" name="nrm">
        <xsl:attribute name="value"><xsl:value-of select="//CONTROLINFO/STANDARD" /></xsl:attribute>
    </input>
    
    <input type="hidden" name="order">
        <xsl:attribute name="value"><xsl:value-of select="//STATPARAM/FILTER/ORDER" /></xsl:attribute>
    </input>
    
    <input type="hidden" name="dti">
        <xsl:attribute name="value"><xsl:value-of select="//STATPARAM/FILTER/INITIAL_DATE" /></xsl:attribute>
    </input>

    <input type="hidden" name="dtf">
        <xsl:attribute name="value"><xsl:value-of select="//STATPARAM/FILTER/FINAL_DATE" /></xsl:attribute>
    </input>
    
</xsl:template>

<!-- Prints the Date Selection TextBoxes
-->
<xsl:template name="PrintDateRangeSelection">
  <script language="javascript">
    <xsl:comment>
      setLanguage('<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)" />');
      setStartDate('<xsl:value-of select="normalize-space(//STATPARAM/START_DATE)" />');
      setLastDate('<xsl:value-of select="normalize-space(//STATPARAM/CURRENT_DATE)" />')

      CreateForm('<xsl:value-of select="//STATPARAM/FILTER/INITIAL_DATE" />', '<xsl:value-of select="//STATPARAM/FILTER/FINAL_DATE" />');
    // </xsl:comment>
  </script>
</xsl:template>

<!-- Prints the submit button (reload button)
-->
<xsl:template name="PutSubmitButton">
    <xsl:choose>
        <xsl:when test=" //CONTROLINFO/LANGUAGE = 'en' ">
            <input type="submit" value="Reload" />
        </xsl:when>
        <xsl:when test=" //CONTROLINFO/LANGUAGE = 'pt' ">
            <input type="submit" value="Recarregar" />
        </xsl:when>
        <xsl:when test=" //CONTROLINFO/LANGUAGE = 'es' ">
            <input type="submit" value="Recargar" />
        </xsl:when>    
    </xsl:choose>
</xsl:template>

<!-- Shows empty query message -->
<xsl:template name="ShowEmptyQueryResult">
    <hr/>
    <p>
        <center>
            <font color="blue">
            <xsl:choose>
                <xsl:when test=" //CONTROLINFO/LANGUAGE = 'en' ">There are no statistics for that period.</xsl:when>
                <xsl:when test=" //CONTROLINFO/LANGUAGE = 'pt' ">Não existem estatísticas nesse período.</xsl:when>
                <xsl:when test=" //CONTROLINFO/LANGUAGE = 'es' ">No existen estadísticas para ese período.</xsl:when>    
            </xsl:choose>
            </font>
        </center>
    </p>
    <hr/>
</xsl:template>

<xsl:template  match="LANGUAGES">
    <xsl:param name="LANG" select="//CONTROLINFO/LANGUAGE" />
    <xsl:param name="PID" />
    <xsl:param name="VERIFY" />
    
    <div align="left">
    <!--    <table align="left" width="100%">
       <tr>
	     <td width="7%">&#160;</td>
           <td width="93%"> -->
           &#160;&#160;&#160;
            <xsl:apply-templates select="ABSTRACT_LANGS">
                <xsl:with-param name="LANG" select="$LANG" />
                <xsl:with-param name="PID" select="$PID"  />
            </xsl:apply-templates>
            <!-- tr -->
                <!-- td -->
                    <xsl:apply-templates select="ART_TEXT_LANGS">
                        <xsl:with-param name="LANG" select="$LANG" />
                        <xsl:with-param name="PID" select="$PID"  />
                    </xsl:apply-templates>

                    <xsl:apply-templates select="PDF_LANGS">
                        <xsl:with-param name="LANG" select="$LANG" />
                        <xsl:with-param name="PID" select="$PID"  />
                    </xsl:apply-templates>
                    
                    <xsl:if test="$VERIFY">
                        &#160;&#160;&#160;&#160;
                        <xsl:call-template name="CREATE_VERIFY_LINK">
                            <xsl:with-param name="PID" select="$PID"/>
                        </xsl:call-template>
                    </xsl:if>
       <!--         </td>
            </tr>
        </table> -->
    </div>
</xsl:template>

<xsl:template match="ABSTRACT_LANGS">
       <xsl:param name="LANG" />
       <xsl:param name="PID" />
<!--       <tr>
           <td>             -->
 
               &#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font>

<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->        

                <xsl:apply-templates select="LANG[.=$LANG]" mode="abstract">
                    <xsl:with-param name="LANG" select="$LANG" />
                    <xsl:with-param name="PID" select="$PID"/>
                </xsl:apply-templates>
                               
                <xsl:apply-templates select="LANG[.!=$LANG]" mode="abstract">
                    <xsl:with-param name="LANG" select="$LANG" />
                    <xsl:with-param name="PID" select="$PID"/>
                    <xsl:with-param name="CONTINUATION" select="(LANG[.=$LANG]!='')"/>
                </xsl:apply-templates>
            <!-- /td -->
        <!-- /tr -->
</xsl:template>

<xsl:template match="ART_TEXT_LANGS">
       <xsl:param name="LANG" />
       <xsl:param name="PID" />

           &#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font>

       <!-- <xsl:choose>
           <xsl:when test=" $LANG = 'en' "> text in </xsl:when>
           <xsl:when test=" $LANG = 'es' "> texto en </xsl:when>
           <xsl:when test=" $LANG = 'pt' "> texto em </xsl:when>
       </xsl:choose> -->

<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->        

               <xsl:apply-templates select="LANG[.=$LANG]" mode="text">
                    <xsl:with-param name="LANG" select="$LANG" />
                    <xsl:with-param name="PID" select="$PID"/>
               </xsl:apply-templates>

               <xsl:apply-templates select="LANG[.!=$LANG]" mode="text">
                    <xsl:with-param name="LANG" select="$LANG" />
                    <xsl:with-param name="PID" select="$PID"/>
                    <xsl:with-param name="CONTINUATION" select="(LANG[.=$LANG]!='')"/>                    
               </xsl:apply-templates>

       <!--xsl:variable name="SPOS">
           <xsl:for-each select="LANG">
               <xsl:if test=" text() = $LANG ">
                   <xsl:value-of select="position()" />
               </xsl:if>
           </xsl:for-each>
       </xsl:variable>

       <xsl:choose>
           <xsl:when test=" $SPOS > 0">
               <xsl:apply-templates select="LANG[ position() = $SPOS ]" mode="text">
                    <xsl:with-param name="LANG" select="$LANG" />
                    <xsl:with-param name="PID" select="$PID"/>
               </xsl:apply-templates>
           </xsl:when>
           <xsl:otherwise>
               <xsl:apply-templates select="LANG[ position() = 1 ]" mode="text">
                    <xsl:with-param name="LANG" select="$LANG" />
                    <xsl:with-param name="PID" select="$PID"/>
               </xsl:apply-templates>
           </xsl:otherwise>
       </xsl:choose-->
</xsl:template>

<xsl:template match="PDF_LANGS">
       <xsl:param name="LANG" />
       <xsl:param name="PID" />

       &#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font>

<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->        
              
               <xsl:apply-templates select="LANG[.=$LANG]" mode="pdf">
                    <xsl:with-param name="LANG" select="$LANG" />
                    <xsl:with-param name="PID" select="$PID"/>
               </xsl:apply-templates>

               <xsl:apply-templates select="LANG[.!=$LANG]" mode="pdf">
                    <xsl:with-param name="LANG" select="$LANG" />
                    <xsl:with-param name="PID" select="$PID"/>
                    <xsl:with-param name="CONTINUATION" select="(LANG[.=$LANG]!='')"/>                    
               </xsl:apply-templates>
</xsl:template>

<xsl:template match="LANG" mode="abstract">
       <xsl:param name="LANG" />
       <xsl:param name="PID" />
       <xsl:param name="CONTINUATION" />

<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->        

	<xsl:if test="$CONTINUATION or (not($CONTINUATION) and position()>1)"> |</xsl:if>
       <xsl:call-template name="CREATE_ARTICLE_LINK">
           <xsl:with-param name="TYPE">abstract</xsl:with-param>
           <xsl:with-param name="INTLANG" select="$LANG"/>
           <xsl:with-param name="TXTLANG" select="text()"/>
           <xsl:with-param name="PID" select="$PID"/>
           <xsl:with-param name="FIRST_LABEL">
              <xsl:choose>
                  <xsl:when test="$CONTINUATION">0</xsl:when>
                  <xsl:when test="not($CONTINUATION) and position()>1">0</xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
              </xsl:choose>
           </xsl:with-param>
       </xsl:call-template>					
</xsl:template>

<xsl:template match="LANG" mode="text">
       <xsl:param name="LANG" />
       <xsl:param name="PID" />

<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->        

       <xsl:param name="CONTINUATION" />
	  <xsl:if test="$CONTINUATION or (not($CONTINUATION) and position()>1)"> |</xsl:if>
       <xsl:call-template name="CREATE_ARTICLE_LINK">
           <xsl:with-param name="TYPE">full</xsl:with-param>
           <xsl:with-param name="INTLANG" select="$LANG"/>
           <xsl:with-param name="TXTLANG" select="text()"/>
           <xsl:with-param name="PID" select="$PID"/>
           <xsl:with-param name="FIRST_LABEL">
              <xsl:choose>
                  <xsl:when test="$CONTINUATION">0</xsl:when>
                  <xsl:when test="not($CONTINUATION) and position()>1">0</xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
              </xsl:choose>
           </xsl:with-param>
       </xsl:call-template>					
</xsl:template>

<xsl:template match="LANG" mode="pdf">
       <xsl:param name="LANG" />
       <xsl:param name="PID" />

<!-- fixed 20040122 - ordem dos idiomas, primeiro o idioma da interface, seguido pelos outros idiomas -->        

       <xsl:param name="CONTINUATION" />
	  <xsl:if test="$CONTINUATION or (not($CONTINUATION) and position()>1)"> |</xsl:if>

       <xsl:call-template name="CREATE_ARTICLE_LINK">
           <xsl:with-param name="TYPE">pdf</xsl:with-param>
           <xsl:with-param name="INTLANG" select="$LANG"/>
           <xsl:with-param name="TXTLANG" select="text()"/>
           <xsl:with-param name="PID" select="$PID"/>
           <xsl:with-param name="FIRST_LABEL">
              <xsl:choose>
                  <xsl:when test="$CONTINUATION">0</xsl:when>
                  <xsl:when test="not($CONTINUATION) and position()>1">0</xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
              </xsl:choose>
           </xsl:with-param>
       </xsl:call-template>					
</xsl:template>

<!-- Original version. It is commented to avoid mind change troubles

<xsl:template  match="LANGUAGES">
    <xsl:param name="PID" />
    <xsl:param name="VERIFY" />

    <table align="center">
        <xsl:attribute name="width"><xsl:if test="count(*) > 1">480</xsl:if></xsl:attribute>
        <xsl:call-template name="PrintLanguagesLinks">
            <xsl:with-param name="counter" select="1" />
            <xsl:with-param name="maxlines" select="@MAXLINES" />
            <xsl:with-param name="pid" select="$PID" />
            <xsl:with-param name="verify" select="$VERIFY" />
        </xsl:call-template>
    </table>
</xsl:template>

<xsl:template name="PrintLanguagesLinks">
    <xsl:param name="counter" />
    <xsl:param name="maxlines" />
    <xsl:param name="pid" />
    <xsl:param name="verify" />
	
    <xsl:choose>
        <xsl:when test="$counter > $maxlines"></xsl:when>
        <xsl:otherwise>
            <tr>
                <xsl:apply-templates select="ABSTRACT_LANGS">
                    <xsl:with-param name="type">abstract</xsl:with-param>
                    <xsl:with-param name="counter" select="$counter" />
                    <xsl:with-param name="pid" select="$pid" />
                </xsl:apply-templates>

                <xsl:apply-templates select="ART_TEXT_LANGS">
                    <xsl:with-param name="type">full</xsl:with-param>
                    <xsl:with-param name="counter" select="$counter" />
                    <xsl:with-param name="pid" select="$pid" />
                </xsl:apply-templates>

                <xsl:apply-templates select="PDF_LANGS">
                    <xsl:with-param name="type">pdf</xsl:with-param>
                    <xsl:with-param name="counter" select="$counter" />
                    <xsl:with-param name="pid" select="$pid" />
                </xsl:apply-templates>

                <xsl:if test="$verify">
                    <td valign="top" align="left">
                        <xsl:choose>
			        <xsl:when test="$counter = 1">
                                <xsl:call-template name="CREATE_VERIFY_LINK">
                                    <xsl:with-param name="PID" select="$pid"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>&#160;</xsl:otherwise>
                        </xsl:choose>
                    </td>
                </xsl:if>
            </tr>

            <xsl:call-template name="PrintLanguagesLinks">
                <xsl:with-param name="counter" select="$counter+1"></xsl:with-param>
                <xsl:with-param name="maxlines" select="$maxlines"></xsl:with-param>
                <xsl:with-param name="pid" select="$pid"></xsl:with-param>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>	
</xsl:template>

<xsl:template match="ABSTRACT_LANGS | ART_TEXT_LANGS | PDF_LANGS">
    <xsl:param name="type" />
    <xsl:param name="counter" />
    <xsl:param name="pid" />

    <td valign="top" align="left">
        <xsl:choose>
            <xsl:when test="LANG[$counter]">
                <xsl:call-template name="CREATE_ARTICLE_LINK">
                    <xsl:with-param name="TYPE" select="$type" />
                    <xsl:with-param name="INTLANG" select="//CONTROLINFO/LANGUAGE"/>
                    <xsl:with-param name="TXTLANG" select="LANG[$counter]"/>
                    <xsl:with-param name="PID" select="$pid"/>
                </xsl:call-template>					
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
    </td>
</xsl:template>
-->

<xsl:template name="CREATE_VERIFY_LINK">
 <xsl:param name="PID" />

 <font face="Symbol" color="#800000">Ñ </font>
 <a>
 <xsl:attribute name="href">http://<xsl:value-of 
   select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of 
   select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_verify&amp;pid=<xsl:value-of 
   select="$PID" /></xsl:attribute>see mst o/h/f records</a> 

</xsl:template>

<!-- Prints Information about authors, title and strip 
   Parameters:
             NORM - (abn | iso | van)
             LANG - language code
	      LINK = 1 - prints authors with link
	      SHORTTITLE - Opcional
-->
<xsl:template name="PrintAbstractHeaderInformation">
  <xsl:param name="LANG" />
  <xsl:param name="NORM" />  
  <xsl:param name="AUTHLINK">0</xsl:param>

  <xsl:choose>
   <xsl:when test=" $NORM = 'iso' ">
    <xsl:call-template name="PrintArticleReferenceISO">
     <xsl:with-param name="LANG" select="$LANG"/>
     <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
     <xsl:with-param name="AUTHORS" select="AUTHORS"/>
     <xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
     <xsl:with-param name="VOL" select="ISSUEINFO/@VOL" />
     <xsl:with-param name="NUM" select="ISSUEINFO/@NUM" />
     <xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL" />
     <xsl:with-param name="MONTH" select="ISSUEINFO/STRIP/MONTH" />
     <xsl:with-param name="YEAR" select="ISSUEINFO/STRIP/YEAR" />
     <xsl:with-param name="ISSN" select="ISSUEINFO/ISSN"/>
     <xsl:with-param name="FPAGE" select="@FPAGE"/>
     <xsl:with-param name="LPAGE" select="@LPAGE"/>
     <xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE" />
   </xsl:call-template>
   </xsl:when>
   <xsl:when test=" $NORM = 'van' ">
    <xsl:call-template name="PrintArticleReferenceVAN"> 
     <xsl:with-param name="LANG" select="$LANG"/>
     <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
     <xsl:with-param name="AUTHORS" select="AUTHORS"/>
     <xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
     <xsl:with-param name="VOL" select="ISSUEINFO/@VOL" />
     <xsl:with-param name="NUM" select="ISSUEINFO/@NUM" />
     <xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL" />
     <xsl:with-param name="MONTH">
      <xsl:call-template name="GET_MONTH_NAME">
       <xsl:with-param name="LANG" select="$LANG"/>
       <xsl:with-param name="MONTH" select="ISSUEINFO/@MONTH" />
       <xsl:with-param name="ABREV">1</xsl:with-param>
      </xsl:call-template>
     </xsl:with-param>
     <xsl:with-param name="YEAR" select="ISSUEINFO/@YEAR" />
     <xsl:with-param name="ISSN" select="ISSUEINFO/ISSN"/>
     <xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE" />
   </xsl:call-template>
   </xsl:when>
   <xsl:when test=" $NORM = 'abn' ">
    <xsl:call-template name="PrintArticleReferenceABN">
     <xsl:with-param name="LANG" select="$LANG"/>
     <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
     <xsl:with-param name="AUTHORS" select="AUTHORS"/>
     <xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
     <xsl:with-param name="VOL" select="ISSUEINFO/@VOL" />
     <xsl:with-param name="NUM" select="ISSUEINFO/@NUM" />
     <xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL" />
     <xsl:with-param name="MONTH">
      <xsl:call-template name="GET_MONTH_NAME">
       <xsl:with-param name="LANG" select="$LANG"/>
       <xsl:with-param name="MONTH" select="ISSUEINFO/@MONTH" />
       <xsl:with-param name="ABREV">1</xsl:with-param>
      </xsl:call-template>
     </xsl:with-param>
     <xsl:with-param name="YEAR" select="ISSUEINFO/@YEAR" />
     <xsl:with-param name="CITY" select="ISSUEINFO/STRIP/CITY" />
     <xsl:with-param name="ISSN" select="ISSUEINFO/ISSN"/>
     <xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE" />
    </xsl:call-template>
   </xsl:when>
  </xsl:choose>
  
</xsl:template>


<!-- Prints Article Reference  in ISO 690:1987 Format
	
	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	AUTHORS: AUTHORS element Node
	ARTTITLE: Title of the article
	VOL: Volumn
	NUM: Number
	SUPPL: Supplement
	MONTH: month name
	YEAR: year
	ISSN: issn of the journal
	FPAGE: first page of the article
	LPAGE: last page of the article
	SHORTTITLE: short title of the journal
-->
 <xsl:template name="PrintArticleReferenceISO">
  <xsl:param name="LANG" />
  <xsl:param name="AUTHLINK">0</xsl:param>
  <xsl:param name="AUTHORS" />
  <xsl:param name="ARTTITLE" />
  <xsl:param name="VOL" />
  <xsl:param name="NUM" />
  <xsl:param name="SUPPL" />
  <xsl:param name="MONTH" />
  <xsl:param name="YEAR" />
  <xsl:param name="ISSN" />
  <xsl:param name="FPAGE" />
  <xsl:param name="LPAGE" />
  <xsl:param name="SHORTTITLE" select="//TITLEGROUP/SHORTTITLE" />
  <xsl:param name="BOLD">1</xsl:param>

  <xsl:call-template name="PrintAuthorsISO">
   <xsl:with-param name="AUTHORS" select="$AUTHORS" />
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
  </xsl:call-template>
  <xsl:if test="$ARTTITLE">
   <xsl:choose>
    <xsl:when test=" $BOLD = 1">
     <font class="negrito">
      <xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes" />
     </font><xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes" /><xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:if>
  <i><xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes" /></i>,
  <xsl:value-of select="concat(' ', $MONTH)" /><xsl:value-of select="concat(' ', $YEAR)" />,
  <xsl:if test="$VOL"><xsl:value-of select="concat(' vol.', $VOL)" /><xsl:if test="$NUM">,</xsl:if></xsl:if>
  <xsl:if test="$NUM"><xsl:value-of select="concat(' no.', $NUM)" /><xsl:if test="$SUPPL">,</xsl:if></xsl:if>
  <xsl:if test="$SUPPL">
    <xsl:choose>
     <xsl:when test=" $LANG='en' "> suppl</xsl:when>
     <xsl:otherwise> supl</xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$SUPPL>0">.<xsl:value-of select="$SUPPL" /></xsl:if>
  </xsl:if> 
  <xsl:if test="$FPAGE and $LPAGE">
   <xsl:value-of select="concat(', p.', $FPAGE, '-', $LPAGE)" />
  </xsl:if>
  <xsl:value-of select="concat('. ISSN ', $ISSN, '.')" />
 </xsl:template>
 
<!-- Prints Article Reference (Electronic) in ISO 690-2:1997 Format
	
	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	AUTHORS: AUTHORS element Node
	ARTTITLE: Title of the article
	VOL: Volumn
	NUM: Number
	SUPPL: Supplement
	MONTH: month name
	YEAR: year
	CURR_DATE: current date in yyyymmdd format
	PID: pid of the article
	ISSN: issn of the journal
	FPAGE: first page of the article
	LPAGE: last page of the article
	SHORTTITLE: short title of the journal
 -->
 <xsl:template name="PrintArticleReferenceElectronicISO">
  <xsl:param name="LANG" />
  <xsl:param name="AUTHLINK">0</xsl:param>
  <xsl:param name="AUTHORS" />
  <xsl:param name="ARTTITLE" />
  <xsl:param name="VOL" />
  <xsl:param name="NUM" />
  <xsl:param name="SUPPL" />
  <xsl:param name="MONTH" />
  <xsl:param name="YEAR" />
  <xsl:param name="CURR_DATE" />
  <xsl:param name="PID" />
  <xsl:param name="ISSN" />
  <xsl:param name="FPAGE" />
  <xsl:param name="LPAGE" />
  <xsl:param name="SHORTTITLE" select="//TITLEGROUP/SHORTTITLE" />

  <xsl:call-template name="PrintAuthorsISO">
   <xsl:with-param name="AUTHORS" select="$AUTHORS" />
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
  </xsl:call-template>
  <xsl:if test="$ARTTITLE != '' ">
   <font class="negrito">
    <xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes" /><xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
   </font>
  </xsl:if>
  <i><xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes" /></i><xsl:if test="substring($SHORTTITLE,string-length($SHORTTITLE)) != '.' ">.</xsl:if>

  <!--xsl:if test="$ISSN/@TYPE">
   <xsl:value-of select=" concat(' [', $ISSN/@TYPE, '].') " />
  </xsl:if-->
  [online].
  <xsl:value-of select="concat(' ', $MONTH)" /><xsl:value-of select="concat(' ', $YEAR)" />,
  <xsl:if test="$VOL"><xsl:value-of select="concat(' vol.', $VOL)" /><xsl:if test="$NUM">,</xsl:if></xsl:if>
  <xsl:if test="$NUM"><xsl:value-of select="concat(' no.', $NUM)" /><xsl:if test="$SUPPL">,</xsl:if></xsl:if>
  <xsl:if test="$SUPPL">
    <xsl:choose>
     <xsl:when test=" $LANG='en' "> suppl.</xsl:when>
     <xsl:otherwise> supl.</xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$SUPPL>0"><xsl:value-of select="$SUPPL" /></xsl:if>
  </xsl:if> 
  <xsl:if test="$CURR_DATE">
   <xsl:choose>
    <xsl:when test=" $LANG = 'en' "> [cited</xsl:when>
    <xsl:when test=" $LANG = 'pt' "> [citado</xsl:when>
    <xsl:when test=" $LANG = 'es' "> [citado</xsl:when>
   </xsl:choose>
   <xsl:value-of select="concat(' ', substring($CURR_DATE,7,2),' ')" />
   <xsl:call-template name="GET_MONTH_NAME">
    <xsl:with-param name="LANG" select="$LANG" />
    <xsl:with-param name="MONTH" select="substring($CURR_DATE,5,2)" />
   </xsl:call-template>
   <xsl:value-of select="concat(' ',substring($CURR_DATE,1,4),']')" />
  </xsl:if>
  <xsl:if test="$FPAGE and $LPAGE">
   <xsl:value-of select="concat(', p.', $FPAGE, '-', $LPAGE, '.')" />
  </xsl:if>
  <xsl:choose>
   <xsl:when test=" $LANG = 'en' "> Available from World Wide Web: </xsl:when>
   <xsl:when test=" $LANG = 'pt' "> Disponível na  World Wide Web: </xsl:when>
   <xsl:when test=" $LANG = 'es' "> Disponible en la World Wide Web: </xsl:when>
  </xsl:choose>
  
  &lt;<!--a>	<xsl:call-template name="AddScieloLink" >
  	 <xsl:with-param name="seq" select="$PID" />
  	 <xsl:with-param name="script">sci_arttext</xsl:with-param>
  	</xsl:call-template-->http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_arttext&amp;pid=<xsl:value-of select="$PID"/>&amp;lng=<xsl:value-of select="$LANG"/>&amp;nrm=iso<!--/a-->&gt;<xsl:value-of select="concat('. ISSN ', $ISSN, '.')" />
 </xsl:template>
 
<!-- Prints Authors list  in ISO Format: SURNAME1, Name1, SURNAME2, Name2, SURNAME3, Name3 et al.   
       or

       SURNAME1, Name1 and SURNAME2, Name2       (if num authors <= 3 authors)
       
	Parameters:
	AUTHORS: AUTHORS element Node
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
-->  		  		 
 <xsl:template name="PrintAuthorsISO">
  <xsl:param name="AUTHORS"/>
  <xsl:param name="LANG"/>
  <xsl:param name="AUTHLINK"/> 
  
  <xsl:apply-templates select="$AUTHORS/AUTH_PERS/AUTHOR" mode="PERS_ISO">
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
   <xsl:with-param name="NUM_CORP" select="count($AUTHORS/AUTH_CORP/AUTHOR)" />
  </xsl:apply-templates>

  <xsl:apply-templates select="$AUTHORS/AUTH_CORP/AUTHOR" mode="CORP_ISO">
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="MAX" select="4 - count($AUTHORS/AUTH_PERS/AUTHOR)" />
  </xsl:apply-templates>

 </xsl:template>

<!-- Prints Author (Person) in ISO Format 

	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	NUM_CORP: number of corporative authors

-->  		  		
 <xsl:template match="AUTHOR" mode="PERS_ISO">
  <xsl:param name="LANG" />
  <xsl:param name="AUTHLINK" />
  <xsl:param name="NUM_CORP" />
  <xsl:variable name="length" select="normalize-space(string-length(NAME))" />
  
  <xsl:choose>
    <!-- If number of authors > 3 prints et al. and terminate -->
   <xsl:when test=" position() = 4 "><i> et al</i>. </xsl:when> 
   <xsl:when test=" position() > 4 "></xsl:when>
  
   <xsl:otherwise>
    <!-- Prints author in format SURNAME1, Name1, SURNAME2, Name2, SURNAME3, Name3 et al -->
    <xsl:call-template name="CreateAuthor">
     <xsl:with-param name="SURNAME" select="UPP_SURNAME" /> <!-- Uppercase -->
     <!--xsl:with-param name="NAME">
      <xsl:value-of select=" normalize-space(translate(NAME, '.', '')) " /><xsl:if
       test=" substring(NAME, $length, 1) = '.' ">.</xsl:if>
     </xsl:with-param-->
     <xsl:with-param name="NAME" select="NAME" />
     <xsl:with-param name="SEARCH"><xsl:if test=" $AUTHLINK = 1 "><xsl:value-of select="@SEARCH" /></xsl:if></xsl:with-param>
     <xsl:with-param name="LANG" select="$LANG" />
     <xsl:with-param name="NORM">iso</xsl:with-param>
     <xsl:with-param name="SEPARATOR">,</xsl:with-param>
    </xsl:call-template>
    <xsl:choose>
     <xsl:when test=" position() = last() and $NUM_CORP = 0 ">
      <xsl:if test=" substring (NAME, $length, 1) != '.' ">.</xsl:if><xsl:text> </xsl:text>
     </xsl:when>
     <!-- Case next author is the last one (not et al), displays ' and ' or equivalent form -->
     <xsl:when test=" position() != 3 and
       ( (position() = last()-1and $NUM_CORP = 0) or (position() = last() and $NUM_CORP = 1) )">
       <xsl:choose>
        <xsl:when test=" $LANG = 'en' "> and </xsl:when>
        <xsl:when test=" $LANG = 'pt' "> e </xsl:when>
        <xsl:when test=" $LANG = 'es' "> y </xsl:when>
       </xsl:choose>
      </xsl:when>
      <!-- Separate authors names by ', '. -->
      <xsl:when test=" position() != 3 ">, </xsl:when>   
    </xsl:choose>
   </xsl:otherwise>
  
  </xsl:choose>
 </xsl:template>

<!-- Prints Author (Corporative) in ISO Format  The max number of authors to be printed is passed as an   argument.

	Parameters:
	LANG: language
	MAX: max number of authors
-->  		  		
 <xsl:template match="AUTHOR" mode="CORP_ISO">
   <xsl:param name="LANG" />
   <xsl:param name="MAX" />

   <xsl:choose>
    <xsl:when test=" position() = $MAX "><i> et al</i>. </xsl:when>
    <xsl:when test=" position() > $MAX "></xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="normalize-space(UPP_ORGNAME)"  disable-output-escaping="yes" />
     <xsl:if test="ORGNAME and ORGDIV">. </xsl:if>
     <xsl:value-of select="normalize-space(ORGDIV)"  disable-output-escaping="yes" />
     <xsl:choose>
      <xsl:when test=" position() = last() ">. </xsl:when>
      
      <xsl:when test=" position() = last() - 1 and last() != $MAX ">
       <xsl:choose>
        <xsl:when test=" $LANG = 'en' "> and </xsl:when>
        <xsl:when test=" $LANG = 'pt' "> e </xsl:when>
        <xsl:when test=" $LANG = 'es' "> y </xsl:when>
       </xsl:choose>
      </xsl:when>
      
      <xsl:when test=" position() + 1 != $MAX ">, </xsl:when>
      </xsl:choose>
    </xsl:otherwise>
   </xsl:choose>

 </xsl:template>

<!-- Prints an Author with surname and name separated by a separator string. If search expression is defined,
 prints a link to search engine passing language and format as parameters.
 
Parameters:
 SURNAME: Surname 
 NAME: Name
 SEARCH: Search Expression
 LANG: language
 NORM: format
 SEPARATOR: separator string
-->
 <xsl:template name="CreateAuthor">
  <xsl:param name="SURNAME" />
  <xsl:param name="NAME" />
  <xsl:param name="SEARCH" />
  <xsl:param name="LANG" />
  <xsl:param name="NORM" />
  <xsl:param name="SEPARATOR" />

  <xsl:variable name="SERVER" select="//SERVER" />
  <xsl:variable name="PATH_WXIS" select="//PATH_WXIS" />
  <xsl:variable name="PATH_DATA_IAH" select="//PATH_DATA_IAH"/>
  <xsl:variable name="PATH_CGI_IAH" select="//PATH_CGI_IAH"/>
  <xsl:variable name="LANG_IAH">
   <xsl:choose>
     <xsl:when test=" $LANG='en' ">i</xsl:when>
     <xsl:when test=" $LANG='es' ">e</xsl:when>
     <xsl:when test=" $LANG='pt' ">p</xsl:when>
   </xsl:choose>
  </xsl:variable>

  <xsl:choose>
   <!-- if SEARCH expression is present prints the link -->
   <xsl:when test=" $SEARCH != '' ">
    <a href="http://{$SERVER}{$PATH_WXIS}{$PATH_DATA_IAH}?IsisScript={$PATH_CGI_IAH}iah.xis&amp;base=article^dlibrary&amp;format={$NORM}.pft&amp;lang={$LANG_IAH}&amp;nextAction=lnk&amp;indexSearch=AU&amp;exprSearch={$SEARCH}">     
     <xsl:value-of select="$SURNAME" disable-output-escaping="yes" />
     <!-- Displays separator character and space -->
     <xsl:if test=" $NAME and $SURNAME ">
      <xsl:value-of select="concat($SEPARATOR, ' ')" />
     </xsl:if>
     <xsl:value-of select="$NAME" disable-output-escaping="yes" />
    </a>
   </xsl:when>
   <!-- Otherwise, prints only the author -->
   <xsl:otherwise>
     <xsl:value-of select="$SURNAME" disable-output-escaping="yes" />
     <!-- Displays separator character and space -->
     <xsl:if test=" $NAME and $SURNAME ">
      <xsl:value-of select="concat($SEPARATOR, ' ')" />
     </xsl:if>
     <xsl:value-of select="$NAME" disable-output-escaping="yes" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

<!-- Prints Article Reference  in Vancouver Format
	
	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	AUTHORS: AUTHORS element Node
	ARTTITLE: Title of the article
	VOL: Volumn
	NUM: Number
	SUPPL: Supplement
	MONTH: month name (abbrev)
	YEAR: year
	ISSN: issn of the journal
	SHORTTITLE: short title of the journal
-->
 <xsl:template name="PrintArticleReferenceVAN"> 
  <xsl:param name="LANG" />
  <xsl:param name="AUTHLINK">0</xsl:param>
  <xsl:param name="AUTHORS" />
  <xsl:param name="ARTTITLE" />
  <xsl:param name="VOL" />
  <xsl:param name="NUM" />
  <xsl:param name="SUPPL" />
  <xsl:param name="MONTH" />
  <xsl:param name="YEAR" />
  <xsl:param name="ISSN" />
  <xsl:param name="SHORTTITLE" select="//TITLEGROUP/SHORTTITLE" />

  <xsl:call-template name="PrintAuthorsVAN">
   <xsl:with-param name="AUTHORS" select="$AUTHORS" />
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
  </xsl:call-template>
  <xsl:if test="$ARTTITLE">
   <font class="negrito">
    <xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes" />
   </font><xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
  </xsl:if>
  <i><xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes" /></i>,
  <xsl:value-of select="concat(' ', $YEAR, ' ', $MONTH)" disable-output-escaping="yes" />;
  <xsl:if test="$VOL"><xsl:value-of select="concat(' ', $VOL)" /></xsl:if>
  <xsl:if test="$NUM">(<xsl:value-of select="$NUM" />)</xsl:if>
  <xsl:if test="$SUPPL">
   <xsl:choose>
    <xsl:when test=" $LANG='en' "> suppl</xsl:when>
    <xsl:otherwise> supl</xsl:otherwise>
   </xsl:choose>
   <xsl:if test="$SUPPL>0">.<xsl:value-of select="$SUPPL" /></xsl:if>
  </xsl:if>
  <xsl:value-of select="concat('. ISSN ', $ISSN, '.')" />
 </xsl:template>
 
 
 <!-- Prints Authors list  in Vancouver Format:
       Surname1 Name1, Surname2  Name2, Surname3  Name3, Surname4 Name4, Surname5  Name5, Surname6  Name6 et al.   or

       Surname1 Name1, Surname2 Name2       (if num authors <= 6 authors)

	Parameters:
	AUTHORS: AUTHORS element Node
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
-->  		  	
 <xsl:template name="PrintAuthorsVAN">
  <xsl:param name="AUTHORS"/>
  <xsl:param name="LANG"/>
  <xsl:param name="AUTHLINK"/> 
  
  <xsl:apply-templates select="$AUTHORS/AUTH_PERS/AUTHOR" mode="PERS_VAN">
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
   <xsl:with-param name="NUM_CORP" select="count($AUTHORS/AUTH_CORP/AUTHOR)" />
  </xsl:apply-templates>

  <xsl:apply-templates select="$AUTHORS/AUTH_CORP/AUTHOR" mode="CORP_VAN">
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="MAX" select="7 - count($AUTHORS/AUTH_PERS/AUTHOR)" />
  </xsl:apply-templates>

 </xsl:template>

<!-- Prints Author (Person) in Vancouver Format 

	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	NUM_CORP: number of corporative authors

-->  		  		
 <xsl:template match="AUTHOR" mode="PERS_VAN">
  <xsl:param name="LANG" />
  <xsl:param name="AUTHLINK" />
  <xsl:param name="NUM_CORP" />
  <xsl:variable name="length" select="normalize-space(string-length(NAME))" />
  
  <xsl:choose>
    <!-- If number of authors > 3 prints et al. and terminate -->
   <xsl:when test=" position() = 7 "><i> et al</i>. </xsl:when> 
   <xsl:when test=" position() > 7 "></xsl:when>
  
   <xsl:otherwise>
    <!-- Prints author in format Surname1 Name1, Surname2 Name2, Surname3 Name3,
          Surname4 Name4, Surname5 Name5, Surname6 Name6 et al -->
    <xsl:call-template name="CreateAuthor">
     <xsl:with-param name="SURNAME" select="SURNAME" /> <!-- Uppercase -->
     <!--xsl:with-param name="NAME">
      <xsl:value-of select=" normalize-space(translate(NAME, '.', '')) " /><xsl:if
       test=" substring(NAME, $length, 1) = '.' ">.</xsl:if>
     </xsl:with-param-->
     <xsl:with-param name="NAME" select="NAME" />
     <xsl:with-param name="SEARCH"><xsl:if test=" $AUTHLINK = 1 "><xsl:value-of select="@SEARCH" /></xsl:if></xsl:with-param>
     <xsl:with-param name="LANG" select="$LANG" />
     <xsl:with-param name="NORM">van</xsl:with-param>
     <xsl:with-param name="SEPARATOR"></xsl:with-param>
    </xsl:call-template>
    <xsl:choose>
     <!-- Last author -->
     <xsl:when test=" position() = last() and $NUM_CORP = 0 ">
      <xsl:if test=" substring (NAME, $length, 1) != '.' ">.</xsl:if><xsl:text> </xsl:text>
     </xsl:when>
     <!-- Separate authors names by ', '. -->
      <xsl:when test=" position() != 6 ">, </xsl:when>   
    </xsl:choose>
   </xsl:otherwise>
  
  </xsl:choose>
 </xsl:template>
 
<!-- Prints Author (Corporative) in Vancouver Format  The max number of authors to be printed is passed as an   argument.

	Parameters:
	LANG: language
	MAX: max number of authors
-->  		  
 <xsl:template match="AUTHOR" mode="CORP_VAN">
   <xsl:param name="LANG" />
   <xsl:param name="MAX" />

   <xsl:choose>
    <xsl:when test=" position() = $MAX "><i> et al</i>. </xsl:when>
    <xsl:when test=" position() > $MAX "></xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="normalize-space(ORGNAME)"  disable-output-escaping="yes" />
     <xsl:if test="ORGNAME and ORGDIV">. </xsl:if>
     <xsl:value-of select="normalize-space(ORGDIV)"  disable-output-escaping="yes" />
     <xsl:choose>
      <xsl:when test=" position() = last() ">. </xsl:when>            
      <xsl:when test=" position() + 1 != $MAX ">, </xsl:when>
      </xsl:choose>
    </xsl:otherwise>
   </xsl:choose>

 </xsl:template>

<!-- Prints Article Reference  in ABNT Format
	
	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	AUTHORS: AUTHORS element Node
	ARTTITLE: Title of the article
	VOL: Volumn
	NUM: Number
	SUPPL: Supplement
	MONTH: month name (abbrev)
	YEAR: year
	CITY: city of the publication
	ISSN: issn of the journal
	SHORTTITLE: short title of the journal
-->
 <xsl:template name="PrintArticleReferenceABN">
  <xsl:param name="LANG" />
  <xsl:param name="AUTHLINK">0</xsl:param>
  <xsl:param name="AUTHORS" />
  <xsl:param name="ARTTITLE" />
  <xsl:param name="VOL" />
  <xsl:param name="NUM" />
  <xsl:param name="SUPPL" />
  <xsl:param name="MONTH" />
  <xsl:param name="YEAR" />
  <xsl:param name="CITY" />
  <xsl:param name="ISSN" />
  <xsl:param name="SHORTTITLE" select="//TITLEGROUP/SHORTTITLE" />
  		
  <xsl:call-template name="PrintAuthorsABN">
   <xsl:with-param name="AUTHORS" select="$AUTHORS" />
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
  </xsl:call-template>
  <xsl:if test="$ARTTITLE">
   <font class="negrito">
    <xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes" />
   </font><xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
  </xsl:if>
  <xsl:variable name="length" select="normalize-space(string-length($SHORTTITLE))" />
  <i><xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes" /></i><xsl:if 
   test="substring($SHORTTITLE,$length,1) != '.' ">.</xsl:if>
  <xsl:value-of select="concat(' ',$CITY)" disable-output-escaping="yes" />,
  <xsl:if test="$VOL"><xsl:value-of select="concat(' v.', $VOL)" /></xsl:if>
  <xsl:if test="$NUM"><xsl:value-of select="concat(' n.', $NUM)" /></xsl:if>
  <xsl:if test="$SUPPL">
    <xsl:choose>
     <xsl:when test=" $LANG='en' "> suppl</xsl:when>
     <xsl:otherwise> supl</xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$SUPPL>0">.<xsl:value-of select="$SUPPL" /></xsl:if>
  </xsl:if>   
  <xsl:value-of select="concat(', ', $MONTH)" /><xsl:value-of select="concat(' ', $YEAR)" />
  <xsl:value-of select="concat('. ISSN ', $ISSN, '.')" />
 
 </xsl:template>

<!-- Prints Authors list  in ABNT Format: Surname1, Name1, Surname2, Name2, Surname3, Name3 et al.   
       or

       Surname1, Name1 and Surname2, Name2       (if num authors <= 3 authors)
       
	Parameters:
	AUTHORS: AUTHORS element Node
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
-->  
 <xsl:template name="PrintAuthorsABN">
  <xsl:param name="AUTHORS"/>
  <xsl:param name="LANG"/>
  <xsl:param name="AUTHLINK"/> 
  
  <xsl:apply-templates select="$AUTHORS/AUTH_PERS/AUTHOR" mode="PERS_ABN">
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
   <xsl:with-param name="NUM_CORP" select="count($AUTHORS/AUTH_CORP/AUTHOR)" />
  </xsl:apply-templates>

  <xsl:apply-templates select="$AUTHORS/AUTH_CORP/AUTHOR" mode="CORP_ABN">
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="MAX" select="4 - count($AUTHORS/AUTH_PERS/AUTHOR)" />
  </xsl:apply-templates>

 </xsl:template>

<!-- Prints Author (Person) in ABNT Format 

	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	NUM_CORP: number of corporative authors

-->  		  		
 <xsl:template match="AUTHOR" mode="PERS_ABN">
  <xsl:param name="LANG" />
  <xsl:param name="AUTHLINK" />
  <xsl:param name="NUM_CORP" />
  <xsl:variable name="length" select="normalize-space(string-length(NAME))" />
  
  <xsl:choose>
    <!-- If number of authors > 3 prints et al. and terminate -->
   <xsl:when test=" position() = 4 "><i> et al</i>. </xsl:when> 
   <xsl:when test=" position() > 4 "></xsl:when>
  
   <xsl:otherwise>
    <!-- Prints author in format SURNAME1, Name1, SURNAME2, Name2, SURNAME3, Name3 et al -->
    <xsl:call-template name="CreateAuthor">
     <xsl:with-param name="SURNAME" select="SURNAME" /> <!-- Uppercase -->
     <xsl:with-param name="NAME" select="NAME" />
     <xsl:with-param name="SEARCH"><xsl:if test=" $AUTHLINK = 1 "><xsl:value-of select="@SEARCH" /></xsl:if></xsl:with-param>
     <xsl:with-param name="LANG" select="$LANG" />
     <xsl:with-param name="NORM">abn</xsl:with-param>
     <xsl:with-param name="SEPARATOR">,</xsl:with-param>
    </xsl:call-template>
    <xsl:choose>
     <xsl:when test=" position() = last() and $NUM_CORP = 0 ">
      <xsl:if test=" substring (NAME, $length, 1) != '.' ">.</xsl:if><xsl:text> </xsl:text>
     </xsl:when>
     <!-- Case next author is the last one (not et al), displays ' and ' or equivalent form -->
     <xsl:when test=" position() != 3 and
       ( (position() = last()-1and $NUM_CORP = 0) or (position() = last() and $NUM_CORP = 1) )">
       <xsl:choose>
        <xsl:when test=" $LANG = 'en' "> and </xsl:when>
        <xsl:when test=" $LANG = 'pt' "> e </xsl:when>
        <xsl:when test=" $LANG = 'es' "> y </xsl:when>
       </xsl:choose>
      </xsl:when>
      <!-- Separate authors names by ', '. -->
      <xsl:when test=" position() != 3 ">, </xsl:when>   
    </xsl:choose>
   </xsl:otherwise>
  
  </xsl:choose>
 </xsl:template>
 
<!-- Prints Author (Corporative) in ABNT Format  The max number of authors to be printed is passed as an   argument.

	Parameters:
	LANG: language
	MAX: max number of authors
-->  		  
 <xsl:template match="AUTHOR" mode="CORP_ABN">
   <xsl:param name="LANG" />
   <xsl:param name="MAX" />

   <xsl:choose>
    <xsl:when test=" position() = $MAX "><i> et al</i>. </xsl:when>
    <xsl:when test=" position() > $MAX "></xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="normalize-space(ORGNAME)"  disable-output-escaping="yes" />
     <xsl:if test="ORGNAME and ORGDIV">. </xsl:if>
     <xsl:value-of select="normalize-space(ORGDIV)"  disable-output-escaping="yes" />
     <xsl:choose>
      <xsl:when test=" position() = last() ">. </xsl:when>
      
      <xsl:when test=" position() = last() - 1 and last() != $MAX ">
       <xsl:choose>
        <xsl:when test=" $LANG = 'en' "> and </xsl:when>
        <xsl:when test=" $LANG = 'pt' "> e </xsl:when>
        <xsl:when test=" $LANG = 'es' "> y </xsl:when>
       </xsl:choose>
      </xsl:when>
      
      <xsl:when test=" position() + 1 != $MAX ">, </xsl:when>
      </xsl:choose>
    </xsl:otherwise>
   </xsl:choose>

 </xsl:template>

<xsl:template match="AUTHORS">
 <xsl:param name="NORM"/>
 <xsl:param name="LANG"/>
 <xsl:param name="AUTHLINK">0</xsl:param>
 
 <xsl:apply-templates select="AUTH_PERS/AUTHOR" mode="PERS">
   <xsl:with-param name="NORM" select="$NORM" />
   <xsl:with-param name="LANG" select="$LANG" />
   <xsl:with-param name="AUTHLINK" select="$AUTHLINK" />
   <xsl:with-param name="NUM_CORP" select="count(AUTH_CORP/AUTHOR)"/>
  </xsl:apply-templates>
 
  <xsl:apply-templates select="AUTH_CORP/AUTHOR" mode="CORP" /> 
</xsl:template>

 <xsl:template match="AUTHOR" mode="PERS">
   <xsl:param name="NORM" />
   <xsl:param name="LANG" />
   <xsl:param name="AUTHLINK" />
   <xsl:param name="NUM_CORP" />
   
   <xsl:call-template name="CreateAuthor">
    <xsl:with-param name="SURNAME" select="SURNAME" />
    <xsl:with-param name="NAME" select="NAME" />
    <xsl:with-param name="SEARCH"><xsl:if test=" $AUTHLINK = 1 "><xsl:value-of select="@SEARCH" /></xsl:if></xsl:with-param>
    <xsl:with-param name="LANG" select="$LANG" />
    <xsl:with-param name="NORM" select="$NORM" />
    <xsl:with-param name="SEPARATOR">,</xsl:with-param>
   </xsl:call-template>
   
   <xsl:if test=" position() != last() or $NUM_CORP > 0 ">; </xsl:if>

  </xsl:template>

 <xsl:template match="AUTHOR" mode="CORP">

     <xsl:value-of select="normalize-space(ORGNAME)"  disable-output-escaping="yes" />
     <xsl:if test="ORGNAME and ORGDIV">. </xsl:if>
     <xsl:value-of select="normalize-space(ORGDIV)"  disable-output-escaping="yes" />
     <xsl:if test=" position() != last() ">, </xsl:if>
     
 </xsl:template>

<xsl:template match="LATTES">
	<xsl:variable name="PATH_GENIMG" select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG" />
	<xsl:variable name="LANGUAGE" select="//CONTROLINFO/LANGUAGE" />
	
	<tr>
		<xsl:choose>
			<xsl:when test=" count(AUTHOR) = 1 ">
				<td valign="middle">
					<a href="{AUTHOR/@HREF}" onmouseover="status='{AUTHOR/@HREF}'; return true;" onmouseout="status='';" style="text-decoration: none;">
		 				<img border="0" align="middle" src="{$PATH_GENIMG}{$LANGUAGE}/lattescv-button.gif"></img>
					</a>
				</td>
				<td valign="middle">
					<a href="{AUTHOR/@HREF}" onmouseover="status='{AUTHOR/@HREF}'; return true;" onmouseout="status='';" style="text-decoration: none;">
		 				<font class="nomodel" size="2">Curriculum Lattes</font>
					</a>
				</td>
		</xsl:when>
		
			<xsl:when test=" count(AUTHOR) > 1 ">				
				<td>
					<xsl:call-template name="JavascriptText" />

					<a href="javascript:void(0);" onclick="OpenLattesWindow();" onmouseout="status='';" style="text-decoration: none;">
						<xsl:attribute name="onmouseover">
							<xsl:choose>
								<xsl:when test=" $LANGUAGE = 'en' ">status='Authors List'; return true;</xsl:when>
								<xsl:when test=" $LANGUAGE = 'pt' ">status='Lista de Autores'; return true;</xsl:when>
								<xsl:when test=" $LANGUAGE = 'es' ">status='Lista de Autores'; return true;</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<img border="0" align="middle" src="{$PATH_GENIMG}{$LANGUAGE}/lattescv-button.gif"></img>
					</a>
				</td>
				<td>
					<a href="javascript:void(0);" onclick="OpenLattesWindow();" onmouseout="status='';" style="text-decoration: none;">
						<xsl:attribute name="onmouseover">
							<xsl:choose>
								<xsl:when test=" $LANGUAGE = 'en' ">status='Authors List'; return true;</xsl:when>
								<xsl:when test=" $LANGUAGE = 'pt' ">status='Lista de Autores'; return true;</xsl:when>
								<xsl:when test=" $LANGUAGE = 'es' ">status='Lista de Autores'; return true;</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<font class="nomodel" size="2">Curriculum Lattes</font>
					</a>
				</td>
			</xsl:when>
		
			<xsl:otherwise><td colspan="2">&#160;</td></xsl:otherwise>
		</xsl:choose>
	</tr>
			
</xsl:template>

<xsl:template name="PrintArticleInformationArea">
	<xsl:param name="LATTES" />
    	<table width="100%" border="0">
    		<tr align="right">
    			<td>
				<table>
					<xsl:apply-templates select="$LATTES" />
					<xsl:call-template name="PrintArticleInformationLink" />
				</table>
			</td>
		</tr>
	</table>	
</xsl:template>

<xsl:template name="JavascriptText">
	<xsl:variable name="PATH_GENIMG" select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG" />
	<xsl:variable name="LANGUAGE" select="//CONTROLINFO/LANGUAGE" />
	<script language="javascript">
	<xsl:comment>
		CreateWindowHeader ( "Curriculum Lattes",
                                                    "<xsl:value-of 
                                                           select="$PATH_GENIMG"/><xsl:value-of 
                                                           select="$LANGUAGE"/>/lattescv.gif",
                                                    "<xsl:value-of select=" $LANGUAGE" />"
                                                  );
			
			<xsl:apply-templates select="AUTHOR" mode="LATTES" />

    		CreateWindowFooter();
	// </xsl:comment>
	</script>
</xsl:template>

<xsl:template match="AUTHOR" mode="LATTES">
	InsertAuthor("<xsl:value-of select="." />", "<xsl:value-of select="@HREF" />");
</xsl:template>

<xsl:template name="PrintArticleInformationLink">
	<xsl:variable name="PATH_GENIMG" select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG" />
	<xsl:variable name="CONTROLINFO" select="//CONTROLINFO" />
	<xsl:variable name="LANGUAGE" select="$CONTROLINFO/LANGUAGE" />
	<xsl:variable name="INFOPAGE">http://<xsl:value-of select="$CONTROLINFO/SCIELO_INFO/SERVER" /><xsl:value-of select="$CONTROLINFO/SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_isoref&amp;pid=<xsl:value-of select="$CONTROLINFO/PAGE_PID" />&amp;lng=<xsl:value-of select="$LANGUAGE" /></xsl:variable>
	
	<td valign="middle">
		<a href="javascript:void(0);" onmouseout="status='';" class="nomodel" style="text-decoration: none;">
			<xsl:attribute name="onclick">OpenArticleInfoWindow ( 640, 320,  "<xsl:value-of select="$INFOPAGE" />");</xsl:attribute>
			<xsl:attribute name="onmouseover">
				status='<xsl:call-template name="PrintArticleInformationLabel">
					<xsl:with-param name="LANGUAGE" select="$LANGUAGE" />
				</xsl:call-template>'; return true;
			</xsl:attribute>
			<img border="0" align="middle" src="{$PATH_GENIMG}{$LANGUAGE}/fulltxt.gif"></img>
		</a>
	</td>
	<td>
		<a href="javascript:void(0);" onmouseout="status='';" class="nomodel" style="text-decoration: none;">
			<xsl:attribute name="onclick">OpenArticleInfoWindow ( 640, 320,  "<xsl:value-of select="$INFOPAGE" />");</xsl:attribute>
			<xsl:attribute name="onmouseover">
				status='<xsl:call-template name="PrintArticleInformationLabel">
					<xsl:with-param name="LANGUAGE" select="$LANGUAGE" />
				</xsl:call-template>'; return true;
			</xsl:attribute>
			<xsl:call-template name="PrintArticleInformationLabel">
				<xsl:with-param name="LANGUAGE" select="$LANGUAGE" />
			</xsl:call-template>
		</a>
	</td>
</xsl:template>

<xsl:template name="PrintArticleInformationLabel">
	<xsl:param name="LANGUAGE" />
	<xsl:choose>
		<xsl:when test=" $LANGUAGE = 'en' ">How to cite this article</xsl:when>
		<xsl:when test=" $LANGUAGE = 'pt' ">Como citar este artigo</xsl:when>
		<xsl:when test=" $LANGUAGE = 'es' ">Como citar este artículo</xsl:when>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
	
