export PATH=$PATH:.

rem scielo_network/generate_issue
rem Parametro 1: temp path
rem Parametro 2: bases-work path
rem Parametro 3: acron
rem Parametro 4: issue

rem Inicializa variaveis
TMP_PATH=$1
BASES_WORK_PATH=$2
ACRON=$3
ISSUE=$4

rem Inicializa variaveis
LOGFILE=${TMP_PATH}/log_generate_${ACRON}_${ISSUE}.log

CISIS_DIR=cisis
ACRON_DB=${BASES_WORK_PATH}/${ACRON}/${ACRON}
ACRON_ISSUE=${ACRON}_${ISSUE}

call scielo_network/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call scielo_network/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9


rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${TMP_PATH} "temp path"
call batch/VerifPresencaParametro.bat $0 @${BASES_WORK_PATH} "bases-work path"
call batch/VerifPresencaParametro.bat $0 @${ACRON} "acron"
call batch/VerifPresencaParametro.bat $0 @${ISSUE} "issue"

call batch/VerifExisteArquivo.bat ${ACRON_DB}.mst

rem Generate and transfer scilista issue
call scielo_network/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer ${ACRON_ISSUE} present in scilista"
${CISIS_DIR}/mx null count=0 create=${TMP_PATH}/${ACRON_ISSUE} now -all
${CISIS_DIR}/mx ${ACRON_DB} ${ISSUE} append=${TMP_PATH}/${ACRON_ISSUE} now -all
call scielo_network/id_generate.bat ${TMP_PATH} ${TMP_PATH}/${ACRON_ISSUE} ${ACRON_ISSUE}.id

call batch/DeletaArquivo.bat ${TMP_PATH}/${ACRON_ISSUE}.mst
call batch/DeletaArquivo.bat ${TMP_PATH}/${ACRON_ISSUE}.xrf

call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call scielo_network/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call scielo_network/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
