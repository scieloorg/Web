if [ -f $2.n01 ]
then
	rm $2.n01
fi
if [ -f $2.n02 ]
then
	rm $2.n02
fi
if [ -f $2.l01 ]
then
	rm $2.l01
fi
if [ -f $2.l02 ]
then
	rm $2.l02
fi
if [ -f $2.ifp ]
then
	rm $2.ifp
fi
if [ -f $2.cnt ]
then
	rm $2.cnt
fi
if [ -f $2.iyp ]
then
	rm $2.iyp
fi
if [ -f $2.ly1 ]
then
	rm $2.ly1
fi
if [ -f $2.ly2 ]
then
	rm $2.ly2
fi

# echo $0 $1 $2 $3 $4
if [ "@$4" == "@" ]
then
	# echo $1 $2 fst=@$3 fullinv=$2
	$1 $2 fst=@$3 fullinv=$2
else
	# echo $1 cipar=$4 $2 fst=@$3 fullinv=$2
	$1 cipar=$4 $2 fst=@$3 fullinv=$2
fi

