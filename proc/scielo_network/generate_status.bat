export PATH=$PATH:.

rem scielo_network/generate_id_from_article
rem Parametro 1: temp path
rem Parametro 2: bases path
rem Parametro 3: key
rem Parametro 4: id filename

rem Inicializa variaveis
TMP_PATH=$1
BASES_PATH=$2

OUTPUT_FILENAME=scielo_network_status.txt

rem Inicializa variaveis
LOGFILE=${TMP_PATH}/log_generate_status_${OUTPUT_FILENAME}.log

CISIS_DIR=cisis
ARTICLE_DB=${BASES_PATH}/artigo/artigo

call scielo_network/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call scielo_network/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${TMP_PATH} "temp path"
call batch/VerifPresencaParametro.bat $0 @${BASES_PATH} "bases path"

call batch/VerifExisteArquivo.bat ${ARTICLE_DB}.mst

rem Generate and transfer scilista issue
call scielo_network/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer ${OUTPUT_FILENAME}"
${CISIS_DIR}/mx ${ARTICLE_DB} btell=0 "bool=tp=h" "pft=ref(mfn-1,v91),',',v880/" now | sort > ${TMP_PATH}/${OUTPUT_FILENAME}


rem Transfer output file
call scielo_network/transf.bat ${LOGFILE} ${TMP_PATH} ${OUTPUT_FILENAME} bin

call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call scielo_network/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call scielo_network/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
