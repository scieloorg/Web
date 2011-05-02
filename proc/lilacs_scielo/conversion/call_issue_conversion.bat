@echo off

echo  %serial_path%\%1\%2\base
if not exist %serial_path%\%1\%2\base mkdir %serial_path%\%1\%2\base
%mx% null count=0 create=%serial_path%\%1\%2\base\%2 now -all
if errorlevel==1 pause
%wxis% IsisScript=lilacs_scielo\conversion\generateSciELOfromLILACS.xis reprocess=%3 center=%center% acron=%1 issueid=%2 proc_path=%proc_path% cip=%cipar_file% debug=%debug% serial_path=%serial_path% url=%url% >> %log_file%





