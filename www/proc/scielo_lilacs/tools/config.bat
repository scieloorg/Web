export PATH=.:$PATH
export proc_path=scielo_lilacs/
export allowed=temp/scielo_lilacs_allowedISSN.txt
export myissue=temp/scielo_lilacs_issue
export templilxp=temp/scielo_lilacs_lxp
export ftp_config=scielo_lilacs/config/EnviaBasesLILACSXPLogOn.txt
export cip=scielo_lilacs/config/cipar.cip
export liltitle=scielo_lilacs/auxiliar/liltitle

$mx iso=scielo_lilacs/auxiliar/scielotp.iso create=scielo_lilacs/auxiliar/scielotp now -all
$mx scielo_lilacs/auxiliar/scielotp fst=@ fullinv=scielo_lilacs/auxiliar/scielotp now -all

$mx iso=scielo_lilacs/auxiliar/gizmoa.iso create=scielo_lilacs/auxiliar/gizmoa now -all

$mx iso=scielo_lilacs/auxiliar/liltitle.iso create=scielo_lilacs/auxiliar/liltitle now -all
$mx scielo_lilacs/auxiliar/liltitle fst=@ fullinv=scielo_lilacs/auxiliar/liltitle now -all
