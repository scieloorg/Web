#!/bin/bash
ARQUIVO="${1:-temp/GeraArtigoFastGeraPadraoStatus.ctrl}"
LIMIAR="${2:-72}"
EMAIL="${3:-tecnologia@scielo.org}"

[ -f "$ARQUIVO" ] || exit 0
[ "$(tr -d '\r' < "$ARQUIVO")" == "RUNNING" ] || exit 0

MTIME=$(stat -c %Y "$ARQUIVO" 2>/dev/null || stat -f %m "$ARQUIVO")
IDADE=$(( ($(date +%s) - MTIME) / 3600 ))
[ "$IDADE" -ge "$LIMIAR" ] || exit 0

DESDE=$(date -d "@$MTIME" +%d/%m/%Y\ %H:%M:%S 2>/dev/null || date -r "$MTIME" +%d/%m/%Y\ %H:%M:%S)

cat >temp/GeraArtigoFastGeraPadraoStatusMessage.txt <<!
A equipe de Infraestrutura,
Processamento GeraPadrao esta executando ha ${IDADE}h (limite: ${LIMIAR}h), status RUNNING desde ${DESDE}.
Favor verificar.
Processamento SciELO
!
mailx -s "[ALERTA-GeraArtigoFast] GeraPadrao RUNNING ${IDADE}h desde ${DESDE}" "$EMAIL" < temp/GeraArtigoFastGeraPadraoStatusMessage.txt
rm temp/GeraArtigoFastGeraPadraoStatusMessage.txt

