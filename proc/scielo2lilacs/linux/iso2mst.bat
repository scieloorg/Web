# if [ -f $1.mst ]
# then
#	echo 
#else
	# echo $0 $1
	if [ -f $1.iso ]
	then
		$2 iso=$1.iso create=$1 now -all
		if [ "@$3" == "@" ]
		then
			echo
		else
			scielo2lilacs/linux/invert.bat $2 $1 $3
		fi
	fi
#fi