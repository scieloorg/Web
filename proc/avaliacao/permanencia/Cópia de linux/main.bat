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

$MX seq=avaliacao/gizmo/gizmoFreq.seq create=avaliacao/gizmo/gizmoFreq now -all

chmod  775 avaliacao/permanencia/linux/*.bat

if [ ! -d $OUTPUT_PATH ]
then
	mkdir -p $OUTPUT_PATH
fi

./avaliacao/permanencia/linux/generateJournalList.bat $MX $CPFILE $SCILISTA

# vi $SCILISTA

$MX "seq=$SCILISTA" lw=9999 "pft='./avaliacao/permanencia/linux/getJournalInfo.bat ',v2,' $ISSUEQTD $MX $CPFILE $OUTPUT_PATH ',v3,' $rel'/" now  > temp/avaliacao_call.bat

chmod 775 temp/avaliacao_call.bat

./temp/avaliacao_call.bat
