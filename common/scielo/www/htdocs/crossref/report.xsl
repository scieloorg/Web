<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:variable name="lang" select="//lang"/>

<xsl:variable name="pathhtdocs" select="/root/vars/htdocs"/>
<xsl:variable name="texts" select="document(concat('file://',$pathhtdocs,'applications/scielo-org/xml/texts.xml'))/texts/language[@id = $lang]"/>
<xsl:variable name="domain" select="//domain"/>
<xsl:variable name="total" select="//Isis_Total/occ"/>

	<xsl:template match="/">
	<html>
		<body>
		<xsl:choose>
			<xsl:when test="$total = '0'">
				Nenhum registro encontrado.		
			</xsl:when>
			<xsl:otherwise>
				Total: <xsl:value-of select="$total"/>	
				<table border="1" width="100%">				
					<tr>
						<td>MFN</td><td>PID</td><td>DATE</td><td>STATUS</td><td>LINKS</td>
					</tr>					
					<xsl:apply-templates select="//record" mode="content"/>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	       </body>
        </html>

	</xsl:template>

		<xsl:template match="record" mode="content">
				<tr>
					<td>
						<xsl:value-of select="@mfn"/>
					</td>
					<td>
						<a href="http://{$domain}/scielo.php?script=sci_abstract&amp;pid={field[@tag = 880]/occ}&amp;lng=en&amp;nrm=iso&amp;tlng=pt" target="_blank"><xsl:value-of select="field[@tag = 880]/occ"/></a>
					</td>
					<td>
						<xsl:value-of select="field[@tag = 10]/occ"/>
					</td>
					<td>
						<xsl:value-of select="field[@tag = 30]/occ"/>
					</td>
					<td>
						<a href="crossrefxml.php?pid={field[@tag = 880]/occ}" target="_blank">crossref xml</a>
					</td>
				</tr>
		</xsl:template>
</xsl:stylesheet>
