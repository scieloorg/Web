export PATH=$PATH:.
export CIPAR=tabs/GIGA032.cip

rem scielo_network/main_generate_and_transfer_bases_work_acrons
rem Parametro 1: bases-work path

rem Inicializa variaveis
BASES_WORK_PATH=$1

rem Inicializa variaveis
TMP_PATH=temp/scielo_network
LOGFILE=${TMP_PATH}/log_main_generate_and_transfer_bases_work_acrons.log
export INFORMALOG=${TMP_PATH}/log_errors.log
export TIME_LOG=${TMP_PATH}/scielo_network_time_`date '+%d'`_acrons.log


echo > ${TIME_LOG}

call scielo_network/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call scielo_network/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${BASES_WORK_PATH} "bases-work path"


call scielo_network/InformaLog.bat ${LOGFILE} $0 "Create ${TMP_PATH}"
call batch/CriaDiretorio.bat ${TMP_PATH}


rem Generate and transfer acrons
call scielo_network/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer acrons"
nohup scielo_network/generate_acrons.bat ${TMP_PATH} ${BASES_WORK_PATH} > ${TMP_PATH}/nohup.acrons.out&
call scielo_network/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.acrons.out"


call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call scielo_network/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call scielo_network/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
