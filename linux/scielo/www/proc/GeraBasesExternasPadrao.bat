export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem          GeraBasesExternas.bat ../bases log/GeraBasesExternasPadrao.bat adiciona
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo Este arquivo executara: 
echo
echo   GeraBasesExternas.bat .. log/GeraBasesExternasPadrao.bat adiciona
echo
echo utilizando como parametros ../bases /home/scielo/www/bases log/AtualizaPadrao.log adiciona
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

read pause

call GeraBasesExternas.bat ../bases log/GeraBasesExternasPadrao.log adiciona
