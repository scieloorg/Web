export PATH=$PATH:.
if [ "@$2" == "@" ] then
	echo Missing the second parameter: mx 	
else
	proc_langs/linux/config/getConfig.bat $2
	$MX $TITLE lw=9000 "pft=if v50='C' then v68,x1,'$'/ fi" now > $1
fi
