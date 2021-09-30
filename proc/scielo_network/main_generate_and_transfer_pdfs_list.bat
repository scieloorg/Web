export PATH=$PATH:.
export CIPAR=tabs/GIGA032.cip

rem scielo_network/main_generate_and_transfer_pdfs_list
rem Parametro 1: bases/pdf path

rem Inicializa variaveis
BASES_PDF_PATH=$1

rem Inicializa variaveis
TMP_PATH=temp/scielo_network
LOGFILE=${TMP_PATH}/log_main_generate_and_transfer_pdfs_list.log
export INFORMALOG=${TMP_PATH}/log_errors.log
export TIME_LOG=${TMP_PATH}/scielo_network_time_`date '+%d'`_pdfs_list.log

PDF_LIST=scielo_network_pdfs_list.txt

echo > ${TIME_LOG}

call scielo_network/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call scielo_network/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${BASES_PDF_PATH} "bases/pdf path"


rem Create tmp dir
call scielo_network/InformaLog.bat ${LOGFILE} $0 "Create ${TMP_PATH}"
call batch/CriaDiretorio.bat ${TMP_PATH}


rem Generate and transfer pdfs list
call scielo_network/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer ${PDF_LIST}"
nohup scielo_network/pdf_list.bat ${TMP_PATH} ${BASES_PDF_PATH} ${PDF_LIST} > ${TMP_PATH}/nohup.pdfs_list.out&
call scielo_network/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.pdfs_list.out"


call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call scielo_network/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call scielo_network/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
