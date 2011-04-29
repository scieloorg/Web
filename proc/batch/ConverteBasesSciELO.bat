rem ConverteBasesSciELO
rem Parametro 1: path bases a converter
rem Parametro 2: path bases para gravar bases convertidas
rem Parametro 3: posicao rede Scielo no campo 691 da title [opcional]

call batch/VerifPresencaParametro.bat $0 @$1 path bases a converter
call batch/VerifPresencaParametro.bat $0 @$2 path bases para gravar bases convertidas

call batch/ConverteCriaDir.bat $2

echo '' > temp/GeraTitle.prc
if [ $# == 3 ]
then
   echo if mid(v691,$3,1) = '0' then 'd*' fi >> temp/GeraTitle.prc
fi
call batch/GeraMaster.bat ../bases/title/title temp/title temp/GeraTitle.prc

call batch/ConverteMaster.bat temp/title $2/title/title
call batch/ConverteMaster.bat ../bases/newissue/newissue $2/issue/issue
call batch/ConverteMaster.bat $1/code/newcode $2/code/newcode

$CISIS_DIR/mx "seq=temp/scilista-envia.lst " lw=9000 "pft=if p(v1) and v3 <> 'del' then 'call batch/ConverteMaster.bat',x1,'$1/',v1,'/',v2,'/base/',v2,x1,'$2/',v1,'/',v2,'/',v2/ fi" now >temp/ConverteBasesSciELO.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx seq:temp/scilista-envia.lst_ lw:9000 pft:call_batch_ConverteBasesSciELO.bat
chmod 700 temp/ConverteBasesSciELO.bat
call temp/ConverteBasesSciELO.bat
