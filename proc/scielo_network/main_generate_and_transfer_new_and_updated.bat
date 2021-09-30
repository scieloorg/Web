export PATH=$PATH:.
export CIPAR=tabs/GIGA032.cip

rem scielo_network/main_generate_and_transfer_new_and_updated
rem Parametro 1: bases path
rem Parametro 2: bases/pdf path

rem Inicializa variaveis
BASES_PATH=$1
BASES_PDF_PATH=$2


rem Inicializa variaveis
CISIS_DIR=cisis
TMP_PATH=temp/scielo_network

LOGFILE=${TMP_PATH}/log_main_generate_and_transfer_new_and_updated.log
export INFORMALOG=${TMP_PATH}/log_errors.log
export TIME_LOG=${TMP_PATH}/scielo_network_time_`date '+%d'`_new_and_updated.log

ARTIGO=${BASES_PATH}/artigo/artigo
TITLE_MST=${BASES_PATH}/title/title
TITLE_ID=scielo_network_title.id
PDF_LIST=scielo_network_pdfs_list.txt

echo > ${TIME_LOG}

call scielo_network/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call scielo_network/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${BASES_PATH} "bases path"

call scielo_network/InformaLog.bat ${LOGFILE} $0 "Create ${TMP_PATH}"
call batch/CriaDiretorio.bat ${TMP_PATH}

rem Obtém scielo_network_in.txt
call scielo_network/transf.bat ${LOGFILE} ${TMP_PATH} scielo_network_in.txt bin get

rem Usa scielo_network_in.txt como indicativo 
rem de que a colecao tem permissao para enviar os dados
rem lista de pid concatenado com a data de atualizacao v91
rem PID_YYYYMMDD
if [ -f ${TMP_PATH}/scielo_network_in.txt ]
then

    rem ###########################################
    rem Generate and transfer scielo_network_artigo_*
    rem ###########################################
    rem Gera uma base isis SELECTED_DOCS e a indexa
    cisis/mx seq=${TMP_PATH}/scielo_network_in.txt create=${TMP_PATH}/SELECTED_DOCS now -all
    cisis/mx ${TMP_PATH}/SELECTED_DOCS "fst=1 0 v1/" fullinv=${TMP_PATH}/SELECTED_DOCS now -all

    rem Usa a base SELECTED_DOCS indexada para identificar os documentos que são novos ou desatualizados 
    cisis/mx ${ARTIGO} btell=0 tp=h lw=9999 "pft=if l(['${TMP_PATH}/SELECTED_DOCS']v880,'_',ref(mfn-1,v91)) = 0 then v880/ fi" now > ${TMP_PATH}/NOT_scielo_network_in.txt

    rem Gera as bases e arquivos id dos documentos que são novos ou desatualizados 
    cisis/mx seq=${TMP_PATH}/NOT_scielo_network_in.txt lw=9999 "pft=if p(v1) then './scielo_network/generate_id_from_article.bat ${TMP_PATH} ${BASES_PATH} IV=',v1,'$ scielo_network_artigo_',v1/ fi" now > ${TMP_PATH}/NOT_IN_SCIELO_NETWORK.bat
    chmod +x ${TMP_PATH}/NOT_IN_SCIELO_NETWORK.bat
    nohup ${TMP_PATH}/NOT_IN_SCIELO_NETWORK.bat > ${TMP_PATH}/nohup.scielo_network_artigo.out&
    call scielo_network/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.scielo_network_artigo.out"


    rem ###########################################
    rem Generate and transfer scielo_network_pdfs_list.txt
    rem ###########################################
    call scielo_network/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer ${PDF_LIST}"
    nohup scielo_network/pdfs_list.bat ${TMP_PATH} ${BASES_PDF_PATH} ${PDF_LIST} > ${TMP_PATH}/nohup.scielo_network_pdfs_list.out&
    call scielo_network/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.scielo_network_pdfs_list.out"


    rem ###########################################
    rem Generate and transfer scielo_network_title.*
    rem ###########################################
    call scielo_network/InformaLog.bat ${LOGFILE} $0 "In background generate and transfer ${TITLE_ID}"
    nohup scielo_network/id_generate.bat ${TMP_PATH} ${TITLE_MST} ${TITLE_ID} > ${TMP_PATH}/nohup.scielo_network_title.out&
    call scielo_network/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.scielo_network_title.out"


    rem ###########################################
    rem Generate and transfer scielo_network_i_*
    rem ###########################################
    rem Gera as bases e arquivos id dos issues dos documentos que são novos ou desatualizados 
    cisis/mx seq=${TMP_PATH}/NOT_scielo_network_in.txt lw=9999 "pft=v1*1.17/" now | sort -u > ${TMP_PATH}/ISSUE_NOT_scielo_network_in.txt
    cisis/mx seq=${TMP_PATH}/ISSUE_NOT_scielo_network_in.txt lw=9999 "pft=if p(v1) then './scielo_network/generate_id_from_article.bat ${TMP_PATH} ${BASES_PATH} Y',v1,'$ scielo_network_i_',v1/ fi" now > ${TMP_PATH}/ISSUE_NOT_IN_SCIELO_NETWORK.bat
    chmod +x ${TMP_PATH}/ISSUE_NOT_IN_SCIELO_NETWORK.bat
    nohup ${TMP_PATH}/ISSUE_NOT_IN_SCIELO_NETWORK.bat > ${TMP_PATH}/nohup.scielo_network_i.out&
    call scielo_network/InformaLog.bat ${LOGFILE} $0 "Check ${TMP_PATH}/nohup.scielo_network_i.out"

fi


call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call scielo_network/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call scielo_network/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
