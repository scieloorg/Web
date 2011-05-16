
. $1

sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG $0

ISSUEPID=$2
JOURNAL_PATH_OUTPUT=$3
ORDER=$4
OUTPUT_DOCTOPIC_REPORT=$5
OUTPUT_HIST_REPORT=$6
OUTPUT_ISSUES_REPORT=$7.$ORDER.csv
OUTPUT_AUTHORS_REPORT=$8

#OUTPUT_DOCTOPIC_REPORT=$JOURNAL_PATH_OUTPUT/doctopic.txt
#OUTPUT_HIST_REPORT=$JOURNAL_PATH_OUTPUT/recebido-aprovado.txt
#OUTPUT_ISSUES_REPORT=$JOURNAL_PATH_OUTPUT/issue$ORDER
#OUTPUT_AUTHORS_REPORT=$INPUT_FOR_ENDOGENIA_PROC.seq

# TEMP FILES
JOURNAL_ARTICLES_DB=$JOURNAL_PATH_OUTPUT/temp_art_db
DAYS_CRESC_DB=$JOURNAL_PATH_OUTPUT/temp_days
DAYS_CRESC_SEQ=$JOURNAL_PATH_OUTPUT/temp_days.seq
UNORDERED_DAYS=$JOURNAL_PATH_OUTPUT/temp_days_unordered.seq
DAYS_REP_SEQ=$JOURNAL_PATH_OUTPUT/temp_days_rep.seq
DAYS_REP_DB=$JOURNAL_PATH_OUTPUT/temp_days_rep

sh ./$PATH_COMMON_SHELLS/WriteLog.bat $FILE_LOG "Create $JOURNAL_ARTICLES_DB "


$MX null count=0 create=$JOURNAL_ARTICLES_DB now -all
$MX $ARTIGODB btell=0 "hr=S$ISSUEPID$" "proc=ref(['$LANGDB']l(['$LANGDB']'hr='v880),(if v601^l<>'' then 'a601{',v601^l,'{' fi))" "proc='a970{^i',v112,'^f',v114,'{a960{',f(val(ref(['$DATEDB']l(['$DATEDB']v114*1),v2))-val(ref(['$DATEDB']l(['$DATEDB']v112*1),v2)),1,0),'{'"  append=$JOURNAL_ARTICLES_DB now -all


################
# DADOS DOS FASCICULOS

NUMBERSDB=$JOURNAL_ARTICLES_DB.numbers
DOCTOPICDB=$JOURNAL_ARTICLES_DB.doctopic

##########
# PREPARATION
#############
if [ "@$ORDER" == "@1" ]
then
    if [ -f "$DOCTOPICDB.seq" ]
    then
        rm -rf "$DOCTOPICDB.seq"
    fi
    if [ -f "$UNORDERED_DAYS" ]
    then
        rm -rf "$UNORDERED_DAYS"
    fi
fi

$MXTB $JOURNAL_ARTICLES_DB create=$NUMBERSDB  "100:if v71='oa' then 'tp|oa',# fi,if p(v83) then 'tp|artigos',# fi"
$MXTB $JOURNAL_ARTICLES_DB append=$NUMBERSDB  "100:if p(v83) then 'ol|',if v12^l:v40[1] then '1' fi,if v83^l:v40[1] then '1' fi,if instr(v85^l,v40[1])>0 then '1' fi,#  fi"
$MXTB $JOURNAL_ARTICLES_DB append=$NUMBERSDB  "100:if p(v83) then 'en|',if v12^l:'en' then '1' fi,if v83^l:'en' then '1' fi,if v85^l:'en' then '1' fi,#  fi"
$MXTB $JOURNAL_ARTICLES_DB append=$NUMBERSDB  "100:if p(v83) then 'aff|',if p(v70^p) and p(v70^c) then 'x' fi,#  fi"
$MXTB $JOURNAL_ARTICLES_DB append=$NUMBERSDB  "100:if p(v83) then 'email|',if p(v70^e) then 'x' fi,#  fi"
$MXTB $JOURNAL_ARTICLES_DB append=$NUMBERSDB  "100:if p(v83) then 'rec|',if p(v112) then 'x' fi,#  fi"
$MXTB $JOURNAL_ARTICLES_DB append=$NUMBERSDB  "100:if p(v83) then 'apr|',if p(v114) then 'x' fi,#  fi"
$MX $JOURNAL_ARTICLES_DB "proc='a9071{',if instr('|an|oa|up|le|co|sc|ed|ct|in|tr|mt|rn|pv|cr|rc|ab|ra|',v71)=0 then 'xx' else v71 fi,'{'" "pft=v9071,if instr('enespt',v40)=0 then 'xx' else v40 fi,#,if p(v601) then (v9071[1],if instr('enespt',v601)=0 then 'xx' else v601 fi/) fi"  now >> $DOCTOPICDB.seq
$MX $JOURNAL_ARTICLES_DB "pft=s(f(10000000+val(v960),1,0))*1,'|',v970,'|',v880/" now  >> $UNORDERED_DAYS


######################
# EXTRACTED STATISTICS TO EACH ISSUE

$MX $NUMBERSDB lw=999 "pft=v999,'|',v1,#" now > $NUMBERSDB.seq
$MX seq=$NUMBERSDB.seq create=$NUMBERSDB now -all
$MX $NUMBERSDB fst=@fst/tabissue.fst fullinv=$NUMBERSDB
$MX $ARTIGODB btell=0 "Y$ISSUEPID$" "proc='a9001{$NUMBERSDB{'" "proc=@prc/add_articles_data.prc" lw=999 "pft=@$PATH_TEMPLATE/issues.pft" now > $OUTPUT_ISSUES_REPORT
$MX $ARTIGODB btell=0 "Y$ISSUEPID$" "proc='a9001{$NUMBERSDB{'" "proc=@prc/add_articles_data.prc" lw=999 "pft=@$PATH_TEMPLATE/issues.pft" now > $OUTPUT_ISSUES_REPORT.debug
###############

######################
# AUTHORS REPORT
$MX cipar=$FILE_CIPAR $JOURNAL_ARTICLES_DB lw=9999 gizmo=ENTITY  "pft=(v31[1],'|',v32[1],'|',s(v65[1])*0.4,'|',v14^f[1],'|',v12^*[1],'|',,v10^n,| |v10^s,,'|',if p(v10^1) then ,ref(['$DBv10v70']l(['$DBv10v70']v880[1],v10^1*0.3),v2^*,'|',v3^1,'|',v3^2,'|',v2^c,'|',v2^s,'|',v2^p), fi,/)" now >> $OUTPUT_AUTHORS_REPORT


if [ "@$ORDER" == "@LAST" ]
then
    ######################
    # DOCTOPIC REPORT X LANGUAGE

    $MX seq=$DOCTOPICDB.seq create=$DOCTOPICDB now -all
    $MXTB $DOCTOPICDB create=$DOCTOPICDB.tab "100:v1"
    $MX $DOCTOPICDB.tab "fst='1 0 v1'" fullinv=$DOCTOPICDB.tab
    $MX null count=1 "proc='a9001{$DOCTOPICDB.tab{'" lw=999 "pft=@$PATH_TEMPLATE/doctopic.pft" now > $OUTPUT_DOCTOPIC_REPORT

    ######################
    # RECEIVED/APROVED REPORT
    $MX seq=$UNORDERED_DAYS "pft=if v2^i<>'' and v2^f<>'' and val(v2^i)<val(v2^f) then v1/ else '0'/ fi" now | sort    > $DAYS_CRESC_SEQ
    
    $MX seq=$DAYS_CRESC_SEQ create=$DAYS_CRESC_DB now -all
    $MX $DAYS_CRESC_DB lw=999 "pft=@$PATH_DATE_DIFF/formula_total.pft" now > $DAYS_REP_SEQ.pft

    # Artigos com datas aceito/recebido v?lidas
    $MX $DAYS_CRESC_DB "pft=if ref(mfn+1,v1)='' then f(val(mfn),1,0)/ fi" now > $DAYS_REP_SEQ

    # ultimo mfn
    mfn=`cat $DAYS_REP_SEQ`

    # Quantidade de dias
    $MX null count=1 "pft=@$DAYS_REP_SEQ.pft" now >> $DAYS_REP_SEQ
    echo >> $DAYS_REP_SEQ

    # Menor tempo (dias)
    $MX $DAYS_CRESC_DB count=1 "pft=f(val(v1),1,0),#" now >> $DAYS_REP_SEQ

    # Maior tempo (dias)
    $MX $DAYS_CRESC_DB from=$mfn count=1 "pft=f(val(v1),1,0),#" now >> $DAYS_REP_SEQ

    # Media de tempo (em dias)
    $MX seq=$DAYS_REP_SEQ create=$DAYS_REP_DB now -all
    cp $DAYS_REP_SEQ $OUTPUT_HIST_REPORT
    $MX $DAYS_REP_DB from=2 count=1 "pft=f(val(v1)/val(ref(1,v1)),1,2),#" now >> $OUTPUT_HIST_REPORT


fi

