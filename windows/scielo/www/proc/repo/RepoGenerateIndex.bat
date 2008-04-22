@echo off

call batch\CopiaArquivo.bat fst\search.fst temp\search.xxx
call batch\CopiaArquivo.bat fst\searchp.fst temp\searchp.xxx
more repo\repo_linhabranco.pft >> temp\search.xxx
more repo\repo_linhabranco.pft >> temp\searchp.xxx

rem call repo\GenerateListAcronIssn.bat 

echo Parte 1
call batch\Seq2Master.bat repo\repo.seq pipe temp\repo
call batch\Master2Seq.bat temp\repo repo\repo_lista.pft temp\repo_lista.txt
call repo\RepoGeraInvIAH4lista.bat %1 temp\repo_lista.txt
call batch\CopiaArquivo.bat temp\repo_lista.txt reposcilista.txt
more temp\repo_lista.txt > reposcilista.txt

echo Parte 2
call batch\TabulaMaster.bat ..\bases-work\artigo\artigo temp\repo_listatb 30 repo\TabListaRepo.pft
call batch\Master2Seq.bat temp\repo_listatb repo\repo_lista.pft temp\repo_lista.txt
more temp\repo_lista.txt >> reposcilista.txt

call repo\RepoGeraInvIAH4lista.bat %1 temp\repo_lista.txt