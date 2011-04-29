set drive=%1
set serial_journal=%2
set PDF_SEQ=%3
set MX=%4
set RENAME_PROC_PATH=%5
set temp=%6

%drive%:
cd %serial_journal%
dir /s/b > %PDF_SEQ%
%MX% seq=%PDF_SEQ% lw=9999 "pft=@%RENAME_PROC_PATH%\renamePDF.pft" now > %temp%\renamePDF.bat

notepad %temp%\renamePDF.bat

echo ENTER to continue, or CTRL+C to end
pause

call %temp%\renamePDF.bat
