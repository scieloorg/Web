export src=scielo_lilacs/config/auxiliar/
export dest=scielo_lilacs/auxiliar/

rm -rf $dest
mkdir $dest

cp $src/liltitle.mst $dest
cp $src/liltitle.xrf $dest
cp $src/liltitle.fst $dest
cp $src/scielotp.mst $dest
cp $src/scielotp.xrf $dest
cp $src/scielotp.fst $dest
cp $src/gizmoa.mst $dest
cp $src/gizmoa.xrf $dest

cisis.lind/mx $dest/liltitle fst=@ fullinv=$dest/liltitle
cisis.lind/mx $dest/scielotp fst=@ fullinv=$dest/scielotp