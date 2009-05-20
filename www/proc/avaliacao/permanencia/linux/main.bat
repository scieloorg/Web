# Param 1 issn
# Param 2 count

# export MX=$MX
# CPFILE
#
export MX=lindG4/mx
export CPFILE=avaliacao/permanencia/config/avaliacao.cip
export OUTPUT_PATH=/home/scielo/www/htdocs/teste/avaliacao/permanencia/data/
export rel=/teste/avaliacao/permanencia/data/
export SCILISTA=temp/avaliacao_permanencia_scilista.lst
export ISSUEQTD=3
export HTML_FILE=/home/scielo/www/htdocs/teste/avaliacao/permanencia/data/journals.htm
export JOURNAL_EDBOARD_HTML_PATH=/home/scielo/www/htdocs/revistas/

echo Tabelas de gizmo
$MX seq=avaliacao/gizmo/gizmoFreq.seq create=avaliacao/gizmo/gizmoFreq now -all
$MX "seq=avaliacao/gizmo/pipe2tab.seq " create=avaliacao/gizmo/pipe2tab now -all
$MX "seq=avaliacao/permanencia/linux/tab.seq " create=avaliacao/gizmo/tab now -all
$MX "seq=avaliacao/permanencia/linux/tab2sep.seq " create=avaliacao/gizmo/tab2sep now -all
$MX "seq=avaliacao/gizmo/tabEdboard.seq" create=avaliacao/gizmo/tabEdboard now -all


if [ -f temp/avaliacao_afiliacoes.txt ]
then
	rm temp/avaliacao_afiliacoes.txt
fi
if [ -f log/avaliacao_permanencia.log ]
then
	rm log/avaliacao_permanencia.log
fi

if [ -f avaliacao/gizmo/newaff.seq ]
then
# echo avaliacao/gizmo/tab2sep
echo gera newaff
	$MX "seq=avaliacao/gizmo/newaff.seq" gizmo=avaliacao/gizmo/tab2sep create=avaliacao/gizmo/newaff now -all	
	$MX avaliacao/gizmo/newaff lw=9999 "pft=if l(['avaliacao/gizmo/aff']v1)=0 then v1,'|',v2,'|',v3,'|',v4,'|',v5,'|',v6/ fi" now >> avaliacao/gizmo/aff.seq
fi
$MX "seq=avaliacao/gizmo/aff.seq" create=avaliacao/gizmo/aff now -all
$MX avaliacao/gizmo/aff "fst=1 0 mpl,v1/" fullinv=avaliacao/gizmo/aff 


chmod  775 avaliacao/permanencia/linux/*.bat

if [ ! -d $OUTPUT_PATH ]
then
	mkdir -p $OUTPUT_PATH
fi

./avaliacao/permanencia/linux/generateJournalList.bat $MX $CPFILE $SCILISTA

# vi $SCILISTA

more avaliacao/pft/html.00.pft > $HTML_FILE

$MX null count=1 lw=9999 "pft='<p><a href=\"aff_list.txt\">Affiliation list to check</a></p>'" now >> $HTML_FILE

echo JOurnals
$MX "seq=$SCILISTA" lw=9999 "pft='./avaliacao/permanencia/linux/getJournalInfo.bat ',v2,' $ISSUEQTD $MX $CPFILE $OUTPUT_PATH ',v3,' $rel $HTML_FILE $JOURNAL_EDBOARD_HTML_PATH'/" now  > temp/avaliacao_call.bat
chmod 775 temp/avaliacao_call.bat
./temp/avaliacao_call.bat >log/avaliacao_geral.log


echo Afiliacoes
$MX "seq=temp/avaliacao_afiliacoes.txt¨" lw=9999 "pft=if l(['avaliacao/gizmo/aff']v1)=0 then v1,'|',v2,'|',v3,'|',v4,'|',v5,'|',v6/ fi" now > temp/avaliacao_afiliacoes_3.txt

# echo avaliacao/gizmo/pipe2tab
$MX "seq=temp/avaliacao_afiliacoes_3.txt¨" gizmo=avaliacao/gizmo/pipe2tab lw=9999 "pft=v1/" now > $OUTPUT_PATH/aff_list.txt


more avaliacao/pft/html.99.pft >> $HTML_FILE


ls -l $HTML_FILE