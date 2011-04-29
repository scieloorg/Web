. config.sh

echo $REP_EVOL_JOURNAL_PATH 

if [ ! -d $REP_EVOL_JOURNAL_PATH ]
then
   mkdir -p $REP_EVOL_JOURNAL_PATH
fi

$MX $LANGDB lw=9999 "pft=if p(v83) and  a(v131) and a(v132) and v32<>'ahead' and v32<>'review' and (val(v880*10.4)>2005) then v880*1.9,'|',v880*10.4,'|',v40,#,(if v601^l<>'' then v880[1]*1.9,'|',v880[1]*10.4,'|',v601^l,#, fi) fi" now> $TEMP_PATH/report_evol_journal.seq

$MX seq=$TEMP_PATH/report_evol_journal.seq create=$TEMP_PATH/report_evol_journal now -all

$MXTB $TEMP_PATH/report_evol_journal create=$REP_EVOL_JOURNAL_PATH/report_lang_2006-2010 "100:v1,'|',v2,'|,v3/"

