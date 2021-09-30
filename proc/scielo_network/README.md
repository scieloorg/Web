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

A partir de `bases/title/title`, gera um arquivo do tipo `*.id` com o utilitário `cisis/i2id` no diretório temporário `temp/scielo_network` e, na sequência, é feita a transferência.

A partir de `scielo_network_in.txt`, obtido do ftp cadastrado e que contém a lista de PID + data de atualização do registro da base ISIS, é gerada uma lista com os documentos novos e/ou atualizados consultando `bases-work/artigo/artigo`. A partir da lista que contém os itens novos ou atualizados, um arquivo `artigo_*.id` é gerado no diretório temporário `temp/scielo_network` para cada documento usando o utilitário `cisis/i2id` e sua transferência é feita.


As credenciais das transferências podem ser obtidas de um dos arquivos: 

- transf/Envia2MedlineLogOn.txt
- transf/Envia2SciELOFastLogOn.txt
- transf/Envia2SciELONetworkLogOn.txt

Cada transferência envia o arquivo em si, seu arquivo compactado e um arquivo `scielo_network_time.log` contendo acúmulo de data, hora e eventos ocorridos.

São executadas em concorrência as operações:

- geração dos arquivos `scielo_network_artigo_*.id`
- geração de `scielo_network_pdfs_list.txt`
- geração de `scielo_network_title.id`
- geração dos arquivos `scielo_network_i_*.id`


# Script proc/Envia2SciELONetworkPadrao.bat

Chama `scielo_network/main_generate_and_transfer_new_and_updated.bat` com os parâmetros adequados.
