<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="file:///home/scielo/www/htdocs/xsl/sci_navegation.xsl"/>
	<xsl:include href="file:///home/scielo/www/htdocs/xsl/sci_error.xsl"/>

	<xsl:output method="html" indent="no" />
	<xsl:template match="SERIAL">
		<HTML>
			<HEAD>
				<TITLE>
					<xsl:value-of select="//TITLEGROUP/SHORTTITLE " disable-output-escaping="yes"/> - Available issues</TITLE>
				<LINK href="/css/scielo.css" type="text/css" rel="STYLESHEET"/>
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
						<xsl:apply-templates select="//ISSN">
							<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
						</xsl:apply-templates>
					</FONT>
				</CENTER>
				<br/>
				<xsl:apply-templates select="//AVAILISSUES"/>
				<br/>
				<HR/>
				<P align="center">
					<xsl:apply-templates select="//COPYRIGHT"/>
					<xsl:apply-templates select="//CONTACT"/>
				</P>
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
					<TD width="5%">&#160;</TD>
					<TD width="95%">
						<P align="left">
							<FONT class="nomodel" color="#800000">
								<xsl:choose>
									<xsl:when test="//CONTROLINFO[LANGUAGE='en']">Available issues</xsl:when>
									<xsl:when test="//CONTROLINFO[LANGUAGE='es']">Números disponibles</xsl:when>
									<xsl:when test="//CONTROLINFO[LANGUAGE='pt']">Números disponíveis</xsl:when>
								</xsl:choose>
							</FONT>
						</P>
						<TABLE borderColor="#c0c0c0" cellSpacing="3" cellPadding="3" width="100%" border="0">
							<TBODY>
								<TR>
									<TD vAlign="center" align="left" width="15%" bgColor="#e1e6e6" height="35">
										<P align="center">
											<FONT color="#000080">
												<B>
													<xsl:choose>
														<xsl:when test="//CONTROLINFO[LANGUAGE='en']">Year</xsl:when>
														<xsl:when test="//CONTROLINFO[LANGUAGE='es']">Año</xsl:when>
														<xsl:when test="//CONTROLINFO[LANGUAGE='pt']">Ano</xsl:when>
													</xsl:choose>
												</B>
											</FONT>
										</P>
									</TD>
									<!--xsl:variable name="test_vol">
		<xsl:apply-templates select="//YEARISSUE/VOLISSUE" mode="validation"/>
	  </xsl:variable-->
									<!--xsl:if test="YEARISSUE/VOLISSUE/@VOL!=''"-->
									<xsl:if test="$test_vol != ''">
										<TD align="middle" width="10%" bgColor="#e1e6e6" height="35">
											<FONT class="normal" color="#000080">
												<B>Vol.</B>
											</FONT>
										</TD>
									</xsl:if>
									<xsl:if test="YEARISSUE/VOLISSUE/ISSUE/@NUM or YEARISSUE/VOLISSUE/ISSUE/@SUPPL">
										<TD align="left" width="75%" bgColor="#e1e6e6" colSpan="12" height="35">
           &#160;&#160;
          <FONT class="normal" color="000080">
												<B>
													<xsl:choose>
														<xsl:when test="//CONTROLINFO[LANGUAGE='en']">Issue</xsl:when>
														<xsl:otherwise>Número</xsl:otherwise>
													</xsl:choose>
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
								<xsl:if test="//CHANGESINFO">
									<TR>
										<TD colspan="12">
											<BR/>
											<xsl:apply-templates select="//CHANGESINFO">
												<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
											</xsl:apply-templates>
										</TD>
									</TR>
								</xsl:if>
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
				<TD vAlign="center" align="left" width="15%" bgColor="#edecee" height="35">
					<P align="center">
         &#160;&#160;<FONT color="#000080">
							<B>
								<xsl:value-of select="../@YEAR"/>
							</B>
						</FONT>
					</P>
				</TD>
				<xsl:variable name="navailissues" select="count(ISSUE[@NUM or @SUPPL])"/>
				<!--xsl:variable name="test_vol">
		<xsl:apply-templates select="//YEARISSUE/VOLISSUE" mode="validation"/>
	  </xsl:variable-->
				<!-- fixed -->
				<xsl:choose>
					<xsl:when test=" $test_vol != '' ">
						<TD align="middle" width="10%" bgColor="#edecee" height="35">
							<B>
								<FONT class="normal" color="#000080">
									<xsl:choose>
										<xsl:when test="@VOL != '' ">
											<xsl:choose>
												<xsl:when test="$navailissues&gt;0">
													<xsl:value-of select="@VOL"/>
												</xsl:when>
												<xsl:otherwise>
													<A>
														<xsl:call-template name="AddScieloLink">
															<xsl:with-param name="seq" select="ISSUE/@SEQ"/>
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
				<xsl:apply-templates select="ISSUE[@NUM or @SUPPL]"/>
				<!-- fixed 20040114 
					ERRO OCASIONADO APOS CORRIGIR A AUSENCIA DE LINK NO VOLUME QUANDO ESTE NAO TINHA NEM NUMERO NEM VOLUME.
					EXEMPLO ECLETICA QUIMICA ANO 2002.
				-->

				
				<xsl:call-template name="AddBlankCells">
					<xsl:with-param name="ncells" select="10-$navailissues"/>
				</xsl:call-template>
			</TR>
		</xsl:if>
	</xsl:template>
	<xsl:template match="VOLISSUE" mode="old">
		<xsl:if test="ISSUE">
			<TR>
				<TD vAlign="center" align="left" width="15%" bgColor="#edecee" height="35">
					<P align="center">
         &#160;&#160;<FONT color="#000080">
							<B>
								<xsl:value-of select="../@YEAR"/>
							</B>
						</FONT>
					</P>
				</TD>
				<xsl:variable name="navailissues" select="count(ISSUE)"/>
				<!--xsl:variable name="test_vol">
		<xsl:apply-templates select="//YEARISSUE/VOLISSUE" mode="validation"/>
	  </xsl:variable-->
				<xsl:choose>
					<xsl:when test="$navailissues!=0 and (ISSUE/@SUPPL or ISSUE/@NUM)">
						<xsl:choose>
							<!-- xsl:when test="@VOL!='' or $test_vol !=''" -->
							<xsl:when test=" $test_vol != '' ">
								<TD align="middle" width="10%" bgColor="#edecee" height="35">
									<B>
										<FONT class="normal" color="#000080">
											<xsl:choose>
												<xsl:when test="@VOL != '' ">
													<xsl:value-of select="@VOL"/>
												</xsl:when>
												<xsl:otherwise>&#160;</xsl:otherwise>
											</xsl:choose>
										</FONT>
									</B>
								</TD>
							</xsl:when>
							<xsl:otherwise>&#160;</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="ISSUE"/>
					</xsl:when>
					<xsl:otherwise>
						<TD align="middle" width="10%" bgColor="#edecee" height="35">
							<B>
								<FONT color="#000080">
									<A>
										<xsl:call-template name="AddScieloLink">
											<xsl:with-param name="seq" select="ISSUE/@SEQ"/>
											<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
										</xsl:call-template>
										<xsl:value-of select="@VOL"/>
									</A>
								</FONT>
							</B>
						</TD>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="AddBlankCells">
					<xsl:with-param name="ncells" select="10-$navailissues"/>
				</xsl:call-template>
			</TR>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ISSUE">
		<TD align="middle" width="6.25%" bgColor="#f5f5eb" height="35">
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
						<xsl:if test="@NUM='AHEAD'">ahead of print</xsl:if>
					</A>
				</FONT>
			</B>
		</TD>
	</xsl:template>
	<!-- Adds a number of blank cells after the last cell on the table
        Parameter: ncells - Number of cells to add -->
	<xsl:template name="AddBlankCells">
		<xsl:param name="ncells"/>
		<xsl:if test="$ncells>0">
			<TD align="middle" width="6.25%" height="35">&#160;</TD>
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
