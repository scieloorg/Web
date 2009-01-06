wget  --output-document=temp.txt 'http://www.scimagojr.com/journalsearch.php?q='$1'&tip=iss&clean=0' 
#export scimago_id="`cat temp.txt | grep 'input_code.value' | awk '{ print substr( $0, 216, 5 ) }'`"
export scimago_id="`cat temp.txt | grep 'input_code.value' | awk '{ teste=substr( $0, 216 ); iFinal=index(teste,"+"); print substr( $0, 216,iFinal-2 ) }'`"
if [ $scimago_id -ne 0 ]
then
	echo '<title ISSN="'$1'" SCIMAGO_ID="'$scimago_id'"/>' >> meuXML.xml
	exit
fi
