export PATH=$PATH:.

rem Envia2SciELO2021/generate_issues
rem Parametro 1: temp path
rem Parametro 2: bases-work path
rem Parametro 3: scilista

rem Inicializa variaveis
TMP_PATH=$1
BASES_WORK_PATH=$2
SCILISTA_TO_TRANSFER=$3

rem Inicializa variaveis
LOGFILE=${TMP_PATH}/log_generate_issues.log

CISIS_DIR=cisis

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9


rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${TMP_PATH} "temp path"
call batch/VerifPresencaParametro.bat $0 @${BASES_WORK_PATH} "bases-work path"
call batch/VerifPresencaParametro.bat $0 @${SCILISTA_TO_TRANSFER} "scilista"

call batch/VerifExisteArquivo.bat ${TMP_PATH}/${SCILISTA_TO_TRANSFER}

rem Generate and transfer scilista
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer scilista"
call Envia2SciELO2021/transf.bat ${LOGFILE} ${TMP_PATH} ${SCILISTA_TO_TRANSFER} bin


rem Generate and transfer issues in scilista
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer issues present in scilista"
${CISIS_DIR}/mx "seq=${TMP_PATH}/${SCILISTA_TO_TRANSFER}" lw=9999 "pft=if p(v1) and not v1:' del' then 'call Envia2SciELO2021/generate_issue.bat ${TMP_PATH} ${BASES_WORK_PATH} ',v1/ fi" now > ${TMP_PATH}/call_generate_issues.bat
chmod +x ${TMP_PATH}/call_generate_issues.bat
call ${TMP_PATH}/call_generate_issues.bat

rem Delete SCILISTA_TO_TRANSFER
call batch/DeletaArquivo.bat ${TMP_PATH}/${SCILISTA_TO_TRANSFER}


call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
