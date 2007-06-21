rem @echo off
rem GeraFacCount
rem Parametro 1: path producao SciELO

call batch\VerifPresencaParametro.bat %0 @%1 path producao SciELO

call batch\InformaLog.bat %0 x Gera Facic: ..\bases-work\issue\facic
call batch\CriaDiretorio.bat ..\bases-work\issue
call batch\Master2Seq.bat ..\bases-work\artigo\artigo pft\facic.pft temp\facic.seq
echo ARTIGO.*=..\bases-work\artigo\artigo.*> temp\addleg.cip
set cipar=temp\addleg.cip
call batch\Seq2Master.bat temp\facic.seq pipe temp\facic prc\addleg.prc
call unset.bat cipar
call batch\OrdenaMaster.bat temp\facic 150 pft\OrdFacic.pft
call batch\GeraMaster.bat temp\facic ..\bases-work\issue\facic prc\facic2.prc
call batch\GeraInvertido.bat ..\bases-work\issue\facic fst\facic.fst ..\bases-work\issue\facic

call batch\InformaLog.bat %0 x Gera FacCount: ..\bases-work\issue\faccount
call batch\TabulaMaster.bat ..\bases-work\issue\facic ..\bases-work\issue\faccount 10 pft\factab.pft
call batch\GeraInvertido.bat ..\bases-work\issue\faccount fst\faccount.fst ..\bases-work\issue\faccount