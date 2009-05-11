<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:template match="QUERY_RESULT">
	<html>
	<head>
		<title>
			<xsl:choose>
				<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Journal articles requests by month and year</xsl:when>
				<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">Acessos a artigos de revistas por mês e por ano</xsl:when>
				<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">Accesos a artículos de revistas por mes y por año</xsl:when>                        
			</xsl:choose>
		</title>

		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
	</head>
	
	<body bgColor="#ffffff">
		<xsl:call-template name="PrintPageHeaderInfo" />
		<xsl:apply-templates select="COPYRIGHT" />		
	</body>
	
	</html>
</xsl:template>

<xsl:template name="PrintPageHeaderInfo">
	<table cellspacing="0" cellpadding="0" width="100%">
		<tr>
		<td width="20%">
		<p align="center">
			<a>
				<xsl:attribute name="href">http://<xsl:value-of 
						select="CONTROLINFO/SCIELO_INFO/SERVER" /><xsl:value-of 
						select="CONTROLINFO/SCIELO_INFO/PATH_DATA" />scielo.php?lng=<xsl:value-of
						select="CONTROLINFO/LANGUAGE" />&amp;nrm=<xsl:value-of
						select="CONTROLINFO/STANDARD" /></xsl:attribute>

				<img>
						<xsl:attribute name="src">http://<xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/SERVER" /><xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/PATH_DATA" /><xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/PATH_GENIMG" /><xsl:value-of
							select="CONTROLINFO/LANGUAGE" />/fbpelogp.gif</xsl:attribute>
						<xsl:attribute name="alt">Scientific Electronic Library Online</xsl:attribute>
						<xsl:attribute name="border">0</xsl:attribute>
				</img>
			</a>                    
		</p>
		</td>
		<td width="80%">
			<blockquote>
					<p align="left">
						<font face="Arial" color="#800000" size="4">
							<xsl:choose>
								<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Library Collection</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">Coleção da biblioteca</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">Colección de la biblioteca</xsl:when>
							</xsl:choose>
						</font>
					</p>
			</blockquote>
		</td>
		</tr>
		<tr>
		<td width="20%">&#160;</td>
		<td width="80%">
			<blockquote>
				<p>
				<font face="Verdana" color="#000080" size="2">
					<xsl:choose>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Article Requests Sumary by Month and Year</xsl:when>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">Resumo de acessos a artigos por mês e ano</xsl:when>
						<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">Resumen de accesos a los artículos por mes y año</xsl:when>
					</xsl:choose>                            
				</font>
				</p>
			</blockquote>			
		</td>
		</tr>		
	</table><br/>
	
	<xsl:apply-templates select="STATPARAM/START_DATE"	 />
	
    <table width="100%" align="center" border="0" cellpadding="0" cellspacing="3">   
        <tr>
            <td width="30%" bgColor="#e1e6e6" rowspan="2">
			<b>
				<xsl:choose>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'en' ">Journal</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'es' ">Revista </xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'pt' ">Revista </xsl:when>
				</xsl:choose>
			</b>
	     </td>
            <td width="70%" align="center" bgColor="#e1e6e6" colspan="14">
			<b>
				<xsl:choose>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'en' ">Article requests by month and year</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'es' ">Accesos a artículos de revistas por mes y por año</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'pt' ">Acessos a artigos por mês e por ano</xsl:when>
				</xsl:choose>				
			</b>
	     </td>
        </tr>
        <tr>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
				<xsl:choose>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'en' ">Year</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'es' ">Año</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'pt' ">Ano</xsl:when>
				</xsl:choose>				
			
			</b>
	     </td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">01</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
	     </td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">02</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">03</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">04</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">05</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">06</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">07</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">08</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">09</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">10</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">11</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<b>
			<xsl:call-template name="GET_MONTH_NAME">
				 <xsl:with-param name="LANG"  select="CONTROLINFO/LANGUAGE" />
				 <xsl:with-param name="MONTH">12</xsl:with-param>
				 <xsl:with-param name="ABREV">1</xsl:with-param>
			</xsl:call-template>
			</b>
		</td>
            <td width="5%" align="center" bgColor="#e1e6e6">
			<font color="maroon"><b>Total</b></font>
		</td>
        </tr>
		<xsl:apply-templates select="TITLE" />
		<xsl:apply-templates select="TOTAL" />
	</table>
</xsl:template>

<xsl:template match="TITLE | TOTAL">
	<xsl:variable name="nYears" select="count(YEAR)" />	
	<tr><td colspan="15"></td></tr>
	<tr>	
		<td width="30%" bgColor="#edecee" rowspan="{$nYears+1}" valign="center">
			<b>
				<xsl:choose>
					<xsl:when test="@NAME"><xsl:value-of select="@NAME" /></xsl:when>
					<xsl:otherwise>TOTAL</xsl:otherwise>
				</xsl:choose>
			</b>
		</td>
		<xsl:apply-templates select="YEAR" />
	</tr>	
	<tr>	
		<td width="5%" bgColor="#edecee">
			<font color="maroon">
				<b>
					<xsl:choose>
						<xsl:when test=" //CONTROLINFO/LANGUAGE = 'en' ">All</xsl:when>
						<xsl:when test=" //CONTROLINFO/LANGUAGE = 'es' ">Todos</xsl:when>
						<xsl:when test=" //CONTROLINFO/LANGUAGE = 'pt' ">Todos</xsl:when>
					</xsl:choose>
				</b>
			</font>
		</td>
		<xsl:call-template name="SUM_MONTHS">
			<xsl:with-param name="current">1</xsl:with-param>
			<xsl:with-param name="final">12</xsl:with-param>
		</xsl:call-template>
		<td width="5%" bgColor="#f8f8d5" align="right"><font color="maroon"><xsl:value-of select="sum(YEAR/MONTH)" /></font></td>
	</tr>		
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

<xsl:template match="COPYRIGHT">
	<p>
		<xsl:call-template name="COPYRIGHTSCIELO" />
	</p>
</xsl:template>

<xsl:template match="YEAR">
	<xsl:choose>
		<xsl:when test="position() = 1">
			<td width="5%" bgColor="#edecee"><b><xsl:value-of select="@NUMBER" /></b></td>
			<xsl:call-template name="MONTHS">
				<xsl:with-param name="current">01</xsl:with-param>
				<xsl:with-param name="final">12</xsl:with-param>
			</xsl:call-template>
			<td width="5%" bgColor="#f8f8d5" align="right"><font color="maroon"><xsl:value-of select="sum(MONTH)" /></font></td>			
		</xsl:when>
		<xsl:otherwise>
			<tr>
				<td width="5%" bgColor="#edecee"><b><xsl:value-of select="@NUMBER" /></b></td>
				<xsl:call-template name="MONTHS">
					<xsl:with-param name="current">01</xsl:with-param>
					<xsl:with-param name="final">12</xsl:with-param>
				</xsl:call-template>
				<td width="5%" bgColor="#f8f8d5" align="right"><font color="maroon"><xsl:value-of select="sum(MONTH)" /></font></td>				
			</tr>
		</xsl:otherwise>
	</xsl:choose>	
</xsl:template>

<xsl:template name="MONTHS">
	<xsl:param name="current" />
	<xsl:param name="final" />
	
	<xsl:choose>
		<xsl:when test="$current > $final"></xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="MONTH[@NUMBER = $current]">
				  <xsl:apply-templates select="MONTH[@NUMBER = $current]" />
				</xsl:when>
				<xsl:otherwise><td width="5%" bgColor="#f5f5eb" align="center">-</td></xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="MONTHS">
				<xsl:with-param name="current" select="$current + 1" />
				<xsl:with-param name="final" select="$final" />
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="SUM_MONTHS">
	<xsl:param name="current" />
	<xsl:param name="final" />

	<xsl:choose>
		<xsl:when test="$current > $final"></xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="YEAR/MONTH[@NUMBER = $current]">
					<td width="5%" bgColor="#f8f8d5" align="right">
						<font color="maroon">
							<xsl:value-of select="sum(YEAR/MONTH[@NUMBER = $current])" />
						</font>
					</td>
				</xsl:when>
				<xsl:otherwise><td width="5%" bgColor="#f8f8d5" align="center"><font color="maroon">-</font></td></xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="SUM_MONTHS">
				<xsl:with-param name="current" select="$current + 1" />
				<xsl:with-param name="final" select="$final" />
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="MONTH">
	<td width="5%" bgColor="#f5f5eb" align="right"><xsl:value-of select="." /></td>	
</xsl:template>

</xsl:stylesheet>
