export PATH=$PATH:.
export CIPAR=tabs/GIGA032.cip

rem scielo_network/main_generate_and_transfer_diffs
rem Parametro 1: bases path

rem Inicializa variaveis
BASES_PATH=$1

rem Inicializa variaveis
CISIS_DIR=cisis
TMP_PATH=temp/scielo_network
LOGFILE=${TMP_PATH}/log_main_generate_and_transfer_diffs.log
export INFORMALOG=${TMP_PATH}/log_errors.log

ARTIGO=${BASES_PATH}/artigo/artigo
export TIME_LOG=${TMP_PATH}/scielo_network_time_`date '+%d'`_diffs.log


echo > ${TIME_LOG}

call scielo_network/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call scielo_network/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${BASES_PATH} "bases path"

call scielo_network/InformaLog.bat ${LOGFILE} $0 "Create ${TMP_PATH}"
call batch/CriaDiretorio.bat ${TMP_PATH}

rem Obtém scielo_network_in.txt
call scielo_network/transf.bat ${LOGFILE} ${TMP_PATH} scielo_network_in.txt bin get


call batch/VerifExisteArquivo.bat ${TMP_PATH}/scielo_network_in.txt
if [ -f ${TMP_PATH}/scielo_network_in.txt ]
then

    rem Gera uma base isis SELECTED_DOCS e a indexa
    cisis/mx seq=${TMP_PATH}/scielo_network_in.txt create=${TMP_PATH}/SELECTED_DOCS now -all
    cisis/mx ${TMP_PATH}/SELECTED_DOCS "fst=1 0 v1/" fullinv=${TMP_PATH}/SELECTED_DOCS now -all

    rem Usa a base SELECTED_DOCS indexada para identificar os documentos que são novos ou desatualizados 
    cisis/mx ${ARTIGO} btell=0 tp=h lw=9999 "pft=if l(['${TMP_PATH}/SELECTED_DOCS']v880,ref(mfn-1,v91)) = 0 then v880/ fi" now > ${TMP_PATH}/NOT_scielo_network_in.txt

    rem Gera as bases e arquivos id dos documentos que são novos ou desatualizados 
    cisis/mx seq=${TMP_PATH}/NOT_scielo_network_in.txt lw=9999 "pft=if p(v1) then './scielo_network/generate_id_from_article.bat ${TMP_PATH} ${BASES_PATH} IV=',v1,'$ scielo_network_artigo_',v1/ fi" now > ${TMP_PATH}/NOT_IN_SCIELO_NETWORK.bat
    chmod +x ${TMP_PATH}/NOT_IN_SCIELO_NETWORK.bat
    nohup ${TMP_PATH}/NOT_IN_SCIELO_NETWORK.bat > ${TMP_PATH}/nohup.NOT_IN_SCIELO_NETWORK.out&

else
	rem Usa a base ARTIGO indexada para identificar os documentos que são novos ou desatualizados 
    cisis/mx ${ARTIGO} btell=0 tp=h lw=9999 "pft=v880*0.14/" now | sort -u > ${TMP_PATH}/NOT_scielo_network_in.txt

    rem Gera as bases e arquivos id dos documentos que são novos ou desatualizados 
    cisis/mx seq=${TMP_PATH}/NOT_scielo_network_in.txt lw=9999 "pft=if p(v1) then './scielo_network/generate_id_from_article.bat ${TMP_PATH} ${BASES_PATH} IV=',v1*0.14,'$ scielo_network_artigo_',v1*0.14/ fi" now > ${TMP_PATH}/NOT_IN_SCIELO_NETWORK.bat
    chmod +x ${TMP_PATH}/NOT_IN_SCIELO_NETWORK.bat
    nohup ${TMP_PATH}/NOT_IN_SCIELO_NETWORK.bat > ${TMP_PATH}/nohup.NOT_IN_SCIELO_NETWORK.out&

fi


rem Gera as bases e arquivos id dos issues dos documentos que são novos ou desatualizados 
cisis/mx seq=${TMP_PATH}/NOT_scielo_network_in.txt lw=9999 "pft=v1*1.17/" now | sort -u > ${TMP_PATH}/ISSUE_NOT_scielo_network_in.txt
cisis/mx seq=${TMP_PATH}/ISSUE_NOT_scielo_network_in.txt lw=9999 "pft=if p(v1) then './scielo_network/generate_id_from_article.bat ${TMP_PATH} ${BASES_PATH} Y',v1,'$ scielo_network_i_',v1/ fi" now > ${TMP_PATH}/ISSUE_NOT_IN_SCIELO_NETWORK.bat
chmod +x ${TMP_PATH}/ISSUE_NOT_IN_SCIELO_NETWORK.bat
nohup ${TMP_PATH}/ISSUE_NOT_IN_SCIELO_NETWORK.bat > ${TMP_PATH}/nohup.ISSUE_NOT_IN_SCIELO_NETWORK.out&


call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call scielo_network/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call scielo_network/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
