export PATH=$PATH:.
echo Execution begin of $0 $1 $2 $3 $4 $5 in  `date`

sed 's/<crossref_result.*>/<crossref_result>/g' $1 > temp/doi/proc/temp_$3.xml
java -jar doi/crossref/saxon8.jar -o $2 temp/doi/proc/temp_$3.xml doi/xsl/doi_extract_result.xsl
rm temp/doi/proc/temp_$3.xml
echo Execution end of $0 $1 $2 $3 $4 $5 in  `date`