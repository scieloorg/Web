# Sobre o diretório google_metrics

Este diretório contém a implementação do endpoint `/google_metrics/get_h5_m5.php`
que é responsável pela inclusão destes indicadores na página dos periódicos. 

O endpoint recebe como argumento o ISSN do periódico e retorna algo como:

`GET /google_metrics/get_h5_m5.php?issn=0034-8910 HTTP/1.1`

Resposta: 

```javascript
{
    "year":"2017",
    "h5":"36",
    "m5":"47",
    "url":"http:\/\/scholar.google.com\/citations?view_op=list_hcore&venue=ufx6JcDSjHYJ.2017&hl=en"
}
```

Os dados retornados da requisição são resultado de uma consulta ao arquivo
`htdocs/google_metrics/journals_url.csv`, que é atualizado anualmente quando 
o Google nos envia os dados atualizados. O Google geralmente nos envia
(ao Abel e Ednilson) estes dados por email, contendo um arquivo csv para cada 
coleção da Rede. Exemplo:

```bash
$ ls -la
total 616
drwx------@ 17 gustavofonseca  staff     544 15 Fev 17:45 .
drwx------+ 15 gustavofonseca  staff     480 15 Fev 17:42 ..
-rwxr-xr-x@  1 gustavofonseca  staff   14722 15 Fev 17:41 scielo.conicyt.cl.csv
-rwxr-xr-x@  1 gustavofonseca  staff     522 15 Fev 17:41 scielo.iics.una.py.csv
-rwxr-xr-x@  1 gustavofonseca  staff    5809 15 Fev 17:41 scielo.isciii.es.csv
-rwxr-xr-x@  1 gustavofonseca  staff    8443 15 Fev 17:41 scielo.sld.cu.csv
-rwxr-xr-x@  1 gustavofonseca  staff   38087 15 Fev 17:41 www.scielo.br.csv
-rwxr-xr-x@  1 gustavofonseca  staff    1679 15 Fev 17:41 www.scielo.edu.uy.csv
-rwxr-xr-x@  1 gustavofonseca  staff   11087 15 Fev 17:41 www.scielo.org.ar.csv
-rwxr-xr-x@  1 gustavofonseca  staff   28076 15 Fev 17:41 www.scielo.org.co.csv
-rwxr-xr-x@  1 gustavofonseca  staff   16613 15 Fev 17:41 www.scielo.org.mx.csv
-rwxr-xr-x@  1 gustavofonseca  staff    2390 15 Fev 17:41 www.scielo.org.pe.csv
-rwxr-xr-x@  1 gustavofonseca  staff    2742 15 Fev 17:41 www.scielo.org.ve.csv
-rwxr-xr-x@  1 gustavofonseca  staff    5281 15 Fev 17:41 www.scielo.org.za.csv
-rwxr-xr-x@  1 gustavofonseca  staff    2538 15 Fev 17:41 www.scielo.sa.cr.csv
-rwxr-xr-x@  1 gustavofonseca  staff    2563 15 Fev 17:41 www.scielosp.org.csv
```

Os arquivos deverão ser concatenados em um só csv de nome `scielonetwork.csv`:

```bash
$ head -n 1 www.scielo.br.csv && for filename in $(ls *scielo*.csv); do tail -n +2 $filename; done > scielonetwork.csv
```

E então produzir o arquivo final de nome `journals_url.csv` com um simples 
script Python:

```python
import csv
with open('scielonetwork.csv', 'rb') as infile:
    reader = csv.DictReader(infile)
    with open('journals_url.csv', 'w') as outfile:
        writer = csv.DictWriter(outfile, fieldnames='issn year title h5 m5 url'.split())
        writer.writeheader()
        for row in reader:
            for issn in row['ISSN'].split(','):
                writer.writerow({'issn': issn, 'year': '2018', 
                                 'title': row['Title'], 'h5': row['H5-index'], 
                                 'm5': row['H5-median'], 'url': row['URL']})
```
