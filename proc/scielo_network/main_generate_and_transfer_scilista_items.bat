export PATH=$PATH:.
export CIPAR=tabs/GIGA032.cip

rem scielo_network/main_generate_and_transfer_scilista_items
rem Parametro 1: bases-work path
rem Parametro 2: scilista

rem Inicializa variaveis
BASES_WORK_PATH=$1
SCILISTA=$2

rem Inicializa variaveis
TMP_PATH=temp/scielo_network
LOGFILE=${TMP_PATH}/log_main_generate_and_transfer_scilista_items.log
export INFORMALOG=${TMP_PATH}/log_errors.log
export TIME_LOG=${TMP_PATH}/scielo_network_time_`date '+%d'`_scilista_items.log

PDF_LIST=pdfs_list.txt

echo > ${TIME_LOG}

call scielo_network/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call scielo_network/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${BASES_WORK_PATH} "bases-work path"
call batch/VerifPresencaParametro.bat $0 @${SCILISTA} "scilista"

call batch/VerifExisteArquivo.bat ${SCILISTA}

rem Create tmp dir
call scielo_network/InformaLog.bat ${LOGFILE} $0 "Create ${TMP_PATH}"
call batch/CriaDiretorio.bat ${TMP_PATH}

rem Generate and transfer issues
SCILISTA_TO_TRANSFER=scilista_`date '+%Y%m%d-%H%M%S'`.txt
cp ${SCILISTA} ${TMP_PATH}/${SCILISTA_TO_TRANSFER}
call scielo_network/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer issues"
nohup scielo_network/generate_issues.bat ${TMP_PATH} ${BASES_WORK_PATH} ${SCILISTA_TO_TRANSFER} > ${TMP_PATH}/nohup.issues.out&
call scielo_network/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.issues.out"

call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call scielo_network/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call scielo_network/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
