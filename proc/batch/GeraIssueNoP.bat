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
SERIAL_COUCH=../serial_couch


call batch/InformaLog.bat $0 x Gera Issue: $2 $3


call batch/InformaLog.bat $0 x Re-inverte  $REVISTA
rem Este mx eh soh para evitar o erro do mx bool se o master estiver vazio
$CISIS_DIR/mx null count=1 "proc='a4~','$3','~'" append=$REVISTA now -all

call batch/GeraInvertido.bat $REVISTA fst/nop_Fasciculo.fst $REVISTA


echo $REVISTA >> log/NUMEROS
$CISIS_DIR/mx $REVISTA delete count=0 now >> log/NUMEROS
$CISIS_DIR/mx $REVISTA p$ count=0 now >> log/NUMEROS

call batch/InformaLog.bat $0 x Deleta issue antigo: $2 $3
$CISIS_DIR/mx $REVISTA "bool=$3 or delete" "proc='d*'" now -all copy=$REVISTA
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $REVISTA bool:$3 proc:'d.'

call batch/InformaLog.bat $0 x Retirada de paragrafos de $2
$CISIS_DIR/mx $REVISTA btell=0 "a$" lw=9999 "pft=if p(v880) then 'call batch/CreateBaseP.bat ',v880,' $CISIS_DIR/mx $REVISTA $PATH_P/',v880*1.9,'/',v880*10.4,'/',v880*14.4,' ',v880*18,/ fi" now |sort -u > temp1.sh
call temp1.sh
call batch/InformaLog.bat $0 x Fim Retirada de paragrafos de $2

call batch/InformaLog.bat $0 x Remove os registros apagados
rem Este mx eh soh para evitar o erro do mx bool se o master estiver vazio
$CISIS_DIR/mx null count=0 create=$REVISTA.tmp now -all
$CISIS_DIR/mx $REVISTA append=$REVISTA.tmp now -all





if [ ! "$4" == "del" ]
then
   rem 1
   call batch/InformaLog.bat $0 x Gera $2 $3 serial para bases-work
   $CISIS_DIR/mx $1/serial/$2/$3/base/$3 gizmo=gizmo/gizmoHTML  "proc=|d3a3{|v2|{|" create=$ISSUE now -all
   batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1/serial/$2/$3/base/$3 gizmo:gizmo/gizmoHTML create:$ISSUE

   rem 2
   call batch/InformaLog.bat $0 x Inverte usando fst/nop_auxcria799.fst
   call batch/GeraInvertido.bat $ISSUE fst/nop_auxcria799.fst $ISSUE



   rem 3
   call batch/InformaLog.bat $0 x Aplica procs em bases-work $2 $3 e faz append em $2
   $CISIS_DIR/mx $ISSUE proc=@prc/nop_cria799.prc proc=@prc/nop_cria936.prc "proc='d9999a9999{$REVISTA{'" proc=@prc/nop_criaPID.prc copy=$ISSUE now -all
   batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $ISSUE proc:@prc/nop_cria799.prc proc:@prc/nop_cria936.prc proc:@prc/nop_criaPID.prc copy=$ISSUE

    call batch/InformaLog.bat $0 x Retirada de paragrafos de $2 $3
    $CISIS_DIR/mx $ISSUE btell=0 "a$" lw=9999 "pft=if p(v880) then 'call batch/CreateBaseP.bat ',v3,' $CISIS_DIR/mx $ISSUE $PATH_P/',v880*1.9,'/',v880*10.4,'/',v880*14.4,' ',v880*18,/ fi" now |sort -u> temp2.sh
    call temp2.sh
    call batch/InformaLog.bat $0 x Fim Retirada de paragrafos de $2 $3

    if [ -d $SERIAL_COUCH ]
    then
        call batch/InformaLog.bat $0 x Copiar $ISSUE para Couch
        call batch/CriaDiretorio.bat $SERIAL_COUCH/$2
        cp $ISSUE.* $SERIAL_COUCH/$2
    fi

    call batch/InformaLog.bat $0 x Adiciona issue $3 na base $2
    $CISIS_DIR/mx $ISSUE append=$REVISTA.tmp now -all
    batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $ISSUE append:$REVISTA

    call batch/InformaLog.bat $0 x GeraIso $2 $3 
    call batch/GeraIso.bat $1/serial/$2/$3/base/$3 $1/serial/$2/$3/base/$2$3.iso
fi

call batch/InformaLog.bat $0 x $REVISTA.tmp para $REVISTA
$CISIS_DIR/mx $REVISTA.tmp create=$REVISTA now -all
rm -r $REVISTA.tmp.*

call batch/InformaLog.bat $0 x Re-inverte  $REVISTA
call batch/GeraInvertido.bat $REVISTA fst/nop_Fasciculo.fst $REVISTA

$CISIS_DIR/mx $REVISTA delete count=0 now >> log/NUMEROS
$CISIS_DIR/mx $REVISTA p$ count=0 now >> log/NUMEROS

