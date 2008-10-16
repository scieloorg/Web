if "@%2" == "@" goto ERROR

set PATH=%PATH%;.

call proc_langs\win\config\getConfig.bat %2

%MX% %TITLE% lw=9000 "pft=if v50='C' then v68,x1,'$'/ fi" now > %1
goto END


:ERROR
echo Missing the second parameter: mx 	

:END

