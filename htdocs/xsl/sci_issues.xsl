<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="journalStatus.xsl"/>
	<xsl:output method="html" indent="no"/>
	
	<xsl:variable name="PRESENTATION_SORTED_BY_PUBDATE"><xsl:value-of select="//show_issues_sorted_by_pubdate"/></xsl:variable>
	<xsl:variable name="spaceYear" select="'12%'"/>
	<xsl:variable name="spaceVol" select="'7%'"/>
	<xsl:variable name="spaceIssue" select="'5%'"/>
	<xsl:variable name="spaceIssues" select="'70%'"/>
	<!--xsl:variable name="columns" select="//COLUMNS"/>
	<xsl:variable name="colnumber">
		<xsl:choose>
			<xsl:when test="$columns='' or not($columns)">14</xsl:when>
			<xsl:when test="$columns &lt; 14">12</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$columns"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable-->
	<xsl:variable name="colnumber">
		<xsl:choose>
			<xsl:when test=".//YEARISSUE[count(.//ISSUE)&gt;12]">14</xsl:when>
			<xsl:otherwise>12</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="SERIAL">
		<HTML>
			<HEAD>
				<TITLE>
					<xsl:value-of select="//TITLEGROUP/SHORTTITLE " disable-output-escaping="yes"/> - <xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='available_issues']"/>
				</TITLE>
				<LINK href="/css/scielo.css" type="text/css" rel="STYLESHEET"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_layout.css"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_styles.css"/>
				<style type="text/css" title="Gold">
/* The following is for windows that aren't tall enough for
   the fixed menu. Use the scrolling menu instead. */
.note {
  color:#800000
}
.note2 {
  color: black
}

</style>

				<META http-equiv="Pragma" content="no-cache"/>
				<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT"/>
			</HEAD>
			<BODY vLink="#800080" bgColor="#ffffff">
				<xsl:call-template name="NAVBAR">
					<xsl:with-param name="bar1">issues</xsl:with-param>
					<xsl:with-param name="bar2">articlesiah</xsl:with-param>
					<xsl:with-param name="scope" select="//TITLEGROUP/SIGLUM"/>
					<xsl:with-param name="home">1</xsl:with-param>
					<xsl:with-param name="alpha">
						<xsl:choose>
							<xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' ">0</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:apply-templates select="//TITLEGROUP"/>
				<CENTER>
					<FONT color="#000080">
						<xsl:apply-templates select="//TITLE_ISSN">
							<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
						</xsl:apply-templates>
					</FONT>
				</CENTER>
				<!--br/-->
				<div class="content">
					<TABLE width="100%" border="0">
						<TBODY>
							<tr>
								<td>&#160;</td>
								<td width="95%">
									<div class="journalInfo">
										<xsl:if test="/SERIAL/CHANGESINFO">
											<xsl:apply-templates select="/SERIAL/CHANGESINFO">
												<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
											</xsl:apply-templates>
										</xsl:if>
									</div>
								</td>
							</tr>
						</TBODY>
					</TABLE>
					<br/>
					<xsl:apply-templates select="//AVAILISSUES"/>
					<TABLE width="100%" border="0">
						<TBODY>
							<tr>
								<td>&#160;</td>
								<td width="95%">
									<div class="journalInfo"> 
										<xsl:apply-templates select="." mode="journal-history"/>
									</div>
								</td>
							</tr>
						</TBODY>
					</TABLE>
					<br/>
				</div>
				<xsl:apply-templates select="." mode="footer-journal"/>
			</BODY>
		</HTML>
	</xsl:template>
	<xsl:variable name="test_vol">
		<xsl:apply-templates select="//YEARISSUE/VOLISSUE" mode="validation"/>
	</xsl:variable>
	<xsl:template match="AVAILISSUES">
		<TABLE width="100%" border="0">
			<TBODY>
				<TR>
					<TD>&#160;</TD>
					<TD width="95%">
						<P align="left">
							<FONT class="nomodel" color="#800000">
								<xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='available_issues']"/> <a href="#note" class="note">*</a><a name="top"></a>
							</FONT>
						</P>
						<TABLE borderColor="#c0c0c0" cellSpacing="3" cellPadding="3" width="100%" border="0">
							<TBODY>
								<TR>
									<TD vAlign="center" align="left" width="{$spaceYear}" bgColor="#e1e6e6" height="35">
										<P align="center">
											<FONT color="#000080">
												<B>
													<xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='year']"/>
												</B>
											</FONT>
										</P>
									</TD>
									<!--xsl:variable name="test_vol">
		<xsl:apply-templates select="//YEARISSUE/VOLISSUE" mode="validation"/>
	  </xsl:variable-->
									<!--xsl:if test="YEARISSUE/VOLISSUE/@VOL!=''"-->
									<xsl:if test="$test_vol != ''">
										<TD align="middle" width="{$spaceVol}" bgColor="#e1e6e6" height="35">
											<FONT class="normal" color="#000080">
												<B>
													<xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='vol.']"/>
												</B>
											</FONT>
										</TD>
									</xsl:if>
									<xsl:if test="YEARISSUE/VOLISSUE/ISSUE/@NUM or YEARISSUE/VOLISSUE/ISSUE/@SUPPL">
										<TD align="left" width="{$spaceIssues}" bgColor="#e1e6e6" colSpan="{$colnumber}" height="35">
           &#160;&#160;
          <FONT class="normal" color="000080">
												<B>
													<xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='number']"/>
												</B>
											</FONT>
										</TD>
									</xsl:if>
								</TR>
								<!--
       <xsl:apply-templates />
	   -->
								<xsl:apply-templates select="YEARISSUE">
									<xsl:sort select="@YEAR" order="descending" data-type="number"/>
								</xsl:apply-templates>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
	</xsl:template>
	<xsl:template match="YEARISSUE">
	</xsl:template>
	<xsl:template match="YEARISSUE[VOLISSUE/ISSUE]">
		<xsl:apply-templates select="VOLISSUE">
			<xsl:sort select="@VOL" order="descending" data-type="number"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="VOLISSUE">
		<xsl:if test="ISSUE">
			<TR>
				<TD vAlign="center" align="left" width="{$spaceYear}" bgColor="#edecee" height="35">
					<P align="center">
         &#160;&#160;<FONT color="#000080">
							<B>
								<xsl:value-of select="../@YEAR"/>
							</B>
						</FONT>
					</P>
				</TD>
				<xsl:variable name="only_volume_count" select="count(ISSUE[not(@NUM) and not(@SUPPL)])"/>
				<xsl:variable name="navailissues" select="count(ISSUE) - $only_volume_count"/>
				<!--xsl:variable name="test_vol">
		<xsl:apply-templates select="//YEARISSUE/VOLISSUE" mode="validation"/>
	  </xsl:variable-->
				<!-- fixed -->
				<xsl:choose>
					<xsl:when test=" $test_vol != '' ">
						<TD align="middle" width="{$spaceVol}" bgColor="#edecee" height="35">
							<B>
								<FONT class="normal" color="#000080">
									<xsl:choose>
										<xsl:when test="@VOL != '' ">
											<xsl:choose>
												<xsl:when test="$only_volume_count=0">
													<xsl:value-of select="@VOL"/>
												</xsl:when>
												<xsl:otherwise>
													<A>
														<xsl:call-template name="AddScieloLink">
															<xsl:with-param name="seq" select="ISSUE[not(@NUM) and not(@SUPPL)]/@SEQ"/>
															<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
														</xsl:call-template>
														<xsl:value-of select="@VOL"/>
													</A>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>&#160;</xsl:otherwise>
									</xsl:choose>
								</FONT>
							</B>
						</TD>
					</xsl:when>
					<xsl:otherwise>&#160;</xsl:otherwise>
				</xsl:choose>
				
				<xsl:choose>
					<xsl:when test="$PRESENTATION_SORTED_BY_PUBDATE='1'">
						<xsl:apply-templates select="ISSUE[@NUM and @NUM!='AHEAD' and @NUM!='REVIEW' and not(@SUPPL) and @NUM!='SPE']">
							<xsl:sort select="@PUBDATE" data-type="text" order="ascending"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="ISSUE[not(@NUM) or @SUPPL or @NUM='SPE']">
							<xsl:sort select="@PUBDATE" data-type="text" order="ascending"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="ISSUE[@NUM='AHEAD']"/>
						<xsl:apply-templates select="ISSUE[@NUM='REVIEW']"/>
						
						
					</xsl:when>
					<xsl:otherwise>
						<!--xsl:apply-templates select="ISSUE[@NUM and @NUM!='AHEAD' and @NUM!='REVIEW' and not(@SUPPL) and @NUM!='SPE']"/>
						<xsl:apply-templates select="ISSUE[not(@NUM) or @NUM='SPE' or @SUPPL]"/>						
						<xsl:apply-templates select="ISSUE[@NUM='AHEAD']"/>
						<xsl:apply-templates select="ISSUE[@NUM='REVIEW']"/-->
						<xsl:apply-templates select="ISSUE[@NUM or @SUPPL]"/>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:call-template name="AddBlankCells">
					<xsl:with-param name="ncells" select="$colnumber - $navailissues"/>
				</xsl:call-template>
			</TR>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ISSUE">
		<TD align="middle" width="{$spaceIssue}" bgColor="#f5f5eb" height="35">
			<B>
				<FONT color="#000080">
					<A>
						<xsl:call-template name="AddScieloLink">
							<xsl:with-param name="seq" select="@SEQ"/>
							<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="GetNumber">
							<xsl:with-param name="num" select="@NUM"/>
							<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
						</xsl:call-template>
						<xsl:call-template name="GetSuppl">
							<xsl:with-param name="num" select="@NUM"/>
							<xsl:with-param name="suppl" select="@SUPPL"/>
							<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
						</xsl:call-template>
						<xsl:if test="@NUM='beforeprint'">
							<xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='not_printed']"/>
						</xsl:if>
						<xsl:if test="@NUM='AHEAD'">
							<xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='ahead_of_print']"/>
						</xsl:if>
						<xsl:if test="@NUM='REVIEW'">
							<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find='provisional']"/>
						</xsl:if>
					</A>
				</FONT>
			</B>
		</TD>
	</xsl:template>
	<!-- Adds a number of blank cells after the last cell on the table
        Parameter: ncells - Number of cells to add -->
	<xsl:template name="AddBlankCells">
		<xsl:param name="ncells"/>
		<xsl:if test="$ncells&gt;0">
			<TD align="middle" width="{$spaceIssue}" height="35">&#160;</TD>
			<xsl:call-template name="AddBlankCells">
				<xsl:with-param name="ncells" select="$ncells - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="VOLISSUE" mode="validation">
		<xsl:if test="@VOL != ''">
			<xsl:text>FILLED</xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
