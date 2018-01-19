#!/bin/bash

# Substitui scilistatest_bkp.sh
# Substitui coletaxml_bkp.sh


# Verifica o formato da scilista
# Verifica a existência das bases provenientes do serial XML
# Verifica e trata a existência de mais de uma base de ahead
# Executa a coleta das bases do serial XML
# Executa o append das bases ahead, se aplicavel. Evita a duplicidade.
# Em caso de erros, interrompe e envia email indicando os erros.
# Em caso de sucesso, envia email indicando que foi bem sucedido
# e pode ser executar o processa.sh
./scilistatest_and_coletaxml.py
