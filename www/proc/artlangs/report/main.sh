. config.sh

echo LANG.*=${LANGDB}.* >> $CIPFILE

if [ ! -d $REPORT_PATH ]
then
	mkdir -p $REPORT_PATH
fi

$MX seq=report/gizmo.seq create=report/gizmo now -all

$MX cipar=$CIPFILE TITLE "pft=(replace(v441,' ','_')/)" now | sort -u > $TEMP_PATH/subjects.seq
$MX null count=1 "pft='ALL',#," now >> $TEMP_PATH/subjects.seq

$MX cipar=$CIPFILE TITLE fst=@fst/title.fst fullinv=TITLE
 
$MX seq=$TEMP_PATH/subjects.seq lw=9999 "pft='./report/subject.sh $MX $CIPFILE $TEMP_PATH $MXTB $REPORT_PATH/',v1,'.csv ',mfn,' \"',v1,'\"',#"  now > $TEMP_PATH/subjects.sh

sh -x $TEMP_PATH/subjects.sh

