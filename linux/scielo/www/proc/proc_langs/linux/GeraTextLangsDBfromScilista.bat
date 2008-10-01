export PATH=$PATH:.

cisis/mx "seq=$1 " lw=9000 "pft=if p(v1) then 'call proc_langs/linux/GeraTextLangsDB.bat ',v1,x1,v2,x1,$2/ fi" now >temp/GeraTextLangsDB.bat

chmod +x temp/GeraTextLangsDB.bat
temp/GeraTextLangsDB.bat
