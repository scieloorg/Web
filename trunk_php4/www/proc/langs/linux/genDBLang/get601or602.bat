. $1

tag=$2
path=$3
extension=$4
lang=$5
fileName=$6
acron_issueid=$7
olang=$8
procFile=$9

u=_


echo [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executing $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG
# Ex ./langs/linux//get601or602.bat 602 /home/scielo/www/langs/bases/pdf pdf es 27107 rsp/v40n1 pt

echo Testing $path/$acron_issueid/$fileName.$extension  >> $PROCLANG_LOG

echo Testing $path/$acron_issueid/$fileName.$extension
if [ -f "$path/$acron_issueid/$fileName.$extension" ]
then
    echo ",\`a$tag{^d$path^f$acron_issueid/$fileName.$extension^l$lang{\`," >> $procFile
fi
echo      [TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` Executed $0 $1 $2 $3 $4 $5   >> $PROCLANG_LOG