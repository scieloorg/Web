Pacote de processamento para pesquisa de doi (DOI Query)

Cinco Programas:

./doi/create/doi4art.bat
	cria ou atualiza registros na base doi (correspondente ao acronimo e numero)
	para os artigos dos numeros da scilista
	parametro 1: scilista

	Usa bases-work/acron/acron
	Usa proc/scielo_crs/databases/crossref/crossref_DOIReport
	Cria ou atualiza bases-work/doi/controler
	Cria ou atualiza bases-work/doi/acron/issue/issue

./doi/create/doi4ref.bat
	cria ou atualiza registros na base doi (correspondente ao acronimo e numero) 
	para as referencias bibliograficas dos numeros da scilista
	parametro 1: scilista

	Usa bases-work/acron/acron
	Cria ou atualiza bases-work/doi/controler
	Cria ou atualiza bases-work/doi/acron/issue/issue

./doi/scilista/scilista4art.bat
	Cria uma scilista para os registros h, baseado na base de controle do DOI depositados e tambem na base doi, identificando os que faltam
	parametro 1: arquivo scilista a ser gerado

	Usa bases-work/acron/acron
	Usa bases-work/doi/acron/issue/issue
	Usa proc/scielo_crs/databases/crossref/crossref_DOIReport
	Gera em ../bases-work/doi/scilista/<date>, uma scilista por revista e uma scilista (parametro 1) com todos juntos 

./doi/scilista/scilista4ref.bat
	Cria uma scilista para os registros c, baseado na base de controle do DOI depositados e tambem na base doi, identificando os que faltam
	parametro 1: arquivo scilista a ser gerado

	Usa bases-work/acron/acron
	Usa bases-work/doi/acron/issue/issue
	Usa proc/scielo_crs/databases/crossref/crossref_DOIReport
	Gera em ../bases-work/doi/scilista/<date>, uma scilista por revista e uma scilista (parametro 1) com todos juntos 

./doi/report/ReadScilista.bat
	Gera um arquivo de relatorio dado uma scilista, o nome do arquivo de relatorio, seu formato e a selecao de registros

	parametro 1: scilista
	parametro 2: nome do arquivo do relatorio
	parametro 3: formato do arquivo: xml ou seq
	parametro 4: filtro dos registros: status doi ou not_doi ou all
	parametro 5: filtro dos registros tipo de registro art ou ref ou all

