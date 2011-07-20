export PATH=$PATH:.

rem Parametro 1: create or update
rem Parametro 2: scilista
rem Parametro 3: prefixo doi
rem Parametro 4: user
rem Parametro 5: password
rem Parametro 6: email

rem Parametro 7: registro selecionado
rem Parametro 8: pacote ou individual ou no_query

. scielo_crs/shs/crossref_config.sh

doi/create_update/ReadScilista.bat create $1 $depositor_prefix $crossrefUserName $crossrefPassword $depositor_email art no_query

# doi/create_update/ReadScilista.bat create $1 10.1590 bireme bireme303 bireme.crossref@gmail.com art no_query
rem doi/create_update/ReadScilista.bat create $1 10.1590 bireme bireme303 scielo@bireme.br art pacote
rem doi/create_update/ReadScilista.bat create $1 10.1590 bireme bireme303 scielo@bireme.br art individual

