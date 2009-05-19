#export SCILISTA=$1
#export MX=$2
#export BASESWORK=$3
#export DBLANG=$4
#export DOCPATHS=$PROCLANGPATH/config/docpaths.seq
#export CIPAR=$PROCLANGPATH/config/mycipar.cip
#export PROCLANG_LOG=

chmod -R 775 procLangs/linux/*.bat

procLangs/linux/doForList.bat scilist.langs.txt cisis/mx ../bases-work/ ../bases-work/artigo/lang log/procLangs.log
