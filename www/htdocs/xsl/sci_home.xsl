<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<!--xsl:output method="html" encoding="iso-8859-1" /-->
	<xsl:include href="file:///home/scielosp/www/htdocs/xsl/sci_navegation.xsl"/>

	<xsl:template match="HOMEPAGE">
		<xsl:apply-templates select="CONTROLINFO"/>
	</xsl:template>
	
	<xsl:template match="CONTROLINFO[LANGUAGE='en']">
		<html>

			<head>
				<title>SciELO - Health Public</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="STYLESHEET" type="text/css" href="http:/css/scielo.css"/>
				<style type="text/css">
					a { text-decoration: none; }
				</style>
			</head>

			<body vlink="#990000" link="#990000" style="background: rgb(223, 223, 191) ;">
				<div align="center">
					<table width="600" border="0" cellspacing="0" cellpadding="0">
						<tr bgcolor="#DFDFBF">
							<td colspan="2">
								<div align="center">
									<img> 
										<xsl:attribute name="src">http://<xsl:value-of 
											select="SCIELO_INFO/SERVER" /><xsl:value-of 
											select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
											select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/spalc.gif</xsl:attribute>

										<xsl:attribute name="width">600</xsl:attribute>
										<xsl:attribute name="height">119</xsl:attribute>
										<xsl:attribute name="border">0</xsl:attribute>
									</img>
								</div>
							</td>
						</tr>

						<tr>
							<td width="145" valign="top" bgcolor="#DFDFBF">
								<p>
									<br/>
									<br/>
									<a href="http://www.bireme.br/bvs/I/ihome.htm">
										<img> 
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/ibvs.gif</xsl:attribute>

											<xsl:attribute name="width">86</xsl:attribute>
											<xsl:attribute name="height">102</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>
										</img>
									</a>
									<br/>
									<a>

										<xsl:attribute name="href">http://<xsl:value-of 
											select="SCIELO_INFO/SERVER" /><xsl:value-of 
											select="SCIELO_INFO/PATH_DATA" />scielo.php?lng=pt</xsl:attribute>
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/port.gif</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>
										</img>
									</a>

									<br/>
									<a>
										<xsl:attribute name="href">http://<xsl:value-of 
											select="SCIELO_INFO/SERVER" /><xsl:value-of 
											select="SCIELO_INFO/PATH_DATA" />scielo.php?lng=es</xsl:attribute>
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/esp.gif</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>

										</img>
									</a>
									<br/>
									<a href="#site">
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/site.gif</xsl:attribute>
											<xsl:attribute name="width">135</xsl:attribute>

											<xsl:attribute name="height">23</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>
											<xsl:attribute name="alt">About this site</xsl:attribute>
										</img>
									</a>
									<br/>
									<a href="#ayuda">

										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/ayuda.gif</xsl:attribute>
											<xsl:attribute name="width">135</xsl:attribute>
											<xsl:attribute name="height">23</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>
											<xsl:attribute name="alt">Help</xsl:attribute>

										</img>
									</a>
									<br/>
								</p>
							</td>
							<td width="457" valign="top" bgcolor="#DFDFBF">
								<table width="100%" border="0" cellspacing="3" cellpadding="4">
									<tr bgcolor="#DFDFBF" valign="top">
										<td width="73%">

											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/revistas.gif</xsl:attribute>
												<xsl:attribute name="width">205</xsl:attribute>
												<xsl:attribute name="height">23</xsl:attribute>
												<xsl:attribute name="alt">Alphabetic list of serials</xsl:attribute>
											</img>

										</td>
										<td width="27%">
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/busqueda.gif</xsl:attribute>
												<xsl:attribute name="width">100</xsl:attribute>
												<xsl:attribute name="height">23</xsl:attribute>
												<xsl:attribute name="alt">Articles search</xsl:attribute>

											</img>
										</td>
									</tr>
									<tr bgcolor="#CCCC99" valign="top">
										<td width="73%" rowspan="3">
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0021-2571&amp;lng=en&amp;nrm=iso</xsl:attribute>

														Annali dell'Istituto Superiore di Sanità
													</a>
												</font>
											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0042-9686&amp;lng=en&amp;nrm=iso</xsl:attribute>

														Bulletin of the World Health Organization
													</a>
												</font>
											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0102-311X&amp;lng=en&amp;nrm=iso</xsl:attribute>			
														Cadernos de Saúde Pública
													</a>

												</font>
											</p>
											
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1413-8123&amp;lng=en&amp;nrm=iso</xsl:attribute>			
														Cîência e Saúde Coletiva													</a>
												</font>

											</p>
<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0213-9111&amp;lng=en&amp;nrm=iso</xsl:attribute>			
														Gaceta Sanitaria
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1415-790X&amp;lng=en&amp;nrm=iso</xsl:attribute>			
														Revista Brasileira de Epidemiologia
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0864-3466&amp;lng=en&amp;nrm=iso</xsl:attribute>			
														Revista Cubana de Salud Pública
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0124-0064&amp;lng=en&amp;nrm=iso</xsl:attribute>
														Revista de Salud Pública (Colombia)
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0034-8910&amp;lng=en&amp;nrm=iso</xsl:attribute>
														Revista de Saúde Pública
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1135-5727&amp;lng=en&amp;nrm=iso</xsl:attribute>
														Revista Española de Salud Pública
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1020-4989&amp;lng=en&amp;nrm=iso</xsl:attribute>
														Revista Panamericana de Salud Pública
													 </a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1726-4634&amp;lng=en&amp;nrm=iso</xsl:attribute>
														Revista Peruana de Medicina Experimental y Salud Pública
													 </a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0036-3634&amp;lng=en&amp;nrm=iso</xsl:attribute>
														Salud Pública de México
													</a>
												</font>

											</p>
										</td>
										<td width="27%">
											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of select="SCIELO_INFO/PATH_WXIS" />/iah/?IsisScript=iah/iah.xis&amp;base=article^dlibrary&amp;index=AU&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>Author
												</a>

												</font>
												<br/>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of select="SCIELO_INFO/PATH_WXIS" />/iah/?IsisScript=iah/iah.xis&amp;base=article^dlibrary&amp;index=KW&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>Subject
												</a>
												</font>

												<br/>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of select="SCIELO_INFO/PATH_WXIS" />/iah/?IsisScript=iah/iah.xis&amp;base=article^dlibrary&amp;fmt=iso.pft&amp;lang=i</xsl:attribute>Form
												</a>
												</font>
												<br/>&#160;</p>
										</td>

									</tr>
									<xsl:if test=" ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 or ENABLE_COAUTH_REPORTS_LINK = '1' ">			
									<tr bgcolor="#CCCC99" valign="top">
										<td width="27%" bgcolor="#DFDFBF">
											<br/>
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/inform.gif</xsl:attribute>
												<xsl:attribute name="width">100</xsl:attribute>

												<xsl:attribute name="height">23</xsl:attribute>
												<xsl:attribute name="alt">Reports</xsl:attribute>
											</img>
										</td>
									</tr>
									<tr bgcolor="#CCCC99" valign="top">
										<td width="27%">
											<p>

												<xsl:if test=" ENABLE_STAT_LINK = 1 ">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a><xsl:call-template name="AddScieloLink">
													<xsl:with-param name="script">sci_stat</xsl:with-param>   
												</xsl:call-template>Site usage</a>
												</font>
												<br/>
												</xsl:if>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">
												<xsl:if test=" ENABLE_CIT_REP_LINK = 1 ">

												&#160;<a href="{SCIELO_INFO/STAT_SERVER_CITATION}stat_biblio/index.php?lang={LANGUAGE}">
														<font class="linkado" size="-1">Citation</font>
													  </a>
													<br/>
												</xsl:if>
												<xsl:if test=" ENABLE_COAUTH_REPORTS_LINK  = '1' ">

												&#160;<a href="{SCIELO_INFO/STAT_SERVER_COAUTH}stat_biblio/index.php?lang={LANGUAGE}&amp;state=16">
														<font class="linkado" size="-1">Co-authors</font>
											  		  </a>

<!-- Links da nova bibliometria, Rogério, 20041001-->													
																												  <!--a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of
				 										select="SCIELO_INFO/PATH_DATA" />bib2jcr.htm</xsl:attribute>Citation</a-->
												<br/>
												</xsl:if>
												</font>
												&#160;
											</p>
										</td>
									</tr>
									</xsl:if>

								</table>
								<p>&#160;</p>
							</td>
						</tr>
						<tr>
							<td width="602" valign="top" bgcolor="#DFDFBF" colspan="2">
								<p>&#160;</p>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr bgcolor="#CCCC99">

										<td>
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/site2.gif</xsl:attribute>
												<xsl:attribute name="width">200</xsl:attribute>
												<xsl:attribute name="height">22</xsl:attribute>
											</img>
											<a name="site"/>

										</td>
									</tr>
								</table>
								<table width="100%" border="0" cellspacing="0" cellpadding="4" bgcolor="#CCCC99">
									<tr>
										<td>
											<p>
												<font size="3" face="Verdana, Arial, Helvetica, sans-serif"/>
											</p>

											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">
													<strong>SciELO Public Health</strong>        is an electronic library online covering health science articles published by scientific journals. Its         primary goal is to provide universal and integrated access to scientific journals in the health science area        within Ibero-american countries.</font>
											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans" size="2">
													<strong>SciELO Public Health        </strong> library uses <strong>SciELO</strong> methodology which has been developed as a joint venture project        by <a href="http://www.fapesp.br">

														<strong>FAPESP</strong>
													</a> - Fundação de Amparo        à Pesquisa do Estado de São Paulo and <a href="http://www.bireme.br">
														<strong>BIREME</strong>
													</a>        - Centro Latinoamericano y del Caribe de Información en Ciencias de la Salud de la        Organización Panamericana de la Salud.</font>
											</p>
											<p align="right">

												<a href="#top">
													<img>
														<xsl:attribute name="src">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
															select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/top.gif</xsl:attribute>
														<xsl:attribute name="width">14</xsl:attribute>
														<xsl:attribute name="height">14</xsl:attribute>
														<xsl:attribute name="border">0</xsl:attribute>

														<xsl:attribute name="alt">top</xsl:attribute>
													</img>
												</a>
											</p>
										</td>
									</tr>
								</table>
								<p>&#160;</p>

								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr bgcolor="#CCCC99">
										<td>
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/ayuda2.gif</xsl:attribute>
												<xsl:attribute name="width">84</xsl:attribute>
												<xsl:attribute name="height">22</xsl:attribute>

											</img>
											<a name="ayuda"/>
										</td>
									</tr>
								</table>
								<table width="100%" border="0" cellspacing="0" cellpadding="4" bgcolor="#CCCC99">
									<tr>
										<td>
											<p>&#160;</p>

											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">
													<b>SciELO</b>                 interface provides access to its serials collection via an alphabetic                 list of titles or a subject index or a search by word of serial                 titles, publisher names, city of publication and subject.</font>
											</p>
											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">                 The interface also provides access to the full text of articles                 via author index or subject index or a search form on article                 elements such as author names, words from title, subject and words                 from the full text.</font>

											</p>
											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">                 Click an hypertext link to call the corresponding access page.</font>
											</p>
											<p align="right">
												<a href="#top">
													<img>
														<xsl:attribute name="src">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
															select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/top.gif</xsl:attribute>

														<xsl:attribute name="width">14</xsl:attribute>
														<xsl:attribute name="height">14</xsl:attribute>
														<xsl:attribute name="border">0</xsl:attribute>
														<xsl:attribute name="alt">topo</xsl:attribute>
													</img>
												</a>
											</p>

										</td>
									</tr>
								</table>
								<hr/>
								<p align="center">
									<font face="Verdana, Arial, Helvetica, sans-serif" size="1">SciELO Public Health<br/>BIREME<br/>Rua Botucatu, 862 - Vila Clementino<br/>04023-901 São Paulo SP - Brazil<br/>Tel.: (55 11) 5576-9863<br/>Fax: (55 11) 5575-8868<br/>

										<br/>
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/i/correo.gif</xsl:attribute>
											<xsl:attribute name="width">51</xsl:attribute>
											<xsl:attribute name="height">29</xsl:attribute>
											<xsl:attribute name="alt">electronic mail</xsl:attribute>

										</img>
										<br/>
										<a href="mailto:scielosp@bireme.br">scielosp@bireme.br</a>
									</font>
								</p>
							</td>
						</tr>
					</table>

					<p>&#160; </p>
				</div>
				<div align="center"/>
				<p>&#160;</p>
				<p>&#160;</p>
				<p>&#160;</p>
				<p>&#160;</p>
				<p>&#160;</p>

				<p>&#160;</p>
				<xsl:call-template name="UpdateLog" />
			</body>
		</html>
	</xsl:template>
	<xsl:template match="CONTROLINFO[LANGUAGE='pt']">
		<html>
			<head>
				<title>SciELO - Saúde Pública</title>

				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="STYLESHEET" type="text/css" href="http:/css/scielo.css"/>
				<style type="text/css">
					a { text-decoration: none; }
	 			</style>
			</head>
			<body bgcolor="#DFDFBF" link="#990000" vlink="#990000">
				<div align="center">

					<table width="600" border="0" cellspacing="0" cellpadding="0">
						<tr bgcolor="#DFDFBF">
							<td colspan="2">
								<div align="center">
									<img>
										<xsl:attribute name="src">http://<xsl:value-of 
											select="SCIELO_INFO/SERVER" /><xsl:value-of 
											select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
											select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/spalc.gif</xsl:attribute>
										<xsl:attribute name="width">600</xsl:attribute>

										<xsl:attribute name="height">119</xsl:attribute>
										<xsl:attribute name="border">0</xsl:attribute>
									</img>
								</div>
							</td>
						</tr>
						<tr>
							<td width="145" valign="top" bgcolor="#DFDFBF">

								<p>
									<br/>
									<br/>
									<a href="http://www.bireme.br/bvs/P/phome.htm">
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/pbvs.gif</xsl:attribute>
											<xsl:attribute name="width">86</xsl:attribute>

											<xsl:attribute name="height">102</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>
										</img>
									</a>
									<br/>
									<a>
										<xsl:attribute name="href">http://<xsl:value-of 
											select="SCIELO_INFO/SERVER" /><xsl:value-of 
											select="SCIELO_INFO/PATH_DATA" />scielo.php?lng=en</xsl:attribute>

									
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/eng.gif</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>	
										</img>
									</a>
									<br/>
									<a>
										<xsl:attribute name="href">http://<xsl:value-of 
											select="SCIELO_INFO/SERVER" /><xsl:value-of 
											select="SCIELO_INFO/PATH_DATA" />scielo.php?lng=es</xsl:attribute>

										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/esp.gif</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>
										</img>
									</a>
									<br/>
									<a href="#site">

										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/site.gif</xsl:attribute>
											<xsl:attribute name="width">135</xsl:attribute>
											<xsl:attribute name="height">23</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>
											<xsl:attribute name="alt">Sobre este site</xsl:attribute>

										</img>
									</a>
									<br/>
									<a href="#ayuda">
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/ayuda.gif</xsl:attribute>
											<xsl:attribute name="width">135</xsl:attribute>

											<xsl:attribute name="height">23</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>
											<xsl:attribute name="alt">Ajuda</xsl:attribute>
										</img>
									</a>
									<br/>
								</p>

							</td>
							<td width="457" valign="top" bgcolor="#DFDFBF">
								<table width="100%" border="0" cellspacing="3" cellpadding="4">
									<tr bgcolor="#DFDFBF" valign="top">
										<td width="73%">
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/revistas.gif</xsl:attribute>
												<xsl:attribute name="width">205</xsl:attribute>

												<xsl:attribute name="height">23</xsl:attribute>
												<xsl:attribute name="alt">Lista alfabética de revistas</xsl:attribute>
											</img>
										</td>
										<td width="27%">
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/busqueda.gif</xsl:attribute>

												<xsl:attribute name="width">100</xsl:attribute>
												<xsl:attribute name="height">23</xsl:attribute>
												<xsl:attribute name="alt">Pesquisa de artigos</xsl:attribute>
											</img>
										</td>
									</tr>
									<tr bgcolor="#CCCC99" valign="top">

										<td width="73%" rowspan="3">
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0021-2571&amp;lng=pt&amp;nrm=iso</xsl:attribute>

														Annali dell'Istituto Superiore di Sanità
													</a>
												</font>
											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0042-9686&amp;lng=pt&amp;nrm=iso</xsl:attribute>
														Bulletin of the World Health Organization
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0102-311X&amp;lng=pt&amp;nrm=iso</xsl:attribute>
														Cadernos de Saúde Pública
													</a>
												</font>

											</p>
																						<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1413-8123&amp;lng=pt&amp;nrm=iso</xsl:attribute>			
														Cîência e Saúde Coletiva													</a>
												</font>

											</p>
<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0213-9111&amp;lng=pt&amp;nrm=iso</xsl:attribute>
														Gaceta Sanitaria
													</a>
												</font>

											</p>
<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1415-790X&amp;lng=pt&amp;nrm=iso</xsl:attribute>			
														Revista Brasileira de Epidemiologia
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0864-3466&amp;lng=en&amp;nrm=iso</xsl:attribute>			
														Revista Cubana de Salud Pública
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0124-0064&amp;lng=pt&amp;nrm=iso</xsl:attribute>
														 Revista de Salud Pública (Colômbia)
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0034-8910&amp;lng=pt&amp;nrm=iso</xsl:attribute>
														 Revista de Saúde Pública
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1135-5727&amp;lng=pt&amp;nrm=iso</xsl:attribute>
														 Revista Española de Salud Pública
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1020-4989&amp;lng=pt&amp;nrm=iso</xsl:attribute>
													 	Revista Panamericana de Salud Pública
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1726-4634&amp;lng=pt&amp;nrm=iso</xsl:attribute>
														Revista Peruana de Medicina Experimental y Salud Pública
													 </a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0036-3634&amp;lng=pt&amp;nrm=iso</xsl:attribute>
														Salud Pública de México
													</a>
												</font>

											</p>
										</td>
										<td width="27%">
											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of select="SCIELO_INFO/PATH_WXIS" />/iah/?IsisScript=iah/iah.xis&amp;base=article^dlibrary&amp;index=AU&amp;fmt=iso.pft&amp;lang=p</xsl:attribute>Autor
												</a>

												</font>
												<br/>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of select="SCIELO_INFO/PATH_WXIS" />/iah/?IsisScript=iah/iah.xis&amp;base=article^dlibrary&amp;index=KW&amp;fmt=iso.pft&amp;lang=p</xsl:attribute>Assunto
												</a>
												</font>

												<br/>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of select="SCIELO_INFO/PATH_WXIS" />/iah/?IsisScript=iah/iah.xis&amp;base=article^dlibrary&amp;fmt=iso.pft&amp;lang=p</xsl:attribute>Formulário
												</a>
												</font>
												<br/>              &#160;</p>

										</td>
									</tr>
									<xsl:if test=" ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 ">			
									<tr bgcolor="#CCCC99" valign="top">
										<td width="27%" bgcolor="#DFDFBF">
											<br/>
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/inform.gif</xsl:attribute>

												<xsl:attribute name="width">100</xsl:attribute>
												<xsl:attribute name="height">23</xsl:attribute>
												<xsl:attribute name="alt">Relatórios</xsl:attribute>
											</img>
										</td>
									</tr>
									<tr bgcolor="#CCCC99" valign="top">

										<td width="27%">
											<p>
												<xsl:if test=" ENABLE_STAT_LINK = 1 ">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a><xsl:call-template name="AddScieloLink">
													<xsl:with-param name="script">sci_stat</xsl:with-param>   
												</xsl:call-template>Uso do site</a>
												</font>
												<br/>

											</xsl:if>
												<xsl:if test=" ENABLE_CIT_REP_LINK = 1 ">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">
												&#160;<a href="{SCIELO_INFO/STAT_SERVER}stat_biblio/index.php?lang={LANGUAGE}">
														<font class="linkado" size="-1">Citações</font>
													  </a>
													<br/>
												&#160;<a href="{SCIELO_INFO/STAT_SERVER}stat_biblio/index.php?lang={LANGUAGE}&amp;state=16">

														<font class="linkado" size="-1">Co-autoria</font>
											  		  </a>
<!-- Links da nova bibliometria, Rogério, 20041001-->	
																												  <!--a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of
				 										select="SCIELO_INFO/PATH_DATA" />bib2jcrp.htm</xsl:attribute>Citações</a-->
												</font>
												<br/>
												</xsl:if>
												&#160;
											</p>

										</td>
									</tr>
									</xsl:if>									
								</table>
								<p>&#160;</p>
							</td>
						</tr>
						<tr>
							<td width="602" valign="top" bgcolor="#DFDFBF" colspan="2">

								<p>&#160;</p>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr bgcolor="#CCCC99">
										<td>
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/site2.gif</xsl:attribute>
												<xsl:attribute name="width">200</xsl:attribute>

												<xsl:attribute name="height">22</xsl:attribute>
											</img>
											<a name="site"/>
										</td>
									</tr>
								</table>
								<table width="100%" border="0" cellspacing="0" cellpadding="4" bgcolor="#CCCC99">
									<tr>

										<td>
											<p>
												<font size="3" face="Verdana, Arial, Helvetica, sans-serif"/>
											</p>
											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">
													<strong>SciELO Saúde Pública</strong>        é uma biblioteca eletrônica online de revistas científicas em saúde pública. Tem        por objetivo prover o acesso universal e integrado às revistas científicas em saúde        pública relacionadas com os países Ibero-americanos.</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans" size="2">A biblioteca <strong>SciELO Saúde        Pública</strong> utiliza a Metodologia <strong>SciELO</strong> desenvolvida em conjunto        pela <a href="http://www.fapesp.br">
														<strong>FAPESP</strong>
													</a> - Fundação de Amparo        à Pesquisa do Estado de São Paulo e pela <a href="http://www.bireme.br">

														<strong>BIREME</strong>
													</a>        - Centro Latinoamericano y del Caribe de Información en Ciencias de la Salud de la        Organización Panamericana de la Salud.</font>
											</p>
											<p align="right">
												<a href="#top">
													<img>
														<xsl:attribute name="src">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
															select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/top.gif</xsl:attribute>

														<xsl:attribute name="width">14</xsl:attribute>
														<xsl:attribute name="height">14</xsl:attribute>
														<xsl:attribute name="border">0</xsl:attribute>
														<xsl:attribute name="alt">top</xsl:attribute>
													</img>
												</a>
											</p>

										</td>
									</tr>
								</table>
								<p>&#160;</p>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr bgcolor="#CCCC99">
										<td>
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/ayuda2.gif</xsl:attribute>

												<xsl:attribute name="width">84</xsl:attribute>
												<xsl:attribute name="height">22</xsl:attribute>
											</img>
											<a name="ayuda"/>
										</td>
									</tr>
								</table>
								<table width="100%" border="0" cellspacing="0" cellpadding="4" bgcolor="#CCCC99">

									<tr>
										<td>
											<p>&#160;</p>
											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">A                 interface <b>SciELO</b> proporciona acesso à sua coleção                 de periódicos através de uma lista alfabética                 de títulos, ou por meio de um índice de assuntos,                 ou ainda através de um módulo de busca por palavras                 do título dos periódicos, pelos nomes das instituições                 publicadoras, pelo local de publicação e por assunto.</font>
											</p>
											<p>

												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">                 A interface também propicia acesso aos textos completos                 dos artigos através de índices de autor e de assunto,                 ou por meio de um formulário de busca dos elementos que                 compõem um artigo, tais como autor, palavras do título,                 assunto e palavras do texto.</font>
											</p>
											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">                 Clique nas opções marcadas com links para ter acesso                 às páginas correspondentes.</font>
											</p>
											<p align="right">
												<a href="#top">

													<img>
														<xsl:attribute name="src">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
															select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/top.gif</xsl:attribute>
														<xsl:attribute name="width">14</xsl:attribute>
														<xsl:attribute name="height">14</xsl:attribute>
														<xsl:attribute name="border">0</xsl:attribute>
														<xsl:attribute name="alt">topo</xsl:attribute>

													</img>
												</a>
											</p>
										</td>
									</tr>
								</table>
								<hr/>
								<p align="center">
									<font face="Verdana, Arial, Helvetica, sans-serif" size="1">SciELO Saúde Pública<br/>BIREME<br/>Rua Botucatu, 862 - Vila Clementino<br/>04023-901 São Paulo SP - Brasil<br/>Tel.: (55 11) 5576-9863<br/>Fax: (55 11) 5575-8868<br/>

										<br/>
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/p/correo.gif</xsl:attribute>
											<xsl:attribute name="width">51</xsl:attribute>
											<xsl:attribute name="height">29</xsl:attribute>
											<xsl:attribute name="alt">correio eletrônico</xsl:attribute>

										</img>
										<br/>
										<a href="mailto:scielosp@bireme.br">scielosp@bireme.br</a>
									</font>
								</p>
							</td>
						</tr>
					</table>

					<p>&#160; </p>
				</div>
				<div align="center"/>
				<p>&#160;</p>
				<p>&#160;</p>
				<p>&#160;</p>
				<p>&#160;</p>
				<p>&#160;</p>

				<p>&#160;</p>
				<xsl:call-template name="UpdateLog" />
			</body>
		</html>
	</xsl:template>
	<xsl:template match="CONTROLINFO[LANGUAGE='es']">
		<html>
			<head>
				<title>SciELO - Salud Pública</title>

				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="STYLESHEET" type="text/css" href="http:/css/scielo.css"/>
				<style type="text/css">
					a { text-decoration: none; } 
				</style>
			</head>
			<body bgcolor="#DFDFBF" link="#990000" vlink="#990000">
				<div align="center">

					<table width="600" border="0" cellspacing="0" cellpadding="0">
						<tr bgcolor="#DFDFBF">
							<td colspan="2">
								<div align="center">
									<img>
										<xsl:attribute name="src">http://<xsl:value-of 
											select="SCIELO_INFO/SERVER" /><xsl:value-of 
											select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
											select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/spalc.gif</xsl:attribute>
										<xsl:attribute name="width">600</xsl:attribute>

										<xsl:attribute name="height">119</xsl:attribute>
										<xsl:attribute name="border">0</xsl:attribute>
									</img>
								</div>
							</td>
						</tr>
						<tr>
							<td width="145" valign="top" bgcolor="#DFDFBF">

								<p>&#160;<br/>
									<br/>
									<a href="http://www.bireme.br/bvs/E/ehome.htm">
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/ebvs.gif</xsl:attribute>
											<xsl:attribute name="width">86</xsl:attribute>
											<xsl:attribute name="height">102</xsl:attribute>

											<xsl:attribute name="border">0</xsl:attribute>
										</img> 
									</a>
									<br/>
									<a>
										<xsl:attribute name="href">http://<xsl:value-of 
											select="SCIELO_INFO/SERVER" /><xsl:value-of 
											select="SCIELO_INFO/PATH_DATA" />scielo.php?lng=pt</xsl:attribute>
									
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/port.gif</xsl:attribute>

											<xsl:attribute name="border">0</xsl:attribute>
										</img>
									</a>
									<br/>
									<a>
										<xsl:attribute name="href">http://<xsl:value-of 
											select="SCIELO_INFO/SERVER" /><xsl:value-of 
											select="SCIELO_INFO/PATH_DATA" />scielo.php?lng=en</xsl:attribute>
										<img>

											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/eng.gif</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>
										</img>
									</a>
									<br/>
									<a href="#site">
										<img>

											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/site.gif</xsl:attribute>
											<xsl:attribute name="width">135</xsl:attribute>
											<xsl:attribute name="height">23</xsl:attribute>
											<xsl:attribute name="border">0</xsl:attribute>
											<xsl:attribute name="alt">Acerca de este Sitio</xsl:attribute>
										</img>

									</a>
									<br/>
									<a href="#ayuda">
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/ayuda.gif</xsl:attribute>
											<xsl:attribute name="width">135</xsl:attribute>
											<xsl:attribute name="height">23</xsl:attribute>

											<xsl:attribute name="border">0</xsl:attribute>
											<xsl:attribute name="alt">Ayuda</xsl:attribute>
										</img>
									</a>
									<br/>
								</p>
							</td>
							<td width="457" valign="top" bgcolor="#DFDFBF">

								<table width="100%" border="0" cellspacing="3" cellpadding="4">
									<tr bgcolor="#DFDFBF" valign="top">
										<td width="73%">
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/revistas.gif</xsl:attribute>
												<xsl:attribute name="width">205</xsl:attribute>
												<xsl:attribute name="height">23</xsl:attribute>

												<xsl:attribute name="alt">Lista alfabética de revistas</xsl:attribute>
											</img>
										</td>
										<td width="27%">
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/busqueda.gif</xsl:attribute>															<xsl:attribute name="width">100</xsl:attribute>

												<xsl:attribute name="height">23</xsl:attribute>
												<xsl:attribute name="alt">Búsqueda por artículos</xsl:attribute>
											</img>
										</td>
									</tr>
									<tr bgcolor="#CCCC99" valign="top">
										<td width="73%" rowspan="3">
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0021-2571&amp;lng=es&amp;nrm=iso</xsl:attribute>

														Annali dell'Istituto Superiore di Sanità
													</a>
												</font>
											</p>
											<p>

												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0042-9686&amp;lng=es&amp;nrm=iso</xsl:attribute>
														Bulletin of the World Health Organization
													</a>
												</font>
											</p>
											<p>

												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0102-311X&amp;lng=es&amp;nrm=iso</xsl:attribute>
														Cadernos de Saúde Pública
													</a>
												</font>
											</p>
																						<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1413-8123&amp;lng=es&amp;nrm=iso</xsl:attribute>			
														Cîência e Saúde Coletiva													</a>
												</font>

											</p>
<p>

												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0213-9111&amp;lng=es&amp;nrm=iso</xsl:attribute>
														Gaceta Sanitaria
													</a>
												</font>
											</p>
<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1415-790X&amp;lng=es&amp;nrm=iso</xsl:attribute>			
														Revista Brasileira de Epidemiologia
													</a>
												</font>

											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0864-3466&amp;lng=en&amp;nrm=iso</xsl:attribute>			
														Revista Cubana de Salud Pública
													</a>
												</font>

											</p>
											<p>

												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
													<xsl:attribute name="href">http://<xsl:value-of 
														select="SCIELO_INFO/SERVER" /><xsl:value-of 
														select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0124-0064&amp;lng=es&amp;nrm=iso</xsl:attribute>
														Revista de Salud Pública (Colombia)
													</a>
												</font>
											</p>
											<p>

												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
													<xsl:attribute name="href">http://<xsl:value-of 
														select="SCIELO_INFO/SERVER" /><xsl:value-of 
														select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0034-8910&amp;lng=es&amp;nrm=iso</xsl:attribute>
														Revista de Saúde Pública
													</a>
												</font>
											</p>
											<p>

												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1135-5727&amp;lng=es&amp;nrm=iso</xsl:attribute>
														 Revista Española de Salud Pública
													</a>
												</font>
											</p>
											<p>

												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1020-4989&amp;lng=es&amp;nrm=iso</xsl:attribute>
														Revista Panamericana de Salud Pública
													</a>
												</font>
											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=1726-4634&amp;lng=es&amp;nrm=iso</xsl:attribute>
														Revista Peruana de Medicina Experimental y Salud Pública
													 </a>
												</font>

											</p>
											<p>

												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">
													<a>
														<xsl:attribute name="href">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" />scielo.php?script=sci_serial&amp;pid=0036-3634&amp;lng=es&amp;nrm=iso</xsl:attribute>
													 	Salud Pública de México 
													</a>
												</font>
											</p>
										</td>

										<td width="27%">
											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of select="SCIELO_INFO/PATH_WXIS" />/iah/?IsisScript=iah/iah.xis&amp;base=article^dlibrary&amp;index=AU&amp;fmt=iso.pft&amp;lang=e</xsl:attribute>Autor
												</a>
												</font>

												<br/>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of select="SCIELO_INFO/PATH_WXIS" />/iah/?IsisScript=iah/iah.xis&amp;base=article^dlibrary&amp;index=KW&amp;fmt=iso.pft&amp;lang=e</xsl:attribute>Materia
												</a>
												</font>
												<br/>

												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of select="SCIELO_INFO/PATH_WXIS" />/iah/?IsisScript=iah/iah.xis&amp;base=article^dlibrary&amp;fmt=iso.pft&amp;lang=e</xsl:attribute>Formulario
												</a>
												</font>
												<br/>              &#160;</p>
										</td>

									</tr>
									<xsl:if test=" ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 ">			
									<tr bgcolor="#CCCC99" valign="top">
										<td width="27%" bgcolor="#DFDFBF">
											<br/>
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/inform.gif</xsl:attribute>
												<xsl:attribute name="width">100</xsl:attribute>

												<xsl:attribute name="height">23</xsl:attribute>
												<xsl:attribute name="alt">Informes</xsl:attribute>
											</img>
										</td>
									</tr>
									<tr bgcolor="#CCCC99" valign="top">
										<td width="27%">
											<p>

												<xsl:if test=" ENABLE_STAT_LINK = 1 ">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">&#160;<a><xsl:call-template name="AddScieloLink">
													<xsl:with-param name="script">sci_stat</xsl:with-param>   
												</xsl:call-template>Uso del sitio</a>
												</font>
												<br/>
												</xsl:if>
												<xsl:if test=" ENABLE_CIT_REP_LINK = 1 ">

												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">
												&#160;<a href="{SCIELO_INFO/STAT_SERVER}stat_biblio/index.php?lang={LANGUAGE}">
														<font class="linkado" size="-1">Citas</font>
													  </a>
													<br/>
												&#160;<a href="{SCIELO_INFO/STAT_SERVER}stat_biblio/index.php?lang={LANGUAGE}&amp;state=16">
														<font class="linkado" size="-1">Co-autoria</font>
											  		  </a>

																												  <!--a>
													<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER" /><xsl:value-of
				 										select="SCIELO_INFO/PATH_DATA" />bib2jcre.htm</xsl:attribute>Citas</a-->
												</font>
												<br/>
												</xsl:if>
												&#160;
											</p>
										</td>
									</tr>
									</xsl:if>

								</table>
								<p>&#160;</p>
							</td>
						</tr>
						<tr>
							<td width="602" valign="top" bgcolor="#DFDFBF" colspan="2">
								<p>&#160;</p>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr bgcolor="#CCCC99">

										<td>
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/site2.gif</xsl:attribute>
												<xsl:attribute name="width">200</xsl:attribute>
												<xsl:attribute name="height">22</xsl:attribute>
											</img>
											<a name="site"/>

										</td>
									</tr>
								</table>
								<table width="100%" border="0" cellspacing="0" cellpadding="4" bgcolor="#CCCC99">
									<tr>
										<td>
											<p>
												<font size="3" face="Verdana, Arial, Helvetica, sans-serif"/>
											</p>

											<p>
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif">
													<strong>SciELO Salud Pública</strong>        es una biblioteca electrónica online de revistas científicas en salud pública. Tiene        por objetivo prover acceso universal e integrado a las revistas científicas en salud        pública relacionadas con los países de Iberoamérica.</font>
											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans" size="2">La biblioteca <strong>SciELO Salud        Pública</strong> utiliza la Metodologia <strong>SciELO</strong> desarrollada en conjunto        por la <a href="http://www.fapesp.br">

														<strong>FAPESP</strong>
													</a> - Fundação de Amparo        à Pesquisa do Estado de São Paulo y por <a href="http://www.bireme.br">
														<strong>BIREME</strong>
													</a>        - Centro Latinoamericano y del Caribe de Información en Ciencias de la Salud de la        Organización Panamericana de la Salud.</font>
											</p>
											<p align="right">

												<a href="#top">
													<img>
														<xsl:attribute name="src">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
															select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/top.gif</xsl:attribute>
														<xsl:attribute name="width">14</xsl:attribute>
														<xsl:attribute name="height">14</xsl:attribute>
														<xsl:attribute name="border">0</xsl:attribute>

														<xsl:attribute name="alt">top</xsl:attribute>
													</img>
												</a>
											</p>
										</td>
									</tr>
								</table>
								<p>&#160;</p>

								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr bgcolor="#CCCC99">
										<td>
											<img>
												<xsl:attribute name="src">http://<xsl:value-of 
													select="SCIELO_INFO/SERVER" /><xsl:value-of 
													select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
													select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/ayuda2.gif</xsl:attribute>
												<xsl:attribute name="width">84</xsl:attribute>
												<xsl:attribute name="height">22</xsl:attribute>

											</img>
											<a name="ayuda"/>
										</td>
									</tr>
								</table>
								<table width="100%" border="0" cellspacing="0" cellpadding="4" bgcolor="#CCCC99">
									<tr>
										<td>
											<p>&#160;</p>

											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">La                 interfase <b>SciELO</b> proporciona acceso a su colección                 de revistas mediante una lista alfabética de títulos,                 un índice de materias, o una búsqueda por palabra                 de las revistas, nombres de publicadores, ciudad de publicación                 y materia.</font>
											</p>
											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">                 La interfase también proporciona acceso al texto completo                 de los artículos por medio de un índice de autores,                 un índice de materias o un formulario de búsqueda                 por los elementos del artículo como nombres de autores,                 palabras del título, materias y palabras del texto completo.</font>
											</p>

											<p>
												<font face="Verdana, Arial, Helvetica, sans-serif" size="2">                 Clique un enlace hipertexto para llamar la correspondiente página                 de acceso.</font>
											</p>
											<p align="right">
												<a href="#top">
													<img>
														<xsl:attribute name="src">http://<xsl:value-of 
															select="SCIELO_INFO/SERVER" /><xsl:value-of 
															select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
															select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/top.gif</xsl:attribute>

														<xsl:attribute name="width">14</xsl:attribute>
														<xsl:attribute name="height">14</xsl:attribute>
														<xsl:attribute name="border">0</xsl:attribute>
														<xsl:attribute name="alt">topo</xsl:attribute>
													</img>
												</a>
											</p>

										</td>
									</tr>
								</table>
								<hr/>
								<p align="center">
									<font face="Verdana, Arial, Helvetica, sans-serif" size="1">SciELO Salud Pública<br/>BIREME<br/>Rua Botucatu, 862 - Vila Clementino<br/>04023-901 São Paulo SP - Brasil<br/>Tel.: (55 11) 5576-9863<br/>Fax: (55 11) 5575-8868<br/>

										<br/>
										<img>
											<xsl:attribute name="src">http://<xsl:value-of 
												select="SCIELO_INFO/SERVER" /><xsl:value-of 
												select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
												select="SCIELO_INFO/PATH_GENIMG" />sp-home/e/correo.gif</xsl:attribute>
											<xsl:attribute name="width">51</xsl:attribute>
											<xsl:attribute name="height">29</xsl:attribute>
											<xsl:attribute name="alt">correo electrónico</xsl:attribute>

										</img>
										<br/>
										<a href="mailto:scielosp@bireme.br">scielosp@bireme.br</a>
									</font>
								</p>
							</td>
						</tr>
					</table>

					<p>&#160; </p>
				</div>
				<div align="center"/>
				<p>&#160;</p>
				<p>&#160;</p>
				<p>&#160;</p>
				<p>&#160;</p>
				<p>&#160;</p>

				<p>&#160;</p>
				<xsl:call-template name="UpdateLog" />
			</body>
		</html>
	</xsl:template>
	<xsl:template match="SCIELOINFOGROUP">
		<hr/>
		<p align="center">
			<font class="nomodel" color="#0000A0" size="-1">

				<xsl:value-of select="normalize-space(SITE_NAME)"/>
				<br/>
				<xsl:value-of select="normalize-space(ORGANIZATION)"/>
				<br/>
				<xsl:value-of select="normalize-space(ADDRESS/ADDRESS_1)"/>
				<br/>
				<xsl:value-of select="normalize-space(ADDRESS/ADDRESS_2)"/> - <xsl:value-of select="normalize-space(ADDRESS/COUNTRY)"/>
				<br/> 			Tel.: <xsl:value-of select="normalize-space(PHONE)"/>

				<br/> 			Fax: <xsl:value-of select="normalize-space(FAX)"/>
			</font>
			<br/>
			<a>
				<xsl:attribute name="href">mailto:<xsl:value-of select="normalize-space(EMAIL)"/></xsl:attribute>
				<img>
					<xsl:attribute name="src">http://<xsl:value-of 
						select="SCIELO_INFO/SERVER" /><xsl:value-of 
						select="SCIELO_INFO/PATH_DATA" /><xsl:value-of 
						select="//PATH_GENIMG"/>e-mailt.gif</xsl:attribute>

					<xsl:attribute name="border">0</xsl:attribute>
				</img>
				<br/>
				<font color="#0000A0" size="2">
					<xsl:value-of select="normalize-space(EMAIL)"/>
				</font>
			</a>
		</p>

		<xsl:call-template name="UpdateLog" />	
	</xsl:template>
</xsl:stylesheet> 
