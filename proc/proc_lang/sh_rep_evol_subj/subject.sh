MX=$1
CIPFILE=$2
TEMP_PATH=$3
MXTB=$4
OUTPUT=$5
SUBJ_I=$6
SUBJ=$7

PID_LANG=$TEMP_PATH/${SUBJ_I}_pid_lang
PID_LANG_COMB=$TEMP_PATH/${SUBJ_I}_pid_lang_comb
YEAR_LANG=$TEMP_PATH/${SUBJ_I}_year_lang
YEAR_LANG_COMB=$TEMP_PATH/${SUBJ_I}_year_lang_comb
TOTAL_ARTICLE_VERSIONS=$TEMP_PATH/${SUBJ_I}_total_art_versions
TOTAL_ARTICLE=$TEMP_PATH/${SUBJ_I}_total_art
LANGS=$TEMP_PATH/${SUBJ_I}_langs
YEARS=$TEMP_PATH/${SUBJ_I}_years


echo "---------------"
echo subject.sh 
echo SUBJECT=$SUBJ
echo `date`
echo "---------------"
if [ -f $PID_LANG.seq ]
then
	rm $PID_LANG.seq
fi

if [ "$SUBJ" == "ALL" ]
then
	./sh_rep_evol_subj/issue.sh $MX $CIPFILE $TEMP_PATH HR=S$ $PID_LANG.seq
else
	# Get the ISSN of the title of a SUBJECT
	$MX cipar=$CIPFILE TITLE btell=0 "bool=SUBJ=$SUBJ" "pft=v400/" now > $TEMP_PATH/issn.seq
	
	# For the list of ISSN generate a list of PID vs language
	$MX seq=$TEMP_PATH/issn.seq lw=9999 "pft='./sh_rep_evol_subj/issn.sh $MX $CIPFILE $TEMP_PATH $PID_LANG ',v1,' \"$SUBJ\" '/"  now > $TEMP_PATH/artigo.sh
	sh -x $TEMP_PATH/artigo.sh
fi

if [ -f $PID_LANG.seq ]
then
	$MX seq=$PID_LANG.seq create=$PID_LANG now -all
	
	# For the list of PID vs language, generate PID vs combination of languages
	$MX $PID_LANG lw=9999 "pft=if ref(mfn-1,v1)<>v1 then #,v1,'|', fi,|-|v2|-|," now | sort -u > $PID_LANG_COMB.seq
	$MX seq=$PID_LANG_COMB.seq create=$PID_LANG_COMB now -all
	
	# Tabulate YEAR vs COMBINATIONS OF LANG
	$MXTB $PID_LANG_COMB create=${YEAR_LANG_COMB} "230:'^y',v1*10.4,'^l',v2/" class=1000000 tell=10000

	# Tabulate TOTAL OF ARTICLES BY YEAR
	$MXTB $PID_LANG_COMB create=${TOTAL_ARTICLE}  "230:'^y',v1*10.4/"         class=1000000 tell=10000

	# Tabulate YEAR vs LANG
	$MXTB $PID_LANG      create=${YEAR_LANG}               "230:'^y',v1*10.4,'^l',v2/" class=1000000 tell=10000

	# Tabulate TOTAL OF VERSIONS OF ARTICLE BY YEAR
	$MXTB $PID_LANG      create=${TOTAL_ARTICLE_VERSIONS} "230:'^y',v1*10.4/"         class=1000000 tell=10000
	
	# List of years
	$MX ${TOTAL_ARTICLE_VERSIONS} "pft=v1^y/" now | sort > $YEARS.seq
	
	# List of languages and their combinations
	$MXTB $YEAR_LANG      create=${LANGS}  "230:'^l',v1^l/"         class=1000000 tell=10000
	$MXTB $YEAR_LANG_COMB create=${LANGS}1 "230:'^l',v1^l/"         class=1000000 tell=10000
	$MX ${LANGS}  "pft=v1^l/" now | sort >  $LANGS.seq
	$MX ${LANGS}1 "pft=v1^l/" now | sort > ${LANGS}1.seq
	
	# invert
	$MX $YEAR_LANG fst=@sh_rep_evol_subj/year_lang.fst fullinv=$YEAR_LANG
	$MX $YEAR_LANG_COMB fst=@sh_rep_evol_subj/year_lang.fst fullinv=$YEAR_LANG_COMB
	$MX $TOTAL_ARTICLE_VERSIONS fst=@sh_rep_evol_subj/year_lang.fst fullinv=$TOTAL_ARTICLE_VERSIONS
	$MX $TOTAL_ARTICLE fst=@sh_rep_evol_subj/year_lang.fst fullinv=$TOTAL_ARTICLE
	
	# Create table
	if [ "$SUBJ" == "$" ]
	then
		echo > $OUTPUT
	else
		echo $SUBJ> $OUTPUT
	fi
	$MX seq=${YEARS}.seq "pft=(';',v1)" now >> $OUTPUT
	$MX seq=$LANGS.seq "proc='a9000~',v1,'~'" create=$LANGS now -all
	$MX $LANGS gizmo=sh_rep_evol_subj/gizmo,9000  lw=9999 "pft='./sh_rep_evol_subj/table.sh $MX ${YEARS}.seq $YEAR_LANG ',v1,' ',v9000,#" now           >  $TEMP_PATH/table.sh
	$MX null count=1      lw=9999 "pft='./sh_rep_evol_subj/table.sh $MX ${YEARS}.seq $TOTAL_ARTICLE_VERSIONS ',#" now >> $TEMP_PATH/table.sh
	$MX seq=${LANGS}1.seq "proc='a9000~',v1,'~'" create=${LANGS}1 now -all
	$MX ${LANGS}1 gizmo=sh_rep_evol_subj/gizmo,9000 lw=9999 "pft='./sh_rep_evol_subj/table.sh $MX ${YEARS}.seq $YEAR_LANG_COMB ',v1,' ',v9000,#" now      >> $TEMP_PATH/table.sh
	$MX null count=1      lw=9999 "pft='./sh_rep_evol_subj/table.sh $MX ${YEARS}.seq $TOTAL_ARTICLE ',#" now          >> $TEMP_PATH/table.sh
	sh -x $TEMP_PATH/table.sh >> $OUTPUT
	
fi
echo fim subject.sh $SUBJ `date`
