export PATH=$PATH:.
export TABS=tabs
rem Este arquivo eh uma chamada para: 
rem Preparação da sincronização dos dados para o Kernel
rem GeraScielo.bat com parametros STANDARD


clear
echo === ATENCAO ===
echo 
echo Este arquivo executara os seguintes comandos
echo "nohup ./CallPrepSyncToKernel.bat > /tmp/CallPrepSyncToKernel.out&"
echo GeraScielo.bat .. /scielo/web log/GeraPadrao.log adiciona
echo "nohup ./CallTriggerSyncIsisToKernel.bat > /tmp/CallTriggerSyncIsisToKernel.out&"
echo 

GERAPADRAO_ID=$(date "+%Y-%m-%d-%H%M%s")
nohup ./CallPrepSyncToKernel.bat ${GERAPADRAO_ID} > /tmp/CallPrepSyncToKernel.out 2>&1 &

./PrepSyncToKernelCpBases.bat
nohup ./CallTriggerSyncIsisToKernel.bat  ${GERAPADRAO_ID} > /tmp/CallTriggerSyncIsisToKernel.out 2>&1 &

GeraScielo.bat .. .. log/GeraPadrao.log adiciona

#nohup ./CallTriggerSyncIsisToKernel.bat  ${GERAPADRAO_ID} > /tmp/CallTriggerSyncIsisToKernel.out 2>&1 &
#nohup ./CallGeraUriList.bat  ${GERAPADRAO_ID} > /tmp/CallGeraUriList.out 2>&1 &
