export PATH=$PATH:.

if [ "@$2" == "@" ] then
	echo Missing the second parameter: mx 	
else
	proc_langs/linux/config/getConfig.bat $2

	if [ ! -f $CTRL.mst ]
	then
	   mkdir -p $CTRL_PATH
	   $MX null count=0 create=$CTRL now
	fi
	$MX $CTRL fst=@proc_langs/fst/control.fst fullinv=$CTRL

	$MX "seq=$1 " lw=9000 "pft=if p(v1) then 'call proc_langs/linux/GeraTextLangsDB.bat ',v1,x1,v2,x1,'$3'/ fi" now >temp/GeraTextLangsDB.bat

	chmod +x temp/GeraTextLangsDB.bat
	temp/GeraTextLangsDB.bat
fi



