<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="no" />
<xsl:include href="file:///home/scielo/www/htdocs/xsl/sci_common.xsl"/>
<xsl:include href="file:///home/scielo/www/htdocs/xsl/sci_mysqlerror.xsl"/>

<xsl:template match="JOURNALSTAT">
	<html>
	<head>
		<title>
			<xsl:if test=" count(LIST) = 0 ">
				<xsl:value-of select="JOURNAL/TITLEGROUP/SHORTTITLE" disable-output-escaping="yes" /> - 
			</xsl:if>
			<xsl:choose>
				<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Journal requests summary</xsl:when>
				<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">Resumo de acessos às revistas</xsl:when>
				<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">Resumen de accesos a las revistas</xsl:when>                        
			</xsl:choose>
		</title>
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />

		<xsl:call-template name="SetLogJavascriptCode" />
	</head>

	<body bgColor="#ffffff">
		<xsl:call-template name="PrintPageHeaderInfo" />
		<xsl:call-template name="PrintForm" />
		<xsl:call-template name="ShowResultTable" />
		<xsl:apply-templates select="COPYRIGHT" />
	</body>
	</html>
</xsl:template>

<xsl:template name="ShowResultTable">
	<table cellspacing="2" cellpadding="2" width="96%" align="center" border="0">
		<xsl:choose>
			<xsl:when test=".//HOMEPAGE or .//ISSUETOC or .//ARTICLES or .//OTHERS">	
				<xsl:call-template name="ShowResultTableHeader" />
				<xsl:choose>
					<xsl:when test="LIST/JOURNAL or ./JOURNAL">
						<xsl:choose>
							<xsl:when test=" //FILTER/ORDER = 1 ">
								<xsl:apply-templates select="//JOURNAL">
									<xsl:sort select="TITLE" order="ascending" />
            							</xsl:apply-templates>
		        				</xsl:when>
							<xsl:when test=" //FILTER/ORDER = 2 ">
								<xsl:apply-templates select="//JOURNAL">
									<xsl:sort select="HOMEPAGE" order="descending" />
								</xsl:apply-templates>
							</xsl:when>
							<xsl:when test=" //FILTER/ORDER = 3 ">
								<xsl:apply-templates select="//JOURNAL">
									<xsl:sort select="ISSUETOC" order="descending" />
								</xsl:apply-templates>
							</xsl:when>
							<xsl:when test=" //FILTER/ORDER = 4 ">
								<xsl:apply-templates select="//JOURNAL">
									<xsl:sort select="ARTICLES" order="descending" />
								</xsl:apply-templates>
							</xsl:when>
							<xsl:when test=" //FILTER/ORDER = 5 ">
								<xsl:apply-templates select="//JOURNAL">
									<xsl:sort select="OTHERS" order="descending" />
								</xsl:apply-templates>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="//JOURNAL" />
							</xsl:otherwise>                
						</xsl:choose>
					</xsl:when>
					<!--xsl:otherwise>
						<tr><td><p>&#160;</p><xsl:call-template name="ShowEmptyQueryResult" /></td></tr>
					</xsl:otherwise-->
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<tr><td><p>&#160;</p><xsl:call-template name="ShowEmptyQueryResult" /></td></tr>
			</xsl:otherwise>
		</xsl:choose>
	</table>		
</xsl:template>

<xsl:template match="COPYRIGHT">
	<p>
		<xsl:call-template name="COPYRIGHTSCIELO" />
	</p>
</xsl:template>

<xsl:template name="PutOrderSelector">
	<xsl:param name="ORDER" />
	<xsl:param name="TIP" />

	<xsl:choose>
		<xsl:when test=" not(//FILTER/ORDER) "></xsl:when>
		<xsl:when test=" //FILTER/ORDER = $ORDER "><b><font face="Symbol" color="#eb0000" size="2">D</font></b></xsl:when>
		<xsl:otherwise>
			<a>
				<xsl:call-template name="AddScieloLogLink">
					<xsl:with-param name="pid" select="//JOURNAL/ISSN" />
					<xsl:with-param name="script">sci_journalstat</xsl:with-param>
					<xsl:with-param name="order" select="$ORDER" />
					<xsl:with-param name="dti" select="//STATPARAM/FILTER/INITIAL_DATE" />
					<xsl:with-param name="dtf" select="//STATPARAM/FILTER/FINAL_DATE" /> 					
				</xsl:call-template>	
				<xsl:attribute name="title"><xsl:value-of select="$TIP" /></xsl:attribute>                
				<b><font face="Symbol" color="#0000eb" size="2">Ñ</font></b>
			</a>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="JOURNAL">
	<tr>
		<xsl:attribute name="bgcolor"><xsl:choose>
			<xsl:when test="(position() mod 2) = 1">#f2f2f2</xsl:when>
			<xsl:otherwise>#eff7f7</xsl:otherwise>
		</xsl:choose></xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>

		<xsl:if test="/JOURNALSTAT/LIST">
			<td align="left" width="30%">
				<font face="Arial" size="2"><xsl:value-of select="TITLE" disable-output-escaping="yes" /></font>
			</td>
		</xsl:if>
        
		<td align="left" width="22%">
			<xsl:choose>
				<xsl:when test="@STARTDATE != '' ">
					<font face="Arial" size="2">
						<xsl:call-template name="ShowDate">
							<xsl:with-param name="DATEISO" select="@STARTDATE" />
							<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE" />
							<xsl:with-param name="ABREV">1</xsl:with-param>
						</xsl:call-template>
					</font>
				</xsl:when>
				<xsl:otherwise>&#160;</xsl:otherwise>
			</xsl:choose>
		</td>
       
		<td align="right" width="12%">
			<font face="Arial" size="2"><xsl:value-of select="HOMEPAGE" /></font>&#160;
		</td>
        
		<td align="right" width="12%">
			<font face="Arial" size="2"><xsl:value-of select="ISSUETOC" /></font>&#160;
		</td>
        
		<td align="right" width="12%">
			<font face="Arial" size="2"><xsl:value-of select="ARTICLES" /></font>&#160;
		</td>
        
		<td align="right" width="12%">
			<font face="Arial" size="2"><xsl:value-of select="OTHERS" /></font>&#160;
		</td>
	</tr>
</xsl:template>


<xsl:template name="PrintPageHeaderInfo">
	<table cellspacing="0" cellpadding="0" width="100%">
		<tr>
		<td width="20%">
		<p align="center">

			<a>
			<xsl:choose>
				<xsl:when test="LIST or not(JOURNAL)">
					<xsl:attribute name="href">http://<xsl:value-of 
						select="CONTROLINFO/SCIELO_INFO/SERVER" /><xsl:value-of 
						select="CONTROLINFO/SCIELO_INFO/PATH_DATA" />scielo.php/lng_<xsl:value-of
						select="CONTROLINFO/LANGUAGE" />/nrm_<xsl:value-of
						select="CONTROLINFO/STANDARD" /></xsl:attribute>

					<img>
						<xsl:attribute name="src">http://<xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/SERVER" /><xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/PATH_DATA" /><xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/PATH_GENIMG" /><xsl:value-of
							select="CONTROLINFO/LANGUAGE" />/fbpelogp.gif</xsl:attribute>
						<xsl:attribute name="alt">xScientific Electronic Library Online</xsl:attribute>
						<xsl:attribute name="border">0</xsl:attribute>
					</img>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="AddScieloLink">
						<xsl:with-param name="seq" select="JOURNAL/ISSN" />
						<xsl:with-param name="script">sci_serial</xsl:with-param>
					</xsl:call-template>
    
					<img>
						<xsl:attribute name="src">http://<xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/SERVER" /><xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/PATH_DATA" /><xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/PATH_SERIMG" /><xsl:value-of
							select="JOURNAL/TITLEGROUP/SIGLUM" />/plogo.gif</xsl:attribute>
						<xsl:attribute name="alt">x<xsl:value-of select="JOURNAL/TITLEGROUP/SHORTTITLE"/></xsl:attribute>
						<xsl:attribute name="border">0</xsl:attribute>
					</img>
				</xsl:otherwise>
			</xsl:choose>
			</a>                    
		</p>
		</td>
		<td width="80%">
			<blockquote>
			<xsl:choose>
				<xsl:when test="LIST">
					<p align="left">
						<font face="Verdana" color="#000080" size="4">
							<xsl:choose>
								<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Library Collection</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">Coleção da biblioteca</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">Colección de la biblioteca</xsl:when>
							</xsl:choose>
						</font>
					</p>
				</xsl:when>
				<xsl:otherwise>
					<font class="nomodel" size="+1" color="#000080">
						<xsl:value-of select="JOURNAL/TITLEGROUP/TITLE" disable-output-escaping="yes" />
					</font><br/>
					<font class="nomodel" color="#000080">
						<xsl:apply-templates select="JOURNAL/ISSN">
							<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)" />
						</xsl:apply-templates>
					</font>
				</xsl:otherwise>
			</xsl:choose>
			</blockquote>
		</td>
		</tr>
		<tr>
		<td></td>
		<td>
			<p>
				<blockquote>
				<font face="Verdana" color="#800000" size="2">
					<xsl:choose>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Site usage reports</xsl:when>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">Relatórios de utilização do site</xsl:when>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">Informes de uso del sítio</xsl:when>
					</xsl:choose>                            
				</font>
				</blockquote>
			</p>
		</td>
		</tr>
	</table>
		
	<table cellspacing="2" cellpadding="2" width="96%" align="center" border="0">
		<tr width="100%">
		<td align="left" width="70%" colspan="6">
			<p align="left">
			<b><font face="Verdana" size="2">
				<xsl:choose>
					<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Journal requests summary</xsl:when>
					<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">Resumo de acessos às revistas</xsl:when>
					<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">Resumen de accesos a las revistas</xsl:when>                        
				</xsl:choose>
				<xsl:apply-templates select="//STATPARAM/CURRENT_DATE" />
                    </font></b>
                    </p>
			<xsl:apply-templates select="//STATPARAM/START_DATE" />
		</td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="CURRENT_DATE">
	<xsl:choose>
		<xsl:when test=" //CONTROLINFO/LANGUAGE = 'en' "> - as of </xsl:when>
		<xsl:when test=" //CONTROLINFO/LANGUAGE = 'pt' "> - datado de </xsl:when>
		<xsl:when test=" //CONTROLINFO/LANGUAGE = 'es' "> - fecha del </xsl:when>
	</xsl:choose>
	
	<xsl:call-template name="ShowDate">
		<xsl:with-param name="DATEISO" select="." />
		<xsl:with-param name="LANG" select=" //CONTROLINFO/LANGUAGE" />
	</xsl:call-template>
</xsl:template>

<xsl:template match="START_DATE">
	<p>
		<font face="Verdana" size="2">

		<xsl:call-template name="PrintLogStartDate">
			<xsl:with-param name="date" select="." />
		</xsl:call-template>
		</font>

	</p>
</xsl:template>

<xsl:template name="PrintForm">
	<table cellspacing="2" cellpadding="2" width="96%" align="center" border="0">
		<tr width="100%">
		<td align="left" width="70%" colspan="6">
		<font face="Verdana" size="2">

			<br/>
			<p><xsl:call-template name="PrintDateRangeSelection" /></p>			
		</font>

			<form>
				<xsl:call-template name="GenerateLogForm">
					<xsl:with-param name="script">sci_journalstat</xsl:with-param>
					<xsl:with-param name="pid"><xsl:value-of select="normalize-space(//ISSN)" /></xsl:with-param>            
				</xsl:call-template>
								
				<xsl:call-template name="PutSubmitButton" />
			</form>
				
			<xsl:if test="LIST/JOURNAL">
				<p align="left">
					<b><font face="Symbol" color="#0000eb" size="2">Ñ</font></b> - 
			<font face="Verdana" size="2">

					<xsl:choose>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">click to select column order</xsl:when>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">clique para selecionar a coluna de ordenação</xsl:when>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">clique para seleccionar la columna de ordenamiento</xsl:when>
					</xsl:choose><br/>
					<b><font face="Symbol" color="#eb0000" size="2">D</font></b> - 
					<xsl:choose>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">indicates current order</xsl:when>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">indica a ordem corrente</xsl:when>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">indica el orden actual</xsl:when>
					</xsl:choose>
			</font>

				</p>
			</xsl:if>                
		</td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="ShowResultTableHeader">
	<tr bgColor="#dfebeb" width="100%">
		<xsl:choose>
			<xsl:when test="LIST">
				<td width="52%" colspan="2">&#160;</td>
			</xsl:when>
			<xsl:otherwise>
				<td width="30%">&#160;</td>
			</xsl:otherwise>
		</xsl:choose>
		<td align="middle" width="48%" colspan="4">
			<b>
			<font face="Arial" size="2">

				<xsl:choose>
					<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">number of requests</xsl:when>
					<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">número de acessos</xsl:when>
					<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">numero de accesos</xsl:when>
				</xsl:choose>                            
			</font>

			</b>
		</td>
	</tr>
	<tr bgColor="#dfebeb" width="100%">
		<xsl:if test="LIST">
			<td width="30%">
				<strong>
					<font face="Arial" size="2">
						<xsl:if test=" LIST and //FILTER/ORDER = 1 ">
							<xsl:attribute name="color">#eb0000</xsl:attribute>
						</xsl:if>
						<xsl:choose>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">journal title</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">título da revista</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">titulo de la revista</xsl:when>
						</xsl:choose>                            
					</font>
				</strong>
				<xsl:if test="LIST">
					<br/><xsl:call-template name="PutOrderSelector">
						<xsl:with-param name="ORDER">1</xsl:with-param>
						<xsl:with-param name="TIP"><xsl:choose>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Sets the order to title</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">seleciona a ordenação por título</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">selecciona el orden por titulo</xsl:when>
						</xsl:choose></xsl:with-param>                        
					</xsl:call-template>
				</xsl:if>
			</td>
		</xsl:if>

		<td width="22%">
			<p align="center">
				<strong>
					<font face="Arial" size="2">
						<xsl:choose>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">start date</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">data inicial</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">fecha de inicio</xsl:when>
						</xsl:choose>
						<xsl:if test="LIST"><br/>&#160;</xsl:if>
					</font>
				</strong>
			</p>
		</td>

		<td width="12%">
			<p align="center">
				<strong>
					<font face="Arial" size="2">
						<xsl:if test=" LIST and //FILTER/ORDER = 2 ">
							<xsl:attribute name="color">#eb0000</xsl:attribute>
						</xsl:if>home
					</font>
				</strong>
				<xsl:if test="LIST">
					<br/><xsl:call-template name="PutOrderSelector">
						<xsl:with-param name="ORDER">2</xsl:with-param>
						<xsl:with-param name="TIP"><xsl:choose>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Sets the order to home</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">seleciona a ordenação por home</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">selecciona el orden por home</xsl:when>
						</xsl:choose></xsl:with-param>                        
					</xsl:call-template>
				</xsl:if>            
			</p>
		</td>

		<td width="12%">
			<p align="center">
				<strong>
					<font face="Arial" size="2">
						<xsl:if test=" LIST and //FILTER/ORDER = 3 ">
							<xsl:attribute name="color">#eb0000</xsl:attribute>
						</xsl:if>
                
						<xsl:choose>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">toc</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">sumário</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">toc</xsl:when>
						</xsl:choose>
					</font>
				</strong>
				
				<xsl:if test="LIST">
					<br/><xsl:call-template name="PutOrderSelector">
						<xsl:with-param name="ORDER">3</xsl:with-param>
						<xsl:with-param name="TIP"><xsl:choose>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Sets the order to toc</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">seleciona a ordenação por sumário</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">selecciona el orden por toc</xsl:when>
						</xsl:choose></xsl:with-param>                        
					</xsl:call-template>
				</xsl:if>            
			</p>
		</td>
    
		<td width="12%">
			<p align="center">
				<strong>
					<font face="Arial" size="2">
						<xsl:if test=" LIST and //FILTER/ORDER = 4 ">
							<xsl:attribute name="color">#eb0000</xsl:attribute>
						</xsl:if>
                
						<xsl:choose>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">articles</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">artigos</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">artículos</xsl:when>
						</xsl:choose>                        
					</font>
				</strong>
				<xsl:if test="LIST">
					<br/><xsl:call-template name="PutOrderSelector">
						<xsl:with-param name="ORDER">4</xsl:with-param>
						<xsl:with-param name="TIP"><xsl:choose>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Sets the order to articles</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">seleciona a ordenação por artigos</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">selecciona el orden por artículos</xsl:when>
						</xsl:choose></xsl:with-param>                        
					</xsl:call-template>
				</xsl:if>            
			</p>
		</td>

		<td width="12%">
			<p align="center">
				<strong>
					<font face="Arial" size="2">
						<xsl:if test=" LIST and //FILTER/ORDER = 5 ">
							<xsl:attribute name="color">#eb0000</xsl:attribute>
						</xsl:if>
                
						<xsl:choose>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">other</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">outros</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">otros</xsl:when>
						</xsl:choose>                        
					</font>
				</strong>
				<xsl:if test="LIST">
					<br/><xsl:call-template name="PutOrderSelector">
						<xsl:with-param name="ORDER">5</xsl:with-param>
						<xsl:with-param name="TIP"><xsl:choose>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Sets the order to other</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">seleciona a ordenação por outros</xsl:when>
							<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">selecciona el orden por otros</xsl:when>
						</xsl:choose></xsl:with-param>                        
					</xsl:call-template>
				</xsl:if>            
			</p>
		</td>
	</tr>
</xsl:template>

</xsl:stylesheet>
