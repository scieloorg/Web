##### 
# Gera arquivo XML da bases scielo FRONT/BACK
# Parametros
# $1 - nome da base de dados que será processada

. crossref_config.sh

echo "Y.*=$database_dir/title/title.*">crossref.cip
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
		   echo "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>" > $conversor_dir/output/crossref/$ISSN/$YEAR/$NUMB/$ARTC/requestDOIXML_$ARTC.xml
#		echo "$cisis_dir/mx cipar=crossref.cip $database_dir/artigo/artigo \"proc=@$conversor_dir/prc/Article.prc\" \"proc=('G$conversor_dir/gizmo/crossref')\"  btell=0  \"HR=$DAVEZ_Y and tp=h\" \"proc='d32001'\" lw=99999 pft=@$conversor_dir/formats/crossref_requestXML.pft \"tell=1000\" -all now >> $conversor_dir/output/crossref/$ISSN/$YEAR/$NUMB/$ARTC/requestDOIXML_$ARTC.xml"
   
		$cisis_dir/mx cipar=crossref.cip $database_dir/artigo/artigo "proc=@$conversor_dir/prc/Article.prc" "proc=('G$conversor_dir/gizmo/crossref')"  btell=0  "HR=$DAVEZ_Y and tp=h" "proc='d32001'" lw=99999 pft=@$conversor_dir/formats/crossref_requestXML.pft "tell=1000" -all now >> $conversor_dir/output/crossref/$ISSN/$YEAR/$NUMB/$ARTC/requestDOIXML_$ARTC.xml
		   COUNTY=`expr $COUNTY - 1`
		done
	fi
rm toDoList.txt
fi
rm crossref.cip
