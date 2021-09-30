export PATH=$PATH:.
export CIPAR=tabs/GIGA032.cip

rem Envia2SciELO2021/main_generate_and_transfer_pdfs_list
rem Parametro 1: bases/pdf path

rem Inicializa variaveis
BASES_PDF_PATH=$1

rem Inicializa variaveis
TMP_PATH=temp/Envia2SciELO2021
LOGFILE=${TMP_PATH}/log_main_generate_and_transfer_pdfs_list.log
export INFORMALOG=${TMP_PATH}/log_errors.log
export TIME_LOG=${TMP_PATH}/time_`date '+%d'`_pdfs_list.log

PDF_LIST=pdfs_list.txt

echo > ${TIME_LOG}

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${BASES_PDF_PATH} "bases/pdf path"


rem Create tmp dir
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Create ${TMP_PATH}"
call batch/CriaDiretorio.bat ${TMP_PATH}


rem Generate and transfer pdfs list
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer ${PDF_LIST}"
nohup Envia2SciELO2021/pdf_list.bat ${TMP_PATH} ${BASES_PDF_PATH} ${PDF_LIST} > ${TMP_PATH}/nohup.pdfs_list.out&
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.pdfs_list.out"


call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
