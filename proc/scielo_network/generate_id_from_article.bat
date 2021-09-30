export PATH=$PATH:.

rem scielo_network/generate_id_from_article
rem Parametro 1: temp path
rem Parametro 2: bases path
rem Parametro 3: key
rem Parametro 4: id filename

rem Inicializa variaveis
TMP_PATH=$1
BASES_PATH=$2
KEY=$3
ID_FILENAME=$4

rem Inicializa variaveis
LOGFILE=${TMP_PATH}/log_generate_id_from_article_${ID_FILENAME}.log

CISIS_DIR=cisis
ARTICLE_DB=${BASES_PATH}/artigo/artigo

call scielo_network/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call scielo_network/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${TMP_PATH} "temp path"
call batch/VerifPresencaParametro.bat $0 @${BASES_PATH} "bases path"
call batch/VerifPresencaParametro.bat $0 @${KEY} "key"
call batch/VerifPresencaParametro.bat $0 @${ID_FILENAME} "id filename"

call batch/VerifExisteArquivo.bat ${ARTICLE_DB}.mst

rem Generate and transfer scilista issue
call scielo_network/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer ${ID_FILENAME}"
${CISIS_DIR}/mx null count=0 create=${TMP_PATH}/${ID_FILENAME} now -all
${CISIS_DIR}/mx ${ARTICLE_DB} "bool=${KEY}" append=${TMP_PATH}/${ID_FILENAME} now -all
call scielo_network/id_generate.bat ${TMP_PATH} ${TMP_PATH}/${ID_FILENAME} ${ID_FILENAME}.id

call batch/DeletaArquivo.bat ${TMP_PATH}/${ID_FILENAME}.mst
call batch/DeletaArquivo.bat ${TMP_PATH}/${ID_FILENAME}.xrf

call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call scielo_network/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call scielo_network/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
