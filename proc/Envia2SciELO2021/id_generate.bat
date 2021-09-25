export PATH=$PATH:.

rem Envia2SciELO2021/id_generate
rem Parametro 1: temp path
rem Parametro 2: isis database file without extension
rem Parametro 3: id filename

rem Inicializa variaveis
TMP_PATH=$1
MST=$2
ID_FILE=$3

LOGFILE=${TMP_PATH}/log_${ID_FILE}.log
CISIS_DIR=cisis

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${TMP_PATH} "temp path"
call batch/VerifPresencaParametro.bat $0 @${MST} "isis database file without extension"
call batch/VerifPresencaParametro.bat $0 @${ID_FILE} "id filename"

call batch/VerifExisteArquivo.bat ${MST}.mst


rem Generate id file
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Create ${ID_FILE}"
${CISIS_DIR}/i2id ${MST} > ${TMP_PATH}/${ID_FILE}
rem Transfer id file
call Envia2SciELO2021/transf.bat ${LOGFILE} ${TMP_PATH} ${ID_FILE} bin


rem Generate tgz file
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Generate tgz file ${ID_FILE}"
back=`pwd`
cd ${TMP_PATH}
tar cvfzp ${ID_FILE}.tgz ${ID_FILE}
cd $back
rem Transfer tgz file
call Envia2SciELO2021/transf.bat ${LOGFILE} ${TMP_PATH} ${ID_FILE}.tgz bin


rem Delete id file and id file tgz
call batch/DeletaArquivo.bat ${TMP_PATH}/${ID_FILE}
call batch/DeletaArquivo.bat ${TMP_PATH}/${ID_FILE}.tgz


rem Register errors
call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
