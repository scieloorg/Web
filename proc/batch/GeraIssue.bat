rem export PATH=$PATH:.
rem GeraIssue
rem Parametro 1: path producao SciELO
rem Parametro 2: sigla da revista
rem Parametro 3: volume-numero do issue
rem Parametro 4: acao - se for "del" eh para deletar, se ausente eh caso normal

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO
call batch/VerifPresencaParametro.bat $0 @$2 sigla da revista
call batch/VerifPresencaParametro.bat $0 @$3 volume-numero do issue

call batch/CriaDiretorio.bat ../bases-work/$2
export REVISTA=../bases-work/$2/$2
call batch/CriaDiretorio.bat ../bases-work/$2/$3
export ISSUE=../bases-work/$2/$3/$3
PATH_P=../bases-work/artigo/p

call batch/InformaLog.bat $0 x Gera Issue: $2 $3

rem Este mx eh soh para evitar o erro do mx bool se o master estiver vazio
echo $3> temp/vol-num.txt
$CISIS_DIR/mx tmp count=1 "proc='a4~',cat('temp/vol-num.txt'),'~','a1004~',date,'~'" append=$REVISTA now -all
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 Gambiarra...

call batch/InformaLog.bat $0 x Re-inverte  $REVISTA
call batch/GeraInvertido.bat $REVISTA fst/Fasciculo.fst $REVISTA


call batch/InformaLog.bat $0 x Retirada de paragrafos de $2
$CISIS_DIR/mx $REVISTA btell=0 "a$" lw=9999 "pft='call batch/CreateBaseP.bat ',v880,' $CISIS_DIR/mx $REVISTA $PATH_P/',v880*1.9,'/',v880*10.4,'/',v880*14.4,' ',v880*18,/ fi" now > temp.sh
call temp.sh
call batch/InformaLog.bat $0 x Fim Retirada de paragrafos de $2


call batch/InformaLog.bat $0 x Deleta issue antigo: $2 $3
$CISIS_DIR/mx $REVISTA "bool=$3" "proc='d.'" now -all append=$REVISTA.tmp
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $REVISTA bool:$3 proc:'d.'

call batch/InformaLog.bat $0 x $REVISTA.tmp para $REVISTA
$CISIS_DIR/mx $REVISTA.tmp create=$REVISTA now -all
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $REVISTA bool:$3 proc:'d.'



if [ ! "$4" == "del" ]
then
	rem 1
    call batch/InformaLog.bat $0 x Gera $2 $3 de serial para bases-work
	$CISIS_DIR/mx $1/serial/$2/$3/base/$3 gizmo=gizmo/gizmoHTML create=$ISSUE now -all
	batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1/serial/$2/$3/base/$3 gizmo:gizmo/gizmoHTML create:$ISSUE

	rem 2
    call batch/InformaLog.bat $0 x Inverte usando fst/auxcria799.fst
	call batch/GeraInvertido.bat $ISSUE fst/auxcria799.fst $ISSUE

	rem 3
    call batch/InformaLog.bat $0 x Aplica procs em bases-work $2 $3 e faz append em $2
	$CISIS_DIR/mx $ISSUE proc=@prc/cria799.prc proc=@prc/cria936.prc "proc='a9999{$REVISTA{'" proc=@prc/criaPID.prc copy=$ISSUE now -all
	batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $ISSUE proc:@prc/cria799.prc proc:@prc/cria936.prc proc:@prc/criaPID.prc copy=$ISSUE 

    $CISIS_DIR/mx $ISSUE proc=@prc/cria799.prc proc=@prc/cria936.prc "proc='a9999{$REVISTA{'" proc=@prc/criaPID.prc copy=$ISSUE now -all

    call batch/InformaLog.bat $0 x Retirada de paragrafos de $2 $3
    $CISIS_DIR/mx $ISSUE btell=0 "a$" lw=9999 "pft='call batch/CreateBaseP.bat ',v2,' $CISIS_DIR/mx $ISSUE $PATH_P/',v880*1.9,'/',v880*10.4,'/',v880*14.4,' ',v880*18,/ fi" now > temp.sh
    call temp.sh
    call batch/InformaLog.bat $0 x Fim Retirada de paragrafos de $2 $3

    call batch/InformaLog.bat $0 x Adiciona issue $3 na base $2
    $CISIS_DIR/mx $ISSUE append=$REVISTA now -all
    batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $ISSUE append:$REVISTA

    call batch/InformaLog.bat $0 x GeraIso $2 $3 
    call batch/GeraIso.bat $1/serial/$2/$3/base/$3 $1/serial/$2/$3/base/$2$3.iso
fi

call batch/InformaLog.bat $0 x Re-inverte  $REVISTA
call batch/GeraInvertido.bat $REVISTA fst/Fasciculo.fst $REVISTA
