rem ManutencaoOn
rem Parametro 1: diretorio bases do ambiente online - producao 

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 diretorio bases do ambiente de testes

call batch/VerifExisteArquivo.bat $1/control_on.def

call batch/InformaLog.bat $0 x Site em MANUTENCAO
call batch/CopiaArquivo.bat $1/control_on.def $1/control.def
