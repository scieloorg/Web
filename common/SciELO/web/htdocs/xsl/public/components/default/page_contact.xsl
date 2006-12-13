<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:param name="source" select="/root/http-info/VARS/source" />
	<xsl:param name="id" select="/root/http-info/cgi/id" />
	
	<xsl:param name="texts" select="/root/bvs/texts" />
	<xsl:param name="bvsRoot" select="/root/bvs" />	
	<xsl:param name="lang" select="/root/http-info//lang" />
	
	<xsl:include href="xsl/public/components/texts.xsl"/>

	<xsl:template match="/">
		<div id="contact">
			<xsl:apply-templates select="$bvsRoot/contact" mode="display" />
		</div>
	</xsl:template>
	
	<xsl:template match="contact" mode="display" >
		<h3><span><xsl:apply-templates select="$texts/text[@id = 'contact']" /></span></h3>
		<div id="breadCrumb">
			<a href="../php/index.php?lang={$lang}"><xsl:apply-templates select="$texts/text[@id = 'home']" /></a> &gt; 
			<xsl:apply-templates select="$texts/text[@id = 'contact']" />
		</div>
		<div class="content">
			<form name="mailto" action="/php/mailto.php" method="post">
				<input type="hidden" name="lang" value="{$lang}" />
				<xsl:apply-templates select="." mode="hiddenButtons" />
				<xsl:apply-templates select="." mode="subject" />
				<input type="hidden" name="response" value="/php/contact.php?lang={$lang}&amp;mode=response" />
				<p>
					<xsl:apply-templates select="$texts/text[@id = 'contact: name']" /><br />
					<input class="name" name="fromName" /> 
				</p>
				<p>
					<xsl:apply-templates select="$texts/text[@id = 'contact: email']" /><br />
					<input class="from" name="from" />
				</p>
				<p>
					<xsl:apply-templates select="$texts/text[@id = 'contact: message']" /><br />
					<textarea class="message" name="message"><xsl:text> </xsl:text></textarea>
				</p>
				<p>
					<input type="submit" name="submit" class="submit" value="{$texts/text[@id = 'contact: send']}" onClick="checkContactForm(document.mailto,'{$texts/text[@id = 'contact: error']}','{$texts/text[@id = 'contact: name']}','{$texts/text[@id = 'contact: email']}','{$texts/text[@id = 'contact: message']}'); return false;" />
				</p>
			</form>
		</div>

	</xsl:template>
	
	<xsl:template match="contact" mode="hiddenButtons">
		<input type="hidden" name="account">
			<xsl:attribute name="value"><xsl:apply-templates select="item" mode="account" /></xsl:attribute>
		</input>
		<input type="hidden" name="host">
			<xsl:attribute name="value"><xsl:apply-templates select="item" mode="host" /></xsl:attribute>
		</input>
	</xsl:template>
	
	<xsl:template match="contact/item" mode="account"><xsl:value-of select="substring-before(@href,'@')" /><xsl:if test="position() != last()">, </xsl:if></xsl:template>
	
	<xsl:template match="contact/item" mode="host"><xsl:value-of select="substring-after(@href,'@')" /><xsl:if test="position() != last()">, </xsl:if></xsl:template>

	<xsl:template match="contact" mode="subject">
		<xsl:choose>
			<xsl:when test="count(item[@available != 'no']) &gt; 1">
				<p>
					<xsl:apply-templates select="$texts/text[@id = 'contact: subject']" /><br />
					<select name="subject">
						<xsl:apply-templates select="item" mode="subject" />
					</select>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<input type="hidden" name="subject" value="({position()}){item[1]/text()}" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="contact/item" mode="subject"><option value="({position()}){text()}"><xsl:apply-templates select="text()" /></option></xsl:template>
	
	<xsl:template match="*[@available = 'no']" />
	<xsl:template match="contact/item[@available = 'no']" mode="account" />
	<xsl:template match="contact/item[@available = 'no']" mode="host" />
	<xsl:template match="contact[@available = 'no']" mode="hiddenButtons" />
	<xsl:template match="contact/item[@available = 'no']" mode="subject" />
	<xsl:template match="contact[@available = 'no']" mode="subject" />
	

</xsl:stylesheet>