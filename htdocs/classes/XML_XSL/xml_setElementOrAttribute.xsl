<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink">
	<!--
		Originalmente para atribuir um valor para um atributo.
		Serve também para acrescentar ou atualizar um elemento
	-->
	<xsl:variable name="selection" select="//selection"/>
	<xsl:variable name="setNameSpace" select="//setNameSpace"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//xml/*"/>
	</xsl:template>
	
	<xsl:template match="@*" mode="name"><xsl:value-of select="name()"/></xsl:template>
	<xsl:template match="xml/*">
		<xsl:element name="{name()}">
			<xsl:if test="$setNameSpace='yes' and not(@*[name()='xmlns:xlink'])">
				<xsl:attribute name="xmlns:xlink" namespace="http://www.w3.org/2000/xmlns/">http://www.w3.org/1999/xlink</xsl:attribute>				
			</xsl:if>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="getNodePath">
		<xsl:apply-templates select="ancestor::*" mode="getNodePath"/>
		<xsl:apply-templates select="." mode="getNodePath"/>
	</xsl:template>
	<xsl:template match="*" mode="getNodePath">
		<xsl:value-of select="concat('/',name())"/>
	</xsl:template>
	<xsl:template match="*" mode="exist">
		<xsl:param name="name"/>
		<xsl:if test="name()=$name">1</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="exist-debug">
		<xsl:param name="name"/>
	param=<xsl:value-of select="$name"/>;
	name=<xsl:value-of select="name()"/>;
	result=
	<xsl:if test="name()=$name">1</xsl:if>
		<br/>
	</xsl:template>
	<xsl:template match="*">
		<xsl:param name="nodeName"/>
		<xsl:param name="node"/>
		<xsl:variable name="path">
			<xsl:call-template name="getNodePath"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$nodeName=name()">
				<!--xsl:copy-of select="$node"/-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{name()}">
				
					<xsl:choose>
						<xsl:when test="$path=concat('/root/xml',$selection/nodePath)">
							<xsl:choose>
								<xsl:when test="$selection/attribute">
									<xsl:apply-templates select="@*|*|text()">
										<xsl:with-param name="value" select="$selection/value"/>
									</xsl:apply-templates>
								</xsl:when>
								<xsl:when test="$selection/elementName and $selection/mode='add'">
									<xsl:apply-templates select="*|@*|text()">
										<xsl:with-param name="nodeName" select="$selection/elementName"/>
										<xsl:with-param name="node" select="$selection/elementValue/*"/>
									</xsl:apply-templates>
									<!--xsl:variable name="exist"><xsl:apply-templates select="*" mode="exist"><xsl:with-param name="name" select="$selection/elementName"/></xsl:apply-templates></xsl:variable>
									<xsl:if test="$exist=''">
										<xsl:copy-of select="$selection/elementValue/*"/>
									</xsl:if-->
									<xsl:copy-of select="$selection/elementValue/*"/>
									<!--debug>
										<xsl:value-of select="$exist"/>
										<elementName>
											<xsl:value-of select="$selection/elementName"/>
											<xsl:apply-templates select="*" mode="exist-debug"><xsl:with-param name="name" select="$selection/elementName"/></xsl:apply-templates>
										</elementName>
										
									</debug-->
								</xsl:when>
								<xsl:otherwise>none</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="*|@*|text()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:param name="value"/>
		<xsl:attribute name="{name()}"><xsl:choose><xsl:when test="(name()=$selection/attribute) and $value"><xsl:value-of select="$value"/></xsl:when><xsl:otherwise><!--xsl:value-of select="$selection/attribute"/>,
					<xsl:value-of select="$value"/>,--><xsl:value-of select="."/></xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="text()">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="not($selection/attribute) and $value">
				<xsl:value-of select="$value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--xsl:template match="*">	
		<xsl:param name="position" select="1"/>
	
		<xsl:variable name="name" select="name()"/>
		<xsl:choose>
			<xsl:when test="$selection/parentNodeName[position()=$position and name()=$name]">
				<xsl:apply-templates>
					<xsl:with-param name="position" select="$position+1"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name()=$selection/element">
				<xsl:apply-templates select="." mode="elementNode"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()">
		<xsl:copy/>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:attribute name="{name()}"><xsl:choose><xsl:when test="name()=$selection/attribute"><xsl:value-of select="$selection/value"/></xsl:when><xsl:otherwise><xsl:apply-templates/></xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="*" mode="parentNodeName">
		
	</xsl:template-->
</xsl:stylesheet>
