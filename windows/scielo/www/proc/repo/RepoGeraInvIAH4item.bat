rem @echo off
rem RepoGeraInvIAH4item
rem Parametro 1: repositorio
rem Parametro 2: repositorio formatado
rem Parametro 3: opcional acronimo
rem Parametro 4: opcional issn da revista, obrigatorio se o parametro 2 for informado

call batch\VerifPresencaParametro.bat %0 @%1 repositorio

call batch\InformaLog.bat %0 x Gera invertidos do IAH

echo rem RepoGeraInvIAH4item >temp\RepoGeraInvIAH4item.bat

call repo\RepoGenerateFst.bat %1 temp\repo_fst_search.fst temp\repo_fst_searchp.fst %4 

call batch\CriaDiretorio.bat ..\bases-work\iah\%2%3

if "@%3"=="@"  call batch\GeraInvertido.bat ..\bases-work\artigo\artigo temp\repo_fst_search.fst ..\bases-work\iah\%2\search
if "@%3"=="@"  call batch\GeraInvertido.bat ..\bases-work\artigo\artigo temp\repo_fst_searchp.fst ..\bases-work\iah\%2\searchp


if not "@%3"=="@" call batch\GeraInvertido.bat ..\bases-work\%3\%3 temp\repo_fst_search.fst ..\bases-work\iah\%2%3\search
if not "@%3"=="@" call batch\GeraInvertido.bat ..\bases-work\%3\%3 temp\repo_fst_searchp.fst ..\bases-work\iah\%2%3\searchp


