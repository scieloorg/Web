<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="sci_common.xsl"/>
<!--xsl:include href="sci_statcommon.xsl"/-->

<xsl:template match="STATISTICS">
 <HTML>
  <xsl:call-template name="HeadStatJournal" />
  <BODY bgcolor="#FFFFFF">
   <xsl:call-template name="FormStatJournal">
    <xsl:with-param name="table_perc">
      <!-- 80% when there are no statistics for the submit button to fit on the same line as the dates -->
      <xsl:choose>
        <xsl:when test="count(//ISSUE_LIST/ISSUE)>0">70%</xsl:when>
        <xsl:otherwise>80%</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
   </xsl:call-template>

   <BR/>
    <xsl:if test="//QUERY_RESULT_PAGES/@TOTAL>1">
     <xsl:apply-templates select="QUERY_RESULT_PAGES"> 
      <xsl:with-param name="table_perc">70%</xsl:with-param>
     </xsl:apply-templates>
     <BR/>
    </xsl:if>  

   <TABLE border="0" align="center" cellpadding="2" cellspacing="2">  
    <xsl:attribute name="width">
     <xsl:choose>
       <xsl:when test="count(//ISSUE_LIST/ISSUE)>0">70%</xsl:when>
       <xsl:otherwise>80%</xsl:otherwise>
     </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates select="ISSUE_LIST"/>
   </TABLE>

   <xsl:if test="//QUERY_RESULT_PAGES/@TOTAL>1">
     <BR/>
      <xsl:apply-templates select="QUERY_RESULT_PAGES"> 
       <xsl:with-param name="table_perc">70%</xsl:with-param>
     </xsl:apply-templates>   
   </xsl:if>

   <xsl:apply-templates select="COPYRIGHT"/>
  </BODY>
 </HTML>
</xsl:template>

<xsl:template match="ISSUE_LIST">
  <xsl:choose >
  <xsl:when test="count(ISSUE)=0">
     <xsl:call-template name="ShowEmptyQueryResult"/> 
  </xsl:when>
  <xsl:otherwise>
  <TR width="70%" bgcolor="#DFEBEB">
  <TD width="10%">
   <P align="center">
    <STRONG>
      <font face="Arial" size="2">
        <xsl:value-of select="$translations/xslid[@id='sci_statiss']/text[@find='nr_of_requests']"/>
      </font>
    </STRONG>
   </P>
  </TD>    
  <TD width="60%">
   <P align="center">
    <STRONG>
      <font face="Arial" size="2">
          <xsl:value-of select="$translations/xslid[@id='sci_statiss']/text[@find='issue']"/>
      </font>
    </STRONG>
   </P>
  </TD>  
  </TR>  
  <xsl:apply-templates select="ISSUE" />
 </xsl:otherwise>
 </xsl:choose> 
</xsl:template>

<xsl:template match="ISSUE">
 <TR width="70%">
   <xsl:attribute name="bgcolor">
     <xsl:choose>
	<xsl:when test="position() mod 2 != 0">#F2F2F2</xsl:when>
	<xsl:otherwise>#EFF7F7</xsl:otherwise>
     </xsl:choose>
   </xsl:attribute>
   <TD width="10%" align="center">
    <xsl:value-of select="@REQUESTS"/>
   </TD>
   <TD width="60%" align="left">
    <A class="issue">
     <xsl:call-template name="AddScieloLink">
       <xsl:with-param name="seq" select="@SEQ"/>
       <xsl:with-param name="script">sci_issuetoc</xsl:with-param>
     </xsl:call-template>    
     <xsl:call-template name="SHOWSTRIP">
      <xsl:with-param name="VOL" select="@VOL" />
      <xsl:with-param name="NUM" select="@NUM" />
      <xsl:with-param name="SUPPL" select="@SUPPL" />
      <xsl:with-param name="MONTH" select="@MONTH" />
      <xsl:with-param name="YEAR" select="@YEAR" />
      <xsl:with-param name="SHORTTITLE" select="SHORTTITLE" />
     </xsl:call-template>
    </A>&#160;
   </TD>  
  </TR>
</xsl:template>

</xsl:stylesheet>
