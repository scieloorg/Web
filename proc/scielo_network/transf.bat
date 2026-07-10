export PATH=$PATH:.

rem scielo_network/transf
rem Parametro 1: log file
rem Parametro 2: temp path
rem Parametro 3: file to transfer
rem Parametro 4: bin or asc

rem Inicializa variaveis
LOGFILE=$1
TMP_PATH=$2
FILE_TO_TRANSFER=$3
FTP_BIN_OR_ASC=$4
GET_OR_PUT=$5

if [ "@${GET_OR_PUT}" == "@" ]
then
    GET_OR_PUT=put
fi

rem Inicio
call scielo_network/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call scielo_network/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${LOGFILE} "log file"
call batch/VerifPresencaParametro.bat $0 @${TMP_PATH} "tmp path"
call batch/VerifPresencaParametro.bat $0 @${FILE_TO_TRANSFER} "file to transfer"
call batch/VerifPresencaParametro.bat $0 @${FTP_BIN_OR_ASC} "bin or asc"

call batch/VerifExisteArquivo.bat ${TMP_PATH}/${FILE_TO_TRANSFER}


if [ "put" == "${GET_OR_PUT}" ]
then
    rem Generate tgz file
    call scielo_network/InformaLog.bat ${LOGFILE} $0 "Generate ${FILE_TO_TRANSFER}.tgz"
    back=`pwd`
    cd ${TMP_PATH}
    tar cvfzp ${FILE_TO_TRANSFER}.tgz ${FILE_TO_TRANSFER}
    cd $back
fi


rem Create ftp instructions file
FTP_INSTR=${TMP_PATH}/ftp_instructions_${FILE_TO_TRANSFER}.txt
if [ ! -f ${FTP_INSTR} ]
then
    call scielo_network/InformaLog.bat ${LOGFILE} $0 "Create ${FTP_INSTR}"

    FTP_HEAD_FILE_PATH=${TMP_PATH}/ftp_head

    if [ ! -f ${FTP_HEAD_FILE_PATH} ]
    then
        FTP_INSTR_ALT1=transf/Envia2MedlineLogOn.txt
        FTP_INSTR_ALT2=transf/Envia2SciELOFastLogOn.txt
        FTP_INSTR_ALT3=transf/Envia2SciELONetworkLogOn.txt
        if [ -f ${FTP_INSTR_ALT1} ]
        then
            head -n 3 ${FTP_INSTR_ALT1} > ${FTP_HEAD_FILE_PATH}
        fi
        if [ -f ${FTP_INSTR_ALT2} ]
        then
            head -n 3 ${FTP_INSTR_ALT2} > ${FTP_HEAD_FILE_PATH}
        fi
        if [ -f ${FTP_INSTR_ALT3} ]
        then
            head -n 3 ${FTP_INSTR_ALT3} > ${FTP_HEAD_FILE_PATH}
        fi
    fi

    call batch/VerifExisteArquivo.bat ${FTP_HEAD_FILE_PATH}

    cat ${FTP_HEAD_FILE_PATH} > ${FTP_INSTR}
    echo "${FTP_BIN_OR_ASC}" >> ${FTP_INSTR}
    echo "lcd ${TMP_PATH}" >> ${FTP_INSTR}
    if [ "put" == "${GET_OR_PUT}" ]
    then
        echo "${GET_OR_PUT} ${FILE_TO_TRANSFER}.tgz" >> ${FTP_INSTR}
        if [ "@"!="@${TIME_LOG}" -a -f ${TIME_LOG} ]
        then
            echo "put `basename ${TIME_LOG}`" >> ${FTP_INSTR}
        fi
    else
        echo "${GET_OR_PUT} ${FILE_TO_TRANSFER}" >> ${FTP_INSTR}
    fi
    echo "close" >> ${FTP_INSTR}
    echo "bye" >> ${FTP_INSTR}
fi
call batch/VerifExisteArquivo.bat ${FTP_INSTR}

ftp -n < ${FTP_INSTR} >> ${LOGFILE}

rem Delete ftp instruction file
call batch/DeletaArquivo.bat ${FTP_INSTR}

if [ "put" == "${GET_OR_PUT}" ]
then
    call batch/DeletaArquivo.bat ${TMP_PATH}/${FILE_TO_TRANSFER}
    call batch/DeletaArquivo.bat ${TMP_PATH}/${FILE_TO_TRANSFER}.tgz
fi

rem Register errors
call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}

call scielo_network/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call scielo_network/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
