rem Iso2Master
rem Parametro 1: arquivo.iso
rem Parametro 2: base
rem Parametro 3: gizmo [opcional]

call batch\VerifPresencaParametro.bat %0 @%1 nome-do-arquivo-iso a ser lido
call batch\VerifExisteArquivo.bat %1
call batch\VerifPresencaParametro.bat %0 @%2 base a ser gerada

echo -all> temp\Iso2Master.in
if "@%3"=="@" goto SKIP_GIZMO
   call batch\VerifExisteBase.bat %3
   echo gizmo=%3>> temp\Iso2Master.in
fi
:SKIP_GIZMO

call batch\InformaLog.bat %0 x Gera master: %2
%CISIS_DIR%\mx iso=%1 create=%2 now in=temp\Iso2Master.in
if errorlevel==1 batch\AchouErro.bat %0 mx iso:%1 create:%2
