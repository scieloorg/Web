set PATH=.;%PATH%
set proc_path=scielo_lilacs\
set allowed=temp\scielo_lilacs_allowedISSN.txt
set myissue=temp\scielo_lilacs_issue
set templilxp=temp\scielo_lilacs_lxp
set ftp_config=scielo_lilacs\config\EnviaBasesLILACSXPLogOn.txt
set cip=scielo_lilacs\config\cipar.cip
set liltitle=scielo_lilacs\auxiliar\liltitle

%mx% iso=scielo_lilacs\auxiliar\scielotp.iso create=scielo_lilacs\auxiliar\scielotp now -all
%mx% scielo_lilacs\auxiliar\scielotp fst=@ fullinv=scielo_lilacs\auxiliar\scielotp now -all

%mx% iso=scielo_lilacs\auxiliar\gizmoa.iso create=scielo_lilacs\auxiliar\gizmoa now -all

%mx% iso=scielo_lilacs\auxiliar\liltitle.iso create=scielo_lilacs\auxiliar\liltitle now -all
%mx% scielo_lilacs\auxiliar\liltitle fst=@ fullinv=scielo_lilacs\auxiliar\liltitle now -all
