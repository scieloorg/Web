tag=$1
path=$2
extension=$3
lang=$5
fileName=$5
acron_issueid=$6
olang=$7

echo Executing $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG

if [ -f $path/$acron_issueid/$lang\_$fileName.$extension ]
then
    echo ",`a$tag{\^d$path\^f$acron_issueid/$lang\_$fileName.$extension\^l$lang,{`,"
else
    if [ "@$olang" == "@$lang" ]
    then
        if [ -f $path/$acron_issueid/$fileName.$extension ]
        then
            echo ",`a$tag{\^d$path\^f$acron_issueid/$fileName.$extension\^l$lang{`,"
        fi
    fi
fi
echo Executed $0 $1 $2 $3 $4 $5 >> $PROCLANG_LOG