<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:variable name="lang" select="/root/vars/lang"/>
	<xsl:variable name="applserver" select="/root/vars/applserver"/>
	<xsl:variable name="processCode" select="/root/vars/processCode"/>
	<xsl:variable name="texts" select="document('file:///home/scielo/www/htdocs/applications/scielo-org/xml/texts.xml')/texts/language[@id = $lang]"/>



	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="count(root/areasgeo/areasgeo/arealist) &gt; 0">
				<ul>
					<xsl:apply-templates select="root/areasgeo/areasgeo[position() = 1]/arealist/country"/>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$texts/text[find='dataFound']/replace"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="country">
		<div class="articleList">
			<li>
				<a href="{@url}"><xsl:value-of select="@name"/></a>
				<ul><a href="{@url}"><xsl:apply-templates select="region"/></a></ul>
			</li>
		</div>
	</xsl:template>

	<xsl:template match="region">
		<li>
			<xsl:value-of select="@name"/>
			<ul><a href="{@url}"><xsl:apply-templates select="state"/></a></ul>
		</li>
	</xsl:template>

	<xsl:template match="state">
		<li>
			<xsl:value-of select="@name"/>
			<ul><a href="{@url}"><xsl:apply-templates select="city"/></a></ul>
		</li>
	</xsl:template>

	<xsl:template match="city">
		<li>
			<xsl:value-of select="@name"/>
			<a href="{@url}"><xsl:apply-templates select="city"/></a>
		</li>
	</xsl:template>
	
</xsl:stylesheet>

<!--

<areasgeo>
<areasgeo>
 <article pid="S0034-89101991000300008" country="scl"/>
 <arealist>
  <country name="BRASIL" code="BR" url="http://tabnet.datasus.gov.br/tabdata/cadernos/BR/BRASIL_GeralBR.xls">
   <region name="Sudeste" code="SE" url="http://tabnet.datasus.gov.br/tabdata/cadernos/BR/Sudeste_GeralRegiao.xls">
    <state name="Rio de Janeiro" code="RJ" url="http://tabnet.datasus.gov.br/tabdata/cadernos/RJ/RJ_Rio_de_Janeiro_GeralUF.xls">
     <city name="Rio de Janeiro" code="330455" url="http://tabnet.datasus.gov.br/tabdata/cadernos/RJ/RJ_Rio_de_Janeiro_Geral.xls"/>
    </state>
   </region>
  </country>
 </arealist>
</areasgeo>
<areasgeo>
 <article pid="S0034-89101991000300008" country="spa"/>
 <arealist>
  <country name="BRASIL" code="BR" url="http://tabnet.datasus.gov.br/tabdata/cadernos/BR/BRASIL_GeralBR.xls">
   <region name="Sudeste" code="SE" url="http://tabnet.datasus.gov.br/tabdata/cadernos/BR/Sudeste_GeralRegiao.xls">
    <state name="Rio de Janeiro" code="RJ" url="http://tabnet.datasus.gov.br/tabdata/cadernos/RJ/RJ_Rio_de_Janeiro_GeralUF.xls">
     <city name="Rio de Janeiro" code="330455" url="http://tabnet.datasus.gov.br/tabdata/cadernos/RJ/RJ_Rio_de_Janeiro_Geral.xls"/>
    </state>
   </region>
  </country>
 </arealist>
</areasgeo>
</areasgeo>

-->
