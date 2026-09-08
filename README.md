# Web
SciELO Web


A partir da versão **5.45.2**, copiar os arquivos `gizmo.*`, disponíveis em `bases_modelo/gizmo` para o diretório `bases/gizmo` da aplicação implantada.
Caso a página do site não carregue conforme esperado, execute também:

```
proc/cisis/id2i bases/gizmo/gizmo.id create=bases/gizmo/gizmo
```

## Configuração do servidor SciELO

Defina o hostname público que será gravado em `htdocs/scielo.def.php` criando um
arquivo `.env` no mesmo diretório do `docker-compose.yml`:

```dotenv
SERVER_SCIELO=cienciaecultura.bvs.br
STANDARD_LANG=pt
ACTIVATE_GOOGLE=1
GOOGLE_CODE=UA-6060112-1
```

Informe somente o hostname ou endereço IP, sem `http://` ou `https://`. Uma porta
opcional também pode ser usada, por exemplo `localhost:8080`.

Depois de definir ou alterar a variável, recrie o container:

```sh
docker compose up -d --force-recreate
```

`STANDARD_LANG` define o idioma padrão da interface. Use um código de idioma em
letras minúsculas, como `pt`, `es`, `en` ou `nso`.

Para ativar o Google Analytics, use `ACTIVATE_GOOGLE=1` e informe o identificador
da propriedade em `GOOGLE_CODE`. Para desativá-lo, use `ACTIVATE_GOOGLE=0`.

O `.env` é complementar ao `scielo.def.php`: valores não vazios definidos no
`.env` têm precedência e são aplicados em cada inicialização; variáveis ausentes
ou vazias preservam o arquivo e o valor existente no `scielo.def.php`. Quando o
arquivo já existe no diretório montado, ele não é substituído pelo template. O
template só é copiado quando `scielo.def.php` ainda não existe. O arquivo `.env`
é local e não deve ser versionado.
