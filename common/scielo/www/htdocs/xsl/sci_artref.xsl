<?xml version="1.0" encoding="utf-8"?>
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
				<xsl:with-param name="lang" select="$lang"/>
				<xsl:with-param name="strip" select="1"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="contains($num,'ahead')">ahead of print</xsl:if>
		<xsl:if test="contains($num,'review')"><xsl:choose>
					<xsl:when test="$lang='es'">en revisión</xsl:when>
					<xsl:when test="$lang='pt'">em revisão</xsl:when>
					<xsl:otherwise>review in progress</xsl:otherwise>
				</xsl:choose></xsl:if>
		<xsl:if test="contains($num,'beforeprint')">				<xsl:choose>
					<xsl:when test="//CONTROLINFO/LANGUAGE='es'">no impresos</xsl:when>
					<xsl:when test="//CONTROLINFO/LANGUAGE='pt'">não impressos</xsl:when>
					<xsl:otherwise>not printed</xsl:otherwise>
				</xsl:choose>
</xsl:if>
	</xsl:template>
	<!-- Get Number in specified language -->
	<xsl:template name="GetNumber">
		<xsl:param name="num"/>
		<xsl:param name="lang"/>
		<xsl:param name="strip"/>
		<xsl:choose>
			<xsl:when test="starts-with($num,'SPE')">
				<xsl:choose>
					<xsl:when test="$lang='en'">special<xsl:if test="$strip">&#160;issue</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$strip">no.</xsl:if>especial</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="string-length($num) > 3">
					<xsl:value-of select="concat(' ',substring($num,4))"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$num='se' or $num='SE'">
				<xsl:choose>
					<xsl:when test="$lang='es'">edición special</xsl:when>
					<xsl:when test="$lang='pt'">edição special</xsl:when>
					<xsl:otherwise>special edition</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="string-length($num) > 3">
					<xsl:value-of select="concat(' ',substring($num,4))"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="starts-with($num,'beforeprint')"/>
			<xsl:when test="starts-with($num,'REVIEW')"/>
			<xsl:when test="starts-with($num,'AHEAD')"/>
			<xsl:when test="starts-with($num,'MON')">
				<xsl:choose>
					<xsl:when test="$lang='en'">monograph<xsl:if test="$strip">&#160;issue</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$strip">no.</xsl:if>monográfico</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="string-length($num) > 3">
					<xsl:value-of select="concat(' ',substring($num,4))"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$strip">no.</xsl:if>
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
			<xsl:choose>
				<xsl:when test="$lang='en'">suppl.</xsl:when>
				<xsl:otherwise>supl.</xsl:otherwise>
			</xsl:choose>
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
		<xsl:if test="$SHORTTITLE">
			<xsl:value-of select="normalize-space($SHORTTITLE)" disable-output-escaping="yes"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="contains($NUM,'ahead')">
				<xsl:choose>
					<xsl:when test="../ARTICLE/BODY">, <xsl:choose>
							<xsl:when test="//ARTICLE/@ahpdate=''">
								<xsl:value-of select="substring(//ARTICLE/@CURR_DATE,1,4)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$CITY">&#160;<xsl:value-of select="normalize-space($CITY)"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose> ahead of print
			</xsl:when>
			<xsl:when test="contains($NUM,'review')">&#160;
				<xsl:choose>
					<xsl:when test="//CONTROLINFO/LANGUAGE='es'">en revisión</xsl:when>
					<xsl:when test="//CONTROLINFO/LANGUAGE='pt'">em revisão</xsl:when>
					<xsl:otherwise>review in progress</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($NUM,'beforeprint')">&#160;
				<xsl:choose>
					<xsl:when test="//CONTROLINFO/LANGUAGE='es'">no impresos</xsl:when>
					<xsl:when test="//CONTROLINFO/LANGUAGE='pt'">não impressos</xsl:when>
					<xsl:otherwise>not printed</xsl:otherwise>
				</xsl:choose>
				
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
	</xsl:template>
	<!-- Shows the formatted date
   DATEISO : Date in format yyyymmdd
   LANG : display language   
   ABREV : 1 - Abreviated -->
	<xsl:template name="ShowDate">
		<xsl:param name="DATEISO"/>
		<xsl:param name="LANG"/>
		<xsl:param name="ABREV"/>
		<xsl:choose>
			<xsl:when test=" $LANG = 'en' ">
				<xsl:call-template name="GET_MONTH_NAME">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="MONTH" select="substring($DATEISO,5,2)"/>
					<xsl:with-param name="ABREV" select="$ABREV"/>
				</xsl:call-template>
				<xsl:text/>
				<xsl:value-of select=" substring($DATEISO,7,2) "/>, <xsl:value-of select=" substring($DATEISO,1,4) "/>
			</xsl:when>
			<xsl:when test=" $LANG != 'en' and $ABREV">
				<xsl:value-of select=" substring($DATEISO,7,2) "/>-<xsl:call-template name="GET_MONTH_NAME">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="MONTH" select="substring($DATEISO,5,2)"/>
					<xsl:with-param name="ABREV" select="$ABREV"/>
				</xsl:call-template>-<xsl:value-of select=" substring($DATEISO,1,4) "/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select=" substring($DATEISO,7,2) "/> de <xsl:call-template name="GET_MONTH_NAME">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="MONTH" select="substring($DATEISO,5,2)"/>
					<xsl:with-param name="ABREV" select="$ABREV"/>
				</xsl:call-template> de <xsl:value-of select=" substring($DATEISO,1,4)"/>
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
		<xsl:param name="AUTHLINK">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$NORM='iso-e'">
				<xsl:call-template name="PrintArticleReferenceElectronicISO">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK">0</xsl:with-param>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL"/>
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM"/>
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL"/>
					<xsl:with-param name="MONTH" select="ISSUEINFO/STRIP/MONTH"/>
					<xsl:with-param name="YEAR" select="ISSUEINFO/STRIP/YEAR"/>
					<xsl:with-param name="CURR_DATE" select="@CURR_DATE"/>
					<xsl:with-param name="PID" select="../CONTROLINFO/PAGE_PID"/>
					<xsl:with-param name="ISSN" select="../ISSN"/>
					<xsl:with-param name="FPAGE" select="@FPAGE"/>
					<xsl:with-param name="LPAGE" select="@LPAGE"/>
					<xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$NORM='vancouv-e'">
				<xsl:call-template name="PrintArticleReferenceElectronicVancouver">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK">0</xsl:with-param>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL"/>
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM"/>
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL"/>
					<xsl:with-param name="MONTH" select="ISSUEINFO/@MONTH"/>
					<xsl:with-param name="YEAR" select="ISSUEINFO/STRIP/YEAR"/>
					<xsl:with-param name="CURR_DATE" select="@CURR_DATE"/>
					<xsl:with-param name="PID" select="../CONTROLINFO/PAGE_PID"/>
					<xsl:with-param name="ISSN" select="../ISSN"/>
					<xsl:with-param name="FPAGE" select="@FPAGE"/>
					<xsl:with-param name="LPAGE" select="@LPAGE"/>
					<xsl:with-param name="SHORTTITLE" select="ISSUEINFO/STRIP/SHORTTITLE"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$NORM='nbr6023-e'">
				<xsl:call-template name="PrintArticleReferenceElectronicABNT">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="AUTHLINK">0</xsl:with-param>
					<xsl:with-param name="AUTHORS" select="AUTHORS"/>
					<xsl:with-param name="ARTTITLE" select="TITLE | SECTION"/>
					<xsl:with-param name="VOL" select="ISSUEINFO/@VOL"/>
					<xsl:with-param name="NUM" select="ISSUEINFO/@NUM"/>
					<xsl:with-param name="SUPPL" select="ISSUEINFO/@SUPPL"/>
					<xsl:with-param name="MONTH" select="ISSUEINFO/STRIP/MONTH"/>
					<xsl:with-param name="YEAR" select="ISSUEINFO/STRIP/YEAR"/>
					<xsl:with-param name="CURR_DATE" select="@CURR_DATE"/>
					<xsl:with-param name="PID" select="../CONTROLINFO/PAGE_PID"/>
					<xsl:with-param name="ISSN" select="../ISSN"/>
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
					<xsl:with-param name="ISSN" select="ISSUEINFO/ISSN"/>
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
					<xsl:with-param name="ISSN" select="ISSUEINFO/ISSN"/>
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
					<xsl:with-param name="ISSN" select="ISSUEINFO/ISSN"/>
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
		<!-- fixed_scielo_social_sciences_20051027 -->
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
					<xsl:choose>
						<xsl:when test=" $LANG='en' "> suppl</xsl:when>
						<xsl:otherwise> supl</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$SUPPL>0">.<xsl:value-of select="$SUPPL"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$FPAGE and $LPAGE">
					<xsl:value-of select="concat(', p.', $FPAGE, '-', $LPAGE)"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="concat('. ISSN ', $ISSN, '.')"/>
		<xsl:if test="$NUM='ahead'"> In press 
		<xsl:choose>
				<xsl:when test="//ARTICLE/@ahpdate=''">
					<xsl:value-of select="substring(//ARTICLE/@CURR_DATE,1,4)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
				</xsl:otherwise>
			</xsl:choose>.
		</xsl:if>
		<xsl:apply-templates select="//ARTICLE/@DOI"/>
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
		<xsl:call-template name="PrintAuthorsISO">
			<xsl:with-param name="AUTHORS" select="$AUTHORS"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
		</xsl:call-template>
		<xsl:if test="$ARTTITLE != '' ">
			<!--font class="negrito"-->
			<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"/>
			<xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
			<!--/font-->
		</xsl:if>
		<!-- fixed_scielo_social_sciences_20051027 -->
		<xsl:call-template name="PrintTranslatorsISO">
			<xsl:with-param name="TRANSLATORS" select="$AUTHORS//PERSON[@type='TR']"/>
			<xsl:with-param name="LANG" select="$LANG"/>
		</xsl:call-template>
		<i>
			<xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes"/>
		</i>
		
		<!--xsl:if test="$ISSN/@TYPE">
   <xsl:value-of select=" concat(' [', $ISSN/@TYPE, '].') " />
  </xsl:if-->
  [online].
  <!--xsl:value-of select="concat(' ', $MONTH)"/-->
		<xsl:if test="$NUM!='ahead' and $NUM!='review' and $NUM!='beforeprint'">
			<xsl:value-of select="concat(' ', $YEAR)"/>,
		<xsl:if test="$VOL">
				<xsl:value-of select="concat(' vol. ', $VOL)"/>
				<xsl:if test="$NUM">, </xsl:if>
			</xsl:if>
			<xsl:if test="$NUM">
				<xsl:choose>
					<xsl:when test="$NUM='SE' or $NUM='se'">Selected Edition</xsl:when>
					<xsl:otherwise>no. <xsl:value-of select="$NUM"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$SUPPL">, </xsl:if>
			</xsl:if>
			<xsl:if test="$SUPPL">
				<xsl:choose>
					<xsl:when test=" $LANG='en' "> suppl.</xsl:when>
					<xsl:otherwise> supl.</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$SUPPL>0">
					<xsl:value-of select="$SUPPL"/>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$CURR_DATE">
			<xsl:choose>
				<xsl:when test=" $LANG = 'en' "> [cited </xsl:when>
				<xsl:when test=" $LANG = 'pt' "> [citado </xsl:when>
				<xsl:when test=" $LANG = 'es' "> [citado </xsl:when>
			</xsl:choose>
			<xsl:value-of select="substring($CURR_DATE,1,4)"/>-<xsl:value-of select="substring($CURR_DATE,5,2)"/>-<xsl:value-of select="substring($CURR_DATE,7,2)"/>]</xsl:if>
		<!-- fixed_scielo_social_sciences_20051027 -->
		<xsl:if test="$FPAGE!=0 and $LPAGE!=0">
			<xsl:value-of select="concat(', pp. ', $FPAGE, '-', $LPAGE)"/>
		</xsl:if>.
		<!--xsl:choose>
			<xsl:when test=" $LANG = 'en' "> Available from World Wide Web: </xsl:when>
			<xsl:when test=" $LANG = 'pt' "> Disponível na  World Wide Web: </xsl:when>
			<xsl:when test=" $LANG = 'es' "> Disponible en la World Wide Web: </xsl:when>
		</xsl:choose-->
		<xsl:choose>
			<xsl:when test=" $LANG = 'en' "> Available from: </xsl:when>
			<xsl:when test=" $LANG = 'pt' "> Disponível em: </xsl:when>
			<xsl:when test=" $LANG = 'es' "> Disponible en: </xsl:when>
		</xsl:choose>
  
  &lt;<!--a>	<xsl:call-template name="AddScieloLink" >
  	 <xsl:with-param name="seq" select="$PID" />
  	 <xsl:with-param name="script">sci_arttext</xsl:with-param>
  	</xsl:call-template-->http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/>
		<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_arttext&amp;pid=<xsl:value-of select="$PID"/>&amp;lng=<xsl:value-of select="$LANG"/>&amp;nrm=iso<!--/a-->&gt;<xsl:value-of select="concat('. ISSN ', $ISSN, '.')"/>
		<xsl:if test="$NUM='ahead'"> In press 
		<xsl:choose>
				<xsl:when test="//ARTICLE/@ahpdate=''">
					<xsl:value-of select="substring(//ARTICLE/@CURR_DATE,1,4)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
				</xsl:otherwise>
			</xsl:choose>.
		</xsl:if>
		<xsl:apply-templates select="@DOI"/>
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
		<!-- fixed_scielo_social_sciences_20051027 -->
		<xsl:if test="$TRANSLATORS">
			<xsl:choose>
				<xsl:when test=" $LANG = 'en' "> Translated by </xsl:when>
				<xsl:when test=" $LANG = 'pt' "> Traduzido por </xsl:when>
				<xsl:when test=" $LANG = 'es' "> Traducido por </xsl:when>
			</xsl:choose>
			<xsl:apply-templates select="$TRANSLATORS" mode="FULLNAME"/>.
  </xsl:if>
	</xsl:template>
	<!-- Prints Author (Person) in ISO Format 

	Parameters:
	LANG: language
	AUTHLINK: Flag '1' = print link for each author.
	NUM_CORP: number of corporative authors

-->
	<xsl:template match="PERSON" mode="FULLNAME">
		<!-- fixed_scielo_social_sciences_20051027 -->
		<xsl:if test="position()!=1">,&#160;
  </xsl:if>
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
					<!--xsl:with-param name="NAME">
      <xsl:value-of select=" normalize-space(translate(NAME, '.', '')) " /><xsl:if
       test=" substring(NAME, $length, 1) = '.' ">.</xsl:if>
     </xsl:with-param-->
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
					<xsl:when test=" position() != 3 and
       ( (position() = last()-1 and $NUM_CORP = 0) or (position() = last() and $NUM_CORP = 1) )">
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
		<xsl:param name="SURNAME"/>
		<xsl:param name="NAME"/>
		<xsl:param name="SEARCH"/>
		<xsl:param name="LANG"/>
		<xsl:param name="NORM"/>
		<xsl:param name="SEPARATOR"/>
		<xsl:param name="FULLNAME"/>
		<xsl:variable name="SERVER" select="//SERVER"/>
		<xsl:variable name="PATH_WXIS" select="//PATH_WXIS"/>
		<xsl:variable name="PATH_DATA_IAH" select="//PATH_DATA_IAH"/>
		<xsl:variable name="PATH_CGI_IAH" select="//PATH_CGI_IAH"/>
		<xsl:variable name="LANG_IAH">
			<xsl:choose>
				<xsl:when test=" $LANG='en' ">i</xsl:when>
				<xsl:when test=" $LANG='es' ">e</xsl:when>
				<xsl:when test=" $LANG='pt' ">p</xsl:when>
			</xsl:choose>
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
				<a href="http://{$SERVER}{$PATH_WXIS}{$PATH_DATA_IAH}?IsisScript={$PATH_CGI_IAH}iah.xis&amp;base=article^dlibrary&amp;format={$NORM}.pft&amp;lang={$LANG_IAH}&amp;nextAction=lnk&amp;indexSearch=AU&amp;exprSearch={$SEARCH}">
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
		</i>,
		<xsl:choose>
			<xsl:when test="$NUM='ahead' or $NUM='review' or $NUM='beforeprint'">
				<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(' ', $YEAR, ' ', $MONTH)" disable-output-escaping="yes"/>;
  <xsl:if test="$VOL">
					<xsl:value-of select="concat(' ', $VOL)"/>
				</xsl:if>
				<xsl:if test="$NUM">(<xsl:value-of select="$NUM"/>)</xsl:if>
				<xsl:if test="$SUPPL">
					<xsl:choose>
						<xsl:when test=" $LANG='en' "> suppl</xsl:when>
						<xsl:otherwise> supl</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$SUPPL>0">.<xsl:value-of select="$SUPPL"/>
					</xsl:if>
				</xsl:if>
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
					<!--xsl:with-param name="NAME">
      <xsl:value-of select=" normalize-space(translate(NAME, '.', '')) " /><xsl:if
       test=" substring(NAME, $length, 1) = '.' ">.</xsl:if>
     </xsl:with-param-->
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
		<xsl:value-of select="concat(' ',$CITY)" disable-output-escaping="yes"/>,
  <xsl:choose>
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
					<xsl:choose>
						<xsl:when test=" $LANG='en' "> suppl</xsl:when>
						<xsl:otherwise> supl</xsl:otherwise>
					</xsl:choose>
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
					<xsl:when test=" position() != 3 and
       ( (position() = last()-1 and $NUM_CORP = 0) or (position() = last() and $NUM_CORP = 1) )">
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
		<xsl:choose>
			<xsl:when test=" $LANG = 'en' ">[serial on the Internet]. </xsl:when>
			<xsl:when test=" $LANG = 'pt' ">[periódico na Internet]. </xsl:when>
			<xsl:when test=" $LANG = 'es'">[periódico en la Internet]. </xsl:when>
		</xsl:choose>
		<!--xsl:value-of select="concat(' ', $MONTH)"/-->
		<xsl:if test="$NUM!='ahead' and $NUM!='review' and $NUM!='beforeprint'">
			<xsl:value-of select="$YEAR"/>&#160;
		<xsl:call-template name="GET_MONTH_NAME">
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="ABREV" select="1"/>
				<xsl:with-param name="MONTH" select="$MONTH"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$CURR_DATE">
			<xsl:choose>
				<xsl:when test=" $LANG = 'en' "> [cited </xsl:when>
				<xsl:when test=" $LANG = 'pt' "> [citado </xsl:when>
				<xsl:when test=" $LANG = 'es' "> [citado </xsl:when>
			</xsl:choose>
			<xsl:value-of select="substring($CURR_DATE,1,4)"/>&#160;

			<xsl:call-template name="GET_MONTH_NAME">
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="ABREV" select="1"/>
				<xsl:with-param name="MONTH" select="substring($CURR_DATE,5,2)"/>
			</xsl:call-template>&#160;

			<xsl:value-of select="substring($CURR_DATE,7,2)"/>]</xsl:if>
		<xsl:if test="$NUM!='ahead' and $NUM!='review' and $NUM!='beforeprint'">
;&#160;
		<xsl:value-of select="$VOL"/>
			<xsl:if test="$NUM">
				<xsl:choose>
					<xsl:when test="$NUM='SE' or $NUM='se'">Selected Edition</xsl:when>
					<xsl:otherwise>(<xsl:value-of select="$NUM"/>):
				</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<!--xsl:if test="$SUPPL">
			<xsl:choose>
				<xsl:when test=" $LANG='en' "> suppl.</xsl:when>
				<xsl:otherwise> supl.</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$SUPPL>0">
				<xsl:value-of select="$SUPPL"/>
			</xsl:if>
		</xsl:if-->
			<xsl:if test="$FPAGE!=0 and $LPAGE!=0">
				<xsl:value-of select="concat(' ',$FPAGE, '-', $LPAGE)"/>
			</xsl:if>
		</xsl:if>.

		<xsl:choose>
			<xsl:when test=" $LANG = 'en' "> Available from: </xsl:when>
			<xsl:when test=" $LANG = 'pt' "> Disponível em: </xsl:when>
			<xsl:when test=" $LANG = 'es' "> Disponible en: </xsl:when>
		</xsl:choose>
  		http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/>
		<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_arttext&amp;pid=<xsl:value-of select="$PID"/>&amp;lng=<xsl:value-of select="$LANG"/>&amp;nrm=iso.
		<xsl:if test="$NUM='ahead'"> In press 
		<xsl:choose>
				<xsl:when test="//ARTICLE/@ahpdate=''">
					<xsl:value-of select="substring(//ARTICLE/@CURR_DATE,1,4)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
				</xsl:otherwise>
			</xsl:choose>.
		</xsl:if>
		<xsl:apply-templates select="@DOI"/>
	</xsl:template>
	<xsl:template name="PrintArticleReferenceElectronicABNT">
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
			<!--font class="negrito"-->
			<xsl:value-of select="concat(' ', $ARTTITLE)" disable-output-escaping="yes"/>
			<xsl:if test="substring($ARTTITLE,string-length($ARTTITLE)) != '.' ">.</xsl:if>
			<!--/font-->
		</xsl:if>
		<b>
			<xsl:value-of select="concat(' ', $SHORTTITLE)" disable-output-escaping="yes"/>
		</b>
		,&#160;
		<xsl:value-of select="$LOCAL"/>
		<xsl:choose>
			<xsl:when test="$NUM!='ahead' and $NUM!='review' and $NUM!='beforeprint'">,&#160;
			<xsl:if test="$VOL">v. <xsl:value-of select="$VOL"/>,&#160;
			</xsl:if>
				<xsl:if test="$NUM">
					<xsl:choose>
						<xsl:when test="$NUM='SE' or $NUM='se'">Selected Edition</xsl:when>
						<xsl:otherwise>n. <xsl:value-of select="$NUM"/>,&#160;</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:call-template name="GET_MONTH_NAME">
					<xsl:with-param name="LANG" select="$LANG"/>
					<xsl:with-param name="ABREV" select="1"/>
					<xsl:with-param name="MONTH" select="$MONTH"/>
				</xsl:call-template>
				<xsl:value-of select="$YEAR"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="//ARTICLE/@ahpdate=''">
						<xsl:value-of select="substring(//ARTICLE/@CURR_DATE,1,4)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(//ARTICLE/@ahpdate,1,4)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		.&#160; Disponível em: 
		<!--xsl:choose>
		<xsl:when test=" $LANG = 'pt' "> Disponível em: </xsl:when>
			<xsl:when test=" $LANG = 'en' "> Available from: </xsl:when>
			
			<xsl:when test=" $LANG = 'es' "> Disponible en: </xsl:when>
		</xsl:choose-->
  		&lt;http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/>
		<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_arttext&amp;pid=<xsl:value-of select="$PID"/>&amp;lng=<xsl:value-of select="$LANG"/>&amp;nrm=iso&gt;.
		<xsl:if test="$CURR_DATE"> Acesso em: 
			<!--xsl:choose>
				<xsl:when test=" $LANG = 'en' "> Access on: </xsl:when>
				<xsl:when test=" $LANG = 'pt' "> Acesso em: </xsl:when>
				<xsl:when test=" $LANG = 'es' "> Acceso el: </xsl:when>
			</xsl:choose-->
			<xsl:value-of select="substring($CURR_DATE,7,2)"/>
		</xsl:if>&#160;
			<xsl:call-template name="GET_MONTH_NAME">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="ABREV" select="1"/>
			<xsl:with-param name="MONTH" select="substring($CURR_DATE,5,2)"/>
		</xsl:call-template>&#160;
			<xsl:value-of select="substring($CURR_DATE,1,4)"/>.
			
			<xsl:if test="$NUM='ahead'"> &#160; Pré-publicação.</xsl:if>
		<xsl:apply-templates select="@DOI"/>
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
		<xsl:apply-templates select=".//AUTH_PERS/AUTHOR[position()&lt;=$MAX_PRESENTED]" mode="ref-PERS">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="NUM_CORP" select="count(.//AUTH_CORP/AUTHOR)"/>
			<xsl:with-param name="sep_surname_and_name" select="$sep_surname_and_name"/>
			<xsl:with-param name="sep_authors" select="$sep_authors"/>
			<xsl:with-param name="sep_last_author" select="$sep_last_author"/>
			<xsl:with-param name="uppercase_surname" select="$uppercase_surname"/>
		</xsl:apply-templates>
		<xsl:if test="count(.//AUTH_PERS/AUTHOR)&gt;$max">
			et al
		</xsl:if>.
		<!--xsl:apply-templates select="AUTH_CORP/AUTHOR" mode="CORP">
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="MAX" select="4 - count(.//AUTH_PERS/AUTHOR)"/>
			<xsl:with-param name="sep1" select="$sep1"/>
			<xsl:with-param name="sep2" select="$sep2"/>
			<xsl:with-param name="limit" select="$limit"/>
		</xsl:apply-templates-->
	</xsl:template>
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
			<xsl:comment>
		CreateWindowHeader ( "Curriculum ScienTI",
                                                    "<xsl:value-of select="$PATH_GENIMG"/>
				<xsl:value-of select="$LANGUAGE"/>/lattescv.gif",
                                                    "<xsl:value-of select=" $LANGUAGE"/>"
                                                  );
			
			<xsl:apply-templates select="AUTHOR" mode="LATTES"/>

    		CreateWindowFooter();
	// </xsl:comment>
		</script>
	</xsl:template>
	<xsl:template match="LATTES">
		<xsl:variable name="PATH_GENIMG" select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/>
		<xsl:variable name="LANGUAGE" select="//CONTROLINFO/LANGUAGE"/>
		<tr>
			<xsl:choose>
				<xsl:when test=" count(AUTHOR) = 1 ">
					<td valign="middle">
						<a href="{AUTHOR/@HREF}" onmouseover="status='{AUTHOR/@HREF}'; return true;" onmouseout="status='';" style="text-decoration: none;" >
							<img border="0" align="middle" src="{$PATH_GENIMG}{$LANGUAGE}/lattescv-button.gif"/>
						</a>
					</td>
					<td valign="middle">
						<a href="{AUTHOR/@HREF}" onmouseover="status='{AUTHOR/@HREF}'; return true;" onmouseout="status='';" style="text-decoration: none;" >Curriculum ScienTI
						</a>
					</td>
				</xsl:when>
				<xsl:when test=" count(AUTHOR) > 1 ">
					<td>
						<xsl:call-template name="JavascriptText"/>
						<a href="javascript:void(0);" onclick="OpenLattesWindow();" onmouseout="status='';" style="text-decoration: none;">
							<xsl:attribute name="onmouseover"><xsl:choose><xsl:when test=" $LANGUAGE = 'en' ">status='Authors List'; return true;</xsl:when><xsl:when test=" $LANGUAGE = 'pt' ">status='Lista de Autores'; return true;</xsl:when><xsl:when test=" $LANGUAGE = 'es' ">status='Lista de Autores'; return true;</xsl:when></xsl:choose></xsl:attribute>
							<img border="0" align="middle" src="{$PATH_GENIMG}{$LANGUAGE}/lattescv-button.gif"/>
						</a>
					</td>
					<td>
						<a href="javascript:void(0);" onclick="OpenLattesWindow();" onmouseout="status='';" style="text-decoration: none;">
							<xsl:attribute name="onmouseover"><xsl:choose><xsl:when test=" $LANGUAGE = 'en' ">status='Authors List'; return true;</xsl:when><xsl:when test=" $LANGUAGE = 'pt' ">status='Lista de Autores'; return true;</xsl:when><xsl:when test=" $LANGUAGE = 'es' ">status='Lista de Autores'; return true;</xsl:when></xsl:choose></xsl:attribute>Curriculum ScienTI
						</a>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="2">&#160;</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
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
</xsl:stylesheet>
