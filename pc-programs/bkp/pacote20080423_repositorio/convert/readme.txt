20010613
SciELO - problema na paginacao: se o número era 3 ele sumia. Explicação em parser2result no procedimento 4, caso o valor de h (format) é %, é usado para separar as ocorrencias, caso o conteúdo contenha espaço em branco, caso contrário os espaços em branco são usados para a quebra de linha (occ). O erro estava na programação, que ao invés de verificar se h=%, verificava o contrário, quebrando as occ em 3, que era o valor de h.

Novo sistema: Conference
tabelas de conversão


20010604
Novo sistema: Conference
tabelas de conversão

20010419
Thesis - tabelas de conversão para o elemento order ser gravado em todos os registros.


20010411
Scielo-lilacs: nome e sobrenome do autor PAULO M. C. DE; ou Fulano Dos Santos.

20010403
Thesis - problema na funcao de isodb.isoupdate: erro de isis.dll
	- criação de mais diretórios e campos no form para acessar o registro de configuração e construir a estrutura de diretórios.
	a) dir: orgname, ano, nome do diretório livre, base, nome da base segundo o diretório
	b) configuration: orgname, ano, nome e sobrenome do autor

20010328
BVSLaw - problema com tabelas em html colocadas em um único registro. Solução: criar arquivos com o conteúdo da tabela (conteúdo de <table></table>). 

20010319
BVSLaw - problema na função LawStructureLevel. Faltou set reg = copy.copy. Sem isso, a copia do "registro" nao era feita, então este era alterado em seguida, e a cada iteração, o registro ficava cada vez maior e com conteúdo errado, pois não era a cópia que era manipulada, senão o próprio registro.

20010308
BVSLaw - imagem está em registro errado, devido a separação de um trecho da lei em vários registros. Solução: tentar manter o máximo as partes em um mesmo registro em mais de uma ocorrência. Inserção de ^qb no fim de cada ocorrência quando se trata de uma quebra de parágrafo.

Outros problemas: alguns elementos faltaram no arquivo 2db, como figgrp, table, link com devidos elementos, nos escopos de body e attach. Solução copiar todos os arquivos da versao 1.3 para 1.2

20010302
Scielo - bug: alteração na busca das referencias no texto completo. Porque em alguns casos os trechos no texto completo pode estar separados em mais de uma linha.


20010301
BVSLaw - imagem no texto: novo elemento/atributo filename para identificar o nome do arquivo da imagem.
		subcampo: ^9
Scielo - alteração na busca das referencias no texto completo. Porque em alguns casos os trechos no texto completo pode estar separados em mais de uma linha.

20010219
Scielo - fazer link de author no body (como para as referencias)
	- alterar artmodel.mst
	- alterar programa
20010213
Scielo - fazer link de author no body (como para as referencias)
	- alterar artmodel.mst
	- alterar programa

20010209
Lilacs - campo 38 deve ser repetitivo e não com ocorrências separadas por %
	 campos de conferência

20010208
Scielo - registro lilacs - afiliacao nao está indo em alguns casos, provavelmente por causa da ausencia do endereço.

20010207
BVSLaw - formulário de administração da base não habilitado ao iniciar 
	-> fazer leitura dos dados de bvs antes.
	-> alterações em detalhes de visualização.

20010206
BVSLaw - arquivo bvslaw.ini,  state e as bases artigon foram tiradas.

20010201
BVSLaw - artno -> part e partno em link

20010124
BVSLaw - dava erro por usar strcomp sem o parametro de comparacao

20010123
BVSLaw - criar (registro de) index somente para partes, senao o registro estoura

20010116
Revista da FAPESP - tabelas

20010112
BVSLaw - o campo 67 de country nao estava sendo carregado com a nova versao, provocando erro na recuperação das palavras.
	- alterei também a montagem da estrutura das leis. Era gerado o mesmo valor de chave para conteúdos em escopos diferentes.


20010110
Lilacs - campo 38=nd -> nao enviar o campo 38
BVSLaw - inclusão de atributos para leis internacionais
	- faltou inserir o campo 67 de país no registro lilacs
	- novo campo em lawmod12 -> campo 904 para conteúdos repetitivos
	- como inserir dados de link??? -> 
		- texto do link está no campo 203^l (repetitivo)
		- as informações do link estão no campo 37 (repetitivo)
		- testes com link.pft (guardado em library\bvslaw)


20010109
BVSLaw - link -> bvslaw 1.2, inclusao de atributos para link


20010104
SciELO - scielo.ini -> apresentação dos títulos das revistas no formulário, excluindo as revistas usadas somente para relatórios e alteração do programa para não incluir linhas em branco no combo do formulário para as revistas excluídas

20010103
BVSLaw - estrutura de diretórios
	escopo apenas para leitura e comparacao com o documento -> modificação no arquivo bvslaw.ini em [CfgRec] e 
[DirInfo]

LILACS - criação de uma função que completa a localização da afiliação


20010102
BVSLaw - library
incluir atributos novos: lorgname, esource, scopegrp
alteracoes dos atributos: 
	authorsp - aparece em mais um nivel
	country - repetitivo
	title	- repetitivo, a marcacao deve inserir o caracter % entre cada ocorrencia. Alteracao no conversor para aceitar %.
		


20001222
Bvslaw - library
Erro na descricao das tabelas para os elementos flutuantes quando eles aparecem no front e no back.


20001219
- tratamento de part sem header
- article, paragraph, etc muito grandes, nao cabem em um único registro, dividir em mais de um.
- lilacs: 
	campo 38: codigo em minuscula, nd = "", fig = ilus
	campo 8: url do artigo


20001218
- tratamento de part sem header
- article, paragraph, etc muito grandes, nao cabem em um único registro, dividir em mais de um.

20001215
BVSLaw 
- tratamento de part sem header
- article, paragraph, etc muito grandes, nao cabem em um único registro, dividir em mais de um.

20001214
Deixar  o menu habilitado opcionalmente para Administracao das bd.

20001212
Thesis
Arquivos de entrada e library e labels
Inclui campo 709 para guardar o nome da DTD
Os nomes dos diretorios em caixa baixa.

20001127
Fazer os descritores tag scheme, campo 85, repetitiva, acompanhando cada keyword.
Alterei artmodel os registros de scheme e keyword, acrescentando em ambos o campo v5 com conteudo keygrp:, assim sendo, o conteudo de cada campo v85 (scheme ou keyword) sao ligados por um indice, isto é, o conteúdo do subcampo ^i.

20001121
Administração das Bases de Dados - Recriar a base iso-list

20001116 - bvslaw
Testes - Arquivo com estouro do limite de registro

20001116 - bvslaw
Arquivo com estouro do limite de registro.

20001116
Para procurar as referências do markup no texto completo, estava faltando remover do body as entidades &lt; e &gt;, as quais foram incluidas no arquivo enthtml.txt do diretorio common.

Titulo das revistas no registro l da Lilacs nao estava sendo convertido para DOS.

20001113
Adminsitracao da base de dados - Regerar a base de administracao a partir das bases de dados que foram geradas pelo conversor

20001108
Procurar simplificar o conversor
Funcao para administrar a base de dados para gerar registros na base de administracao para as bases geradas antes da existencia desta base de administracao.

20001107
Para procurar as referências do markup no texto completo, estava faltando remover do markup as entidades, além disso, na funcao de busca por uma referencia estava incorreto o modo de atualizar as informacoes da 'compactacao' das referências marcadas e, por isso, a funcao nao conseguia encontrar as demais.

20001031
Adminsitracao da base de dados
Permitir que sejam apagadas as bases criadas pelo conversor

20001019
Form About

Versao generica do conversor
Lilacs