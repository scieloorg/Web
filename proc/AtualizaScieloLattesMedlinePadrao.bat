export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem          AtualizaLattesOnLine.bat
rem          AtualizaMedlineOnLine.bat
rem          AtualizaScieloOnLine.bat
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo ATUALIZACAO DO SITE WWW.SCIELO.BR
echo
echo Este arquivo executara: 
echo
echo  AtualizaLattesOnLine.bat
echo  AtualizaMedlineOnLine.bat
echo  AtualizaScieloOnLine.bat
echo
echo utilizando como parametros ../bases /home/scielo/www/bases log/AtualizaPadrao.log adiciona
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

read pause

export INFORMALOG=log/GeraScielo.log
export CISIS_DIR=cisis

call batch/ManutencaoOn.bat /home/scielo/online/bases
call AtualizaLattesOnLine.bat ../bases /home/scielo/online/bases log/AtualizaPadrao.log adiciona
call AtualizaMedlineOnLine.bat ../bases /home/scielo/online/bases log/AtualizaPadrao.log adiciona
call AtualizaScieloOnLine.bat ../bases /home/scielo/online/bases log/AtualizaPadrao.log adiciona
call batch/ManutencaoOff.bat /home/scielo/online/bases
