
set LANG_DB=%LANG_DATABASE_PATH%\lang\lang
set LANG_DB_OLD=%LANG_DATABASE_PATH%\lang\replaced_lang

if not exist %LANG_DB%.mst mkdir %LANG_DATABASE_PATH%\lang\
if not exist %LANG_DB%.mst %MX% null count=0 create=%LANG_DB% now 
%MX% %LANG_DB% fst=@proc_langs\fst\lang.fst fullinv=%LANG_DB% 

if not exist %LANG_DB_OLD%.mst mkdir %LANG_DATABASE_PATH%\lang\
if not exist %LANG_DB_OLD%.mst %MX% null count=0 create=%LANG_DB_OLD% now 
%MX% %LANG_DB_OLD% fst=@proc_langs\fst\lang.fst fullinv=%LANG_DB_OLD% 


%WXIS% IsisScript=proc_langs\core\identifyLangs.xis def=proc_langs\config\app.def acron=%1 issue=%2 debug=%3 LANG_DB=%LANG_DB% LANG_DB_OLD=%LANG_DB_OLD% reinvert=temp\%1.bat

%MX% %CTRL% fst=@proc_langs\fst\control.fst fullinv=%CTRL% 
%MX% %LANG_DB% fst=@proc_langs\fst\lang.fst fullinv=%LANG_DB%
%MX% %LANG_DB_OLD% fst=@proc_langs\fst\lang.fst fullinv=%LANG_DB_OLD% 