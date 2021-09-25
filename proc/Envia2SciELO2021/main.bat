export PATH=$PATH:.
export CIPAR=tabs/GIGA032.cip

rem Envia2SciELO2021/main
rem Parametro 1: bases or bases-work path
rem Parametro 2: bases/pdf path
rem Parametro 3: bases-work path
rem Parametro 4: scilista

rem Inicializa variaveis
BASES_PATH=$1
BASES_PDF_PATH=$2
BASES_WORK_PATH=$3
SCILISTA=$4

rem Inicializa variaveis
TMP_PATH=temp/Envia2SciELO2021
LOGFILE=${TMP_PATH}/log_main.log
export TIME_LOG=${TMP_PATH}/time.log

TITLE_MST=${BASES_PATH}/title/title
TITLE_ID=title_full.id

PDF_LIST=pdfs_list.txt

echo > ${TIME_LOG}

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${BASES_PATH} "bases or bases-work path"
call batch/VerifPresencaParametro.bat $0 @${BASES_PDF_PATH} "bases/pdf path"
call batch/VerifPresencaParametro.bat $0 @${BASES_WORK_PATH} "bases-work path"
call batch/VerifPresencaParametro.bat $0 @${SCILISTA} "scilista"


call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Create ${TMP_PATH}"
call batch/CriaDiretorio.bat ${TMP_PATH}

rem Generate and transfer acrons
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer acrons"
nohup Envia2SciELO2021/generate_acrons.bat ${TMP_PATH} ${BASES_WORK_PATH} > ${TMP_PATH}/nohup.acrons.out&
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.acrons.out"

rem Generate and transfer pdfs list
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer ${PDF_LIST}"
nohup Envia2SciELO2021/pdf_list.bat ${TMP_PATH} ${BASES_PDF_PATH} ${PDF_LIST} > ${TMP_PATH}/nohup.pdfs_list.out&
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.pdfs_list.out"

rem Generate and transfer title.id
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer ${TITLE_ID}"
nohup Envia2SciELO2021/id_generate.bat ${TMP_PATH} ${TITLE_MST} ${TITLE_ID} > ${TMP_PATH}/nohup.title_id.out&
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.title_id.out"

echo ${SCILISTA}
if [ -f ${SCILISTA} ]
then
    rem Generate and transfer issues
    SCILISTA_TO_TRANSFER=scilista_`date '+%Y%m%d-%H%M%S'`.txt
    cp ${SCILISTA} ${TMP_PATH}/${SCILISTA_TO_TRANSFER}
    call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer issues"
    nohup Envia2SciELO2021/generate_issues.bat ${TMP_PATH} ${BASES_WORK_PATH} ${SCILISTA_TO_TRANSFER} > ${TMP_PATH}/nohup.issues.out&
    call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.issues.out"
fi

call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
