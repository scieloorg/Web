#!/bin/bash

. xml_preproc.ini

issuehtm=0
issuexml=0

dos2unix ../serial/scilistaxml.lst

if [ -e "../serial/issue/issue.mst" ]; then 
	issuehtm=$(date -r ../serial/issue/issue.mst +%s)
fi

if [ -e "../serial_xml/issue/issue.mst" ]; then 
	issuexml=$(date -r ../serial_xml/issue/issue.mst +%s)
fi

echo HTM = $issuehtm
echo XML = $issuexml

if [ "$issuehtm" -ge "$issuexml" ]; then 
	echo HTML  mais recente.
else 
	echo Monta a partir de serial_xml
	cp -r ../serial_xml/title ../serial/
	cp -r ../serial_xml/issue ../serial/
	cp -r ../serial_xml/code ../serial/
fi

#Gera uma scilista.lst de HTML, caso não exista
if [ ! -e "../serial/scilista.lst" ]; then 
	echo "Gera uma scilista vazia para HTML"
	touch ../serial/scilista.lst
fi

#Analisa scilistaxml e grava os erros no arquivo scilista-erros.txt
echo Analisando scilistas...
./scilistatest.py


#Vefica se os issues da scilistaxml existem na base 
# ../serial/issue que chegou para processamento.
ISSUES=`cat ./NOT_REGISTERED.txt`

if [ "$(ls -l scilista-erros.txt | cut -d' ' -f5)" -ge "5" ]; then

echo "Envia e-mail para avisar de erros na scilistaxml.lst"

cat >msg-erro.txt <<!
Prezados,

Foram encontrados erros na scilistaxml.lst do processamento $XMLPREPROC_COLLECTION_NAME de $(date '+%d/%m/%Y'). Por favor verifiquem:

!

cat scilista-erros.txt >> msg-erro.txt

cat >>msg-erro.txt <<!

Apos a correcao reenviar a scilista para processamento.

!

if [ ! -z "$ISSUES" ]; then
cat >>msg-erro.txt <<!
Ha fasciculos na scilista que nao estao na base ISSUE recebida para o processamento.
Por favor, verificar e reenviar a base para o processamento (EnviaBasesSciELOPadrao.bat).
Fasciculos ausentes na base:

$ISSUES

!
fi

cat >>msg-erro.txt <<!
Data e hora da scilistaxml.lst testada: $(stat -c %z ../serial/scilistaxml.lst | cut -c 1-16)

Conteudo da scilistaxml.lst testada:

!
cat ../serial/scilistaxml.lst >> msg-erro.txt

cat >>msg-erro.txt <<!



ATENCAO: Mensagem automatica. Nao responder a este e-mail.

SciELO - Scientific Electronic Library Online 
FAPESP CNPq FapUnifesp BIREME

!

mailx $XMLPREPROC_MAILTO -c "$XMLPREPROC_MAILTOCC" -s "Erros na scilistaxml.lst - $XMLPREPROC_COLLECTION_NAME - $(date '+%d/%m/%Y')" < msg-erro.txt

else

echo "Envia e-mail para avisar que esta tudo ok"

cat >msg-ok.txt <<!
Prezados,

A scilistaxml.lst do processamento $XMLPREPROC_COLLECTION_NAME de $(date '+%d/%m/%Y') esta correta.

Data e hora da scilistaxml.lst testada: $(stat -c %z ../serial/scilistaxml.lst | cut -c 1-16)

Conteudo da scilistaxml.lst testada:

!
cat ../serial/scilistaxml.lst >> msg-ok.txt

cat >>msg-ok.txt <<!



Iniciaremos o processamento em breve.

obrigado,


SciELO - Scientific Electronic Library Online 
FAPESP CNPq FapUnifesp BIREME

[pok]

!

mailx $XMLPREPROC_MAILTO -c "$XMLPREPROC_MAILTOCC" -s "Scilistaxml.lst - $XMLPREPROC_COLLECTION_NAME - $(date '+%d/%m/%Y') esta OK" < msg-ok.txt

fi
