<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:util="http://dtd.nlm.nih.gov/xsl/util" xmlns:doc="http://www.dcarlisle.demon.co.uk/xsldoc" xmlns:ie5="http://www.w3.org/TR/WD-xsl" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:fns="http://www.w3.org/2002/Math/preference" xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:pref="http://www.w3.org/2002/Math/preference" pref:renderer="mathplayer" exclude-result-prefixes="util xsl">
	<xsl:variable name="LANGUAGE" select="'en'"/>

	<xsl:include href="TextTypes/PubMedCentral/JournalPublishing/scielo/text.xsl"/>

	<xsl:template match="/">
		<html>
			<head>
				<title></title>
				<xsl:apply-templates select="." mode="css"/>

			</head>
			<body>
				<div id="container">
					
					<div id="body">
						<div id="main">							
							<div id="content">
								<div>
									<xsl:apply-templates select="//article" />
								</div>
							</div>
							<!-- content -->
						</div>
						<!-- main -->
					</div>
					<!-- body -->
				</div>
				<!-- container -->
			</body>
		</html>
	
	</xsl:template>

</xsl:stylesheet>
