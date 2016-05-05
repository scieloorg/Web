. crossref_config.sh

if [ "$1" = "çlkjiuy" ]
then
	rm $XREF_DB_PATH/*.* 
	if [ -d ../output/crossref/ ]
	then
		rm -rf ../output/crossref/*
	fi
	if [ -d ../databases/budget/ ]
	then
		rm -rf ../databases/budget/*
	fi
	echo reseted
else
	echo not reseted, need the password
fi

