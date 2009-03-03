export BATCHES_PATH=procLangs/linux/
export PROCLANG_PATH=procLangs/


export MX=$MX
export PROCLANG_LOG=$PROCLANG_LOG
export DBLANG=$DBLANG
export DOCPATHS=$PROCLANG_PATH/config/docpaths.seq
export CIPAR=$PROCLANG_PATH/config/mycipar.cip


export ACRON=$1
export ISSUEID=$2

export DBACRON=$BASESWORK/$ACRON/$ACRON

$MX cipar=$CIPARFILE TITLE btell=0 "SGL=$ACRON" "pft=(v350/),#" now > temp/lang$ACRON.seq

echo $ACRON publishes texts in these languages >> $PROCLANG_LOG
more temp/lang$ACRON.seq  >> $PROCLANG_LOG

echo Executing $0 for $ACRON $ISSUEID 
echo Executing $0 for $ACRON $ISSUEID  >> $PROCLANG_LOG
$MX $DBACRON lw=9999 h=$ISSUEID count=1 now >> $PROCLANG_LOG

$MX $DBACRON lw=9999 btell=0 h=$ISSUEID "pft=#,'$BATCHES_PATH/doForArticle.bat $ACRON $ISSUEID ',if instr(s(ref(mfn-1,v799)),'.htm')>0 then  ,ref(mfn-1,mid(v799,1,instr(v799,'.htm')-1),' ',mid(v799,instr(v799,'.htm')+1,size(v799))) , else ref(mfn-1,mid(v799,1,size(v799)-4),' ', mid(v799,size(v799)-3,size(v799)) ), fi,' ',v40,' temp/lang$ACRON.seq ',v880,' $DBACRON',/" now> temp/procLangsDoForArticle.bat

chmod 775 temp/procLangsDoForArticle.bat
temp/procLangsDoForArticle.bat
