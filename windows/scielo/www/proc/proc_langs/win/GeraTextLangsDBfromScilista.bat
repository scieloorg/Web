if "@%2" == "@" goto ERROR

set PATH=%PATH%;.

call proc_langs\win\config\getConfig.bat %2

if not exist %CTRL%.mst mkdir %CTRL_PATH%
if not exist %CTRL%.mst %MX% null count=0 create=%CTRL% now 
%MX% %CTRL% fst=@proc_langs\fst\control.fst fullinv=%CTRL% 

cisis\mx "seq=%1 " lw=9000 "pft=if p(v1) then 'call proc_langs\win\GeraTextLangsDB.bat ',v1,x1,v2,x1,'%3'/ fi" now >temp\GeraTextLangsDB.bat
call temp\GeraTextLangsDB.bat

goto END


:ERROR
echo Missing the second parameter: mx 	

:END
