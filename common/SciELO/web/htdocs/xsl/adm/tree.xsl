<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="xsl/adm/menu.xsl"/>

	<xsl:variable name="page" select="$cgi/page"/>
	<xsl:variable name="id" select="$cgi/id"/>
	<xsl:variable name="tab-filler" select="'....'"/>

	<xsl:template match="/">
		<xsl:apply-templates select="root/adm/page[@id = $page]" mode="html"/>
	</xsl:template>

	<xsl:template match="*" mode="script">
		<script language="JavaScript" src="{$location}js/tree-edit.js">
			/* tree-edit.js */
		</script>
		<script language="JavaScript">
			<xsl:apply-templates select="../message-list/message"/>
		</script>
		<script language="JavaScript" src="{$location}js/md5.js">
			/* md5.js */
		</script>
	</xsl:template>

	<xsl:template match="*" mode="form">
		<form name="formPage" action="{$xml2html}" method="post">
			<xsl:apply-templates select="$cgi/*" mode="hidden"/>
			<xsl:apply-templates select="." mode="form-save"/>
			<input type="hidden" name="buffer" value=""/>
			<!--
				<input type="hidden" name="debug" value="xmlSave"/>
			-->
			<xsl:apply-templates/>
		</form>
		<form name="formHidden" action="{$xml2html}" method="post">
			<xsl:apply-templates select="$cgi/*" mode="hidden"/>
			<input type="hidden" name="buffer" value=""/>

<!--
<input type="hidden" name="debug" value="xml"/>
-->
		</form>
	</xsl:template>

	<xsl:template match="xsl" mode="hidden">
		<input type="hidden" name="xsl" value="{$xsl-path}change.xsl"/>
	</xsl:template>

	<xsl:template match="*" mode="form-save">
		<input type="hidden" name="xmlSave" value="{$doc-name}"/>
		<input type="hidden" name="xslSave" value="{$xsl-path}save.xsl"/>
	</xsl:template>

	<xsl:template match="flag">
		<xsl:variable name="find-element" select="@element"/>
		<xsl:variable name="find-flag" select="@name"/>
		<xsl:variable name="flag-found" select="$doc-xml/bvs/*[name() = $find-element]/@*[name() = $find-flag]"/>
	
		<xsl:apply-templates select="." mode="flag-show">
			<xsl:with-param name="curr-value" select="$flag-found"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="flag-show">
		<xsl:param name="curr-value"/>

		<select name="{@name}" size="1">
			<xsl:apply-templates mode="flag-option">
				<xsl:with-param name="curr-value" select="$curr-value"/>
			</xsl:apply-templates>
		</select>
	</xsl:template>

	<xsl:template match="*" mode="flag-option">
		<xsl:param name="curr-value"/>

		<xsl:element name="option">
			<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
			<xsl:if test="@value = $curr-value">
				<xsl:attribute name="selected"></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="buttons">
		<table width="100%" cellpadding="0" cellspacing="0" class="button-list">
			<tr>
				<td>
					<table cellpadding="0" cellspacing="0">
						<tr>
							<xsl:apply-templates/>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="separator">
		<td width="25">&#160;</td>
	</xsl:template>

	<xsl:template match="button">
		<td width="10" valign="top">
			<table>
				<tr>
					<td>
						<xsl:apply-templates select="." mode="button"/>
					</td>
				</tr>
			</table>
		</td>
	</xsl:template>

	<xsl:template match="button" mode="button">
		<center><a href="{@href}"><img src="{$image-location}{@img}" border="0" alt="{@alt}"/></a></center>
		<center><a href="{@href}"><font size="1"><xsl:value-of select="@alt"/></font></a></center>
	</xsl:template>

	<xsl:template match="button[not(@href)]" mode="button">
		<center><img src="{$image-location}{@img}" border="0" alt="{@alt}"/></center>
		<center><font color="Gray" size="1"><xsl:value-of select="@alt"/></font></center>
	</xsl:template>

	<xsl:template match="tree-edit">
		<xsl:variable name="find-element" select="@element"/>
		
		<xsl:apply-templates select="$doc-xml/bvs/*[name() = $find-element]" mode="next-id"/>
		<xsl:apply-templates select="." mode="select">
			<xsl:with-param name="select" select="$doc-xml/bvs/*[name() = $find-element]"/>
		</xsl:apply-templates>		
	</xsl:template>
	
	<xsl:template match="*" mode="next-id">
		<script language="JavaScript">
			/* não deletar NUNCA este comentário */
			<xsl:apply-templates select="//item[@id != '']" mode="sorted-id">
				<xsl:sort select="@id" data-type="number" order="descending"/>
			</xsl:apply-templates>
			<xsl:if test="not(//item[@id != ''])">
				var nextId = 1;
			</xsl:if>
		</script>
	</xsl:template>
	
	<xsl:template match="item" mode="sorted-id">
		<xsl:if test="position() = 1">
			var nextId = <xsl:value-of select="@id"/> + 1;
		</xsl:if>
	</xsl:template>
	

	<xsl:template match="tree-edit[@xml]">
		<xsl:variable name="find-element" select="@element"/>

		<xsl:apply-templates select="." mode="select">
			<xsl:with-param name="select" select="document(@xml)/*[name() = $find-element]"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="tree-edit" mode="select">
		<xsl:param name="select"/>

		<xsl:apply-templates select="$select" mode="var"/>

		<table width="100%" class="tree-edit">
			<tr valign="top">
				<td>
					<br/>
					<ul>
						<li>							
							<xsl:value-of select="ancestor::page/@title"/><br/>
							<select name="tree" size="15">						
								<xsl:apply-templates select="$select" mode="option"/>
							</select><br/>
							<br/>
						</li>
					</ul>
					<!--
					<input type="button" name="test" value="listValues" onClick="javascript:showListValues();"/>
					-->
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="*" mode="var">
		<script language="javascript">
			var listValues = new Array(
				<xsl:apply-templates select="item | attach | warning | text | user" mode="array"/>
				null
			);
		</script>
	</xsl:template>

	<xsl:template match="item" mode="array">
		"<xsl:element name="available"><xsl:apply-templates select="@available" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="id"><xsl:apply-templates select="@id" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="name"><xsl:apply-templates select="text()" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="img"><xsl:apply-templates select="@img" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="href"><xsl:apply-templates select="@href" mode="escape_quotes_js"/></xsl:element>",
		<xsl:apply-templates select="item" mode="array"/>
	</xsl:template>

	<!--
	<xsl:template match="collectionList//item" mode="array">
		"<xsl:element name="available"><xsl:apply-templates select="@available" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="id"><xsl:apply-templates select="@id" mode="escape_quotes_js"/></xsl:element>" +		
		"<xsl:element name="name"><xsl:apply-templates select="text()" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="img"><xsl:apply-templates select="@img" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="href"><xsl:apply-templates select="@href" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="file"><xsl:apply-templates select="@file" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="adm"><xsl:apply-templates select="@adm" mode="escape_quotes_js"/></xsl:element>",
		<xsl:apply-templates select="item" mode="array"/>		
	</xsl:template>
	-->
	<xsl:template match="collectionList//item" mode="array">
		"<xsl:element name="available"><xsl:apply-templates select="@available" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="id"><xsl:apply-templates select="@id" mode="escape_quotes_js"/></xsl:element>" +		
		"<xsl:element name="name"><xsl:apply-templates select="text()" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="href"><xsl:apply-templates select="@href" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="type"><xsl:apply-templates select="@type" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="file"><xsl:apply-templates select="@file" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="adm"><xsl:apply-templates select="@adm" mode="escape_quotes_js"/></xsl:element>"+
		"<xsl:element name="img"><xsl:apply-templates select="@img" mode="escape_quotes_js"/></xsl:element>",
		<xsl:apply-templates select="item" mode="array"/>		
	</xsl:template>
	
	
	<xsl:template match="*" mode="copy">
		<xsl:apply-templates select="text() | *" mode="copy-of"/>
	</xsl:template>

	<xsl:template match="*" mode="copy-of">
		<xsl:choose>
			<xsl:when test="substring(name(),1,10) = 'attribute_'">
				<xsl:attribute name="{substring(name(),11)}"><xsl:value-of select="."/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{name()}">
					<xsl:apply-templates select="@* | text() | *" mode="copy-of"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()" mode="copy-of">
<!--
		<xsl:value-of select="normalize-space(.)"/>
		por causa do HTMLArea
-->
		<xsl:value-of select="translate(.,'&#013;&#010;','  ')"/>
	</xsl:template>

	<xsl:template match="@*" mode="copy-of">
		<xsl:element name="attribute_{name()}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="item" mode="option">
		<xsl:param name="level" select="0"/>
		<xsl:param name="tab" select="''"/>
	
		<xsl:variable name="option-text">
			<xsl:value-of select="concat($tab,text())"/>
			<xsl:if test="normalize-space(text()) = ''">
				<xsl:value-of select="@img"/>
			</xsl:if>
		</xsl:variable>
	
		<option value="{$level}"><xsl:value-of select="$option-text"/></option>
		<xsl:apply-templates select="item" mode="option">
			<xsl:with-param name="level" select="$level + 1"/>
			<xsl:with-param name="tab" select="concat($tab,$tab-filler)"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="about//item" mode="array">
		"<xsl:element name="available"><xsl:apply-templates select="@available" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="id"><xsl:apply-templates select="@id" mode="escape_quotes_js"/></xsl:element>" +		
		"<xsl:element name="name"><xsl:apply-templates select="text()" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="img"><xsl:apply-templates select="@img" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="href"><xsl:apply-templates select="@href" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="description"><xsl:apply-templates select="description" mode="copy-js"/><xsl:value-of select="' '"/></xsl:element>" +
        "<xsl:element name="portal"><xsl:apply-templates select="portal" mode="copy-js"/><xsl:value-of select="' '"/></xsl:element>",
		<xsl:apply-templates select="item" mode="array"/>
	</xsl:template>

	<!-- xsl:template match="attach" mode="array">
		"<xsl:element name="available"><xsl:value-of select="@available"/></xsl:element>" +
		"<xsl:element name="name"><xsl:value-of select="normalize-space(text())"/></xsl:element>" +
		"<xsl:element name="type"><xsl:value-of select="@type"/></xsl:element>" +
		"<xsl:element name="file"><xsl:value-of select="@file"/></xsl:element>" +
		"<xsl:element name="adm"><xsl:value-of select="@adm"/></xsl:element>",
	</xsl:template -->

	<xsl:template match="attach" mode="array">
		"<xsl:element name="available"><xsl:apply-templates select="@available" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="id"><xsl:apply-templates select="@id" mode="escape_quotes_js"/></xsl:element>" +		
		"<xsl:element name="name"><xsl:apply-templates select="text()" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="type"><xsl:apply-templates select="@type" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="file"><xsl:apply-templates select="@file" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="adm"><xsl:apply-templates select="@adm" mode="escape_quotes_js"/></xsl:element>",
	</xsl:template>

	<xsl:template match="attach" mode="option">
		<option value="0"><xsl:value-of select="text()"/><xsl:if test="normalize-space(text()) =''"><xsl:value-of select="@type"/></xsl:if></option>
	</xsl:template>
	
	<!-- xsl:template match="warning" mode="array">
		"<xsl:element name="available"><xsl:value-of select="@available"/></xsl:element>" +
		"<xsl:element name="name"><xsl:value-of select="@name"/></xsl:element>" +
		"<xsl:element name="warning_text"><xsl:apply-templates select="." mode="copy"/></xsl:element>",
	</xsl:template -->
	
	<xsl:template match="warning/item" mode="array">
		"<xsl:element name="available"><xsl:apply-templates select="@available" mode="escape_quotes_js"/></xsl:element>" +		
		"<xsl:element name="name"><xsl:apply-templates select="text()" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="description"><xsl:apply-templates select="description" mode="copy-js"/></xsl:element>",
	</xsl:template>

	
	<xsl:template match="responsable/item" mode="array">
		"<xsl:element name="name"><xsl:apply-templates select="name" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="description"><xsl:apply-templates select="description" mode="copy-js"/><xsl:value-of select="' '"/></xsl:element>" +
	</xsl:template>

	<xsl:template match="responsable/item" mode="option">
		<option value="0"><xsl:value-of select="name"/></option>
	</xsl:template>
	
	<xsl:template match="text" mode="array">
		"<xsl:element name="available"><xsl:apply-templates select="@available" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="id"><xsl:apply-templates select="@id" mode="escape_quotes_js"/></xsl:element>" +
		"<xsl:element name="text_content"><xsl:apply-templates select="." mode="copy-js"/></xsl:element>" + 
		"<xsl:element name="img"><xsl:apply-templates select="@img" mode="escape_quotes_js"/></xsl:element>", 		
	</xsl:template>

	<xsl:template match="text" mode="option">
		<option value="0"><xsl:value-of select="@id"/></option>
	</xsl:template>


	<xsl:template match="* | @* | text()" mode="escape_quotes_js">
		<xsl:variable name="text">
                	<xsl:call-template name="str_replace">
                                <xsl:with-param name="source" select="."/>
                                <xsl:with-param name="find">&quot;</xsl:with-param>
                                <xsl:with-param name="replace">\&quot;</xsl:with-param>
                        </xsl:call-template>
                </xsl:variable>
<!--
		<xsl:value-of select="normalize-space($text)"/>
		por causa do HTMLArea
-->
		<xsl:value-of select="translate($text,'&#013;&#010;','  ')"/>
	</xsl:template>

	<xsl:template match="*" mode="copy-js">
		<xsl:apply-templates select="text() | *" mode="copy-of-js"/>
	</xsl:template>

	<xsl:template match="*" mode="copy-of-js">
		<xsl:choose>
			<xsl:when test="substring(name(),1,10) = 'attribute_'">
				<xsl:attribute name="{substring(name(),11)}"><xsl:apply-templates select="." mode="escape_quotes_js"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{name()}">
					<xsl:apply-templates select="@* | text() | *" mode="copy-of-js"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()" mode="copy-of-js">
		<xsl:apply-templates select="." mode="escape_quotes_js"/>
	</xsl:template>

	<xsl:template match="@*" mode="copy-of-js">
		<xsl:element name="attribute_{name()}">
			<xsl:apply-templates select="." mode="escape_quotes_js"/>
		</xsl:element>
	</xsl:template>

	<xsl:template name="str_replace">
		<xsl:param name="source"/>
		<xsl:param name="find"/>
		<xsl:param name="replace"/>
		
		<xsl:choose>
			<xsl:when test="contains($source, $find)">
				<xsl:variable name="before" select="substring-before($source, $find)"/>
				<xsl:variable name="after">
					<xsl:call-template name="str_replace">
						<xsl:with-param name="source" select="substring-after($source, $find)"/>
						<xsl:with-param name="find" select="$find"/>
						<xsl:with-param name="replace" select="$replace"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat($before, $replace, $after)"/>
			</xsl:when>			
			<xsl:otherwise>
				<xsl:value-of select="$source"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>

