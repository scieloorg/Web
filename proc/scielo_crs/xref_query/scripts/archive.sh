
PATH_XML=$1
DIRS=$2
FILENAME=$3

if [ ! -d $PATH_XML/archived/$DIRS ]
then
	mkdir -p $PATH_XML/archived/$DIRS
fi
if [ -d $PATH_XML/archived/$DIRS ]
then
	if [ -f $PATH_XML/sent/$DIRS/$FILENAME ]
	then
		mv $PATH_XML/sent/$DIRS/$FILENAME 	$PATH_XML/archived/$DIRS/
	fi
fi
