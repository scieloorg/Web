export PATH=$PATH:.
export CIPAR=tabs/GIGA032.cip

rem Envia2SciELO2021/main_generate_and_transfer_diffs
rem Parametro 1: bases path

rem Inicializa variaveis
BASES_PATH=$1

rem Inicializa variaveis
CISIS_DIR=cisis
TMP_PATH=temp/Envia2SciELO2021
LOGFILE=${TMP_PATH}/log_main_generate_and_transfer_diffs.log
export INFORMALOG=${TMP_PATH}/log_errors.log

ARTIGO=${BASES_PATH}/artigo/artigo
export TIME_LOG=${TMP_PATH}/time_`date '+%d'`_diffs.log


echo > ${TIME_LOG}

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "BEGIN"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 $1 $2 $3 $4 $5 $6 $7 $8 $9

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @${BASES_PATH} "bases path"

call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "Create ${TMP_PATH}"
call batch/CriaDiretorio.bat ${TMP_PATH}

rem Obtém IN_CENTRAL_NODE.txt 
call Envia2SciELO2021/transf.bat ${LOGFILE} ${TMP_PATH} IN_CENTRAL_NODE.txt bin get


call batch/VerifExisteArquivo.bat ${TMP_PATH}/IN_CENTRAL_NODE.txt
if [ -f ${TMP_PATH}/IN_CENTRAL_NODE.txt ]
then

    rem Gera uma base isis SELECTED_DOCS e a indexa
    cisis/mx seq=${TMP_PATH}/IN_CENTRAL_NODE.txt create=${TMP_PATH}/SELECTED_DOCS now -all
    cisis/mx ${TMP_PATH}/SELECTED_DOCS "fst=1 0 v1/" fullinv=${TMP_PATH}/SELECTED_DOCS now -all

    rem Usa a base SELECTED_DOCS indexada para identificar os documentos que são novos ou desatualizados 
    cisis/mx ${ARTIGO} btell=0 tp=h lw=9999 "pft=if l(['${TMP_PATH}/SELECTED_DOCS']v880,ref(mfn-1,v91)) = 0 then v880/ fi" now > ${TMP_PATH}/NOT_IN_CENTRAL_NODE.txt

    rem Gera as bases e arquivos id dos documentos que são novos ou desatualizados 
    cisis/mx seq=${TMP_PATH}/NOT_IN_CENTRAL_NODE.txt lw=9999 "pft=if p(v1) then './Envia2SciELO2021/generate_id_from_article.bat ${TMP_PATH} ${BASES_PATH} IV=',v1,'$ artigo_',v1/ fi" now > ${TMP_PATH}/NOT_IN_CENTRAL_NODE.bat
    chmod +x ${TMP_PATH}/NOT_IN_CENTRAL_NODE.bat
    nohup ${TMP_PATH}/NOT_IN_CENTRAL_NODE.bat > ${TMP_PATH}/nohup.NOT_IN_CENTRAL_NODE.out&

else
	rem Usa a base ARTIGO indexada para identificar os documentos que são novos ou desatualizados 
    cisis/mx ${ARTIGO} btell=0 tp=h lw=9999 "pft=v880*0.14/" now | sort -u > ${TMP_PATH}/NOT_IN_CENTRAL_NODE.txt

    rem Gera as bases e arquivos id dos documentos que são novos ou desatualizados 
    cisis/mx seq=${TMP_PATH}/NOT_IN_CENTRAL_NODE.txt lw=9999 "pft=if p(v1) then './Envia2SciELO2021/generate_id_from_article.bat ${TMP_PATH} ${BASES_PATH} IV=',v1*0.14,'$ artigo_',v1*0.14/ fi" now > ${TMP_PATH}/NOT_IN_CENTRAL_NODE.bat
    chmod +x ${TMP_PATH}/NOT_IN_CENTRAL_NODE.bat
    nohup ${TMP_PATH}/NOT_IN_CENTRAL_NODE.bat > ${TMP_PATH}/nohup.NOT_IN_CENTRAL_NODE.out&

fi


rem Gera as bases e arquivos id dos issues dos documentos que são novos ou desatualizados 
cisis/mx seq=${TMP_PATH}/NOT_IN_CENTRAL_NODE.txt lw=9999 "pft=v1*1.17/" now | sort -u > ${TMP_PATH}/ISSUE_NOT_IN_CENTRAL_NODE.txt
cisis/mx seq=${TMP_PATH}/ISSUE_NOT_IN_CENTRAL_NODE.txt lw=9999 "pft=if p(v1) then './Envia2SciELO2021/generate_id_from_article.bat ${TMP_PATH} ${BASES_PATH} Y',v1,'$ i_',v1/ fi" now > ${TMP_PATH}/ISSUE_NOT_IN_CENTRAL_NODE.bat
chmod +x ${TMP_PATH}/ISSUE_NOT_IN_CENTRAL_NODE.bat
nohup ${TMP_PATH}/ISSUE_NOT_IN_CENTRAL_NODE.bat > ${TMP_PATH}/nohup.ISSUE_NOT_IN_CENTRAL_NODE.out&


call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: ${LOGFILE}
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "FINISHED"
call Envia2SciELO2021/InformaLog.bat ${LOGFILE} $0 "LOGFILE: ${LOGFILE}"
