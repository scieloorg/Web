BAK_LC_ALL=$LC_ALL
export LC_ALL=POSIX
sort -T temp -o $1 $2
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ordena chaves
export LC_ALL=$BAK_LC_ALL
