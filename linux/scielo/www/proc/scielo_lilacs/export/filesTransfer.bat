export mx=$1
export ftp_config=$2
export exportdbname=$3
export ctrl_issue=$4
export done=$5

export ftp_instructions_file=temp/EnviaBasesLILACSXP.txt

cp $ftp_config $ftp_instructions_file

export tempdb=temp/$exportdbname
export tempctrlissue=temp/$ctrl_issue

rm -rf $done

echo lcd temp/ > $ftp_instructions_file
echo put $exportdbname >> $ftp_instructions_file
echo put $ctrl_issue >> $ftp_instructions_file
echo get $ctrl_issue $done >> $ftp_instructions_file
echo bye >> $ftp_instructions_file

ftp -i -v -n < $ftp_config > log/trf_SciELO_Lilacs.log


