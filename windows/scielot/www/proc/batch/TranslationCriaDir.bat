rem TranslationCriaDir
rem Parametro 1: path site de teste da SciELO

call batch\VerifPresencaParametro.bat %0 @%1 path site de teste da SciELO

call batch\InformaLog.bat %0 x Cria diretorios para funcionar FTP

%CISIS_DIR%\mx "seq=temp\scilista-Translation.lst " "proc='d401a401~%1~'" "pft=@pft\TranslationCriaDir.pft" now >temp\TranslationCriaDir.bat
if errorlevel==1 batch\AchouErro.bat %0 mx de criacao do batch:temp\TranslationCriaDir.bat
rem chmod 700 temp\TranslationCriaDir.bat
call temp\TranslationCriaDir.bat

