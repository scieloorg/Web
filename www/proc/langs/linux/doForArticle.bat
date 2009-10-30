. $1

echo Executing $0 $1 $2 $3 $4 $5  >> $PROCLANG_LOG

MFN=$2

echo Creating the record >> $PROCLANG_LOG
$MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 "pft='`d*','a880{',v880,'a71{',v71,'{a900{',replace(mid(mid(v702,1,instr(v702,'\markup')-1),instr(v702,'\serial\')+size('\serial\'),size(v702)),'\',''),'{a40{',v40,'{',('a83{',v83^l,'{'),'a91{',date,'{`'" now > temp/langs_proc.prc
$MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 "pft='./$BATCHES_PATH/get601and602.bat $1 ',mid(v702,instr('\markup\')+size('\markup\'),size(v702)),' ',replace(mid(mid(v702,1,instr(v702,'\markup')-1),instr(v702,'\serial\')+size('\serial\'),size(v702)),'\','/'),' ',v40/" now >> temp/langs_proc.prc

$MX cipar=$FILE_CIPAR ARTIGO from=$MFN count=1 "proc=@temp/langs_proc.prc" append=$DBLANG now -all
echo Executed $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG