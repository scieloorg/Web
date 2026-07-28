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
```

Informe somente o hostname ou endereço IP, sem `http://` ou `https://`. Uma porta
opcional também pode ser usada, por exemplo `localhost:8080`.

Depois de definir ou alterar a variável, recrie o container:

```sh
docker compose up -d --force-recreate
```

O entrypoint aplica o valor de `SERVER_SCIELO` ao `scielo.def.php` em cada
inicialização. O arquivo `.env` é local e não deve ser versionado.
