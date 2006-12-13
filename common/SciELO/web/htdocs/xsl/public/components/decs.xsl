<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="xsl/public/components/default/decs.xsl"/>

	<xsl:template match="decs">
		<div id="decs">			
			<script language="JavaScript" src="&lt;?=$def['DIRECTORY']?&gt;js/yui/yahoo.js"><!-- yui library --></script> 
			<script language="JavaScript" src="&lt;?=$def['DIRECTORY']?&gt;js/yui/dom.js"><!-- yui library --></script> 
			<script language="JavaScript" src="&lt;?=$def['DIRECTORY']?&gt;js/yui/event.js"><!-- yui library --></script> 
			<script language="JavaScript" src="&lt;?=$def['DIRECTORY']?&gt;js/yui/connection.js"><!-- yui library --></script> 
			<script language="JavaScript" src="&lt;?=$def['DIRECTORY']?&gt;js/yui/autocomplete.js"><!-- yui library --></script>
											   
			<h3>
			 <span>
			  <xsl:choose>
				<xsl:when test="$decsData/@href != ''">
					<a href="{$decsData/@href}"><xsl:value-of select="$decsData/text()" /></a>
				</xsl:when>
				<xsl:otherwise>
					<a href="../php/level.php?lang={$lang}&amp;component={$id}"><xsl:value-of select="$decsData/text()" /></a>
				</xsl:otherwise>
			  </xsl:choose>	
			 </span>
			</h3>		
			<div class="label"><xsl:value-of select="$decsTexts/text[@id = 'search_terms']"/></div>
			
		    <form action="../php/decsws.php" method="get" name="decswsForm">
  				<input type="hidden" name="lang" value="{$lang}"/>
			  	<input type="hidden" name="tree_id" value=""/>
			 </form>
			 <div id="decsAutocomplete">			  	
		        <input id="terminput" class="textinput"/>
				<span id="loading"></span>
		        <div id="container"></div>
		     </div>
			 <script> 
			 	<![CDATA[
				var serviceUrl = "../php/decsAutoCompleteProxy.php";
				var serviceSchema = ["item","term","id"];
				var decsDataSource = new YAHOO.widget.DS_XHR(serviceUrl, serviceSchema); 
				decsDataSource.responseType = decsDataSource.TYPE_XML;
			
				var decsAutoComp = new YAHOO.widget.AutoComplete('terminput','container', decsDataSource); 	
				decsAutoComp.forceSelection = true;
				decsAutoComp.allowBrowserAutocomplete = false;
				decsAutoComp.minQueryLength = 2;
				decsAutoComp.maxResultsDisplayed = 40;	
	
				decsAutoComp.itemSelectEvent.subscribe(onItemSelect);
				
				decsAutoComp.dataRequestEvent.subscribe(showLoadingImage);	
				decsAutoComp.dataReturnEvent.subscribe(hideLoadingImage);	
				
				var loading = document.getElementById("loading");
				
				function onItemSelect(sType, aArgs) {
					var oItem = aArgs[1];
					var tree_id = oItem._oResultData[1];
					document.decswsForm.tree_id.value = tree_id;
					document.decswsForm.submit();
				}
				
				function showLoadingImage() {
					loading.innerHTML = "<img src=\"../image/common/progress.gif\" border=\"0\"/>";					
				}
				
				function hideLoadingImage() {
					loading.innerHTML = "";					
				}
			]]>	
			</script>
			<div class="label"><xsl:value-of select="$decsTexts/text[@id = 'category']"/></div>
			<ul>
				<xsl:apply-templates select="item">
					<xsl:sort/>
				</xsl:apply-templates>
			</ul>
		</div>
	</xsl:template>
	
</xsl:stylesheet>