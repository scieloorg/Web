export PATH=$PATH:.

export ano=`date +%Y`
export mes=`date +%b%d%y|cut -c1-3`
export dia=`date +%b%d%y|cut -c4-5`
export hora=`date +%H` 
export min=`date +%M`  
export seg=`date +%S`  

export WRK=$1/bases/accesslog/log_scielo/work
 
rem  ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem   
rem Envia2LogAcesso
rem Parametro 1: path da producao da SciELO
rem Parametro 2: arquivo com instrucoes de FTP
rem Parametro 3: arquivo de log

rem Inicializa variaveis

export INFORMALOG=log/Envia2LogAcesso.log
export CISIS_DIR=/home/scielo_prod/www/proc/cisis

rem  Verifica parametros

 call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO
 call batch/VerifPresencaParametro.bat $0 @$2 arquivo com instrucoes de FTP
 call batch/VerifExisteArquivo.bat $2
 call batch/VerifPresencaParametro.bat $0 @$3 arquivo de LOG
 
 call batch/InformaLog.bat $0 dh ===Inicio===
 
 call batch/CriaDiretorio.bat temp/transf2logacesso
 
 cd $1/www/proc 

if [ -d $1/bases/accesslog/log_scielo/ ]
    then
	rm lista.seq
	rm lista2.seq
	rm prog01.sh
	rm prog02.sh
	find $1/bases/accesslog/log_scielo/*.txt | cut -d "." -f "1" > lista.seq
	$CISIS_DIR/mx seq=lista.seq lw=999 "pft='basename ',v1,' >> lista2.seq',#"  -all now > prog01.sh
	chmod 777 prog01.sh
	./prog01.sh
	$CISIS_DIR/mx seq=lista2.seq lw=999 "pft='mv $1/bases/accesslog/log_scielo/',v1,'.txt $1/proc/temp/transf2logacesso/',v1,'$hora$min$seg','.txt'/" -all now > prog02.sh
	chmod 777 prog02.sh
	./prog02.sh      

	head -3 $2                              >  temp/ENVIA2ACESSOFTP.txt
	echo "lcd temp/transf2logacesso"        >> temp/ENVIA2ACESSOFTP.txt
	echo "cd log_acesso"                    >> temp/ENVIA2ACESSOFTP.txt
	echo "mput *.txt"                       >> temp/ENVIA2ACESSOFTP.txt
	echo "close"                            >> temp/ENVIA2ACESSOFTP.txt
	echo "bye"                              >> temp/ENVIA2ACESSOFTP.txt

	ftp -i -v -n < temp/ENVIA2ACESSOFTP.txt >> $INFORMALOG
 
	call batch/CriaDiretorio.bat $WRK/$ano$mes$dia$hora$min
	
	mv temp/transf2logacesso/*.txt $WRK/$ano$mes$dia$hora$min	

	call batch/ifErrorLevel.bat $? call batch/AchouErro.bat $0 ftp: $2

	call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG
fi
