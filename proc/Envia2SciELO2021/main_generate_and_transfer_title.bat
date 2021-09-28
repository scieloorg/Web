export PATH=$PATH:.
export CIPAR=tabs/GIGA032.cip

rem Envia2SciELO2021/main_generate_and_transfer_title
rem Parametro 1: bases or bases-work path

rem Inicializa variaveis
BASES_PATH=$1

rem Inicializa variaveis
TMP_PATH=temp/Envia2SciELO2021
LOGFILE=${TMP_PATH}/log_main_generate_and_transfer_title.log
export TIME_LOG=${TMP_PATH}/time_`date '+%d'`_title.log

TITLE_MST=${BASES_PATH}/title/title
TITLE_ID=title_full.id

echo > ${TIME_LOG}

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${BASES_PATH} "bases or bases-work path"

call batch/VerifExisteArquivo.bat ${TITLE_MST}.mst
call batch/VerifExisteArquivo.bat ${TITLE_MST}.xrf

rem Create tmp dir
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Create ${TMP_PATH}"
call batch/CriaDiretorio.bat ${TMP_PATH}

rem Generate and transfer title.id
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer ${TITLE_ID}"
nohup Envia2SciELO2021/id_generate.bat ${TMP_PATH} ${TITLE_MST} ${TITLE_ID} > ${TMP_PATH}/nohup.title_id.out&
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.title_id.out"


call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
