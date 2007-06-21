rem GeraArtigo
rem Parametro 1: path producao Scielo

call batch\VerifPresencaParametro.bat %0 @%1 path producao SciELO

call batch\CriaDiretorio.bat ..\bases-work\artigo
call batch\CriaMaster.bat ..\bases-work\artigo\artigo

%CISIS_DIR%\mx %1\serial\title\title lw=9000 "pft=if v50='C' then 'call batch\AppendMaster.bat ..\bases-work\',v68,'\',v68,x1,'..\bases-work\artigo\artigo',x1,'prc\d1930.prc'/ fi" now >temp\GeraArtigo.bat
if errorlevel==1 batch\AchouErro.bat %0 mx %1\serial\title\title lw:9000 pft:call_GeraArtigo.bat
rem chmod 700 temp\GeraArtigo.bat
call temp\GeraArtigo.bat

call batch\GeraInvertido.bat ..\bases-work\artigo\artigo fst\artigo.fst ..\bases-work\artigo\artigo
call batch\GeraInvertido.bat ..\bases-work\artigo\artigo fst\author.fst ..\bases-work\artigo\author
