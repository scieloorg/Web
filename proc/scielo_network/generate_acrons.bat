export PATH=$PATH:.

rem scielo_network/generate_acrons
rem Parametro 1: temp path
rem Parametro 2: bases-work path

rem Inicializa variaveis
TMP_PATH=$1
BASES_WORK_PATH=$2

rem Inicializa variaveis
LOGFILE=${TMP_PATH}/log_generate_acrons.log
TITLE_MST=${BASES_WORK_PATH}/title/title
CISIS_DIR=cisis


call scielo_network/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call scielo_network/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9


rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${TMP_PATH} "temp path"
call batch/VerifPresencaParametro.bat $0 @${BASES_WORK_PATH} "bases-work path"


rem Generate and transfer acrons.txt
call scielo_network/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer acrons.txt"
${CISIS_DIR}/mx ${TITLE_MST} lw=999 "pft=if v50='C' then v68/ fi" now > ${TMP_PATH}/acrons.txt
call scielo_network/transf.bat ${LOGFILE} ${TMP_PATH} acrons.txt bin

rem Delete acrons.txt
call batch/DeletaArquivo.bat ${TMP_PATH}/acrons.txt


rem Generate and transfer acrons
call scielo_network/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer acrons"
${CISIS_DIR}/mx ${TITLE_MST} lw=999 "pft=if v50='C' then 'call scielo_network/id_generate.bat ${TMP_PATH} ${BASES_WORK_PATH}/',v68,'/',v68,' ',v68,'.id'/, fi" now > ${TMP_PATH}/call_generate_acrons.bat
chmod +x ${TMP_PATH}/call_generate_acrons.bat
call ${TMP_PATH}/call_generate_acrons.bat


call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call scielo_network/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call scielo_network/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
