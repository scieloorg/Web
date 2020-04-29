#!/bin/bash

# Substitui v1.0/scilistatest.sh
#    v1.0/scilistatest.py
#    v1.0/checkissue.py
# Substitui v1.0/coletaxml.sh
#    v1.0/getbasesxml4proc.py
#    v1.0/joinlist.py

# Diferencas
# Corrige bug de validacao de formato da scilista
# Ao verificar cada item da lista tambem verifica se existe a base correspondente na pasta "serial do XML"
# Ao localizar mais de uma base ahead (proc/serial e "serial do XML"), verifica se sao bases diferentes ou igual, evitando duplicacao de registros
# Em caso de erro em qualquer etapa, interrompe e envia email indicando os erros.
# Em caso de sucesso em todas as etapas, envia email indicando que foi bem sucedido
# (conteudo da mensagem do email mudou para incluir mais informacao)
#
# Entrada:
#  - arquivo de configuracao chamado xmlpreproc_config_<diretorio da colecao>.ini 
#    (Exemplo: xmlpreproc_config_scl.000.ini)
# Saidas:
#  - xmlpreproc_outs.log (registro dos procedimentos efetuados)
#  - xmlpreproc_outs_scilista-erros.txt (anteriormente era scilista-erros.txt)
#  - xmlpreproc_outs_msg-ok.txt (anteriormente era msg-ok.txt)
#  - xmlpreproc_outs_msg-erro.txt (anteriormente era msg-erro.txt)

# Faz parte deste script
# scilistatest.sh
# scilistatest_and_coletaxml.py
# coletaxml.sh (vazio, porque eh chamado en menu_processamento.sh)

./scilistatest_and_coletaxml.py
