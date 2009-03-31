rem ImgPdfCriaDir
rem Parametro 1: path site de teste da SciELO

call batch/VerifPresencaParametro.bat $0 @$1 path site de teste da SciELO

call batch/InformaLog.bat $0 x Cria diretorios para funcionar FTP

$CISIS_DIR/mx "seq=temp/scilista-imgpdf.lst " "proc='d401a401~$1~'" "pft=@pft/ImgPdfCriaDir.pft" now >temp/ImgPdfCriaDir.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx de criacao do batch:temp/ImgPdfCriaDir.bat
chmod 700 temp/ImgPdfCriaDir.bat
call temp/ImgPdfCriaDir.bat

