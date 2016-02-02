BASEDIR=$(dirname $0)
echo $BASEDIR
cd $BASEDIR
cd ../bases
if [ -d "pdf" ]; then
    cd pdf
    find . -name "*.pdf" > ../../htdocs/static_pdf_files.txt
    cd ..
fi

if [ -d "translation" ]; then
    cd translation
    find . -name "*.htm*" > ../../htdocs/static_html_files.txt
    cd ..
fi

if [ -d "xml" ]; then
    cd xml
    find . -name "*.xml" > ../../htdocs/static_xml_files.txt
    cd ..
fi

cd ../proc
cisis/mx ../bases/issue/issue "pft=if p(v49) then (v35[1],v65[1]*0.4,s(f(val(s(v36[1]*4.3))+10000,2,0))*1.4,'|',v49^l,'|',v49^c,'|',v49^t,/) fi" -all now > ../htdocs/static_section_catalog.txt
