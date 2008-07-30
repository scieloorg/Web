
set PROC=prc\tipo_h_pubmed.prc
set I2X=i2x\tipo_h.i2x

echo .. Generate the batch which generates the xml files
utl\wxis IsisScript=xis\xml_scielo_copi.xis sci_lista=%SCI_LISTA% config=%CONFIG% journals=%JOURNALS% path_db=%PATH_DB% proc=%PROC% i2x=%I2X% id=%ID% xsl=%XSL% xsl_link=%XSL_LINK% doi_conf=%DOI_CONF% cipar=%CIPAR_FILE% > temp\GenerateXMLFiles.bat

echo .. Generate the XML files

call temp\GenerateXMLFiles.bat

echo end