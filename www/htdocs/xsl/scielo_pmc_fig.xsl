<?xml version="1.0"?>
<xsl:transform version="1.0" id="ViewNLM-v2-04_scielo.xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:util="http://dtd.nlm.nih.gov/xsl/util" xmlns:mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="util xsl">
	<xsl:template match="fig/*[name()!='graphic']">
		<div class="fig-text">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="fig/label | fig/caption">
		<span class="fig-{name()}">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="fig">
		<!--xsl:if test=" $layout = 'anchor'">
			<xsl:apply-templates select="." mode="display"/>
		</xsl:if-->
	</xsl:template>
	<xsl:template match="fig[graphic[not(@alt-version) and not(@alternate-form-of)]]" mode="display">
		<p>
			<a name="{@id}">
				<xsl:apply-templates select="." mode="back"/>
				<div class="fig">
					<div class="fig-file">
						<xsl:apply-templates select="graphic"/>
					</div>
					<div class="fig-data">
						<xsl:apply-templates select="child::*[not(self::graphic)]"/>
					</div>
				</div>
			</a>
		</p>
	</xsl:template>
	<xsl:template match="graphic/@xlink:href| inline-graphic/@xlink:href">
		<xsl:variable name="id" select="."/>
		<xsl:choose>
			<xsl:when test="$var_IMAGES_INFO">
				<xsl:value-of select="$var_IMAGES_INFO//image[@id=$id]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$var_IMAGE_PATH"/>
				<xsl:apply-templates select="." mode="check-extension"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="graphic/@xlink:href| inline-graphic/@xlink:href" mode="check-extension">
		<xsl:value-of select="."/>
		<!--xsl:choose>
			<xsl:when test="contains(.,'.jpg') or contains(.,'.jpeg')"><xsl:value-of select="."/></xsl:when>
			<xsl:otherwise><xsl:value-of select="substring-before(.,'.tif')"/>.jpg</xsl:otherwise>
		</xsl:choose-->
	</xsl:template>
	<!--	
		figuras e tabelas
	-->
	<xsl:template match="*" mode="figures-and-tables">
		<div id="figTables">
			<xsl:apply-templates select=".//fig| .//table-wrap" mode="display"/>
		</div>
	</xsl:template>
	<xsl:template match="*[graphic[@alt-version]]" mode="display">
		<div class="fig">
			<table>
				<tbody>
					<tr>
						<td>
							<div class="fig-file">
								<a target="_{graphic[@alternate-form-of]/@id}">
									<xsl:attribute name="href"><xsl:apply-templates select="graphic[@alternate-form-of]/@xlink:href"/></xsl:attribute>
									<xsl:apply-templates select="graphic[@alt-version]"/>
								</a>
							</div>
						</td>
						<td>
							<a name="{@id}"/>
							<div class="fig-data">
								<xsl:apply-templates select="*[name()!='graphic' and name()!='table']"/>
							</div>
						</td>
					</tr>
					<!--tr>
						<td colspan="2">
						[View larger version of this figure, clicking on the thumbnail]
						</td>
					</tr-->
				</tbody>
			</table>
			<p>
			[View larger version of this figure, clicking on the thumbnail]
</p>
		</div>
	</xsl:template>
</xsl:transform>
