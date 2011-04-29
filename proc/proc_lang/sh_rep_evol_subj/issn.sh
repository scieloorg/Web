MX=$1
CIPFILE=$2
TEMP_PATH=$3
OUTPUT=$4
ISSN=$5
SUBJ=$6


echo inicio issn.sh $SUBJ $ISSN `date`

./sh_rep_evol_subj/issue.sh $MX $CIPFILE $TEMP_PATH HR=S${ISSN}$ $OUTPUT.seq

#./sh_rep_evol_subj/issue.sh $MX $CIPFILE $TEMP_PATH HR=S${ISSN}2005$ $OUTPUT.seq
#./sh_rep_evol_subj/issue.sh $MX $CIPFILE $TEMP_PATH HR=S${ISSN}2006$ $OUTPUT.seq
#./sh_rep_evol_subj/issue.sh $MX $CIPFILE $TEMP_PATH HR=S${ISSN}2007$ $OUTPUT.seq
#./sh_rep_evol_subj/issue.sh $MX $CIPFILE $TEMP_PATH HR=S${ISSN}2008$ $OUTPUT.seq
#./sh_rep_evol_subj/issue.sh $MX $CIPFILE $TEMP_PATH HR=S${ISSN}2009$ $OUTPUT.seq
#./sh_rep_evol_subj/issue.sh $MX $CIPFILE $TEMP_PATH HR=S${ISSN}2010$ $OUTPUT.seq

echo fim issn.sh $SUBJ $ISSN `date`



 



