rem Este arquivo eh uma chamada para o 
rem rem DOI_CreateDB.bat com parametros STANDARD

echo === ATENCAO ===
echo 
echo Este arquivo executara o seguinte comando
echo DOI_CreateDB.bat $1 $2 $3 $4
echo 
echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

rem DOI_CreateDB
rem Parametro 1: base com registros bibliograficos ou prefixo doi
rem Parametro 2: base doi
rem Parametro 3: base guia
rem Parametro 4: chave dos registros
rem Parametro 5: pacote ou individual ou no_query
rem Parametro 6: sigla_issue
rem Parametro 7: user
rem Parametro 8: password
rem Parametro 9: email


rem Inicializa variaveis
export PATH=$PATH:.:../bases/artigo/
export CISIS_DIR=cisis
export INFORMALOG=log/DOI_CreateDB.log

PROCESS_DATE=`date +%Y%m%d%H%M%S`

echo Execution begin of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 in  `date`
rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 base com registros bibliograficos ou prefixo doi
call batch/VerifPresencaParametro.bat $0 @$2 base doi
call batch/VerifPresencaParametro.bat $0 @$3 base guia
call batch/VerifPresencaParametro.bat $0 @$4 chave dos registros

call batch/VerifPresencaParametro.bat $0 @$5 pacote ou individual ou no_query
call batch/VerifPresencaParametro.bat $0 @$6 sigla_issue

call batch/VerifPresencaParametro.bat $0 @$7 user
call batch/VerifPresencaParametro.bat $0 @$8 password
call batch/VerifPresencaParametro.bat $0 @$9 email


export EMAIL=$9
export USER=$7
export PASS=$8
export PREFIXO=$1



if [  -f "$3.xrf" ]
then

	if [ -f "$2.xrf" ]
	then
		echo do nothing
		call batch/CriaMaster.bat $2
	else
		   echo "creating/reseting base doi: $2"
		   call batch/CriaMaster.bat $2
	fi
	
	cisis/mx $2 fst=@doi/fst/doi.fst fullinv=$2

	if [ "$5" == "no_query" ] 
	then
		rem $3 pode ser qualquer base desde que tenha v880 e seja pid de artigo
		cisis/mx $3 btell=0 "bool=$4" lw=9999 "pft=if size(v880)=23 and ( l(['$2'],v880)=0 or (l(['$2'],v880)>0 and ref(['$2']l(['$2'],v880),v2^*)<>'doi')) then 'call doi/create_update/CreateOrUpdate.bat $2 ',v880,' $PREFIXO/',v880,' doi $3^s',v30,'^d',v10,' ',if l(['$2'],v880)>0 then 'copy' else 'append' fi,/ fi" now > temp/doi/proc/current/CreateOrUpdate.bat

		chmod 770 temp/doi/proc/current/CreateOrUpdate.bat
		call temp/doi/proc/current/CreateOrUpdate.bat
	else
		if [  -f "$1.xrf" ]
		then
			call batch/CriaDiretorio.bat temp/doi/xml

			rm temp/doi/proc/current/pid_list.txt
			cisis/mx $3 btell=0 "bool=$4" "pft=if l(['$2'],v880)=0 then v880/ else if ref(['$2']l(['$2'],v880),v2^*)<>'doi' then v880/  fi, fi" now > temp/doi/proc/current/pid_list.txt

			if [ "$5" = "pacote" ]
			then
				rem O pacote tem que ser enviado a cada 10 registros, pois ha um limite de tamanho do XML de cerca de 5 MB 
				cp temp/doi/proc/current/pid_list.txt temp/doi/proc/current/pid_list_parte2.txt
				variavel="valor"
				while [ $variavel = "valor" ]; do

					cisis/mx seq=temp/doi/proc/current/pid_list_parte2.txt create=temp/doi/proc/current/pid_list_dividir now -all

					cisis/mx temp/doi/proc/current/pid_list_dividir count=10 "pft=v1/" now> temp/doi/proc/current/pid_list_parte1.txt

					cisis/mx temp/doi/proc/current/pid_list_dividir from=11 "pft=v1/" now> temp/doi/proc/current/pid_list_parte2.txt
					
					if grep -q "S" temp/doi/proc/current/pid_list_parte2.txt
					then
						echo ...
					else
						variavel="stop"
					fi

					echo Execute for
					more temp/doi/proc/current/pid_list_parte1.txt
					
					doi/create_update/SubmitQueryAndReceiveResult.bat $6 $PROCESS_DATE temp/doi/xml $2 $1 $EMAIL $USER $PASS temp/doi/proc/current/pid_list_parte1.txt
				done

			else

				cisis/mx seq=temp/doi/proc/current/pid_list.txt lw=99999 "pft='echo ',v1,' > temp/doi/proc/current/pid_list2.txt'/,'doi/create_update/SubmitQueryAndReceiveResult.bat $6_',v1*18.5,' $PROCESS_DATE temp/doi/xml $2 $1 $EMAIL $USER $PASS temp/doi/proc/current/pid_list2.txt'/, " now > temp/doi/proc/current/executeIndividual.bat
				chmod 770 temp/doi/proc/current/executeIndividual.bat
				call temp/doi/proc/current/executeIndividual.bat
			fi

		else
			echo Missing $1.xrf
		fi
	fi

	echo Inverte a base DOI
	cisis/mx $2 fst=@doi/fst/doi.fst fullinv=$2
else
	echo Missing guide database $3.xrf
fi

echo Execution end of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 in  `date`
