##### 
# Gera arquivo XML da bases scielo FRONT/BACK
# Parametros
# $1 - nome da base de dados que sera processada

. crossref_config.sh

rm title.*
cp $database_dir/title/title.mst .
cp $database_dir/title/title.xrf .
mx title fst=@../fst/title.fst fullinv=title
echo "Y.*=title.*">crossref.cip
#echo "Y.*=$database_dir/title/title.*">crossref.cip
if [ -f toDoList.txt ]; then
	COUNTY=`grep -cE $ toDoList.txt`
	TOT=$COUNTY
	if [ $COUNTY ]; then
		echo "TOTAL: "$COUNTY
		while [ $COUNTY != 0 ]
		do
		   DAVEZ_Y=`tail -n $COUNTY toDoList.txt | head -n 1`
		   ISSN=${DAVEZ_Y:1:9}
		   YEAR=${DAVEZ_Y:10:4}
		   NUMB=${DAVEZ_Y:14:4}
		   ARTC=${DAVEZ_Y:18:5}
		   echo $COUNTY" - S"$ISSN$YEAR$NUMB$ARTC
		   # echo "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>" > $conversor_dir/output/crossref/$ISSN/$YEAR/$NUMB/$ARTC/requestDOIXML_$ARTC.xml
		   echo "<?xml version=\"1.0\" encoding=\"utf-8\" ?>" > $conversor_dir/output/crossref/$ISSN/$YEAR/$NUMB/$ARTC/requestDOIXML_$ARTC.xml
#		echo "$cisis_dir/mx cipar=crossref.cip $database_dir/artigo/artigo \"proc=@$conversor_dir/prc/Article.prc\" \"proc=('G$conversor_dir/gizmo/crossref')\"  btell=0  \"HR=$DAVEZ_Y and tp=h\" \"proc='d32001'\" lw=99999 pft=@$conversor_dir/formats/crossref_requestXML.pft \"tell=1000\" -all now >> $conversor_dir/output/crossref/$ISSN/$YEAR/$NUMB/$ARTC/requestDOIXML_$ARTC.xml"
   
		# $cisis_dir/mx cipar=crossref.cip $database_dir/artigo/artigo "proc=@$conversor_dir/prc/Article.prc" "proc=('G$conversor_dir/gizmo/crossref')"  btell=0  "HR=$DAVEZ_Y and tp=h" "proc='d32001'" lw=99999 pft=@$conversor_dir/formats/crossref_requestXML.pft "tell=1000" -all now >> $conversor_dir/output/crossref/$ISSN/$YEAR/$NUMB/$ARTC/requestDOIXML_$ARTC.xml
	$cisis_dir/mx cipar=crossref.cip $database_dir/artigo/artigo "proc=@$conversor_dir/prc/Article.prc" "proc=('G$conversor_dir/gizmo/crossref')"  btell=0  "HR=$DAVEZ_Y and tp=h" "proc='d32001'" lw=99999 pft=@$conversor_dir/formats/crossref_requestXML.pft "tell=1000" -all now | iconv --from-code=ISO-8859-1 --to-code=UTF-8 >> $conversor_dir/output/crossref/$ISSN/$YEAR/$NUMB/$ARTC/requestDOIXML_$ARTC.xml
	$cisis_dir/mx cipar=crossref.cip $database_dir/artigo/artigo "proc=@$conversor_dir/prc/Article.prc" "proc=('G$conversor_dir/gizmo/crossref')"  btell=0  "HR=$DAVEZ_Y and tp=h" lw=99999 "pft=if ref(['Y']l(['Y']'LOC='v35),v400)<>v35 then 'proc date=',date,'|issn(artigo)=',v35,'|tit(artigo)=',v30,'|issn(title)=',ref(['Y']l(['Y']'LOC='v35),v400),'|tit(title)=',ref(['Y']l(['Y']'LOC='v35),v100)/ fi" now >> $conversor_dir/issn_problem.txt
		   COUNTY=`expr $COUNTY - 1`
		done
	fi
rm toDoList.txt
fi
rm crossref.cip
