export PATH=$PATH:.
rem Este arquivo � uma chamada para o 
rem GeraScielo.bat com par�metros STANDARD

clear
echo === ATENCAO ===
echo 
echo Este arquivo executara o seguinte comando
echo GeraScielo.bat .. /scielo/web log/GeraPadrao.log adiciona
echo 
echo Tecle CONTROL-C para sair ou ENTER para continuar...

rem read pause

GeraScielo.bat .. .. log/GeraPadrao.log adiciona
