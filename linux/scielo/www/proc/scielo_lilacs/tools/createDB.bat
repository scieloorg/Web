if [ "@$3" == "@reset" ]
then
	$mx null count=0 create=$1 now -all	
	$mx $1 "fst=@$2" fullinv=$1
fi
if [ ! -f $1.mst ]
then
		$mx null count=0 create=$1 now -all
		$mx $1 "fst=@$2" fullinv=$1
fi
