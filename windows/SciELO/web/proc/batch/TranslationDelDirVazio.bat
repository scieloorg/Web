rem TranslationDelDirVazio
rem Parametro 1: path site de teste SciELO

call batch\VerifPresencaParametro.bat %0 @%1 path site de teste SciELO

call batch\InformaLog.bat %0 x Deleta diretorios vazios criados

%CISIS_DIR%\mx "seq=temp\scilista-Translation.lst " "proc='d401a401~%1~'" "pft=@pft\TranslationDelDirVazio.pft" now >temp\TranslationDelDirVazio.bat
if errorlevel==1 batch\AchouErro.bat %0 mx de criacao do batch:temp\TranslationDelDirVazio.bat
rem chmod 700 temp\TranslationDelDirVazio.bat
call temp\TranslationDelDirVazio.bat
