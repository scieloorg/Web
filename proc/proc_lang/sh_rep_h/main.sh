. config.sh
REPFILE=$1

REP=$TEMP_PATH/report_lang_for_all
REPTAB=$TEMP_PATH/report_lang_for_all_2006-2010
DATA=$TEMP_PATH/data_for_all
if [ "@$REPFILE" == "@" ]
then
REPFILE=report.lang.h.txt
fi

if [ ! -d $TEMP_PATH ]
then
   mkdir -p $TEMP_PATH
fi
echo generate $REP.00.seq
$MX $LANGDB lw=9999 "pft=v880,'|',v40,#,(if v601^l<>'' then v880[1],'|',v601^l,#, fi),(if v602^l<>'' then v880[1],'|',v602^l,#, fi)" now | sort -u>  $REP.00.seq
$MX seq=$REP.00.seq create=$REP.00 now -all

$MX $REP.00 lw=9999 "pft=v1*1.9,'|',v1*10.4,'|',v2,#" now > $REP.seq


echo generate $REP
$MX seq=$REP.seq create=$REP now -all

echo tabula
$MXTB $REP create=$REPTAB "100:v1,'|',v2,'|',if instr('en-es-pt',v3)=0 then '??' else v3 fi/" class=10000

echo generate $DATA.seq
$MX $REPTAB "pft=v1,'|',v999/" now > $DATA.seq

echo generate $DATA
$MX seq=$DATA.seq create=$DATA now -all
$MX $DATA "fst='1 0 v1,v2,v3/'" fullinv=$DATA

echo gera $TEMP_PATH/call_report.sh
$MX $TITLEDB lw=9999 "pft=if v50='C' and v691*0.1='1' and  (v51^c[1]='' or a(v51^c[1]))  then 'sh sh_rep_h/row.sh ',v400,' $DATA \"',v100,'\"',# fi" now > $TEMP_PATH/call_report.sh

echo executa $TEMP_PATH/call_report.sh
echo "||pt|||||es|||||en||||">$REPFILE
echo "title|issn|2006|2007|2008|2009|2010|2006|2007|2008|2009|2010|2006|2007|2008|2009|2010">>$REPFILE
sh $TEMP_PATH/call_report.sh >>$REPFILE

echo read report at $REPFILE
