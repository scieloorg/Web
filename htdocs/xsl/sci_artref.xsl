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
			<xsl:value-of
				select="$translations/xslid[@id='sci_artref']/text[@find = 'ahead_of_print']"/>
		</xsl:if>
		<xsl:if test="contains($num,'review')">
			<xsl:choose>
				<xsl:when test="$reviewType='provisional'">
					<xsl:value-of
						select="$translations/xslid[@id='sci_artref']/text[@find = 'provisional']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of
						select="$translations/xslid[@id='sci_artref']/text[@find = 'review_in_progress']"
					/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="contains($num,'beforeprint')">
			<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'not_printed']"
			/>
		</xsl:if>
	</xsl:template>
	<!-- Get Number in specified language -->
	<xsl:template name="GetNumber">
		<xsl:param name="num"/>
		<xsl:param name="lang"/>
		<xsl:param name="strip"/>
		<xsl:choose>
			<xsl:when test="starts-with($num,'SPE')">
				<xsl:value-of
					select="$translations/xslid[@id='sci_artref']/text[@find = 'special_issue']"/>
				<xsl:if test="string-length($num) > 3">
					<xsl:value-of select="concat(' ',substring($num,4))"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$num='se' or $num='SE'">
				<xsl:value-of
					select="$translations/xslid[@id='sci_artref']/text[@find = 'special_edition']"/>
				<xsl:if test="string-length($num) > 3">
					<xsl:value-of select="concat(' ',substring($num,4))"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="starts-with($num,'beforeprint')"/>
			<xsl:when test="starts-with($num,'REVIEW') or starts-with($num,'review')"/>
			<xsl:when test="starts-with($num,'AHEAD') or starts-with($num,'ahead')"/>
			<xsl:when test="starts-with($num,'MON')">
				<xsl:value-of
					select="$translations/xslid[@id='sci_artref']/text[@find = 'monograph_number']"/>
				<xsl:if test="string-length($num) > 3">
					<xsl:value-of select="concat(' ',substring($num,4))"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$strip">
					<xsl:value-of
						select="$translations/xslid[@id='sci_artref']/text[@find = 'issue']"/>
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
					<xsl:when test="../ARTICLE/BODY or ../ARTICLE/fulltext">, <xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'ahead_of_print']"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$CITY">&#160;<xsl:value-of select="normalize-space($CITY)"/>
						</xsl:if> &#160;<xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'ahead_of_print']"
						/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($NUM,'review')">&#160; <xsl:choose>
					<xsl:when test="$reviewType='provisional'">
						<xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'provisional']"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'review_in_progress']"
						/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($NUM,'beforeprint')">&#160; <xsl:value-of
					select="$translations/xslid[@id='sci_artref']/text[@find = 'not_printed']"/>
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
						<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"
						/>
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
		</i>, <xsl:choose>
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
				<xsl:value-of select="concat(' ', $YEAR)"/>, <xsl:if test="$VOL">
					<xsl:value-of select="concat(' vol.', $VOL)"/>
					<xsl:if test="$NUM">,</xsl:if>
				</xsl:if>
				<xsl:if test="$NUM">
					<xsl:value-of select="concat(' no.', $NUM)"/>
					<xsl:if test="$SUPPL">,</xsl:if>
				</xsl:if>
				<xsl:if test="$SUPPL">
					<xsl:value-of
						select="$translations/xslid[@id='sci_artref']/text[@find = 'suppl.']"/>
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
			</xsl:choose>. </xsl:if>
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
			<xsl:value-of select="$domain"/>/scielo.php?script=sci_arttext&amp;pid=<xsl:value-of
				select="$PID"/>&amp;lng=<xsl:value-of select="$LANG"/>&amp;nrm=iso</xsl:variable>
		<xsl:call-template name="PrintAuthorsISOElectronic">
			<xsl:with-param name="AUTHORS" select="$AUTHORS"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="iah">
				<xsl:if test="not(//SERVER)">
					<xsl:value-of select="$domain"
					/>/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="$ARTTITLE != '' "><span class="article-title">
				<xsl:choose>
					<xsl:when test="$TEXTLINK='1'">
						<A>
							<xsl:attribute name="href"><xsl:value-of select="$url"/></xsl:attribute>
							<xsl:if test="$log = 1 ">
								<xsl:attribute name="OnClick"
									>callUpdateArticleLog('similares_em_scielo');</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="concat(' ', $ARTTITLE)"
								disable-output-escaping="yes"/>
						</A>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"
						/>
					</xsl:otherwise>
				</xsl:choose>
				<!--font class="negrito"-->
				<xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' "
				>.</xsl:if></span>
			<!--/font-->
		</xsl:if>
		<xsl:call-template name="PrintTranslatorsISO">
			<xsl:with-param name="TRANSLATORS" select="$AUTHORS//PERSON[@type='TR']"/>
			<xsl:with-param name="LANG" select="$LANG"/>
		</xsl:call-template>
		<i>
			<xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes"/>
		</i> [<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'online']"
		/>]. <xsl:choose>
			<xsl:when test="($NUM!='ahead' and $NUM!='review' and $NUM!='beforeprint') or $VOL">
				<xsl:variable name="prevVOL">
					<xsl:value-of
						select="$translations/xslid[@id='sci_artref']/text[@find = 'vol.']"/>
				</xsl:variable>
				<xsl:variable name="prevNUM">
					<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'n.']"
					/>
				</xsl:variable>
				<xsl:value-of select="concat(' ', $YEAR)"/>, <xsl:if test="$VOL">
					<xsl:value-of select="concat(' ',$prevVOL, $VOL)"/>
				</xsl:if>
				<xsl:if test="$NUM">
					<xsl:choose>
						<xsl:when test="$NUM='SE' or $NUM='se'">
							<xsl:value-of
								select="$translations/xslid[@id='sci_artref']/text[@find = 'selected_edition']"
							/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$VOL">, </xsl:if>
							<xsl:value-of select="concat($prevNUM,$NUM)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$SUPPL">, <xsl:value-of
						select="$translations/xslid[@id='sci_artref']/text[@find = 'suppl.']"/>
					<xsl:if test="$SUPPL>0">
						<xsl:value-of select="$SUPPL"/>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$NUM='ahead'">
				<xsl:value-of
					select="$translations/xslid[@id='sci_artref']/text[@find = 'ahead_of_print']"/>
			</xsl:when>
			<xsl:when test="$NUM='review'">
				<xsl:choose>
					<xsl:when test="$reviewType='provisional'">
						<xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'provisional']"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'review_in_progress']"
						/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$FORMAT!='short'">
				<xsl:if test="$CURR_DATE"> [<xsl:value-of
						select="$translations/xslid[@id='sci_artref']/text[@find = 'cited']"/>&#160;
						<xsl:value-of select="substring($CURR_DATE,1,4)"/>-<xsl:value-of
						select="substring($CURR_DATE,5,2)"/>-<xsl:value-of
						select="substring($CURR_DATE,7,2)"/>]</xsl:if>
				<xsl:if test="$FPAGE!='' and $LPAGE!=''">
					<xsl:value-of select="concat(', pp. ', $FPAGE, '-', $LPAGE)"/>
				</xsl:if> . <xsl:value-of
					select="$translations/xslid[@id='sci_artref']/text[@find = 'available_from']"/>:
					&lt;<xsl:value-of select="$url"/>&gt;.</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$FPAGE!='' and $LPAGE!=''">
					<xsl:value-of select="concat(', pp. ', $FPAGE, '-', $LPAGE)"/>. </xsl:if>
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
		<xsl:apply-templates select="$AUTHORS/AUTH_PERS/AUTHOR | $AUTHORS/AUTHOR[@key]"
			mode="PERS_ISO">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="NUM_CORP" select="count($AUTHORS/AUTH_CORP/AUTHOR)"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="$AUTHORS/AUTH_CORP/AUTHOR" mode="CORP_ISO">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="MAX" select="4 - count($AUTHORS/AUTH_PERS/AUTHOR)"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template name="PrintTranslatorsISO">
		<xsl:param name="TRANSLATORS"/>
		<xsl:param name="LANG"/>
		<xsl:if test="$TRANSLATORS">
			<xsl:value-of
				select="$translations/xslid[@id='sci_artref']/text[@find = 'translated_by']"/>
			<xsl:apply-templates select="$TRANSLATORS" mode="FULLNAME"/>. </xsl:if>
	</xsl:template>
	<xsl:template name="PrintAuthorsISOElectronic">
		<xsl:param name="AUTHORS"/>
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK"/>
		<xsl:param name="iah"/>
		<xsl:variable name="count" select="count($AUTHORS//AUTHOR)"/>
		<xsl:variable name="MAX">
			<xsl:choose>
				<xsl:when test="$count &gt; 4">1</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$count"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates select="$AUTHORS//AUTHOR[position()&lt;=$MAX]" mode="AUTHOR_E">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="etal">
				<xsl:choose>
					<xsl:when test="$count &gt; 4"> et al</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="iah" select="$iah"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- Prints Author (Person) in ISO Format 

	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	NUM_CORP: number of corporative authors

-->
	<xsl:template match="PERSON" mode="FULLNAME">
		<!-- fixed_scielo_social_sciences_20051027 -->
		<xsl:if test="position()!=1">,&#160; </xsl:if>
		<xsl:apply-templates select="NAME"/>&#160;<xsl:apply-templates select="SURNAME"/>
	</xsl:template>
	<!-- Prints Author (Person) in ISO Format 

	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	NUM_CORP: number of corporative authors

-->
	<xsl:template match="AUTHOR" mode="PERS_ISO">
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK"/>
		<xsl:param name="NUM_CORP"/>
		<xsl:param name="MAX"/>
		<xsl:param name="etal"/>
		<xsl:variable name="length" select="normalize-space(string-length(NAME))"/>
		<xsl:choose>
			<!-- If number of authors > 3 prints et al. and terminate -->
			<xsl:when test=" position() = 4 ">
				<i> et al</i>. </xsl:when>
			<xsl:when test=" position() > 4 "/>
			<xsl:otherwise>
				<!-- Prints author in format SURNAME1, Name1, SURNAME2, Name2, SURNAME3, Name3 et al -->
				<xsl:call-template name="CreateAuthor">
					<xsl:with-param name="SURNAME" select="UPP_SURNAME"/>
					<!-- Uppercase -->
					<xsl:with-param name="NAME" select="NAME"/>
					<xsl:with-param name="SEARCH">
						<xsl:if test=" $AUTHLINK = 1 ">
							<xsl:value-of select="@SEARCH"/>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="NORM">iso</xsl:with-param>
					<xsl:with-param name="SEPARATOR">,</xsl:with-param>
				</xsl:call-template>
				<xsl:choose>
					<xsl:when test=" position() = last() and $NUM_CORP = 0 ">
						<xsl:if test=" substring (NAME, $length, 1) != '.' ">.</xsl:if>
						<xsl:text/>
					</xsl:when>
					<!-- Case next author is the last one (not et al), displays ' and ' or equivalent form -->
					<xsl:when
						test=" position() != 3 and
       ( (position() = last()-1 and $NUM_CORP = 0) or (position() = last() and $NUM_CORP = 1) )"
						> &#160;<xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'and']"
						/>&#160; </xsl:when>
					<!-- Separate authors names by ', '. -->
					<xsl:when test=" position() != 3 ">; </xsl:when>
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
		<xsl:param name="LANG"/>
		<xsl:param name="MAX"/>
		<xsl:choose>
			<xsl:when test=" position() = $MAX ">
				<i> et al</i>. </xsl:when>
			<xsl:when test=" position() > $MAX "/>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(UPP_ORGNAME)" disable-output-escaping="yes"/>
				<xsl:if test="ORGNAME and ORGDIV">. </xsl:if>
				<xsl:value-of select="normalize-space(ORGDIV)" disable-output-escaping="yes"/>
				<xsl:choose>
					<xsl:when test=" position() = last() ">. </xsl:when>
					<xsl:when test=" position() = last() - 1 and last() != $MAX ">
							&#160;<xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'and']"
						/>&#160; </xsl:when>
					<xsl:when test=" position() + 1 != $MAX ">, </xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="AUTHOR" mode="AUTHOR_E">
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK"/>
		<xsl:param name="NUM_CORP"/>
		<xsl:param name="etal"/>
		<xsl:param name="MAX"/>
		<xsl:param name="iah"/>
		<xsl:variable name="length" select="normalize-space(string-length(NAME))"/>
		<xsl:choose>
			<xsl:when test="SURNAME">
				<xsl:call-template name="CreateAuthor">
					<xsl:with-param name="SURNAME" select="UPP_SURNAME"/>
					<xsl:with-param name="NAME" select="NAME"/>
					<xsl:with-param name="SEPARATOR" select="', '"/>
					<xsl:with-param name="SEARCH">
						<xsl:if test=" $AUTHLINK = 1 ">
							<xsl:value-of select="@SEARCH"/>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="iah" select="$iah"/>
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="NORM">iso</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(UPP_ORGNAME)" disable-output-escaping="yes"/>
				<xsl:if test="ORGNAME and ORGDIV">. </xsl:if>
				<xsl:value-of select="normalize-space(ORGDIV)" disable-output-escaping="yes"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="position()=last()">
				<xsl:value-of select="$etal"/>.</xsl:when>
			<xsl:when test="position() + 1=last()"> &#160;<xsl:value-of
					select="$translations/xslid[@id='sci_artref']/text[@find = 'and']"/>&#160; </xsl:when>
			<xsl:otherwise>; </xsl:otherwise>
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
		<xsl:param name="SURNAME"/>
		<xsl:param name="NAME"/>
		<xsl:param name="SEARCH"/>
		<xsl:param name="LANG"/>
		<xsl:param name="NORM"/>
		<xsl:param name="SEPARATOR"/>
		<xsl:param name="FULLNAME"/>
		<xsl:param name="iah"/>
		<xsl:variable name="LANG_IAH">
			<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find = 'lang_iah']"/>
		</xsl:variable>
		<xsl:variable name="fullname">
			<xsl:choose>
				<xsl:when test="$FULLNAME!=''">
					<xsl:value-of select="$FULLNAME"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$SURNAME" disable-output-escaping="yes"/>
					<!-- Displays separator character and space -->
					<xsl:if test=" $NAME and $SURNAME ">
						<xsl:value-of select="concat($SEPARATOR, ' ')"/>
					</xsl:if>
					<xsl:value-of select="$NAME" disable-output-escaping="yes"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<!-- if SEARCH expression is present prints the link -->
			<xsl:when test=" $SEARCH != '' ">
				<xsl:variable name="url">
					<xsl:choose>
						<xsl:when test="string-length($iah)&gt;0">
							<xsl:value-of select="$iah"
								/>&amp;base=article^dlibrary&amp;format=iso.pft&amp;lang=<xsl:value-of
								select="$LANG_IAH"
								/>&amp;nextAction=lnk&amp;indexSearch=AU&amp;exprSearch=<xsl:value-of
								select="$SEARCH"/>
						</xsl:when>
						<xsl:otherwise>http://<xsl:value-of
								select="concat($SERVER,$PATH_WXIS,$PATH_DATA_IAH)"
								/>?IsisScript=<xsl:value-of select="$PATH_CGI_IAH"
								/>iah.xis&amp;base=article^dlibrary&amp;format=iso.pft&amp;lang=<xsl:value-of
								select="$LANG_IAH"
								/>&amp;nextAction=lnk&amp;indexSearch=AU&amp;exprSearch=<xsl:value-of
								select="$SEARCH"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<a href="{$url}">
					<xsl:value-of select="$fullname" disable-output-escaping="yes"/>
				</a>
			</xsl:when>
			<!-- Otherwise, prints only the author -->
			<xsl:otherwise>
				<xsl:value-of select="$fullname" disable-output-escaping="yes"/>
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
		<xsl:param name="SHORTTITLE" select="//TITLEGROUP/SHORTTITLE"/>
		<xsl:call-template name="PrintAuthorsVAN">
			<xsl:with-param name="AUTHORS" select="$AUTHORS"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
		</xsl:call-template>
		<xsl:if test="$ARTTITLE">
			<font class="negrito">
				<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"/>
			</font>
			<xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
		</xsl:if>
		<i>
			<xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes"/>
		</i>, <xsl:choose>
			<xsl:when test="$NUM='ahead' or $NUM='review' or $NUM='beforeprint'">
				<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(' ', $YEAR, ' ', $MONTH)" disable-output-escaping="yes"
				/>; <xsl:if test="$VOL">
					<xsl:value-of select="concat(' ', $VOL)"/>
				</xsl:if>
				<xsl:if test="$NUM or $SUPPL">( <xsl:if test="$NUM">
						<xsl:value-of select="$NUM"/>
					</xsl:if>
					<xsl:if test="$SUPPL and $NUM"> &#160; </xsl:if>
					<xsl:if test="$SUPPL"><xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'suppl.']"/>
						<xsl:if test="$SUPPL&gt;0">
							<xsl:value-of select="$SUPPL"/></xsl:if>
					</xsl:if> ) </xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="concat('. ISSN ', $ISSN, '.')"/>
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
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="NUM_CORP" select="count($AUTHORS/AUTH_CORP/AUTHOR)"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="$AUTHORS/AUTH_CORP/AUTHOR" mode="CORP_VAN">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="MAX" select="7 - count($AUTHORS/AUTH_PERS/AUTHOR)"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- Prints Author (Person) in Vancouver Format 

	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	NUM_CORP: number of corporative authors

-->
	<xsl:template match="AUTHOR" mode="PERS_VAN">
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK"/>
		<xsl:param name="NUM_CORP"/>
		<xsl:variable name="length" select="normalize-space(string-length(NAME))"/>
		<xsl:choose>
			<!-- If number of authors > 3 prints et al. and terminate -->
			<xsl:when test=" position() = 7 ">
				<i> et al</i>. </xsl:when>
			<xsl:when test=" position() > 7 "/>
			<xsl:otherwise>
				<!-- Prints author in format Surname1 Name1, Surname2 Name2, Surname3 Name3,
          Surname4 Name4, Surname5 Name5, Surname6 Name6 et al -->
				<xsl:call-template name="CreateAuthor">
					<xsl:with-param name="SURNAME" select="SURNAME"/>
					<!-- Uppercase -->
					<xsl:with-param name="NAME" select="NAME"/>
					<xsl:with-param name="SEARCH">
						<xsl:if test=" $AUTHLINK = 1 ">
							<xsl:value-of select="@SEARCH"/>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="NORM">van</xsl:with-param>
					<xsl:with-param name="SEPARATOR"/>
				</xsl:call-template>
				<xsl:choose>
					<!-- Last author -->
					<xsl:when test=" position() = last() and $NUM_CORP = 0 ">
						<xsl:if test=" substring (NAME, $length, 1) != '.' ">.</xsl:if>
						<xsl:text/>
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
		<xsl:param name="LANG"/>
		<xsl:param name="MAX"/>
		<xsl:choose>
			<xsl:when test=" position() = $MAX ">
				<i> et al</i>. </xsl:when>
			<xsl:when test=" position() > $MAX "/>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(ORGNAME)" disable-output-escaping="yes"/>
				<xsl:if test="ORGNAME and ORGDIV">. </xsl:if>
				<xsl:value-of select="normalize-space(ORGDIV)" disable-output-escaping="yes"/>
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
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK">0</xsl:param>
		<xsl:param name="AUTHORS"/>
		<xsl:param name="ARTTITLE"/>
		<xsl:param name="VOL"/>
		<xsl:param name="NUM"/>
		<xsl:param name="SUPPL"/>
		<xsl:param name="MONTH"/>
		<xsl:param name="YEAR"/>
		<xsl:param name="CITY"/>
		<xsl:param name="ISSN"/>
		<xsl:param name="SHORTTITLE" select="//TITLEGROUP/SHORTTITLE"/>
		<xsl:call-template name="PrintAuthorsABN">
			<xsl:with-param name="AUTHORS" select="$AUTHORS"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
		</xsl:call-template>
		<xsl:if test="$ARTTITLE">
			<font class="negrito">
				<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"/>
			</font>
			<xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
		</xsl:if>
		<xsl:variable name="length" select="normalize-space(string-length($SHORTTITLE))"/>
		<i>
			<xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes"/>
		</i>
		<xsl:if test="substring($SHORTTITLE,$length,1) != '.' ">.</xsl:if>
		<xsl:value-of select="concat(' ',$CITY)" disable-output-escaping="yes"/>, <xsl:choose>
			<xsl:when test="$NUM='ahead' or $NUM='review' or $NUM='beforeprint'">
				<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$VOL">
					<xsl:value-of select="concat(' v.', $VOL)"/>
				</xsl:if>
				<xsl:if test="$NUM">
					<xsl:value-of select="concat(' n.', $NUM)"/>
				</xsl:if>
				<xsl:if test="$SUPPL">
					<xsl:value-of
						select="$translations/xslid[@id='sci_artref']/text[@find = 'suppl.']"/>
					<xsl:if test="$SUPPL>0">.<xsl:value-of select="$SUPPL"/>
					</xsl:if>
				</xsl:if>
				<xsl:value-of select="concat(', ', $MONTH)"/>
				<xsl:value-of select="concat(' ', $YEAR)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="concat('. ISSN ', $ISSN, '.')"/>
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
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="NUM_CORP" select="count($AUTHORS/AUTH_CORP/AUTHOR)"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="$AUTHORS/AUTH_CORP/AUTHOR" mode="CORP_ABN">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="MAX" select="4 - count($AUTHORS/AUTH_PERS/AUTHOR)"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- Prints Author (Person) in ABNT Format 

	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	NUM_CORP: number of corporative authors

-->
	<xsl:template match="AUTHOR" mode="PERS_ABN">
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK"/>
		<xsl:param name="NUM_CORP"/>
		<xsl:variable name="length" select="normalize-space(string-length(NAME))"/>
		<xsl:choose>
			<!-- If number of authors > 3 prints et al. and terminate -->
			<xsl:when test=" position() = 4 ">
				<i> et al</i>. </xsl:when>
			<xsl:when test=" position() > 4 "/>
			<xsl:otherwise>
				<!-- Prints author in format SURNAME1, Name1, SURNAME2, Name2, SURNAME3, Name3 et al -->
				<xsl:call-template name="CreateAuthor">
					<xsl:with-param name="SURNAME" select="SURNAME"/>
					<!-- Uppercase -->
					<xsl:with-param name="NAME" select="NAME"/>
					<xsl:with-param name="SEARCH">
						<xsl:if test=" $AUTHLINK = 1 ">
							<xsl:value-of select="@SEARCH"/>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="NORM">abn</xsl:with-param>
					<xsl:with-param name="SEPARATOR">,</xsl:with-param>
				</xsl:call-template>
				<xsl:choose>
					<xsl:when test=" position() = last() and $NUM_CORP = 0 ">
						<xsl:if test=" substring (NAME, $length, 1) != '.' ">.</xsl:if>
						<xsl:text/>
					</xsl:when>
					<!-- Case next author is the last one (not et al), displays ' and ' or equivalent form -->
					<xsl:when
						test=" position() != 3 and
       ( (position() = last()-1 and $NUM_CORP = 0) or (position() = last() and $NUM_CORP = 1) )"
						> &#160;<xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'and']"
						/>&#160; </xsl:when>
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
		<xsl:param name="LANG"/>
		<xsl:param name="MAX"/>
		<xsl:choose>
			<xsl:when test=" position() = $MAX ">
				<i> et al</i>. </xsl:when>
			<xsl:when test=" position() > $MAX "/>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(ORGNAME)" disable-output-escaping="yes"/>
				<xsl:if test="ORGNAME and ORGDIV">. </xsl:if>
				<xsl:value-of select="normalize-space(ORGDIV)" disable-output-escaping="yes"/>
				<xsl:choose>
					<xsl:when test=" position() = last() ">. </xsl:when>
					<xsl:when test=" position() = last() - 1 and last() != $MAX ">
							&#160;<xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'and']"
						/>&#160; </xsl:when>
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
			<xsl:with-param name="NORM" select="$NORM"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="NUM_CORP" select="count(AUTH_CORP/AUTHOR)"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="AUTH_CORP/AUTHOR" mode="CORP"/>
	</xsl:template>
	<xsl:template match="AUTHOR" mode="PERS">
		<xsl:param name="NORM"/>
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK"/>
		<xsl:param name="NUM_CORP"/>
		<xsl:call-template name="CreateAuthor">
			<xsl:with-param name="SURNAME" select="SURNAME"/>
			<xsl:with-param name="NAME" select="NAME"/>
			<xsl:with-param name="SEARCH">
				<xsl:if test=" $AUTHLINK = 1 ">
					<xsl:value-of select="@SEARCH"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="NORM" select="$NORM"/>
			<xsl:with-param name="SEPARATOR">,</xsl:with-param>
		</xsl:call-template>
		<xsl:if test=" position() != last() or $NUM_CORP > 0 ">; </xsl:if>
	</xsl:template>
	<xsl:template match="AUTHOR" mode="CORP">
		<xsl:value-of select="normalize-space(ORGNAME)" disable-output-escaping="yes"/>
		<xsl:if test="ORGNAME and ORGDIV">. </xsl:if>
		<xsl:value-of select="normalize-space(ORGDIV)" disable-output-escaping="yes"/>
		<xsl:if test=" position() != last() ">, </xsl:if>
	</xsl:template>
	<xsl:template name="PrintArticleReferenceElectronicVancouver">
		<xsl:param name="FORMAT"/>
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK">0</xsl:param>
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
		<xsl:param name="SHORTTITLE" select="//TITLEGROUP/SHORTTITLE-MEDLINE"/>
		<xsl:apply-templates select="$AUTHORS" mode="ref">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="sep_surname_and_name" select=" ' ' "/>
			<xsl:with-param name="sep_authors" select="', '"/>
			<xsl:with-param name="sep_last_author" select="', '"/>
			<xsl:with-param name="max" select="'6'"/>
			<xsl:with-param name="max_presented" select="'6'"/>
		</xsl:apply-templates>
		<xsl:if test="$ARTTITLE != '' ">
			<!--font class="negrito"-->
			<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"/>
			<xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
			<!--/font-->
		</xsl:if>
		<xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes"/>&#160;
			[<xsl:value-of
			select="$translations/xslid[@id='sci_artref']/text[@find = 'serial_on_the_internet']"
		/>]. <!--xsl:value-of select="concat(' ', $MONTH)"/-->
		<xsl:choose>
			<xsl:when test="$NUM='ahead' or $NUM='review' or $NUM='beforeprint'">
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$YEAR"/>&#160; <xsl:call-template name="GET_MONTH_NAME">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="ABREV" select="1"/>
					<xsl:with-param name="MONTH" select="$MONTH"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="$FORMAT!='short'">
			<xsl:if test="$CURR_DATE"> [<xsl:value-of
					select="$translations/xslid[@id='sci_artref']/text[@find = 'cited']"/>&#160;
					<xsl:value-of select="substring($CURR_DATE,1,4)"/>&#160; <xsl:call-template
					name="GET_MONTH_NAME">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="ABREV" select="1"/>
					<xsl:with-param name="MONTH" select="substring($CURR_DATE,5,2)"/>
				</xsl:call-template>&#160; <xsl:value-of select="substring($CURR_DATE,7,2)"
				/>]</xsl:if>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$NUM='ahead' or $NUM='review' or $NUM='beforeprint'">
				
			</xsl:when>
			<xsl:otherwise>
				;&#160;
					<xsl:value-of select="$VOL"/>
				<xsl:if test="$NUM or $SUPPL">(
					<xsl:if test="$NUM">
						<xsl:value-of select="$NUM"/>
					</xsl:if>
					<xsl:if test="$SUPPL">
						Suppl <xsl:if test="$SUPPL&gt;0"> <xsl:value-of select="$SUPPL"/></xsl:if>
					</xsl:if>
					)</xsl:if>:
					<xsl:if test="$FPAGE!=0 and $LPAGE!=0">
						<xsl:value-of select="concat(' ',$FPAGE, '-', $LPAGE)"/>
					</xsl:if>
				
			</xsl:otherwise>
		</xsl:choose>. 
		<xsl:if test="$FORMAT!='short'">
			<xsl:value-of
				select="$translations/xslid[@id='sci_artref']/text[@find = 'available_from']"/>:
				http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/>
			<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"
				/>scielo.php?script=sci_arttext&amp;pid=<xsl:value-of select="$PID"
				/>&amp;lng=<xsl:value-of select="$LANG"/>.</xsl:if>
		<xsl:if test="$NUM='ahead'">&#160; <xsl:value-of
				select="$translations/xslid[@id='sci_artref']/text[@find = 'in_press']"/>&#160; <xsl:choose>
				<xsl:when test="//ARTICLE/@ahpdate=''">
					<xsl:value-of select="substring(//ARTICLE/@CURR_DATE,1,4)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
				</xsl:otherwise>
			</xsl:choose>. </xsl:if>
		<xsl:apply-templates select="." mode="Epub">
			<xsl:with-param name="ahpdate" select="//ARTICLE/@ahpdate"/>
			<xsl:with-param name="rvpdate" select="//ARTICLE/@rvpdate"/>
		</xsl:apply-templates>
		<xsl:if test="//ARTICLE/@ahpdate and //ARTICLE/@ahpdate!=''">.</xsl:if>
		<xsl:apply-templates select="@DOI" mode="ref"/>
	</xsl:template>
	<xsl:template name="PrintArticleReferenceElectronicABNT">
		<xsl:param name="FORMAT"/>
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK">0</xsl:param>
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
		<xsl:param name="LOCAL"/>
		<xsl:apply-templates select="$AUTHORS" mode="ref">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="sep_surname_and_name" select=" ', ' "/>
			<xsl:with-param name="sep_authors" select="'; '"/>
			<xsl:with-param name="sep_last_author" select="'; '"/>
			<xsl:with-param name="uppercase_surname" select="1"/>
			<xsl:with-param name="max" select="3"/>
			<xsl:with-param name="max_presented" select="1"/>
		</xsl:apply-templates>
		<xsl:if test="$ARTTITLE != '' ">
			<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"/>
			<xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
		</xsl:if>
		<b>
			<xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes"/>
		</b>,&#160; <xsl:value-of select="$LOCAL"/>
		<xsl:choose>
			<xsl:when test="$NUM='ahead' or $NUM='review' or $NUM='beforeprint'">,&#160; <xsl:choose>
					<xsl:when test="//ARTICLE/@ahpdate=''">
						<xsl:value-of select="substring(//ARTICLE/@CURR_DATE,1,4)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise> ,&#160; <xsl:if test="$VOL">v. <xsl:value-of select="$VOL"
					/>,&#160;</xsl:if>
				<xsl:choose>
					<xsl:when test="$NUM='SE' or $NUM='se'">Selected Edition,&#160;</xsl:when>
					<xsl:when test="$NUM">n. <xsl:value-of select="$NUM"/>,&#160;</xsl:when>
				</xsl:choose>
				<xsl:if test="$SUPPL">supl. <xsl:if test="$SUPPL!='0'"><xsl:value-of select="$SUPPL"
						/>,&#160;</xsl:if></xsl:if>
				
				<xsl:if test="number(@FPAGE)!=0 and number(@LPAGE)!=0">p. <xsl:value-of select="@FPAGE"/><xsl:if test="@LPAGE!=@FPAGE">-<xsl:value-of select="@LPAGE"/></xsl:if>,&#160;</xsl:if>
				<xsl:call-template name="GET_MONTH_NAME_ABNT">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="ABREV" select="1"/>
					<xsl:with-param name="MONTH" select="$MONTH"/>
				</xsl:call-template>&#160; <xsl:value-of select="$YEAR"/>
			</xsl:otherwise>
		</xsl:choose> .<xsl:if test="$FORMAT!='short'"> &#160; <xsl:value-of
				select="$translations/xslid[@id='sci_artref']/text[@find = 'available_from']"/>
				&lt;http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/>
			<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"
				/>scielo.php?script=sci_arttext&amp;pid=<xsl:value-of select="$PID"
				/>&amp;lng=<xsl:value-of select="$LANG"/>&amp;nrm=iso&gt;. <xsl:if test="$CURR_DATE">
				<xsl:value-of
					select="$translations/xslid[@id='sci_artref']/text[@find = 'access_on']"/>&#160;
					<xsl:value-of select="substring($CURR_DATE,7,2)"/>
			</xsl:if>&#160; <xsl:call-template name="GET_MONTH_NAME_ABNT">
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="ABREV" select="1"/>
				<xsl:with-param name="MONTH" select="substring($CURR_DATE,5,2)"/>
			</xsl:call-template>&#160; <xsl:value-of select="substring($CURR_DATE,1,4)"/>.</xsl:if>
		<xsl:apply-templates select="." mode="Epub">
			<xsl:with-param name="ahpdate" select="//ARTICLE/@ahpdate"/>
			<xsl:with-param name="rvpdate" select="//ARTICLE/@rvpdate"/>
		</xsl:apply-templates>
		<xsl:if test="//ARTICLE/@ahpdate and //ARTICLE/@ahpdate!=''">.</xsl:if>
		<xsl:apply-templates select="@DOI" mode="ref"/>
	</xsl:template>
	<xsl:template match="AUTHORS" mode="ref">
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK"/>
		<xsl:param name="sep_surname_and_name"/>
		<xsl:param name="sep_authors"/>
		<xsl:param name="sep_last_author"/>
		<xsl:param name="uppercase_surname"/>
		<xsl:param name="max"/>
		<xsl:param name="max_presented"/>
		<xsl:variable name="MAX_PRESENTED">
			<xsl:choose>
				<xsl:when test="count(.//AUTH_PERS/AUTHOR)&gt;$max">
					<xsl:value-of select="$max_presented"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$max"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates select=".//AUTH_PERS/AUTHOR[position()&lt;=$MAX_PRESENTED]"
			mode="ref-PERS">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="NUM_CORP" select="count(.//AUTH_CORP/AUTHOR)"/>
			<xsl:with-param name="sep_surname_and_name" select="$sep_surname_and_name"/>
			<xsl:with-param name="sep_authors" select="$sep_authors"/>
			<xsl:with-param name="sep_last_author" select="$sep_last_author"/>
			<xsl:with-param name="uppercase_surname" select="$uppercase_surname"/>
		</xsl:apply-templates>
		<xsl:if test="count(.//AUTH_PERS/AUTHOR)&gt;$max"> et al </xsl:if>. </xsl:template>
	<xsl:template match="AUTHOR" mode="ref-PERS">
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK"/>
		<xsl:param name="NUM_CORP"/>
		<xsl:param name="uppercase_surname"/>
		<xsl:param name="sep_surname_and_name"/>
		<xsl:param name="sep_authors"/>
		<xsl:param name="sep_last_author"/>
		<xsl:variable name="length" select="normalize-space(string-length(NAME))"/>
		<xsl:variable name="fullname">
			<xsl:choose>
				<xsl:when test="$sep_surname_and_name!=''">
					<xsl:choose>
						<xsl:when test="$uppercase_surname=1">
							<xsl:apply-templates select="UPP_SURNAME"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="SURNAME"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="$sep_surname_and_name"/>
					<xsl:apply-templates select="NAME"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="NAME"/>&#160;<xsl:choose>
						<xsl:when test="$uppercase_surname=1">
							<xsl:apply-templates select="UPP_SURNAME"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="SURNAME"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="position()=1"/>
			<xsl:when test="position()!=last()">
				<xsl:value-of select="$sep_authors"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sep_last_author"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="CreateAuthor">
			<xsl:with-param name="FULLNAME" select="$fullname"/>
			<xsl:with-param name="SEARCH">
				<xsl:if test=" $AUTHLINK = 1 ">
					<xsl:value-of select="@SEARCH"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="NORM">iso</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="JavascriptText">
		<xsl:variable name="PATH_GENIMG" select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/>
		<xsl:variable name="LANGUAGE" select="//CONTROLINFO/LANGUAGE"/>
		<script language="javascript">
		CreateWindowHeader ( "Curriculum ScienTI",
                                                    "<xsl:value-of select="$PATH_GENIMG"/>
				<xsl:value-of select="$LANGUAGE"/>/lattescv.gif",
                                                    "<xsl:value-of select=" $LANGUAGE"/>");
			<xsl:apply-templates select="AUTHOR" mode="LATTES"/>
    		CreateWindowFooter();
		</script>
	</xsl:template>
	<xsl:template match="LATTES">
		<xsl:variable name="PATH_GENIMG" select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/>
		<xsl:variable name="LANGUAGE" select="//CONTROLINFO/LANGUAGE"/>
		<xsl:choose>
			<xsl:when test=" count(AUTHOR) = 1 ">
				<a href="{AUTHOR/@HREF}" onmouseover="status='{AUTHOR/@HREF}'; return true;"
					onmouseout="status='';" rel="nofollow">
					<xsl:if test="$service_log = 1">
						<xsl:attribute name="onclick">
							<xsl:value-of select="$services//service[name='curriculumScienTI']/call"
							/>
						</xsl:attribute>
					</xsl:if>
					<img border="0" align="middle"
						src="{$PATH_GENIMG}{$LANGUAGE}/lattescv-button.gif"/>
					<xsl:value-of
						select="$translations/xslid[@id='sci_artref']/text[@find = 'curriculum_scienti']"
					/>
				</a>
			</xsl:when>
			<xsl:when test=" count(AUTHOR) > 1 ">
				<xsl:call-template name="JavascriptText"/>
				<a href="javascript:void(0);" onmouseout="status='';">
					<xsl:attribute name="rel">nofollow</xsl:attribute>
					<xsl:choose>
						<xsl:when test="$service_log = 1">
							<xsl:attribute name="onclick"> OpenLattesWindow(); <xsl:value-of
									select="$services//service[name='curriculumScienTI']/call"
								/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="onclick"> OpenLattesWindow(); </xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="onmouseover"> status='<xsl:value-of
							select="$translations/xslid[@id='sci_artref']/text[@find = 'authors_list']"
						/>'; return true; </xsl:attribute>
					<img border="0" align="middle"
						src="{$PATH_GENIMG}{$LANGUAGE}/lattescv-button.gif"/>
					<xsl:value-of
						select="$translations/xslid[@id='sci_artref']/text[@find = 'curriculum_scienti']"
					/>
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
		<xsl:variable name="m"
			select="document(concat('../xml/',$LANG,'/month_according_biblio_standard.xml'))//standard[@id='nbr6023']"/>
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
	<xsl:template match="@DOI" mode="ref">&#160; <xsl:apply-templates select="." mode="display"
		/>.</xsl:template>
	<xsl:template match="*" mode="Epub">
		<xsl:param name="ahpdate"/>
		<xsl:param name="rvpdate"/>
		<xsl:variable name="date"><xsl:choose>
			<xsl:when test="$rvpdate!=''"><xsl:value-of select="normalize-space($rvpdate)"/></xsl:when>
			<xsl:when test="$ahpdate!=''"><xsl:value-of select="normalize-space($ahpdate)"/></xsl:when>
		</xsl:choose></xsl:variable>
		<xsl:if test="string-length($date)=8 and substring($date, 7)!='00'">
			&#160;<xsl:value-of
				select="$translations/xslid[@id='sci_artref']/text[@find = 'ahead_of_print_epub']"
				/>&#160;<xsl:call-template name="ShowDate">
				<xsl:with-param name="DATEISO">
					<xsl:value-of select="$date"/>
				</xsl:with-param>
				<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
				<xsl:with-param name="ABREV" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
