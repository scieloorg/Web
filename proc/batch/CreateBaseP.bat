ID=$1
MX=$2
DB=$3
NEWDBPATH=$4
NEWDB=$5

if [ !  "@$NEWDB" == "@" ]
then
    call batch/InformaLog.bat $0 x CreateBaseP for $ID
    if [ -d $NEWDBPATH ]
    then
        call batch/InformaLog.bat $0 x Delete  $NEWDBPATH/$NEWDB.*
        rm $NEWDBPATH/$NEWDB.*

    else
        call batch/InformaLog.bat $0 x Create $NEWDBPATH
        mkdir -p $NEWDBPATH
    fi
    if [ -d $NEWDBPATH ]
    then
        $MX $DB btell=0 "bool=P$ID" count=1 "pft=if p(v880) then 'exist' fi" now > $NEWDBPATH/$NEWDB.exist
        TEST=`cat $NEWDBPATH/$NEWDB.exist`

        if [ "@$TEST" == "@exist" ]
        then
            call batch/InformaLog.bat $0 x References paragraph RP$ID
            $MX $DB btell=0 "bool=RP$ID" count=1 "pft=mfn,'|',v701/" now    > $NEWDBPATH/$NEWDB.r
            $MX $DB btell=0 "bool=RP$ID" "pft=mfn,'|',v701/" now | sort -r >> $NEWDBPATH/$NEWDB.r
            $MX seq=$NEWDBPATH/$NEWDB.r count=2 create=$NEWDBPATH/$NEWDB now -all
            $MX $DB btell=0 "bool=P$ID" append=$NEWDBPATH/$NEWDB now -all

            call batch/InformaLog.bat $0 x Check difference
            $MX $DB btell=0 "bool=P$ID" lw=9999 "pft=v704/" now > $NEWDBPATH/$NEWDB.a
            $MX $NEWDBPATH/$NEWDB       lw=9999 "pft=v704/" now > $NEWDBPATH/$NEWDB.p
            diff -y --suppress-common $NEWDBPATH/$NEWDB.a $NEWDBPATH/$NEWDB.p > $NEWDBPATH/$NEWDB.diff
            DIF=`cat $NEWDBPATH/$NEWDB.diff`
            rm $NEWDBPATH/$NEWDB.a $NEWDBPATH/$NEWDB.p $NEWDBPATH/$NEWDB.r $NEWDBPATH/$NEWDB.exist $NEWDBPATH/$NEWDB.diff
            if [ "@$DIF" == "@" ]
            then
                call batch/InformaLog.bat $0 x Delete P$ID in $DB
                $MX $DB btell=0 "bool=P$ID" "proc='d*'" copy=$DB now -all
            else
                call batch/InformaLog.bat $0 x It is different
                mv $NEWDBPATH/$NEWDB.mst $NEWDBPATH/$NEWDB.bad.mst
                mv $NEWDBPATH/$NEWDB.xrf $NEWDBPATH/$NEWDB.bad.xrf
            fi
        else
            call batch/InformaLog.bat $0 x No P$ID in $DB
        fi
    fi
fi
