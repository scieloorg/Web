export PATH=$PATH:.
export TABS=tabs
rem Este arquivo ?uma chamada para o 
rem PreGeraScielo.bat com par?etros STANDARD

clear
echo === ATENCAO ===
echo 
echo Este arquivo executara o seguinte comando
echo PreGeraScielo.bat .. /scielo/web log/PreGeraPadrao.log adiciona
echo 
echo Tecle CONTROL-C para sair ou ENTER para continuar...

PreGeraScielo.bat .. .. log/PreGeraPadrao.log adiciona
