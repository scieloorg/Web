rem export PATH=$PATH:.
rem GeraCodigoRev
rem Parametro 1: base artigo site
rem Parametro 2: base artigo work producao

call batch/VerifPresencaParametro.bat $0 @$1 base artigo site
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 base artigo work producao

call batch/InformaLog.bat $0 x Gera codigo revista: $2
echo ARTIGO.*=$2.*> temp/GeraCodigoRev.cip
$CISIS_DIR/mx cipar=temp/GeraCodigoRev.cip $1 proc=@prc/GeraCodigoRev.prc now -all create=ARTIGO
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 passo 1
