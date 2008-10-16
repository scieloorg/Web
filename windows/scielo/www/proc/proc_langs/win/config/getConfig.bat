set my_mx=%1
%my_mx% seq=proc_langs\config\app.def lw=9999 "pft=if p(v1) or size(v1)>0 then 'set ',replace(v1,'/','\') fi,#" now > temp\proc_langs_config.bat

call temp\proc_langs_config.bat
