source ../../../scielo-env/bin/activate
./doaj_geraXML.py > ../output/doaj/file.xml
./doaj_splitFiles.py
deactivate
