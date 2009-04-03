wget  --output-document=temp.txt 'http://www.scimagojr.com/journalsearch.php?q='$1'&tip=iss&clean=0'
export scimago_id="`cat temp.txt | grep 'input_code.value' | grep -o 'id=[0-9]*' | grep -o '[0-9][0-9]*'`"
echo "SCIMAGO_ID: "$scimago_id

if test $scimago_id -gt 0
then
        echo '<title ISSN="'$1'" SCIMAGO_ID="'$scimago_id'"/>' >> meuXML.xml
else
        echo -e "This journal does not have SCIMAGO ID: " $1 "\n------------------"
fi
