export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem Envia2Medline
rem Parametro 1: path da producao da SciELO
rem Parametro 2: arquivo com instrucoes de FTP
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona

rem Parametro 5: identificacao do repositorio na base [opcional]
rem Parametro 6: acronimo do repositorio [obrigatorio quando existe 5]


rem Inicializa variaveis
export INFORMALOG=log/Envia2Medline.log
export CISIS_DIR=cisis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO
call batch/VerifPresencaParametro.bat $0 @$2 arquivo com instrucoes de FTP
call batch/VerifExisteArquivo.bat $2
call batch/VerifPresencaParametro.bat $0 @$3 arquivo de LOG
call batch/VerifPresencaParametro.bat $0 @$4 opcao do LOG: cria/adiciona

if [ "$4" == "cria" ]
then
   call batch/DeletaArquivo.bat $3
fi
export INFORMALOG=$3

call batch/InformaLog.bat $0 dh ===Inicio===

call batch/CriaDiretorio.bat temp/transf2medline

if [ "@$5" == "@" ]
then
	call batch/GeraIso.bat $1/bases/issue/issue temp/transf2medline/issue.iso
	call batch/GeraIso.bat $1/bases/title/title temp/transf2medline/title.iso
	call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=i temp/transf2medline/issues.iso

	call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=h temp/transf2medline/artigo.iso
	call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=c temp/transf2medline/bib4cit.iso prc/bib4cit.prc

	rem REPOSITORIO INICIO
	if [ -f repo/Envia2MedlineRepositorio.bat ]
	then 
		call batch/GeraInvertido.bat $1/bases/artigo/artigo repo/title_issue.fst temp/transf2medline/artigo

		$CISIS_DIR/mx null count=0 create=temp/transf2medline/title
		$CISIS_DIR/mx $1/bases/title/title "proc=if v50='C' and l(['temp/transf2medline/artigo'],'TI='v400)>0 then else 'd*' fi" append=temp/transf2medline/title now -all	
		call batch/GeraIso.bat temp/transf2medline/title temp/transf2medline/title.iso

		$CISIS_DIR/mx null count=0 create=temp/transf2medline/issue
		$CISIS_DIR/mx $1/bases/issue/issue "proc=if l(['temp/transf2medline/artigo'],'IS='v35,v36*0.4,s(f(val(v36*4)+10000,2,0))*1.4)>0 then else 'd*' fi" append=temp/transf2medline/issue now -all	
		call batch/GeraIso.bat temp/transf2medline/issue temp/transf2medline/issues.iso

		call repo/Envia2MedlineRepositorio.bat $1 $2 $3 $4
	fi
	rem REPOSITORIO FIM
else
	call batch/CriaDiretorio.bat temp/transf2medline/$6
	call batch/GeraIsoBool.bat $1/bases/artigo/artigo "REP=$5" temp/transf2medline/$6/artigo.iso
	call batch/GeraIsoBool.bat $1/bases/artigo/artigo "C_REP=$5" temp/transf2medline/$6/bib4cit.iso prc/bib4cit.prc

	call batch/Iso2Master.bat temp/transf2medline/$6/artigo.iso temp/transf2medline/$6/artigo
	call batch/GeraInvertido.bat temp/transf2medline/$6/artigo repo/title_issue.fst temp/transf2medline/$6/artigo

	
	$CISIS_DIR/mx null count=0 create=temp/transf2medline/$6/title
	$CISIS_DIR/mx $1/bases/title/title "pft=if v50='C' and l(['temp/transf2medline/$6/artigo'],'TI='v400)>0 then f(mfn,1,0)/ else ''/  fi" now > temp/transf2medline/$6/title.txt
	$CISIS_DIR/mx $1/bases/title/title "proc=if v50='C' and l(['temp/transf2medline/$6/artigo'],'TI='v400)>0 then else 'd*' fi" append=temp/transf2medline/$6/title now -all	
	call batch/GeraIso.bat temp/transf2medline/$6/title temp/transf2medline/$6/title.iso

	$CISIS_DIR/mx null count=0 create=temp/transf2medline/$6/issue
	$CISIS_DIR/mx $1/bases/issue/issue "pft=if l(['temp/transf2medline/$6/artigo'],'IS='v35,v36*0.4,s(f(val(v36*4)+10000,2,0))*1.4)>0 then f(mfn,1,0)/ fi" now >>	
	$CISIS_DIR/mx $1/bases/issue/issue "proc=if l(['temp/transf2medline/$6/artigo'],'IS='v35,v36*0.4,s(f(val(v36*4)+10000,2,0))*1.4)>0 then else 'd*' fi" append=temp/transf2medline/$6/issue now -all	
	call batch/GeraIso.bat temp/transf2medline/$6/issue temp/transf2medline/$6/issues.iso
	
fi

call batch/InformaLog.bat $0 x FTP artigo e bib4cit
ftp -n <$2 >> $INFORMALOG
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: $2

call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG

