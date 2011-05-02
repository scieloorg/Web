# Gera um relatorio com a quantidade de documentos classificados 
# por doctopic, texto original, traduções de um título
#
# | doctopic        | idioma original    | traducoes          |
# |                 | pt  | en | es | ...| pt  | en | es | ...|
# | anexo           |  1  | 0  | 0  |    |0    | 0  | 0  | ...|
#
echo `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5

. $1
ISSN=$2
RESULT_FILE_NAME=$3
LANG_REPORT=$4
YEAR=$5

echo $LANG_REPORT
if [ -f "$LANG_REPORT" ]
then
    $MX "seq=$LANG_REPORT" gizmo=$GZM_TAB2PIPE create=temp/je_langreport now -all
    $MX temp/je_langreport  lw=9999 "pft=if '$YEAR'='' or v1:'$YEAR' then v1,'|',v2,'|',v3,'|', v4,'|',v5,'|',v6,'|',v7/  fi" now > temp/je_selectYear.txt
    $MX seq=temp/je_selectYear.txt create=temp/je_selectYear now -all
    $MX temp/je_selectYear "fst=@$PATH_DOCTOPIC_SHELLS/doctopic_lang_report.fst" fullinv=temp/je_selectYear

    echo "Tipo de contribuição" > $RESULT_FILE_NAME
    $MX temp/je_selectYear "pft=v4/" now | sort -u > $TITLE_LANGS

    $MX seq=$TITLE_LANGS lw=9999 "pft=,if mfn=1 then 'TIPO DE CONTRIBUIÇÕES|ORIGINAIS' fi,'|'" now > $RESULT_FILE_NAME
    $MX seq=$TITLE_LANGS lw=9999 "pft=,if mfn=1 then 'TRADUÇÕES' fi,'|'" now >> $RESULT_FILE_NAME
    echo >> $RESULT_FILE_NAME
    $MX seq=$TITLE_LANGS lw=9999 gizmo=$GZM_LANG "pft='|',v1" now >> $RESULT_FILE_NAME
    $MX seq=$TITLE_LANGS lw=9999 gizmo=$GZM_LANG "pft='|',v1" now >> $RESULT_FILE_NAME
    echo >> $RESULT_FILE_NAME

    $MX seq=$DOCTOPIC lw=9999 "pft='./$PATH_DOCTOPIC_SHELLS/doctopic_getLangReportByDoctopic.bat $FILE_CONFIG ',v1,' $RESULT_FILE_NAME temp/je_selectYear'/" now > temp/doctopic_call_getLanguages.bat
    chmod 775 temp/doctopic_call_getLanguages.bat
    ./temp/doctopic_call_getLanguages.bat
else
    echo Nao Existe $LANG_REPORT
    echo $LANG_REPORT Languages report unavailable >> $RESULT_FILE_NAME
fi
echo `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5
