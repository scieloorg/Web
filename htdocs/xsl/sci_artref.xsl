<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Get Vol. No. Suppl. Strip
      Parameter:
        Element - Name of Element   -->
	<xsl:variable name="SERVER" select="//SERVER"/>
	<xsl:variable name="PATH_WXIS" select="//PATH_WXIS"/>
	<xsl:variable name="PATH_DATA_IAH" select="//PATH_DATA_IAH"/>
	<xsl:variable name="PATH_CGI_IAH" select="//PATH_CGI_IAH"/>
	<xsl:variable name="ISSUE_ISSN" select="//ISSUE_ISSN"/>
	<xsl:template name="GetStrip">
		<xsl:param name="vol"/>
		<xsl:param name="num"/>
		<xsl:param name="suppl"/>
		<xsl:param name="lang"/>
		<xsl:param name="reviewType"/>
		<xsl:if test="$vol">
			<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'vol.']"/>
			<xsl:value-of select="$vol"/>
		</xsl:if>
		<xsl:if test="$num">&#160;<xsl:call-template name="GetNumber">
				<xsl:with-param name="num" select="$num"/>
				<xsl:with-param name="lang" select="$lang"/>
				<xsl:with-param name="strip" select="1"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$suppl">&#160;<xsl:call-template name="GetSuppl">
				<xsl:with-param name="num" select="$num"/>
				<xsl:with-param name="suppl" select="$suppl"/>
				<xsl:with-param name="lang" select="$lang"/>
				<xsl:with-param name="strip" select="1"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="contains($num,'ahead')">
			<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'ahead_of_print']"/>
		</xsl:if>
		<xsl:if test="contains($num,'review')">
			<xsl:choose>
				<xsl:when test="$reviewType='provisional'">
					<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'provisional']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'review_in_progress']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="contains($num,'beforeprint')">
			<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'not_printed']"/>
		</xsl:if>
	</xsl:template>
	<!-- Get Number in specified language -->
	<xsl:template name="GetNumber">
		<xsl:param name="num"/>
		<xsl:param name="lang"/>
		<xsl:param name="strip"/>
		<xsl:choose>
			<xsl:when test="starts-with($num,'SPE')">
				<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'special_issue']"/>
				<xsl:if test="string-length($num) > 3">
					<xsl:value-of select="concat(' ',substring($num,4))"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$num='se' or $num='SE'">
				<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'special_edition']"/>
				<xsl:if test="string-length($num) > 3">
					<xsl:value-of select="concat(' ',substring($num,4))"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="starts-with($num,'beforeprint')"/>
			<xsl:when test="starts-with($num,'REVIEW') or starts-with($num,'review')"/>
			<xsl:when test="starts-with($num,'AHEAD') or starts-with($num,'ahead')"/>
			<xsl:when test="starts-with($num,'MON')">
				<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'monograph_number']"/>
				<xsl:if test="string-length($num) > 3">
					<xsl:value-of select="concat(' ',substring($num,4))"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$strip">
					<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'issue']"/>
				</xsl:if>
				<xsl:value-of select="$num"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Get Supplement in specified language -->
	<xsl:template name="GetSuppl">
		<xsl:param name="num"/>
		<xsl:param name="suppl"/>
		<xsl:param name="lang"/>
		<xsl:param name="strip"/>
		<xsl:if test="$suppl">
			<xsl:if test="$num">&#160;</xsl:if>
			<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'suppl.']"/>
			<xsl:if test="$suppl!=0">
				<xsl:value-of select="$suppl"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- Shows bibliografic strip -->
	<xsl:template name="SHOWSTRIP">
		<xsl:param name="SHORTTITLE"/>
		<xsl:param name="VOL"/>
		<xsl:param name="NUM"/>
		<xsl:param name="SUPPL"/>
		<xsl:param name="CITY"/>
		<xsl:param name="MONTH"/>
		<xsl:param name="YEAR"/>
		<xsl:param name="reviewType"/>
		<xsl:if test="$SHORTTITLE">
			<xsl:value-of select="normalize-space($SHORTTITLE)" disable-output-escaping="yes"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="contains($NUM,'ahead')">
				<xsl:choose>
					<xsl:when test="../ARTICLE/BODY or ../ARTICLE/fulltext">, 
                        <xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'ahead_of_print']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$CITY">&#160;<xsl:value-of select="normalize-space($CITY)"/>
						</xsl:if>
						&#160;<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'ahead_of_print']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($NUM,'review')">&#160;
				<xsl:choose>
					<xsl:when test="$reviewType='provisional'">
						<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'provisional']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'review_in_progress']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($NUM,'beforeprint')">&#160;
                <xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'not_printed']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$VOL">&#160;<xsl:value-of select="normalize-space($VOL)"/>
				</xsl:if>
				<xsl:if test="$NUM">&#160;<xsl:value-of select="normalize-space($NUM)"/>
				</xsl:if>
				<xsl:if test="$SUPPL">&#160;<xsl:value-of select="normalize-space($SUPPL)"/>
				</xsl:if>
				<xsl:if test="$CITY">&#160;<xsl:value-of select="normalize-space($CITY)"/>
				</xsl:if>
				<xsl:if test="$MONTH">&#160;<xsl:value-of select="normalize-space($MONTH)"/>
				</xsl:if>
				<xsl:if test="$YEAR">&#160;<xsl:value-of select="normalize-space($YEAR)"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="." mode="Epub">
			<xsl:with-param name="ahpdate" select="//ARTICLE/@ahpdate"/>
			<xsl:with-param name="rvpdate" select="//ARTICLE/@rvpdate"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- Shows the formatted date
   DATEISO : Date in format yyyymmdd
   LANG : display language   
   ABREV : 1 - Abreviated -->
	<xsl:template name="ShowDate">
		<xsl:param name="DATEISO"/>
		<xsl:param name="LANG"/>
		<xsl:param name="ABREV"/>
		<xsl:param name="PREPOSITION"/>
		<xsl:choose>
			<xsl:when test=" $LANG = 'en' ">
				<xsl:if test="$PREPOSITION=1">
					<xsl:choose>
						<xsl:when test="substring($DATEISO,5,2)!='00' ">on </xsl:when>
						<xsl:otherwise>in </xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="substring($DATEISO,5,2)!='00'">
					<xsl:call-template name="GET_MONTH_NAME">
						<xsl:with-param name="LANG" select="$LANG"/>
						<xsl:with-param name="MONTH" select="substring($DATEISO,5,2)"/>
						<xsl:with-param name="ABREV" select="$ABREV"/>
					</xsl:call-template>
					<xsl:text>&#160;</xsl:text>
				</xsl:if>
				<xsl:if test="substring($DATEISO,7,2)!='00'">
					<xsl:value-of select=" substring($DATEISO,7,2) "/>, </xsl:if>
				<xsl:value-of select=" substring($DATEISO,1,4) "/>
			</xsl:when>
			<xsl:when test=" $LANG != 'en' and $ABREV">
				<xsl:if test="$PREPOSITION=1">
					<xsl:choose>
						<xsl:when test="$LANG='pt'">em </xsl:when>
						<xsl:when test="$LANG='es'">en </xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="substring($DATEISO,7,2)!='00'">
					<xsl:value-of select=" substring($DATEISO,7,2) "/>-</xsl:if>
				<xsl:if test="substring($DATEISO,5,2)!='00'">
					<xsl:call-template name="GET_MONTH_NAME">
						<xsl:with-param name="LANG" select="$LANG"/>
						<xsl:with-param name="MONTH" select="substring($DATEISO,5,2)"/>
						<xsl:with-param name="ABREV" select="$ABREV"/>
					</xsl:call-template>-</xsl:if>
				<xsl:value-of select=" substring($DATEISO,1,4) "/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="substring($DATEISO,7,2)!='00'">
					<xsl:value-of select=" substring($DATEISO,7,2) "/> de </xsl:if>
				<xsl:if test="substring($DATEISO,5,2)!='00'">
					<xsl:call-template name="GET_MONTH_NAME">
						<xsl:with-param name="LANG" select="$LANG"/>
						<xsl:with-param name="MONTH" select="substring($DATEISO,5,2)"/>
						<xsl:with-param name="ABREV" select="$ABREV"/>
					</xsl:call-template> de </xsl:if>
				<xsl:value-of select=" substring($DATEISO,1,4)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Prints Information about authors, title and strip 
   Parameters:
             NORM - (abn | iso | van)
             LANG - language code
	      LINK = 1 - prints authors with link
	      SHORTTITLE - Opcional
-->
	<xsl:template name="PrintAbstractHeaderInformation">
		<xsl:param name="LANG"/>
		<xsl:param name="NORM"/>
		<xsl:param name="FORMAT"/>
		<xsl:param name="AUTHLINK">0</xsl:param>
		<xsl:param name="TEXTLINK">0</xsl:param>
		<xsl:param name="reviewType"/>
		<xsl:choose>
			<xsl:when test="$NORM='iso-e'">
				<xsl:call-template name="PrintArticleReferenceElectronicISO">
					<xsl:with-param name="FORMAT" select="$FORMAT"/>
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
					<xsl:with-param name="TEXTLINK" select="$TEXTLINK"/>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL"/>
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM"/>
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL"/>
					<xsl:with-param name="MONTH" select="ISSUEINFO/STRIP/MONTH"/>
					<xsl:with-param name="YEAR" select="ISSUEINFO/STRIP/YEAR"/>
					<xsl:with-param name="CURR_DATE" select="@CURR_DATE"/>
					<xsl:with-param name="PID" select="../CONTROLINFO/PAGE_PID"/>
					<xsl:with-param name="ISSN" select="$ISSUE_ISSN"/>
					<xsl:with-param name="FPAGE" select="@FPAGE"/>
					<xsl:with-param name="LPAGE" select="@LPAGE"/>
					<xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE"/>
					<xsl:with-param name="reviewType" select="$reviewType"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$NORM='vancouv-e'">
				<xsl:call-template name="PrintArticleReferenceElectronicVancouver">
					<xsl:with-param name="FORMAT" select="$FORMAT"/>
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL"/>
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM"/>
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL"/>
					<xsl:with-param name="MONTH" select="ISSUEINFO/@MONTH"/>
					<xsl:with-param name="YEAR" select="ISSUEINFO/STRIP/YEAR"/>
					<xsl:with-param name="CURR_DATE" select="@CURR_DATE"/>
					<xsl:with-param name="PID" select="../CONTROLINFO/PAGE_PID"/>
					<xsl:with-param name="ISSN" select="../..//ISSUE_ISSN"/>
					<xsl:with-param name="FPAGE" select="@FPAGE"/>
					<xsl:with-param name="LPAGE" select="@LPAGE"/>
					<xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$NORM='nbr6023-e'">
				<xsl:call-template name="PrintArticleReferenceElectronicABNT">
					<xsl:with-param name="FORMAT" select="$FORMAT"/>
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL"/>
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM"/>
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL"/>
					<xsl:with-param name="MONTH" select="ISSUEINFO/@MONTH"/>
					<xsl:with-param name="YEAR" select="ISSUEINFO/STRIP/YEAR"/>
					<xsl:with-param name="CURR_DATE" select="@CURR_DATE"/>
					<xsl:with-param name="PID" select="../CONTROLINFO/PAGE_PID"/>
					<xsl:with-param name="ISSN" select="../..//ISSUE_ISSN"/>
					<xsl:with-param name="FPAGE" select="@FPAGE"/>
					<xsl:with-param name="LPAGE" select="@LPAGE"/>
					<xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE"/>
					<xsl:with-param name="LOCAL" select="ISSUEINFO/STRIP/CITY"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test=" $NORM = 'iso' ">
				<xsl:call-template name="PrintArticleReferenceISO">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL"/>
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM"/>
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL"/>
					<xsl:with-param name="MONTH" select="ISSUEINFO/STRIP/MONTH"/>
					<xsl:with-param name="YEAR" select="ISSUEINFO/STRIP/YEAR"/>
					<xsl:with-param name="ISSN" select="ISSUEINFO/ISSUE_ISSN"/>
					<xsl:with-param name="FPAGE" select="@FPAGE"/>
					<xsl:with-param name="LPAGE" select="@LPAGE"/>
					<xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test=" $NORM = 'van' ">
				<xsl:call-template name="PrintArticleReferenceVAN">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL"/>
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM"/>
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL"/>
					<xsl:with-param name="MONTH">
						<xsl:call-template name="GET_MONTH_NAME">
							<xsl:with-param name="LANG" select="$LANG"/>
							<xsl:with-param name="MONTH" select="ISSUEINFO/@MONTH"/>
							<xsl:with-param name="ABREV">1</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="YEAR" select="ISSUEINFO/@YEAR"/>
					<xsl:with-param name="ISSN" select="ISSUEINFO/ISSUE_ISSN"/>
					<xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test=" $NORM = 'abn' ">
				<xsl:call-template name="PrintArticleReferenceABN">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL"/>
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM"/>
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL"/>
					<xsl:with-param name="MONTH">
						<xsl:call-template name="GET_MONTH_NAME">
							<xsl:with-param name="LANG" select="$LANG"/>
							<xsl:with-param name="MONTH" select="ISSUEINFO/@MONTH"/>
							<xsl:with-param name="ABREV">1</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="YEAR" select="ISSUEINFO/@YEAR"/>
					<xsl:with-param name="CITY" select="ISSUEINFO/STRIP/CITY"/>
					<xsl:with-param name="ISSN" select="ISSUEINFO/ISSUE_ISSN"/>
					<xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE"/>
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
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK">0</xsl:param>
		<xsl:param name="AUTHORS"/>
		<xsl:param name="ARTTITLE"/>
		<xsl:param name="VOL"/>
		<xsl:param name="NUM"/>
		<xsl:param name="SUPPL"/>
		<xsl:param name="MONTH"/>
		<xsl:param name="YEAR"/>
		<xsl:param name="ISSN"/>
		<xsl:param name="FPAGE"/>
		<xsl:param name="LPAGE"/>
		<xsl:param name="TEXTLINK"/>
		<xsl:param name="SHORTTITLE" select="//TITLEGROUP/SHORTTITLE"/>
		<xsl:param name="BOLD">1</xsl:param>
		<xsl:call-template name="PrintAuthorsISO">
			<xsl:with-param name="AUTHORS" select="$AUTHORS"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
		</xsl:call-template>
		<xsl:if test="$ARTTITLE">
			<xsl:choose>
				<xsl:when test=" $BOLD = 1">
					<font class="negrito">
						<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"/>
					</font>
					<xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"/>
					<xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:call-template name="PrintTranslatorsISO">
			<xsl:with-param name="TRANSLATORS" select="$AUTHORS//PERSON[@type='TR']"/>
			<xsl:with-param name="LANG" select="$LANG"/>
		</xsl:call-template>
		<i>
			<xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes"/>
		</i>,
		
		<xsl:choose>
			<xsl:when test="$NUM='ahead' or $NUM='review' or $NUM='beforeprint'">
				<xsl:choose>
					<xsl:when test="//ARTICLE/@ahpdate=''">
						<xsl:value-of select="substring(//ARTICLE/@CURR_DATE,1,4)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(' ', $MONTH)"/>
				<xsl:value-of select="concat(' ', $YEAR)"/>,
  <xsl:if test="$VOL">
					<xsl:value-of select="concat(' vol.', $VOL)"/>
					<xsl:if test="$NUM">,</xsl:if>
				</xsl:if>
				<xsl:if test="$NUM">
					<xsl:value-of select="concat(' no.', $NUM)"/>
					<xsl:if test="$SUPPL">,</xsl:if>
				</xsl:if>
				<xsl:if test="$SUPPL">
					<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'suppl.']"/>
					<xsl:if test="$SUPPL>0">.<xsl:value-of select="$SUPPL"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$FPAGE and $LPAGE">
					<xsl:value-of select="concat(', p.', $FPAGE, '-', $LPAGE)"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="concat('. ISSN ', $ISSN, '.')"/>
		<xsl:if test="$NUM='ahead'">
			<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'in_press']"/>
			<xsl:choose>
				<xsl:when test="//ARTICLE/@ahpdate=''">
					<xsl:value-of select="substring(//ARTICLE/@CURR_DATE,1,4)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
				</xsl:otherwise>
			</xsl:choose>.
		</xsl:if>
		<xsl:apply-templates select="//ARTICLE/@DOI" mode="ref"/>
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
		<xsl:param name="domain" select="concat('http://',//CONTROLINFO/SCIELO_INFO/SERVER)"/>
		<xsl:param name="log"/>
		<xsl:param name="FORMAT"/>
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK">0</xsl:param>
		<xsl:param name="TEXTLINK">0</xsl:param>
		<xsl:param name="AUTHORS"/>
		<xsl:param name="ARTTITLE"/>
		<xsl:param name="VOL"/>
		<xsl:param name="NUM"/>
		<xsl:param name="SUPPL"/>
		<xsl:param name="MONTH"/>
		<xsl:param name="YEAR"/>
		<xsl:param name="CURR_DATE"/>
		<xsl:param name="PID"/>
		<xsl:param name="ISSN"/>
		<xsl:param name="FPAGE"/>
		<xsl:param name="LPAGE"/>
		<xsl:param name="SHORTTITLE" select="//TITLEGROUP/TITLE"/>
		<xsl:param name="reviewType"/>
		<xsl:variable name="url">
			<xsl:value-of select="$domain"/>/scielo.php?script=sci_arttext&amp;pid=<xsl:value-of select="$PID"/>&amp;lng=<xsl:value-of select="$LANG"/>&amp;nrm=iso</xsl:variable>
		<xsl:call-template name="PrintAuthorsISOElectronic">
			<xsl:with-param name="AUTHORS" select="$AUTHORS"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="iah">
				<xsl:if test="not(//SERVER)">
					<xsl:value-of select="$domain"/>/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="$ARTTITLE != '' "><span class="article-title">
			<xsl:choose>
				<xsl:when test="$TEXTLINK='1'">
					<A>
						<xsl:attribute name="href"><xsl:value-of select="$url"/></xsl:attribute>
						<xsl:if test="$log = 1 ">
							<xsl:attribute name="OnClick">callUpdateArticleLog('similares_em_scielo');</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"/>
					</A>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--font class="negrito"-->
			<xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if></span>
			<!--/font-->
		</xsl:if>
		<xsl:call-template name="PrintTranslatorsISO">
			<xsl:with-param name="TRANSLATORS" select="$AUTHORS//PERSON[@type='TR']"/>
			<xsl:with-param name="LANG" select="$LANG"/>
		</xsl:call-template>
		<i>
			<xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes"/>
		</i> [<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'online']"/>].
		
		<xsl:choose>
			<xsl:when test="($NUM!='ahead' and $NUM!='review' and $NUM!='beforeprint') or $VOL">
				<xsl:variable name="prevVOL">
					<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'vol.']"/>
				</xsl:variable>
				<xsl:variable name="prevNUM">
					<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'n.']"/>
				</xsl:variable>
				<xsl:value-of select="concat(' ', $YEAR)"/>,
				<xsl:if test="$VOL">
					<xsl:value-of select="concat(' ',$prevVOL, $VOL)"/>
				</xsl:if>
				<xsl:if test="$NUM">
					<xsl:choose>
						<xsl:when test="$NUM='SE' or $NUM='se'">
							<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'selected_edition']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$VOL">, </xsl:if>
							<xsl:value-of select="concat($prevNUM,$NUM)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$SUPPL">,
                <xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'suppl.']"/>
					<xsl:if test="$SUPPL>0">
						<xsl:value-of select="$SUPPL"/>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$NUM='ahead'">
				<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'ahead_of_print']"/>
			</xsl:when>
			<xsl:when test="$NUM='review'">
				<xsl:choose>
					<xsl:when test="$reviewType='provisional'">
						<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'provisional']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'review_in_progress']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$FORMAT!='short'">
				<xsl:if test="$CURR_DATE">
                    [<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'cited']"/>&#160;
					<xsl:value-of select="substring($CURR_DATE,1,4)"/>-<xsl:value-of select="substring($CURR_DATE,5,2)"/>-<xsl:value-of select="substring($CURR_DATE,7,2)"/>]</xsl:if>
				<xsl:if test="$FPAGE!='' and $LPAGE!=''">
					<xsl:value-of select="concat(', pp. ', $FPAGE, '-', $LPAGE)"/>
				</xsl:if>
                . <xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'available_from']"/>:
  			  &lt;<xsl:value-of select="$url"/>&gt;.</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$FPAGE!='' and $LPAGE!=''">
					<xsl:value-of select="concat(', pp. ', $FPAGE, '-', $LPAGE)"/>.
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="." mode="Epub">
			<xsl:with-param name="ahpdate" select="..//ARTICLE/@ahpdate"/>
			<xsl:with-param name="rvpdate" select="..//ARTICLE/@rvpdate"/>
		</xsl:apply-templates>
		<xsl:if test="..//ARTICLE/@ahpdate and //ARTICLE/@ahpdate!=''">.</xsl:if>
		<xsl:value-of select="concat(' ISSN ', $ISSN, '.')"/>
		<xsl:apply-templates select="@DOI" mode="ref"/>
	</xsl:template>
	<!-- Prints Authors list  in ISO Format: SURNAME1, Name1, SURNAME2, Name2, SURNAME3, Name3 et al.   
       or

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Get Vol. No. Suppl. Strip

      Parameter:

        Element - Name of Element   -->

	<xsl:template name="GetStrip">

		<xsl:param name="vol"/>

		<xsl:param name="num"/>

		<xsl:param name="suppl"/>

		<xsl:param name="lang"/>

		<xsl:if test="$vol">vol.<xsl:value-of select="$vol"/>

		</xsl:if>

		<xsl:if test="$num">&#160;<xsl:call-template name="GetNumber">

				<xsl:with-param name="num" select="$num"/>

				<xsl:with-param name="lang" select="$lang"/>

				<xsl:with-param name="strip" select="1"/>

			</xsl:call-template>

		</xsl:if>

		<xsl:if test="$suppl">&#160;<xsl:call-template name="GetSuppl">

				<xsl:with-param name="num" select="$num"/>

				<xsl:with-param name="suppl" select="$suppl"/>

    		CreateWindowFooter();
	// </xsl:comment>
		</script>
	</xsl:template>
	<xsl:template match="LATTES">
		<xsl:variable name="PATH_GENIMG" select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/>
		<xsl:variable name="LANGUAGE" select="//CONTROLINFO/LANGUAGE"/>
		<xsl:choose>
			<xsl:when test=" count(AUTHOR) = 1 ">
				<a href="{AUTHOR/@HREF}" onmouseover="status='{AUTHOR/@HREF}'; return true;" onmouseout="status='';" rel="nofollow">
					<xsl:if test="$service_log = 1">
						<xsl:attribute name="onclick"><xsl:value-of select="$services//service[name='curriculumScienTI']/call"/></xsl:attribute>
					</xsl:if>
					<img border="0" align="middle" src="{$PATH_GENIMG}{$LANGUAGE}/lattescv-button.gif"/>
					<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'curriculum_scienti']"/>
				</a>
			</xsl:when>
			<xsl:when test=" count(AUTHOR) > 1 ">
				<xsl:call-template name="JavascriptText"/>
				<a href="javascript:void(0);" onmouseout="status='';">
					<xsl:attribute name="rel">nofollow</xsl:attribute>
					<xsl:choose>
						<xsl:when test="$service_log = 1">
							<xsl:attribute name="onclick">
									OpenLattesWindow();
									<xsl:value-of select="$services//service[name='curriculumScienTI']/call"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="onclick">
									OpenLattesWindow();
								</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="onmouseover">
                        status='<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'authors_list']"/>'; return true;
                     </xsl:attribute>
					<img border="0" align="middle" src="{$PATH_GENIMG}{$LANGUAGE}/lattescv-button.gif"/>
					<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'curriculum_scienti']"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<td colspan="2">&#160;</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Gets the month name in selected language
         Parameters:
           LANG    language code
           MONTH (01..12)
           ABREV  1: abbreviated name (Optional) -->
	<xsl:template name="GET_MONTH_NAME">
		<xsl:param name="LANG"/>
		<xsl:param name="MONTH"/>
		<xsl:param name="ABREV"/>
		<xsl:choose>
			<xsl:when test="$LANG='en'">
				<xsl:call-template name="MONTH_NAME_EN">
					<xsl:with-param name="MONTH" select="$MONTH"/>
					<xsl:with-param name="ABREV" select="$ABREV"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$LANG='pt'">
				<xsl:call-template name="MONTH_NAME_PT">
					<xsl:with-param name="MONTH" select="$MONTH"/>
					<xsl:with-param name="ABREV" select="$ABREV"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$LANG='es'">
				<xsl:call-template name="MONTH_NAME_ES">
					<xsl:with-param name="MONTH" select="$MONTH"/>
					<xsl:with-param name="ABREV" select="$ABREV"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GET_MONTH_NAME_ABNT">
		<xsl:param name="LANG"/>
		<xsl:param name="MONTH"/>
		<xsl:variable name="m" select="document(concat('../xml/',$LANG,'/month_according_biblio_standard.xml'))//standard[@id='nbr6023']"/>
		<xsl:apply-templates select="$m//month[@id=$MONTH]"/>
	</xsl:template>
	<!-- Auxiliary function - Gets the month name in english. See GET_MONTH_NAME function -->
	<xsl:template name="MONTH_NAME_EN">
		<xsl:param name="MONTH"/>
		<xsl:param name="ABREV"/>
		<xsl:choose>
			<xsl:when test=" $MONTH='01' ">Jan<xsl:if test="not($ABREV)">uary</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='02' ">Feb<xsl:if test="not($ABREV)">ruary</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='03' ">Mar<xsl:if test="not($ABREV)">ch</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='04' ">Apr<xsl:if test="not($ABREV)">il</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='05' ">May</xsl:when>
			<xsl:when test=" $MONTH='06' ">June</xsl:when>
			<xsl:when test=" $MONTH='07' ">July</xsl:when>
			<xsl:when test=" $MONTH='08' ">Aug<xsl:if test="not($ABREV)">ust</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='09' ">Sep<xsl:if test="not($ABREV)">tember</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='10' ">Oct<xsl:if test="not($ABREV)">ober</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='11' ">Nov<xsl:if test="not($ABREV)">ember</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='12' ">Dec<xsl:if test="not($ABREV)">ember</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- Auxiliary function - Gets the month name in portuguese. See GET_MONTH_NAME function -->
	<xsl:template name="MONTH_NAME_PT">
		<xsl:param name="MONTH"/>
		<xsl:param name="ABREV"/>
		<xsl:choose>
			<xsl:when test=" $MONTH='01' ">Jan<xsl:if test="not($ABREV)">eiro</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='02' ">Fev<xsl:if test="not($ABREV)">ereiro</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='03' ">Mar<xsl:if test="not($ABREV)">ço</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='04' ">Abr<xsl:if test="not($ABREV)">il</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='05' ">Maio</xsl:when>
			<xsl:when test=" $MONTH='06' ">Jun<xsl:if test="not($ABREV)">ho</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='07' ">Jul<xsl:if test="not($ABREV)">ho</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='08' ">Ago<xsl:if test="not($ABREV)">sto</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='09' ">Set<xsl:if test="not($ABREV)">embro</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='10' ">Out<xsl:if test="not($ABREV)">ubro</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='11' ">Nov<xsl:if test="not($ABREV)">embro</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='12' ">Dez<xsl:if test="not($ABREV)">embro</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- Auxiliary function - Gets the month name in spanish. See GET_MONTH_NAME function -->
	<xsl:template name="MONTH_NAME_ES">
		<xsl:param name="MONTH"/>
		<xsl:param name="ABREV"/>
		<xsl:choose>
			<xsl:when test=" $MONTH='01' ">Ene<xsl:if test="not($ABREV)">ro</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='02' ">Feb<xsl:if test="not($ABREV)">rero</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='03' ">Mar<xsl:if test="not($ABREV)">zo</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='04' ">Abr<xsl:if test="not($ABREV)">il</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='05' ">Mayo</xsl:when>
			<xsl:when test=" $MONTH='06' ">Jun<xsl:if test="not($ABREV)">io</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='07' ">Jul<xsl:if test="not($ABREV)">io</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='08' ">Ago<xsl:if test="not($ABREV)">sto</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='09' ">Sep<xsl:if test="not($ABREV)">tiembre</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='10' ">Oct<xsl:if test="not($ABREV)">ubre</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='11' ">Nov<xsl:if test="not($ABREV)">iembre</xsl:if>
			</xsl:when>
			<xsl:when test=" $MONTH='12' ">Dic<xsl:if test="not($ABREV)">iembre</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ARTICLE" mode="print-ref">
		<xsl:param name="NORM"/>
		<xsl:param name="LANG"/>
		<xsl:param name="FORMAT" select="'full'"/>
		<xsl:param name="reviewType"/>
		<xsl:call-template name="PrintAbstractHeaderInformation">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK">0</xsl:with-param>
			<xsl:with-param name="NORM" select="$NORM"/>
			<xsl:with-param name="FORMAT" select="$FORMAT"/>
			<xsl:with-param name="reviewType" select="$reviewType"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="*" mode="standardized-reference">
		<xsl:param name="log"/>
		<xsl:param name="LANG"/>
		<xsl:param name="domain"/>
		<xsl:call-template name="PrintArticleReferenceElectronicISO">
			<xsl:with-param name="log" select="$log"/>
			<xsl:with-param name="FORMAT" select="'short'"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="'1'"/>
			<xsl:with-param name="TEXTLINK" select="'0'"/>
			<xsl:with-param name="AUTHORS" select="authors"/>
			<xsl:with-param name="ARTTITLE" select="titles/title[1]"/>
			<xsl:with-param name="VOL" select="volume"/>
			<xsl:with-param name="NUM" select="number"/>
			<xsl:with-param name="SUPPL" select="suppl | supplement"/>
			<xsl:with-param name="YEAR" select="year"/>
			<xsl:with-param name="PID" select="@pid"/>
			<xsl:with-param name="ISSN" select="substring(@pid,2,9)"/>
			<xsl:with-param name="SHORTTITLE" select="serial"/>
			<xsl:with-param name="domain" select="$domain"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="@DOI" mode="ref">&#160;
		<xsl:apply-templates select="." mode="display"/>.</xsl:template>
	<xsl:template match="*" mode="Epub">
		<xsl:param name="ahpdate"/>
		<xsl:param name="rvpdate"/>
		<xsl:if test="$ahpdate!='' or $rvpdate!=''">&#160;<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'ahead_of_print_epub']"/>&#160;<xsl:call-template name="ShowDate">
				<xsl:with-param name="DATEISO">
					<xsl:choose>
						<xsl:when test="$rvpdate!=''">
							<xsl:value-of select="$rvpdate"/>
						</xsl:when>
						<xsl:when test="$ahpdate!=''">
							<xsl:value-of select="$ahpdate"/>
						</xsl:when>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
				<xsl:with-param name="ABREV" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
