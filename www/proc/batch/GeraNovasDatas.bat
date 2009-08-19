rem GeraNovasDatas
rem Parametro 1: base title no ar
rem Parametro 2: lista atualizacao revista vol-num
rem Parametro 3: base novas datas

call batch/VerifPresencaParametro.bat $0 @$1 base title no ar
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 lista atualizacao revista vol-num
call batch/VerifExisteArquivo.bat $2
call batch/VerifPresencaParametro.bat $0 @$3 base novas datas

call batch/InformaLog.bat $0 x Gera Novas Datas: $3

$CISIS_DIR/mx "seq=$2 " pft=@pft/DatasLista.pft now -all > temp/NovasDatas.seq
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 passo 1

$CISIS_DIR/mx $1 pft=@pft/DatasSite.pft now -all >> temp/NovasDatas.seq
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 gera datas site

call batch/Seq2Master.bat temp/NovasDatas.seq pipe temp/NovasDatas

call batch/GeraInvertido.bat temp/NovasDatas fst/NovasDatas.fst temp/NovasDatas
