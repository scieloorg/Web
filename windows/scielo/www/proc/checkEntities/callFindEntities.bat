@echo off

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem set SHELL=C:\COMMAND.COM /P /E:1024

rem Parametro 1: mx
rem Parametro 2: base artigo
rem Parametro 3: diretorio de temporarios
rem Parametro 4: mz
rem Parametro 5: invertido accent

rem Inicializa variaveis
set SHELL=C:\COMMAND.COM /P /E:1024
set INFORMALOG=log\GeraScielo.log
set CISIS_DIR=cisis


rem call checkEntities\private\findEntities.bat cisis\mx ..\bases\artigo\artigo temp\entities \\alpha1\spd\utl\cisis1660\mz 

rem call checkEntities\private\findEntities.bat cisis\mx ..\bases\artigo\artigo temp\entities \\alpha1\spd\utl\cisis1660\mz gizmo\accent transf\transf2linux\entidades_faltantes_em_accent.txt

call batch\CriaDiretorio.bat temp\entities

call checkEntities\private\findEntities.bat cisis\mx d:\temp\v32n2 temp\entities \\alpha1\spd\utl\cisis1660\mz gizmo\accent ..\bases\entidades_faltantes_em_accent.txt
