rem ManutencaoOff
rem Parametro 1: diretorio bases do ambiente online - producao 

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 diretorio bases do ambiente de testes

call batch/VerifExisteArquivo.bat $1/control_off.def

call batch/InformaLog.bat $0 x Site LIBERADO
call batch/CopiaArquivo.bat $1/control_off.def $1/control.def
