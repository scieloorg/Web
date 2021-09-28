export PATH=$PATH:.
export CIPAR=tabs/GIGA032.cip

rem Envia2SciELO2021/main_generate_and_transfer_bases_work_acrons
rem Parametro 1: bases-work path

rem Inicializa variaveis
BASES_WORK_PATH=$1

rem Inicializa variaveis
TMP_PATH=temp/Envia2SciELO2021
LOGFILE=${TMP_PATH}/log_main_generate_and_transfer_bases_work_acrons.log
export TIME_LOG=${TMP_PATH}/time_`date '+%d'`_acrons.log


echo > ${TIME_LOG}

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${BASES_WORK_PATH} "bases-work path"


call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Create ${TMP_PATH}"
call batch/CriaDiretorio.bat ${TMP_PATH}


rem Generate and transfer acrons
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer acrons"
nohup Envia2SciELO2021/generate_acrons.bat ${TMP_PATH} ${BASES_WORK_PATH} > ${TMP_PATH}/nohup.acrons.out&
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.acrons.out"


call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
