rem ImgPdfDelDirVazio
rem Parametro 1: path site de teste SciELO

call batch/VerifPresencaParametro.bat $0 @$1 path site de teste SciELO

call batch/InformaLog.bat $0 x Deleta diretorios vazios criados

$CISIS_DIR/mx "seq=temp/scilista-imgpdf.lst " "proc='d401a401~$1~'" "pft=@pft/ImgPdfDelDirVazio.pft" now >temp/ImgPdfDelDirVazio.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx de criacao do batch:temp/ImgPdfDelDirVazio.bat
chmod 700 temp/ImgPdfDelDirVazio.bat
call temp/ImgPdfDelDirVazio.bat
