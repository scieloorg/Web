BASEDIR=$(dirname $0)
echo $BASEDIR
cd $BASEDIR/../bases

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
