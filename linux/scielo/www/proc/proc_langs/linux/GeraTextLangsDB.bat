if [ ! -f ../bases-work/lang/control.mst ]
then
   mkdir ../bases-work/lang
   cisis/mx null count=0 create=../bases-work/lang/control now
fi
cisis/mx ../bases-work/lang/control fst=@proc_langs/control.fst fullinv=../bases-work/lang/control

../cgi-bin/wxis.exe IsisScript=proc_langs/process_texts.xis def=proc_langs/text-langs.def acron=$1 issue=$2 debug=$3 reinvert=temp/$1.bat

cisis/mx ../bases-work/lang/control fst=@proc_langs/control.fst fullinv=../bases-work/lang/control

