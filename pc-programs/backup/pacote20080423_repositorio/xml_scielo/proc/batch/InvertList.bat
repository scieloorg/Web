rem usa wxis

set INFORMALOG=%LOG%

call batch\Seq2Master.bat %CONFIG%.seq space %CONFIG%

call batch\Seq2Master.bat %JOURNALS%.seq space %JOURNALS%

call batch\GeraInvertido.bat %CONFIG% %CONFIG%.fst %CONFIG%

call batch\GeraInvertido.bat %JOURNALS% %JOURNALS%.fst %JOURNALS%

call batch\GeraInvertido.bat %TITLE% fst\title.fst %TEMP_TITLE%

call batch\ListBasesPubInv.bat

rem usa wXis
rem echo Cria a lista de arquivos para FTP
rem call batch\ListFtp.bat