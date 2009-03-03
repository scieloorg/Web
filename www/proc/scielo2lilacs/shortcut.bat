
chmod -R 775 scielo2lilacs/linux/*.bat 

#######################################
# begin Setting Environment Variables
#######################################
export CREATE_LIST=$1

export SCILIL_PARM_SRCDB=/home/scielo/www/bases-aux/scielo-lilacs/input/regL
export SCILIL_PARM_list=scilist.scielo2lilacs.txt
export SCILIL_PARM_limit=20080000
export SCILIL_PARM_dbtitles=/home/scielo/www/bases-aux/scielo-lilacs/input/titles
export SCILIL_PARM_dest=/home/scielo/www/bases-aux/scielo-lilacs/output/scielolilacs
export SCILIL_PARM_cipfile=temp/scielo2lilacs_mycipar.cip
export SCILIL_PARM_ctrlConversion=/home/scielo/www/bases-aux/scielo-lilacs/ctrl/ctrl_conversion
export SCILIL_PARM_ctrlIssue=/home/scielo/www/bases-aux/scielo-lilacs/ctrl/ctrl_issue
export SCILIL_PARM_WXISLOG=temp/scielo2lilacs_wxislog.txt
export SCILIL_PARM_DBLANG=/home/scielo/www/bases-work/artigo/lang

export SCILIL_MX=cisis/mx
export SCILIL_WXIS=cisis/wxis

export SCILIL_GBL_LILTITLE=/home/scielo/www/bases-aux/scielo-lilacs/input/liltitle
export SCILIL_GBL_COLLECTIONS=/home/scielo/www/bases-aux/scielo-lilacs/input/collections
export SCILIL_GBL_GIZMOA=/home/scielo/www/bases-aux/scielo-lilacs/input/gizmoa
export SCILIL_GBL_SCIELOTP=/home/scielo/www/bases-aux/scielo-lilacs/input/scielotp

#######################################
# begin Deleting temp
#######################################

#rm ../bases-aux/scielo-lilacs/ctrl/* ../bases-aux/scielo-lilacs/output/* 
rm temp/scielo2lilacs.convert.txt
rm temp/scielo2lilacs_convert.xis.log
rm temp/scielo2lilacs_controlIssue.xis.log
rm temp/scielo2lilacs_*

#######################################
# begin Creating $SCILIL_PARM_cipfile
#######################################
if [ -f "$SCILIL_PARM_cipfile" ]
then
	rm $SCILIL_PARM_cipfile
fi
scielo2lilacs/linux/addLineInCip.bat CTRL_ISSUE $SCILIL_PARM_ctrlIssue $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat CTRL_CONVERSION $SCILIL_PARM_ctrlConversion $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat TITLES $SCILIL_PARM_dbtitles $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat LILTITLE $SCILIL_GBL_LILTITLE $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat LILTITLES $SCILIL_GBL_LILTITLE $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat COLLECTIONS $SCILIL_GBL_COLLECTIONS $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat GIZIDIOMA $SCILIL_GBL_GIZMOA $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat SCIELOTP $SCILIL_GBL_SCIELOTP $SCILIL_PARM_cipfile


#######################################
# begin Creating $SCILIL_PARM_list
#######################################

if [ "@$CREATE_LIST" == "@yes" ]
then
	scielo2lilacs/linux/generateList.bat $SCILIL_PARM_SRCDB $SCILIL_PARM_list $SCILIL_PARM_dbtitles $SCILIL_PARM_limit $SCILIL_PARM_cipfile
fi




#######################################
# begin Main
#######################################

scielo2lilacs/linux/doForList.bat $SCILIL_PARM_list $SCILIL_PARM_SRCDB $SCILIL_PARM_dest $SCILIL_PARM_ctrlConversion $SCILIL_PARM_ctrlIssue $SCILIL_PARM_cipfile $SCILIL_PARM_WXISLOG $SCILIL_PARM_DBLANG 
