##### 
# Gera arquivo XML da bases scielo FRONT
#####

#####
# variáveis
. doaj_config.sh
##### 

$cisis/mx seq=$proc_path/scielo_doaj/databases/iso6932.seq create=$proc_path/scielo_doaj/databases/iso6932 -all now
$cisis/mx $proc_path/scielo_doaj/databases/iso6932 fst=@$proc_path/scielo_doaj/databases/iso6932.fst fullinv=$proc_path/scielo_doaj/databases/iso6932 -all now

echo "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>" > $proc_path/scielo_doaj/output/doaj/file.xml
echo "<records>" >> $proc_path/scielo_doaj/output/doaj/file.xml

echo "Y.*="$database_title".*" > $proc_path/scielo_doaj/databases/cipar.cip
echo "LANG.*="$proc_path/scielo_doaj/databases/iso6932".*" >> $proc_path/scielo_doaj/databases/cipar.cip

$cisis/mx cipar=$proc_path/scielo_doaj/databases/cipar.cip $database_article "proc=('G$proc_path/scielo_doaj/gizmo/gizmo_xml')" btell=0  tp=h "proc='d32001'" lw=99999 pft=@$proc_path/scielo_doaj/formats/doaj_XML.pft tell=1000 -all now >> $proc_path/scielo_doaj/output/doaj/file.xml

echo "</records>" >> $proc_path/scielo_doaj/output/doaj/file.xml
#rm cipar.cip

java -jar $proc_path/scielo_doaj/java/msv.jar $proc_path/scielo_doaj/xsd/doajArticles.xsd $proc_path/scielo_doaj/output/doaj/file.xml > $proc_path/scielo_doaj/output/doaj/errorlog.txt
