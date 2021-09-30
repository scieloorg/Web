# scielo_network

## Objetivos

Enviar os metadados da coleção para o nó central para fornecer serviços no âmbito da rede SciELO.

Os metadados são de periódicos, fascículos e documentos, e lista de arquivos PDF dos documentos.


## Motivação

O envio de arquivos `.iso` atual apresenta muitos problemas, pois podem vir corrompidos.

Ausência nos metadados a informação dos PDFs correspondentes aos documentos e, esta informação é necessária para identificar os idiomas disponíveis dos documentos, principalmente quando têm tradução.


## Origem dos metadados

- `bases/title/title`
- `bases/artigo/artigo`
- `bases/pdf/*`


## Sobre os scripts

A partir de `bases/pdf/*` e do comando `find`, é obtida uma lista de pdfs no padrão:

```
../bases/pdf/<acron>/v17n1/v17n1a16-es.pdf
../bases/pdf/<acron>/v17n1/v17n1a04-es.pdf
../bases/pdf/<acron>/v17n1/v17n1a12-es.pdf
```

Esta lista é criada em um arquivo no diretório `temp/scielo_network`. E na sequência, é feita a transferência.

A partir de `bases-work/<acron>/<acron>` e `bases/title/title`, gera para cada base de dados, um arquivo do tipo `*.id` com o utilitário `cisis/i2id` no diretório temporário `temp/scielo_network`. E na sequência de cada geração de arquivo `*.id`, é feita a transferência.

A partir da scilista atual, `proc/scilista.lst`, é gerada uma base de dados ISIS temporária para cada item da lista em `temp/scielo_network`. Cada uma destas bases corresponde a registros de documentos de um fascículo, obtidos de `bases-work/<acron>/<acron>`. Para cada base de dados temporária é gerado um arquivo do tipo `*.id` com o utilitário `cisis/i2id` no diretório temporário `temp/scielo_network`. E na sequência de cada geração de arquivo `*.id`, é feita a transferência.

As credenciais das transferências podem ser obtidas de um dos arquivos: 

- transf/Envia2MedlineLogOn.txt
- transf/Envia2SciELOFastLogOn.txt
- transf/Envia2SciELONetworkLogOn.txt

Cada transferência envia o arquivo em si, seu arquivo compactado e um arquivo `scielo_network_time.log` contendo data, hora e evento ocorrido.

São executadas em concorrência as operações, disparadas nesta ordem:

- geração dos arquivos `scielo_network_artigo_*.id`
- geração dos arquivos `scielo_network_i_*.id`
- geração de `scielo_network_pdfs_list.txt`
- geração de `scielo_network_title.id`


# Script proc/Envia2SciELONetworkPadrao.bat

Chama `scielo_network/main.bat` com os parâmetros adequados.
