rem GeraArtigoFast
rem Parametro 1: path producao Scielo

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO

call batch/CriaDiretorio.bat ../bases-work/fast
call batch/CriaMaster.bat ../bases-work/fast/artigo

$CISIS_DIR/mx $1/serial/title/title lw=9000 "pft=if v50='C' then 'call batch/AppendMaster.bat ../bases-work/',v68,'/',v68,x1,'../bases-work/fast/artigo',x1,'prc/d1930.prc'/ fi" now >temp/GeraArtigoFast.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1/serial/title/title lw:9000 pft:call_GeraArtigo.bat
chmod 700 temp/GeraArtigoFast.bat
call temp/GeraArtigoFast.bat

echo "GeraArtigoFast: Envia de bases title e artigo do bases-work para FTP para carga em ArticleMeta"
call Envia2SciELOFast.bat ../bases-work transf/Envia2SciELOFastLogOn.txt log/enviaGeraArtigoFast.log cria ../bases-work/fast/artigo
echo "GeraArtigoFast: Fim de envio de bases"
