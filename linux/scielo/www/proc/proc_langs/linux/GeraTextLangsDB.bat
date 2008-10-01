if [ ! -f $CTRL.mst ]
then
   mkdir -p $CTRL_PATH
   $MX null count=0 create=$CTRL now
fi
$MX $CTRL fst=@proc_langs/control.fst fullinv=$CTRL


if [ "@$1" == "@" ] then

else

	$WXIS IsisScript=proc_langs/process_texts.xis def=proc_langs/text-langs.def acron=$1 issue=$2 debug=$3 reinvert=temp/$1.bat

	$MX $CTRL fst=@proc_langs/control.fst fullinv=$CTRL
fi

