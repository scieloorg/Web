if not exist %CTRL%.mst mkdir %CTRL_PATH%
if not exist %CTRL%.mst %MX% null count=0 create=%CTRL% now 
%MX% %CTRL% fst=@proc_langs\control.fst fullinv=%CTRL% 

%WXIS% IsisScript=proc_langs\process_texts.xis def=proc_langs\text-langs.def acron=%1 issue=%2 debug=%3 reinvert=temp\%1.bat

