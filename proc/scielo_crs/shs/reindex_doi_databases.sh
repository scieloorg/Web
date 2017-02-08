BASEDIR=$(dirname $0)
journals=`ls -1 -d $BASEDIR/../../../bases/doi/*/`

for journal in $journals; do
    issues=`ls -1 -d $journal*/`
    for issue in $issues; do
        database_path=${issue%?}
        database_name=`echo $database_path | sed 's#.*/##'`
        mst=$database_path'/'$database_name
        $BASEDIR/../../cisis/mx $mst fst=@$BASEDIR/../../doi/fst/doi.fst fullinv/ansi=$mst
    done
done