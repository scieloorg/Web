<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="HeadStatJournal">
 <HEAD>
  <META http-equiv="Pragma" content="no-cache" /> 
  <META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT" />
  <TITLE>
  <xsl:choose>
	<xsl:when test="//TITLEGROUP">
         <xsl:value-of select="//TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/> - <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='most_visited']"/>
	</xsl:when>
	<xsl:otherwise>
       <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='most_visited']"/>
	</xsl:otherwise>
  </xsl:choose>
     <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='issue']"/>
  </TITLE>
  <style type="text/css">
	a { text-decoration: none; }
       a.email { text-decoration: underline; }
       a.issue { text-decoration: underline; }
       a.page { text-decoration: underline; }
       a.page:visited {color: blue;}
  </style>
  <xsl:call-template name="SetLogJavascriptCode" />
 </HEAD>
</xsl:template>

<xsl:template name="FormStatJournal">
 <xsl:param name="table_perc" />

 <TABLE cellpadding="0" cellspacing="0" width="100%">  
 <TR>    
  <TD width="20%">
   <P align="center">
   <A>
    <xsl:choose>
	<xsl:when test="//TITLEGROUP">
        <xsl:call-template name="AddScieloLink">
          <xsl:with-param name="seq" select="ISSN"/>
          <xsl:with-param name="script">sci_serial</xsl:with-param>
        </xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
        <xsl:call-template name="AddScieloLink">
          <xsl:with-param name="script">sci_home</xsl:with-param>
        </xsl:call-template>
	</xsl:otherwise>
    </xsl:choose> 
     <IMG border="0">
      <xsl:attribute name="src">
        <xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_SERIMG"/>
        <xsl:choose>
   	      <xsl:when test="//TITLEGROUP"><xsl:value-of select="//TITLEGROUP/SIGLUM"/>/plogo.gif</xsl:when>
             <xsl:otherwise>fbpelogp.gif</xsl:otherwise>
        </xsl:choose>
     </xsl:attribute>
     <xsl:attribute name="alt">
        <xsl:choose>
   	      <xsl:when test="//TITLEGROUP"><xsl:value-of select="//TITLEGROUP/SHORTTITLE "/></xsl:when>
            <xsl:otherwise>Scientific Electronic Library Online</xsl:otherwise>
        </xsl:choose>
     </xsl:attribute>
    </IMG> 
   </A>
   </P>
  </TD> 
  <TD align="center" width="80%">
   <BLOCKQUOTE>      
   <P align="left">
    <xsl:call-template name="PAGETITLE">
      <xsl:with-param name="text">
        <xsl:choose>
	  <xsl:when test="//TITLEGROUP"><xsl:value-of select="//TITLEGROUP/TITLE " disable-output-escaping="yes" /></xsl:when>
	  <xsl:otherwise>
          <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='library_collection']"/>
	  </xsl:otherwise>
       </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="ISSN"/>
   </P>    
   </BLOCKQUOTE>    
  </TD>   
 </TR>
 <TR>
  <TD></TD>    
  <TD>
   <BLOCKQUOTE>      
     <FONT face="Verdana" size="2" color="#800000">
         <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='most_visited_issue']"/>
     </FONT><BR/>    
    <P>
     <FONT face="Verdana" size="2">
         <xsl:copy-of select="$translations/xslid[@id='sci_statcommon']/text[@find='sentence1']"/>
     </FONT>    
    </P>
   </BLOCKQUOTE>    
  </TD>
 </TR>
 </TABLE>
 <TABLE border="0" align="center" cellpadding="2" cellspacing="2"> 
 <xsl:attribute name="width"><xsl:value-of select="$table_perc"/></xsl:attribute>
 <TR>
  <xsl:attribute name="width"><xsl:value-of select="$table_perc"/></xsl:attribute>
  <TD align="left" colspan="2">
     <xsl:attribute name="width"><xsl:value-of select="$table_perc"/></xsl:attribute>
     <xsl:apply-templates select="STATPARAM"/>
  </TD>
 </TR>
 </TABLE>
 <TABLE border="0" align="center" cellpadding="2" cellspacing="2">
 <xsl:attribute name="width"><xsl:value-of select="$table_perc"/></xsl:attribute>
  <TR>
  <xsl:attribute name="width"><xsl:value-of select="$table_perc"/></xsl:attribute>
   <TD align="left" colspan="2">
   <xsl:attribute name="width"><xsl:value-of select="$table_perc"/></xsl:attribute> 
     <BR/>
     <xsl:call-template  name="PrintLogForm" />
   </TD>
  </TR>
 </TABLE> 
</xsl:template>

<xsl:template name="PAGETITLE">
<xsl:param name="text" />
  <FONT face="Verdana" size="4" color="#000080"><xsl:value-of select="$text" /></FONT><BR/>
</xsl:template>

<xsl:template match="ISSN">
  <FONT size="3" color="#0000A0">
    <xsl:call-template name="GET_ISSN_TYPE">
        <xsl:with-param name="TYPE" select="@TYPE" />
        <xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE" />
    </xsl:call-template>&#160;ISSN
   </FONT>&#160;<xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="STATPARAM">
     <P>
  <FONT face="Verdana" size="2">
      <xsl:call-template name="PrintLogStartDate">
        <xsl:with-param name="date" select="START_DATE" />
      </xsl:call-template>.
  </FONT>
     </P>
</xsl:template>

<xsl:template name="PrintLogForm">
  <FONT face="Verdana" size="2">
<xsl:call-template name="PrintDateRangeSelection"/>
  </FONT>

 <FORM>
  <xsl:call-template name="GenerateLogForm">
   <xsl:with-param name="script" select="//CONTROLINFO/PAGE_NAME" />
   <xsl:with-param name="pid" select="ISSN" />
  </xsl:call-template>  
  <xsl:apply-templates select="POSSIBLE_NO_ACCESS" />
  &#160;&#160;&#160;
  <xsl:call-template name="PutSubmitButton" />
 </FORM>
 </xsl:template>

<xsl:template match="POSSIBLE_NO_ACCESS">
  <FONT face="Verdana" size="2">
  <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='display_issue_visited']"/>
  <SELECT NAME="access">
   <xsl:apply-templates select="OPTION" />
   <OPTION>
   <xsl:if  test="not(//STATPARAM/FILTER/NUM_ACCESS) or //STATPARAM/FILTER/NUM_ACCESS=1">
     <xsl:attribute name="selected">1</xsl:attribute>
   </xsl:if>
   1</OPTION>
  </SELECT>
  <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='times_or_more']"/>.
  </FONT>

</xsl:template>

<xsl:template match="OPTION">
 <xsl:variable name="number" select="."/>
 <OPTION>
 <xsl:if test="//STATPARAM/FILTER/NUM_ACCESS=$number">
   <xsl:attribute name="selected">1</xsl:attribute>
 </xsl:if>
 <xsl:value-of select="$number"/>
 </OPTION>
</xsl:template>

<xsl:template match="COPYRIGHT">
   <BR/>
   <br/>
   <xsl:call-template name="COPYRIGHTSCIELO"/>
</xsl:template>

<xsl:template match="QUERY_RESULT_PAGES">
<xsl:param name="table_perc" />

 <TABLE align="center" cellpadding="0" cellspacing="0">
 <xsl:attribute name="width"><xsl:value-of select="$table_perc"/></xsl:attribute>
 <TR>
  <TD width="25%">
  <B>
  <xsl:if test="@TOTAL>1">
  <FONT face="Arial" size="2">
   <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='page']"/>
   <xsl:value-of select="@CURRENT"/>
   <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='of']"/>
   <xsl:value-of select="@TOTAL"/>
  </FONT>
  </xsl:if>
  </B>
  </TD>
  <TD  align="right" width="75%">
   <xsl:call-template name="ShowQueryResultPageLink"/>
  </TD>
 </TR>
 </TABLE>
</xsl:template>

<xsl:template name="ShowQueryResultPageLink">
  <FONT face="Arial" size="2">
    [<xsl:choose>
	<xsl:when test="@CURRENT!=1"><xsl:call-template name="LinkFirst"/>	</xsl:when>
	<xsl:otherwise><xsl:call-template name="TextFirst"/></xsl:otherwise>
     </xsl:choose>]&#160;
    [<xsl:choose>
	<xsl:when test="@CURRENT!=1"><xsl:call-template name="LinkPrevious"/></xsl:when>
	<xsl:otherwise><xsl:call-template name="TextPrevious"/></xsl:otherwise>
     </xsl:choose>]&#160;
    [<xsl:choose>
	<xsl:when test="@CURRENT!=@TOTAL"><xsl:call-template name="LinkNext"/></xsl:when>
	<xsl:otherwise><xsl:call-template name="TextNext"/></xsl:otherwise>
     </xsl:choose>]&#160;
    [<xsl:choose>
	<xsl:when test="@CURRENT!=@TOTAL"><xsl:call-template name="LinkLast"/></xsl:when>
	<xsl:otherwise><xsl:call-template name="TextLast"/></xsl:otherwise>
     </xsl:choose>] 
  </FONT>
</xsl:template>

<xsl:template name="LinkFirst">
  <A class="page">
     <xsl:call-template name="AddScieloLogLinkCall">
       <xsl:with-param name="page">1</xsl:with-param>
     </xsl:call-template>
     <xsl:call-template name="TextFirst" />
   </A>
</xsl:template>

<xsl:template name="TextFirst">
    <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='first']"/>
</xsl:template>

<xsl:template name="LinkPrevious">
  <A class="page">
    <xsl:call-template name="AddScieloLogLinkCall">
      <xsl:with-param name="page" select="@PREVIOUS"/> 
    </xsl:call-template>
    <xsl:call-template name="TextPrevious" />
   </A>
</xsl:template>

<xsl:template name="TextPrevious">
    <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='first']"/>
</xsl:template>

<xsl:template name="LinkNext">
  <A class="page">
      <xsl:call-template name="AddScieloLogLinkCall">
       <xsl:with-param name="page" select="@NEXT" />
      </xsl:call-template>
      <xsl:call-template name="TextNext" />
   </A>
</xsl:template>

<xsl:template name="TextNext">
    <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='next']"/>
</xsl:template>

<xsl:template name="LinkLast">
   <A class="page">
      <xsl:call-template name="AddScieloLogLinkCall">
       <xsl:with-param name="page" select="@TOTAL" />
      </xsl:call-template>
      <xsl:call-template name="TextLast" />
   </A>
</xsl:template>

<xsl:template name="TextLast">
    <xsl:value-of select="$translations/xslid[@id='sci_statcommon']/text[@find='last']"/>
</xsl:template>

<xsl:template name="AddScieloLogLinkCall">
 <xsl:param name="page"/>
    <xsl:call-template name="AddScieloLogLink">
       <xsl:with-param name="script" select="//CONTROLINFO/PAGE_NAME"/>   
       <xsl:with-param name="dti" select="//STATPARAM/FILTER/INITIAL_DATE"/>   
       <xsl:with-param name="dtf" select="//STATPARAM/FILTER/FINAL_DATE"/>   
       <xsl:with-param name="access" select="//STATPARAM/FILTER/NUM_ACCESS"/> 
       <xsl:with-param name="cpage" select="$page"/> 
       <xsl:with-param name="nlines" select="@NLINES"/> 
       <xsl:with-param name="tpages" select="@TOTAL"/> 
       <xsl:with-param name="maccess" select="//POSSIBLE_NO_ACCESS/@MAX"/>
       <xsl:with-param name="pid" select="/STATISTICS/ISSN"/>
    </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
