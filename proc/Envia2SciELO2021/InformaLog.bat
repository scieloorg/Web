export PATH=$PATH:.

rem Envia2SciELO2021/InformaLog
rem Parametro 1: log file
rem Parametro 2: nome do batch

rem Inicializa variaveis
LOG_FILE=$1
SCRIPT_NAME=$2
PARAM_3=$3
PARAM_4=$4
PARAM_5=$5
PARAM_6=$6
PARAM_7=$7
PARAM_8=$8
PARAM_9=$9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${SCRIPT_NAME} "nome do batch"
call batch/VerifPresencaParametro.bat $0 @${LOG_FILE} "log file"


echo `date '+%Y%m%d %H:%M:%S'` $2 $3 $4 $5 $6 $7 $8 $9 >> ${TIME_LOG}

echo `date '+%Y%m%d %H:%M:%S'` >> ${LOG_FILE}
echo [${SCRIPT_NAME}] >> ${LOG_FILE}
echo    ${PARAM_3} ${PARAM_4} ${PARAM_5} ${PARAM_6} ${PARAM_7} ${PARAM_8} ${PARAM_9} >> ${LOG_FILE}
echo >> ${LOG_FILE}
