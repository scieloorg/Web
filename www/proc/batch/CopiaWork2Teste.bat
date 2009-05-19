rem CopiaWork2Teste
rem Parametro 1: diretorio a ser lido
rem Parametro 2: diretorio a ser gravado

call batch/VerifPresencaParametro.bat $0 @$1 diretorio a ser lido
call batch/VerifPresencaParametro.bat $0 @$2 diretorio a ser gravado

call batch/CopiaDiretorio.bat $1/title $2
call batch/CopiaDiretorio.bat $1/issue $2
call batch/CopiaDiretorio.bat $1/newissue $2
call batch/CopiaDiretorio.bat $1/iah $2
call batch/CopiaDiretorio.bat $1/artigo $2

