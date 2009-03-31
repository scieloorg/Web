rem ConverteCriaDir
rem Parametro 1: path para armazenar bases convertidas

call batch/VerifPresencaParametro.bat $0 @$1 path para armazenar bases convertidas

call batch/CriaDiretorio.bat $1

call batch/CriaDiretorio.bat $1/title
call batch/CriaDiretorio.bat $1/issue
call batch/CriaDiretorio.bat $1/code

$CISIS_DIR/mx "seq=temp/scilista-envia.lst " lw=9000 "pft=if p(v1) and v3 <> 'del' then 'call batch/CriaDiretorio.bat $1/',v1/ fi" now >temp/ConverteCriaDir.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 passo 1
$CISIS_DIR/mx "seq=temp/scilista-envia.lst " lw=9000 "pft=if p(v1) and v3 <> 'del' then 'call batch/CriaDiretorio.bat $1/',v1,'/',v2/ fi" now >>temp/ConverteCriaDir.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 passo 2
chmod 700 temp/ConverteCriaDir.bat
call temp/ConverteCriaDir.bat

