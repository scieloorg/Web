<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="sci_statcommon.xsl"/>
<xsl:include href="sci_mysqlerror.xsl"/>

<xsl:template match="STATISTICS">
 <HTML>
  <xsl:call-template name="HeadStatJournal">
   <xsl:with-param name="entities_en">articles</xsl:with-param>
  </xsl:call-template>

  <BODY bgcolor="#FFFFFF"> 
   <xsl:call-template name="FormStatJournal">
    <xsl:with-param name="script">sci_jstatart</xsl:with-param>
    <xsl:with-param name="entities_en">articles</xsl:with-param>
    <xsl:with-param name="entities_es">artículos</xsl:with-param>
    <xsl:with-param name="entities_pt">artigos</xsl:with-param>
    <xsl:with-param name="entities1_en">articles</xsl:with-param>
    <xsl:with-param name="entities1_es">Artículos</xsl:with-param>
    <xsl:with-param name="entities1_pt">Artigos</xsl:with-param>
    <xsl:with-param name="measured_by_line1_en">measured by access to full text articles only</xsl:with-param>
    <xsl:with-param name="measured_by_line1_es">medido por acceso solamente a los artículos completos</xsl:with-param>
    <xsl:with-param name="measured_by_line1_pt">medido por acesso somente aos artigos completos</xsl:with-param>
    <xsl:with-param name="table_perc">80%</xsl:with-param>
   </xsl:call-template>

   <BR/>
   <xsl:if test="//QUERY_RESULT_PAGES/@TOTAL>1">
     <xsl:apply-templates select="QUERY_RESULT_PAGES">
       <xsl:with-param name="table_perc">80%</xsl:with-param>
     </xsl:apply-templates>
     <BR/>
   </xsl:if>  
    
   <TABLE border="0" align="center" cellpadding="2" cellspacing="2" width="80%">  
     <xsl:apply-templates select="ARTICLE_LIST"/> 
   </TABLE>
   <xsl:if test="//QUERY_RESULT_PAGES/@TOTAL>1">
     <BR/>
     <xsl:apply-templates select="QUERY_RESULT_PAGES">
       <xsl:with-param name="table_perc">80%</xsl:with-param>
     </xsl:apply-templates>
   </xsl:if> 
   <xsl:apply-templates select="COPYRIGHT"/>
  </BODY>
 </HTML>
</xsl:template>

<xsl:template match="ARTICLE_LIST">
  <xsl:choose >
  <xsl:when test="count(ARTICLE)=0">
      <xsl:call-template name="ShowEmptyQueryResult"/>
  </xsl:when>
  <xsl:otherwise>
  <TR width="70%" bgcolor="#DFEBEB">
  <TD width="10%">
   <P align="center">
    <STRONG>
      <xsl:choose>
        <xsl:when test="//CONTROLINFO/LANGUAGE='en'">nr. of requests</xsl:when>
        <xsl:when test="//CONTROLINFO/LANGUAGE='es'">no. de accesos</xsl:when>
        <xsl:when test="//CONTROLINFO/LANGUAGE='pt'">n. de acessos</xsl:when>
      </xsl:choose>
    </STRONG>
   </P>
  </TD>    
  <TD width="60%">
   <P align="center">
    <STRONG>
      <xsl:choose>
        <xsl:when test="//CONTROLINFO/LANGUAGE='en'">article reference</xsl:when>
        <xsl:when test="//CONTROLINFO/LANGUAGE='es'">referencia al artículo</xsl:when>
        <xsl:when test="//CONTROLINFO/LANGUAGE='pt'">referência ao artigo</xsl:when>
      	</xsl:choose>
    </STRONG>
   </P>
  </TD>  
  </TR>  
  <xsl:apply-templates select="ARTICLE" />
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="ARTICLE">
 <TR width="80%">
   <xsl:attribute name="bgcolor">
     <xsl:choose>
	<xsl:when test="position() mod 2 != 0">#F2F2F2</xsl:when>
	<xsl:otherwise>#EFF7F7</xsl:otherwise>
     </xsl:choose>
   </xsl:attribute>
   <TD width="10%" align="center">
    <xsl:value-of select="@REQUESTS"/>
   </TD>
   <TD width="90%" align="left">
     <xsl:call-template name="PrintAbstractHeaderInformation">
       <xsl:with-param name="NORM" select="//CONTROLINFO/STANDARD" />
       <xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE" />
       <xsl:with-param name="AUTHLINK">1</xsl:with-param>
     </xsl:call-template>
     <P align="center"> 
     <!--xsl:if test="@ABSTLANG">
     <xsl:call-template name="CREATE_ARTICLE_LINK">
      <xsl:with-param name="TYPE">abstract</xsl:with-param>
      <xsl:with-param name="INTLANG" select="//CONTROLINFO/LANGUAGE"/>
      <xsl:with-param name="TXTLANG" select="@TEXTLANG"/>
      <xsl:with-param name="PID" select="@PID"/>
     </xsl:call-template>
     </xsl:if>
     <xsl:call-template name="CREATE_ARTICLE_LINK">
      <xsl:with-param name="TYPE">full</xsl:with-param>
      <xsl:with-param name="INTLANG" select="//CONTROLINFO/LANGUAGE"/>
      <xsl:with-param name="TXTLANG" select="@TEXTLANG"/>
      <xsl:with-param name="PID" select="@PID"/>
     </xsl:call-template> 
     <xsl:if test="@PDF">
     <xsl:call-template name="CREATE_ARTICLE_LINK">
      <xsl:with-param name="TYPE">pdf</xsl:with-param>
      <xsl:with-param name="INTLANG" select="//CONTROLINFO/LANGUAGE"/>
      <xsl:with-param name="TXTLANG" select="@TEXTLANG"/>
      <xsl:with-param name="PID" select="@PID"/>
     </xsl:call-template>
    </xsl:if-->
    <xsl:apply-templates select="LANGUAGES">
      <xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE" />    
      <xsl:with-param name="PID" select="@PID" />
    </xsl:apply-templates>		
    
    </P>
   </TD>  
  </TR>
</xsl:template>

</xsl:stylesheet>
