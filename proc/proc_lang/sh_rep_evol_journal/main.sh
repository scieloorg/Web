. config.sh


if [ ! -d $TEMP_PATH ]
then
   mkdir -p $TEMP_PATH
fi
echo generate $TEMP_PATH/report_evol_journal.seq
$MX $LANGDB lw=9999 "pft=if p(v83) and  a(v131) and a(v132) and v32<>'ahead' and v32<>'review'  then v880*1.9,'|',v880*10.4,'|',v40,#,(if v601^l<>'' then v880[1]*1.9,'|',v880[1]*10.4,'|',v601^l,#, fi) fi" now> $TEMP_PATH/report_evol_journal.seq

echo generate $TEMP_PATH/report_evol_journal
$MX seq=$TEMP_PATH/report_evol_journal.seq create=$TEMP_PATH/report_evol_journal now -all

echo tabula
$MXTB $TEMP_PATH/report_evol_journal create=$TEMP_PATH/report_lang_2006-2010 "100:v1,'|',v2,'|',if instr('en-es-pt',v3)=0 then '??' else v3 fi/" class=10000

echo generate $TEMP_PATH/data.seq
$MX $TEMP_PATH/report_lang_2006-2010 "pft=v1,'|',v999/" now > $TEMP_PATH/data.seq

echo generate $TEMP_PATH/data
$MX seq=$TEMP_PATH/data.seq create=$TEMP_PATH/data now -all
$MX $TEMP_PATH/data "fst='1 0 v1,v2,v3/'" fullinv=$TEMP_PATH/data

echo gera $TEMP_PATH/call_report.sh
$MX $TITLEDB lw=9999 "pft='sh sh_rep_evol_journal/row.sh ',v400,' $TEMP_PATH/data \"',v100,'\"',#" now > $TEMP_PATH/call_report.sh

echo executa $TEMP_PATH/call_report.sh
echo "||pt|||||es|||||en||||">$REP_EVOL_JOURNAL_PATH/report_journal_lang.txt
echo "title|issn|2006|2007|2008|2009|2010|2006|2007|2008|2009|2010|2006|2007|2008|2009|2010">>$REP_EVOL_JOURNAL_PATH/report_journal_lang.txt
sh $TEMP_PATH/call_report.sh >>$REP_EVOL_JOURNAL_PATH/report_journal_lang.txt