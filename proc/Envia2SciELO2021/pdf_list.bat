export PATH=$PATH:.

rem Envia2SciELO2021/pdf_list
rem Parametro 1: temp path
rem Parametro 2: caminho da pasta bases/pdf
rem Parametro 3: somente nome do arquivo da lista de pdfs

rem Inicializa variaveis
TMP_PATH=$1
BASES_PDF_PATH=$2
PDF_LIST_NAME=$3

call Envia2SciELO2021/InformaLog.bat ${INFORMALOG} $0 "FINISHED"
LOGFILE=${TMP_PATH}/log_pdfs_list.log

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${TMP_PATH} "temp path"
call batch/VerifPresencaParametro.bat $0 @${BASES_PDF_PATH} "caminho da pasta bases/pdf"
call batch/VerifPresencaParametro.bat $0 @${PDF_LIST_NAME} "somente nome do arquivo da lista de pdfs"


rem Generates PDF list
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Generates PDF list ${TMP_PATH}/${PDF_LIST_NAME}"

find ${BASES_PDF_PATH} -name "*.pdf" > ${TMP_PATH}/${PDF_LIST_NAME}

rem Transfer
call Envia2SciELO2021/transf.bat ${LOGFILE} ${TMP_PATH} ${PDF_LIST_NAME} bin

rem Delete pids_list.*
call batch/DeletaArquivo.bat ${TMP_PATH}/${PDF_LIST_NAME}
call batch/DeletaArquivo.bat ${TMP_PATH}/${PDF_LIST_NAME}.tgz

rem Register errors
call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"

