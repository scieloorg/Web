<?
/**
* definição das constantes para os rótulos dos formulários
* usados para multilanguage
*/

include_once(dirname(__FILE__)."/../../../php/include.php");


$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def" , true);
$url = $ini['scielo_org_urls']['home'];

$langs = array("pt","en","es");

if(!in_array($lang,$langs)){
	$lang = "pt";
}

if($lang == "pt")
{
/*
rótulos tela DATASUS
*/
define("DATASUS","Indicadores de Saúde");

/*
rótulos tela Article References
*/
define("SCIELO.ORG"," indicou um artigo para você.");
define("ARTICLE_REFERENCES","Referências do Artigo");
define('NO_DATA_FOR_GRAPHIC','Gráfico não disponível, dados em processamento.');

/*
rótulos para a tela envio de artigo por email
*/
define("TO_EMAIL","Email do destinatário:");
define("TO_NAME","Nome do destinatário:");
define("COMMENTS","Comentários:");
define("ARTICLE_TITLE","Título: ");
define("ARTICLE_SUGGESTION","SciELO: Artigo recomendado de ");
/*
rótulos para a tela envio de nova senha
*/
define("FORGOT_TITLE","Envio de nova senha");
define("BUTTON_SEND_NEW_PASSORD","Enviar nova senha");
define("UNKNOW_USER_ERROR","Usuário não encontrado");
define("SEND_NEW_PASSWORD_SUCCESS","Senha enviada com sucesso !!!");

/*
rótulos para a tela de login
*/
define("HELLO_STRING","Olá, ");
define("EDIT_USER_DATA","Meus dados");
define("LOGIN_TITLE","Login de usuário");
define("BUTTON_LOGIN","Login");
define("BUTTON_LOGOUT","Sair");
define("FORGOT_PASSWORD","Enviar-me nova senha  ");
define("REGISTER","Cadastre-se");
define("FOR_SERVICES","para serviços personalizados");
define("LOGIN_ERROR","Login/Senha inválidos");
define("FIELD_LOGIN_ALREADY_EXISTS","Login já existe !!!");
define("REQUIRED_FIELD_TEXT"," * Campos Obrigatórios");
define("LOGOUT_DONE","Logout realizado com sucesso !!!");
define("NOT_LOGED","Usuário não logado, por favor, visite <a target=\"_blank\" href=\"".$url."\">Scielo</a> e se logue");

/*
rotulos da tela de cadastro/alteracao de usuario
*/
define("REGISTER_NEW_USER_TITLE","Cadastro de Novo Usuário");
define("UPDATE_USER_TITLE","Atualização dos dados");
define("FIELD_FIRST_NAME","Nome");
define("FIELD_LAST_NAME","Sobrenome");
define("FIELD_GENDER","Sexo");
define("FIELD_GENDER_MALE","Masculino");
define("FIELD_GENDER_FEMALE","Feminino");
define("FIELD_PASSWORD","Senha");
define("FIELD_PASSWORD_CONFIRMATION","Confirmação");
define("FIELD_PASSWORD_CHANGE_MESSAGE","(somente preencha caso deseje alterar sua senha)");
define("FIELD_EMAIL","E-Mail");
define("FIELD_LOGIN","Login");
define("FIELD_AFILIATION","Instituição");
define("FIELD_DEGREE","Select|Selecione,Ensino_Fundamental|Ensino Fundamental (1o Grau),Ensino_Medio|Ensino Médio (2o Grau),Ensino_Tecnico|Ensino Profissional De Nível Técnico,Graduacao|Graduação,Especializacao|Especialização,Mestrado_Profissionalizante|Mestrado Profissionalizante,Mestrado|Mestrado,Doutorado|Doutorado,MBA|MBA,Pos_Doutorado|Pós Doutorado,PHD|PHD");
define("STEP","Passo");
define("OF","de");

/*
rótulos para o cadastro de avise-me
*/
define("ADD_TO_SHELF_OK","Artigo adicionado à coleção com sucesso !!!");
define("REMOVE_FROM_SHELF_OK","Artigo removido da coleção com sucesso !!!");
define("REMOVE_CITED_ALERT_OK","Alerta de citação removido com sucesso !!!");
define("REMOVE_ACCESS_ALERT_OK","Alerta de acesso removido com sucesso !!!");
define("ALERT_CITED_OK","Aviso quando for citado cadastrado com sucesso !!!");
define("ALERT_ACCESSED_OK","Cadastro para envio de estatísticas de acesso realizado com sucesso !!!");

/*
rótulos dos links para os serviços de usuários
*/
define("PERSONAL_DATA","Dados pessoais");
define("PROFILE","Perfil");
define("PROFILES","Perfis");
define("VIEW_BY","Visualizar Lista por");
define("MY_SHELF","Minha Coleção");
define("MY_LINKS","Meus Links");
define("MY_NEWS","Minhas Noticias");
define("MY_ARTICLE_PROFILE","Artigos do Perfil");
define("MY_NEW_ARTICLE_PROFILE","Artigos Novos do Perfil");
define("ORDER_BY","Ordenado por");
define("RELEVANCE","Relevância");
define("DATE","Data");
define("MY_ALERTS","Meus Alertas");
define("REMOVE_FROM_SHELF","Remover da coleção");
define("CITATIONS","Citações");
define("ACCESS_STATS","Estatísticas de acessos");
define("ARTICLE_ACCESS","Acessos ao Artigo");
define("ACCESSES","Acessos");
define("MONTHS","Meses");
define("REMOVE_ALERT","Remover alerta");
define("REMOVE_ACCESS_ALERT","Não receber mais alertas de acessos desse artigo");
define("REMOVE_CITED_ALTER","Não receber mais alertas de citação desse artigo");
define("MONTH_LIST", "jan,fev,mar,abr,mai,jun,jul,ago,set,out,nov,dez");
define("CITED_BY","Citado Por");
define("SIMILARYS_IN","Similares em");
define("SEE","Ver");
define("SEE_HISTORY","Ver Histórico");
define("CHOOSE_PERIOD", "Escolha por ano:");
define("START_YEAR", "De:");
define("LAST_YEAR", "Até:");
define("BUTTON_REFRESH", "Atualizar gráfico");
define("GRAFIC_STATS_FALSE", "Não existem dados estatísticos para o período selecionado");
/*
textos das mensagens de erro
*/
define("FIELD_FIRST_NAME_ERROR_DESCRIPTION","*");
define("FIELD_LAST_NAME_ERROR_DESCRIPTION","*");
define("FIELD_GENDER_ERROR_DESCRIPTION","*");
define("FIELD_PASSWORD_ERROR_DESCRIPTION","*");
define("FIELD_EMAIL_ERROR_DESCRIPTION","*");
define("FIELD_LOGIN_ERROR_DESCRIPTION","*");
define("FIELD_PROFILE_ONE","Perfil 1");
define("FIELD_PROFILE_TWO","Perfil 2");
define("FIELD_PROFILE_TREE","Perfil 3");
define("FIELD_PROFILE_NAME","Nome");
define("FIELD_PROFILE_DESCRIPTION_TEXT","Descrição");
define("BUTTON_NEW_USER","Gravar");
define("BUTTON_UPDATE_USER","Atualizar");
define("BUTTON_BACK","Voltar");
define("BUTTON_CANCEL","Cancelar");
define("BUTTON_CLOSE","Fechar");
define("REGISTER_NEW_USER_SUCESS","Dados Gravados com sucesso !!!");
define("UPDATE_USER_SUCESS","Dados Atualizados com sucesso !!!");

/*
textos para a paginação
*/
define("FIRST_PAGE","Primeira");
define("LAST_PAGE","Última");
define("PAGE","Página");

/*
textos para a régua de navegação
*/
define("HOME","home");
define("SEARCH_JOURNALS","Pesquisa periódicos");
define("JOURNALS_ALPHABETIC_LIST","Periódicos por ordem alfabética");

/*
segundo nivel SciELO em números
*/
define("NUMBERS","SciELO em números");
define("CITATION","Citações");
define("CO_AUTHORS","Co-autoria");
define("USAGE","Uso do site");
define("BRASIL","Brasil");
define("CHILE","Chile");
define("CUBA","Cuba");
define("PUBLIC_HEALTH","Saúde Pública");
define("SPAIN","Espanha");
define("VENEZUELA","Venezuela");

/*
pesquisa por titulos
*/
define("FIND_RESULTS","resultados encontrados :");

/*
artigos do meu perfil
*/
define("TOOLS","Ferramentas");

/*
minhas noticias
*/
define("ADD","Adicionar");
define("ADD_FEED","Adicionar RSS Feed");
define("REMOVE_FEED","Remover RSS Feed");
define("RSS_PROBLEM","Ocorreu um erro ao tentar abrir o RSS Feed");
define("REMOVE_FEED_CONFIRM","Confirma a remoção do Feed ?");
define("PUBLISH_IN_HOME_PAGE","Publicar na Home Page");
define("REMOVE_FROM_HOME_PAGE","Remover da Home Page");
define("ALL_FEEDS","Todos os Feeds");
/*
meus links
*/
define("ADD_LINK","Adicionar Link");

/*
	USER SHELF FOLDERS
*/

define("MONITORED_ACCESS","acesso monitorado");
define("MONITORED_CITATIONS","citações monitoradas");
define("MOVE_TO","mover para");
define("MY_FOLDERS","Minhas Pastas");
define("ADD_FOLDER","Adicionar pasta");
define("INCOMING_FOLDER","Pasta de Entrada");
define("DATE_SORT","Data");
define("MY_RANKING","Meu ranking");
define("EDIT_FOLDER","Editar Pasta");
define("DELETE_FOLDER","Remover Pasta");
define("FOLDER_NAME","Nome da Pasta");
define("MOVE_FOLDER_TO","Mover Para");
define("BUTTON_MOVE","mover");
define("BUTTON_CANCEL","cancelar");
define("BUTTON_REMOVE","remover");
define("BUTTON_EDIT","editar");
define("BUTTON_CREATE","salvar");
define("MOVE_CONTENT_TO_OTHER_FOLDER","mover conteúdo para outra pasta");
define("REMOVE_CONTENT","remover conteúdo");
define("SHOW_BY_RATE"," por Ranking");
define("SHOW_BY_DATE"," por Data");

/*
 USER LINKS
*/

define("REMOVE_LINK","deletar link");
define("EDIT_LINK","editar link");
define("ADD_LINK","Incluir link");
define("LINK_TITLE","Título do Link");
define("LINK_URL","URL do Link");
define("LINK_DESCRIPTION","Descrição do Link");
define("IN_HOME","página inicial");
define("DO_YOU_REALY_WANT_TO_REMOVE_IT","Deseja realmente excluir este link?");
define("ENVIAR_ARTIGO_POR_EMAIL","Enviar artigo por e-mail");
define("SEND","enviar e-mail");
define("CLOSE","fechar janela");
define("ARTICLE_SUBMITED_WITH_SUCCESS","artigo enviado com sucesso");
define("SEARCHING_IN","buscando em");
define("SIMILARITY","relevância");
/*
Collexis Instances Name
*/
define("ARR","SCI_OVERALL|SciELO Regional,SCI_SCIELOBR|SciELO Brasil,SCI_SCIELOCL|SciELO Chile,SCI_SCIELOCB|SciELO Cuba,SCI_SCIELOESP| SciELO Espanha,SCI_SCIELOVE|SciELO Venezuela,SCI_SCIELOSP|SciELO Saúde Pública,SCI_SCIELOSS|SciELO Ciências Sociais");

define("FULL_TEXT","texto completo");
}


if ($lang=="en")
{

/*
rótulos tela DATASUS
*/
define("DATASUS","Health Indicators");

/*
rótulos tela Article References
*/

define("ARTICLE_REFERENCES","Article References");
define('NO_DATA_FOR_GRAPHIC','Graphic unavailable, data in processing.');

/*
rótulos para a tela envio de artigo por email
*/
define("TO_EMAIL","To Email:");
define("TO_NAME","To:");
define("COMMENTS","Comments:");
define("ARTICLE_TITLE","Title: ");
define("ARTICLE_SUGGESTION","SciELO: Recommended article from ");

/*
rótulos para a tela envio de nova senha
*/
define("FORGOT_TITLE","New password send");
define("BUTTON_SEND_NEW_PASSORD","Send new password");
define("UNKNOW_USER_ERROR","User not found");
define("SEND_NEW_PASSWORD_SUCCESS","New password sent successfully !!!");

/*
rótulos para a tela de login
*/
define("HELLO_STRING","Hello, ");
define("EDIT_USER_DATA","Edit user data");
define("LOGIN_TITLE","User Login");
define("BUTTON_LOGIN","Login");
define("BUTTON_LOGOUT","Logout");
define("FORGOT_PASSWORD","Send me a new password");
define("REGISTER","Register");
define("FOR_SERVICES","for personalized services");
define("LOGIN_ERROR","User/Login invalid");
define("LOGOUT_DONE","Logout was made successfully !!!");
define("NOT_LOGED","User not logged, please, visit <a target=\"_blank\" href=\"".$url."\">Scielo</a> and log in");

/*
rotulos da tela de cadastro/alteracao de usuario
*/
define("REGISTER_NEW_USER_TITLE","New user registration");
define("UPDATE_USER_TITLE","Update user data");
define("FIELD_FIRST_NAME","First Name");
define("FIELD_LAST_NAME","Last Name");
define("FIELD_GENDER","Gender");
define("FIELD_GENDER_MALE","Male");
define("FIELD_GENDER_FEMALE","Female");
define("FIELD_PASSWORD","Password");
define("FIELD_PASSWORD_CONFIRMATION","Confirmation");
define("FIELD_PASSWORD_CHANGE_MESSAGE","(fill it in only to change the password)");
define("FIELD_EMAIL","E-Mail");
define("FIELD_LOGIN","Login");
define("FIELD_AFILIATION","Afilliation");
define("FIELD_DEGREE","Select|Select,Ensino_Fundamental|Basic Education,Ensino_Medio|High School,Ensino_Tecnico|Technical Studies,Graduacao|Graduate Study,Especializacao|Specialization,Mestrado_Profissionalizante|Professional Master's Degree,Mestrado|Master's Degree,Doutorado|Doctorate,MBA|MBA,Pos_Doutorado|Post Doctorate,PHD|PhD");
define("FIELD_LOGIN_ALREADY_EXISTS","Login already exists !!!");
define("REQUIRED_FIELD_TEXT"," * Mandatory fields");
define("STEP","Step");
define("OF","of");

/*
rótulos para o cadastro de avise-me
*/
define("ADD_TO_SHELF_OK","Article added to collection successfully !!!");
define("REMOVE_FROM_SHELF_OK","Article removed from collection successfully !!!");
define("REMOVE_CITED_ALERT_OK","Citation alert removed successfully !!!");
define("REMOVE_ACCESS_ALERT_OK","Access alert removed successfully !!!");
define("ALERT_CITED_OK","Acknowledgment when article will be cited registered successfully !!!");
define("ALERT_ACCESSED_OK","Registration to receive statistics of access was made successfully !!!");

/*
rótulos dos links para os serviços de usuários
*/
define("PERSONAL_DATA","Personal data");
define("PROFILE","Profile");
define("PROFILES","Profiles");
define("VIEW_BY","View list by");
define("MY_SHELF","My Collection");
define("MY_LINKS","My Links");
define("MY_NEWS","My News");
define("MY_ARTICLE_PROFILE","Articles of my profiles");
define("MY_NEW_ARTICLE_PROFILE","New articles of my profiles");
define("ORDER_BY","Sorted by");
define("RELEVANCE","Relevance");
define("DATE","Date");
define("MY_ALERTS","My Alerts");
define("REMOVE_FROM_SHELF","Remove from collection");
define("CITATIONS","Citations");
define("ACCESS_STATS","Access Stats");
define("ARTICLE_ACCESS","Article Access");
define("ACCESSES","Access");
define("MONTHS","Months");
define("REMOVE_ALERT","Remove alert");
define("REMOVE_ACCESS_ALERT","I do not want to receive any further alerts of accesses of  this article");
define("REMOVE_CITED_ALTER","I do not want to receive any further alerts of citations to  this article");
define("MONTH_LIST", "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sept,Oct,Nov,Dec");
define("CITED_BY","Cited By");
define("SIMILARYS_IN","Similars in");
define("SEE","See");
define("SEE_HISTORY","See History");
define("CHOOSE_PERIOD", "Choose by Year:");
define("START_YEAR", "From:");
define("LAST_YEAR", "To:");
define("BUTTON_REFRESH", "Change graphic");
define("GRAFIC_STATS_FALSE", "Do not exists statistic data for the selected period");

/*
textos das mensagens de erro
*/
define("FIELD_FIRST_NAME_ERROR_DESCRIPTION","*");
define("FIELD_LAST_NAME_ERROR_DESCRIPTION","*");
define("FIELD_GENDER_ERROR_DESCRIPTION","*");
define("FIELD_PASSWORD_ERROR_DESCRIPTION","*");
define("FIELD_EMAIL_ERROR_DESCRIPTION","*");
define("FIELD_LOGIN_ERROR_DESCRIPTION","*");
define("FIELD_PROFILE_ONE","Profile 1");
define("FIELD_PROFILE_TWO","Profile 2");
define("FIELD_PROFILE_TREE","Profile 3");
define("FIELD_PROFILE_NAME","Name");
define("FIELD_PROFILE_DESCRIPTION_TEXT","Description");
define("BUTTON_NEW_USER","Record");
define("BUTTON_UPDATE_USER","Update");
define("BUTTON_BACK","Back");
define("BUTTON_CANCEL","Cancel");
define("BUTTON_CLOSE","Close");
define("REGISTER_NEW_USER_SUCESS","New user registration done successfully !!!");
define("UPDATE_USER_SUCESS","Update user data successfully !!!");

/*
textos para a paginação
*/
define("FIRST_PAGE","First");
define("LAST_PAGE","Last");
define("PAGE","Page");

/*
textos para a régua de navegação
*/
define("HOME","home");
define("SEARCH_JOURNALS","Search by journals");
define("JOURNALS_ALPHABETIC_LIST","Periódicos por ordem alfabética");

/*
segundo nivel SciELO em números
*/
define("NUMBERS","SciELO in numbers");
define("CITATION","Citations");
define("CO_AUTHORS","Co-authors");
define("USAGE","Site usage");
define("BRASIL","Brasil");
define("CHILE","Chile");
define("CUBA","Cuba");
define("PUBLIC_HEALTH","Public Health");
define("SPAIN","Spain");
define("VENEZUELA","Venezuela");

/*
pesquisa por titulos
*/
define("FIND_RESULTS","results :");

/*
artigos do meu perfil
*/
define("TOOLS","Tools");

/*
minhas noticias
*/
define("ADD","Add");
define("ADD_FEED","Add RSS Feed");
define("REMOVE_FEED","Remove RSS Feed");
define("RSS_PROBLEM","An error has occurred when trying open the RSS Feed");
define("REMOVE_FEED_CONFIRM","Are you sure ?");
define("PUBLISH_IN_HOME_PAGE","Publish in Home Page");
define("REMOVE_FROM_HOME_PAGE","Remove from Home Page");
define("ALL_FEEDS","All Feeds");


/*
	USER SHELF FOLDERS
*/

define("MONITORED_ACCESS","monitored access");
define("MONITORED_CITATIONS","monitored citations");
define("MOVE_TO","move to");
define("MY_FOLDERS","My Folders");
define("ADD_FOLDER","Add folder");
define("INCOMING_FOLDER","Incoming Folder");
define("SHOW_FOLDERLIST_BY","show list by:");
define("DATE_SORT","Date");
define("MY_RANKING","My ranking");
define("EDIT_FOLDER","Edit Folder");
define("DELETE_FOLDER","Remove Folder");
define("FOLDER_NAME","Folder Name");
define("MOVE_FOLDER_TO","Move to");
define("BUTTON_MOVE","move");
define("BUTTON_CANCEL","cancel");
define("BUTTON_REMOVE","remove");
define("BUTTON_EDIT","edit");
define("BUTTON_CREATE","create");
define("MOVE_CONTENT_TO_OTHER_FOLDER","move content to another folder");
define("REMOVE_CONTENT","remove content");
define("SHOW_BY_RATE"," by Ranking");
define("SHOW_BY_DATE"," by Date");

/*
 USER LINKS
*/

define("REMOVE_LINK","delete link");
define("EDIT_LINK","edit link");
define("ADD_LINK","add link");
define("LINK_TITLE","Link Title");
define("LINK_URL","Link URL");
define("LINK_DESCRIPTION","Link Description");
define("IN_HOME","show in home");
define("DO_YOU_REALY_WANT_TO_REMOVE_IT","Do you realy want to remove it?");
define("ENVIAR_ARTIGO_POR_EMAIL","Send article by mail");
define("SEND","send mail");
define("CLOSE","close window");
define("ARTICLE_SUBMITED_WITH_SUCCESS","article submited with success");
define("SEARCHING_IN","searching in");
define("SIMILARITY","similarity");
/*
Collexis Instances Name
*/
define("ARR","SCI_OVERALL|SciELO Regional,SCI_SCIELOBR|SciELO Brazil,SCI_SCIELOCL|SciELO Chile,SCI_SCIELOCB|SciELO Cuba,SCI_SCIELOESP| SciELO Spain,SCI_SCIELOVE|SciELO Venezuela,SCI_SCIELOSP|SciELO Public Health,SCI_SCIELOSS|SciELO Social Sciences");

define("FULL_TEXT","full text");
}

if ($lang=="es")
{

/*
rótulos tela DATASUS
*/
define("DATASUS","Indicadores de Salud");

/*
rótulos tela Article References
*/

define("ARTICLE_REFERENCES","Referencias del artículo");
define('NO_DATA_FOR_GRAPHIC','Gráfico no disponible, datos en procesamiento.');

/*
rótulos para a tela envio de artigo por email
*/
define("TO_EMAIL","Correo Electrónico del Destinatario:");
define("TO_NAME","Destinatario:");
define("COMMENTS","Comentários:");
define("ARTICLE_TITLE","Título: ");
define("ARTICLE_SUGGESTION","SciELO: Artículo recomendado de ");

/*
rótulos para a tela envio de nova senha
*/
define("HELLO_STRING","Hola, ");
define("FORGOT_TITLE","Nueva clave de acceso");
define("BUTTON_SEND_NEW_PASSORD","Envío de nueva clave de acceso");
define("UNKNOW_USER_ERROR","Usuario no encontrado");
define("SEND_NEW_PASSWORD_SUCCESS","Clave de acceso enviada con éxito");

/*
rótulos para a tela de login
*/
define("LOGIN_TITLE","Login de usuario");
define("EDIT_USER_DATA","Actualizar los datos personales");
define("BUTTON_LOGIN","Login");
define("BUTTON_LOGOUT","Salir");
define("FORGOT_PASSWORD","Envíeme una nueva clave de acceso");
define("REGISTER","Regístrese");
define("FOR_SERVICES","para servicios personalizados");
define("LOGIN_ERROR","Usuario/Clave inválidos");
define("LOGOUT_DONE","Logout realizado con éxito!!!");
define("NOT_LOGED","Usuario no logado, por favor, visitar <a target=\"_blank\" href=\"".$url."\">Scielo</a> y entrar");

/*
rotulos da tela de cadastro/alteracao de usuario
*/
define("REGISTER_NEW_USER_TITLE","Registro de nuevo usuario");
define("UPDATE_USER_TITLE","Actualización de sus datos");
define("FIELD_FIRST_NAME","Nombre");
define("FIELD_LAST_NAME","Apellido");
define("FIELD_GENDER","Género");
define("FIELD_GENDER_MALE","Masculino");
define("FIELD_GENDER_FEMALE","Femenino");
define("FIELD_PASSWORD","Clave de acceso");
define("FIELD_PASSWORD_CONFIRMATION","Confirmación");
define("FIELD_PASSWORD_CHANGE_MESSAGE","(Llene apenas si desea cambiar su clave de acceso)");
define("FIELD_EMAIL","Correo Electrónico");
define("FIELD_LOGIN","Login");
define("FIELD_AFILIATION","Instituición");
define("FIELD_DEGREE","Select|Selecione,Ensino_Fundamental|Enseñanza o Educación Básica,Ensino_Medio|Enseñanza o Educación Media,Ensino_Tecnico|Enseñanza o Educación Técnico-Profesional,Graduacao|Superior Universitario de Grado,Especializacao|Especialización,Mestrado_Profissionalizante|Maestría Profisionalizante,Mestrado|Maestría,Doutorado|Doctorado,MBA|MBA,Pos_Doutorado|Pos Doctorado,PHD|PhD");
define("FIELD_LOGIN_ALREADY_EXISTS","Login ya existe !!!");
define("REQUIRED_FIELD_TEXT"," * Campos obligatorios");
define("STEP","Passo");
define("OF","de");

/*
rótulos para o cadastro de avise-me
*/
define("ADD_TO_SHELF_OK","Artigo adicionado a la colección");
define("REMOVE_FROM_SHELF_OK","Artigo retirado de la colección");
define("REMOVE_CITED_ALERT_OK","Alerta de citación retirado");
define("REMOVE_ACCESS_ALERT_OK","Alerta de acesso retirado");
define("ALERT_CITED_OK","Alerta de cuando el artículo es citado fue registrado con éxito");
define("ALERT_ACCESSED_OK","Registro para recibimiento de estadísticas de acceso del artículo realizado con éxito");

/*
rótulos dos links para os serviços de usuários
*/
define("PERSONAL_DATA","Datos personales");
define("PROFILE","Perfil");
define("PROFILES","Perfiles");
define("VIEW_BY","Ver la Lista por");
define("MY_SHELF","Mi Colección");
define("MY_LINKS","Mis Enlaces");
define("MY_NEWS","Mis Notícias");
define("MY_ARTICLE_PROFILE","Artículos de mi perfil");
define("MY_NEW_ARTICLE_PROFILE","Artículos nuevos de mi perfil");
define("ORDER_BY","Ordenado por");
define("RELEVANCE","Relevancia");
define("DATE","Fecha");
define("MY_ALERTS","Mis Alertas");
define("REMOVE_FROM_SHELF","Retirar de mi colección");
define("CITATIONS","Citaciones");
define("ACCESS_STATS","Estadísticas de accesos");
define("ARTICLE_ACCESS","Accesos al artículo");
define("ACCESSES","Accesos");
define("MONTHS","Meses");
define("REMOVE_ALERT","Retirar alerta");
define("REMOVE_ACCESS_ALERT","No quiero más recibir alertas de accessos de este artículo");
define("REMOVE_CITED_ALTER","No quiero más recibir alertas de citaciones a este artículo");
define("MONTH_LIST", "ene,feb,mar,abr,mayo,jun,jul,ago,sept,oct,nov,dic");
define("CITED_BY","Citado Por");
define("SIMILARYS_IN","Similares en");
define("SEE","Ver");
define("SEE_HISTORY","Ver Histórico");
define("CHOOSE_PERIOD", "Elegir por año:");
define("START_YEAR", "De:");
define("LAST_YEAR", "Hasta:");
define("BUTTON_REFRESH", "Actualizar gráfico");
define("GRAFIC_STATS_FALSE", "No hay datos estadísticos para el periodo elegido");
/*
textos das mensagens de erro
*/
define("FIELD_FIRST_NAME_ERROR_DESCRIPTION","*");
define("FIELD_LAST_NAME_ERROR_DESCRIPTION","*");
define("FIELD_GENDER_ERROR_DESCRIPTION","*");
define("FIELD_PASSWORD_ERROR_DESCRIPTION","*");
define("FIELD_EMAIL_ERROR_DESCRIPTION","*");
define("FIELD_LOGIN_ERROR_DESCRIPTION","*");
define("FIELD_PROFILE_ONE","Perfil 1");
define("FIELD_PROFILE_TWO","Perfil 2");
define("FIELD_PROFILE_TREE","Perfil 3");
define("FIELD_PROFILE_NAME","Título");
define("FIELD_PROFILE_DESCRIPTION_TEXT","Descripción");
define("BUTTON_NEW_USER","Record");
define("BUTTON_UPDATE_USER","Update");
define("BUTTON_BACK","Volver");
define("BUTTON_CANCEL","Cancelar");
define("BUTTON_CLOSE","Cerrar");
define("REGISTER_NEW_USER_SUCESS","Nuevo usuario registrado con éxito");
define("UPDATE_USER_SUCESS","Actualización de datos hecha con éxito");

/*
textos para a paginação
*/
define("FIRST_PAGE","Primera ");
define("LAST_PAGE","Última");
define("PAGE","Página");

define("HOME","home");
define("SEARCH_JOURNALS","Búsqueda por Periódicos");
define("JOURNALS_ALPHABETIC_LIST","Periódicos por ordem alfabética");

/*
segundo nivel SciELO em números
*/
define("NUMBERS","SciELO en números");
define("CITATION","Citas de revistas");
define("CO_AUTHORS","Co-autoria");
define("USAGE","Uso del sitio");
define("BRASIL","Brasil");
define("CHILE","Chile");
define("CUBA","Cuba");
define("PUBLIC_HEALTH","Salud Pública");
define("SPAIN","España");
define("VENEZUELA","Venezuela");

/*
pesquisa por titulos
*/
define("FIND_RESULTS","resultados encontrados :");

/*
artigos do meu perfil
*/
define("TOOLS","Herramientas");

/*
minhas noticias
*/
define("ADD","Añadir RSS Feed");
define("ADD_FEED","Añadir RSS Feed");
define("REMOVE_FEED","Remover RSS Feed");
define("RSS_PROBLEM","Se ocurrrió un error al abrir el RSS Feed");
define("REMOVE_FEED_CONFIRM","Esta seguro?");
define("PUBLISH_IN_HOME_PAGE","Publicar en la Home");
define("REMOVE_FROM_HOME_PAGE","Remover de la Home");
define("ALL_FEEDS","Todos los Feeds");

/*
	USER SHELF FOLDERS
*/

define("MONITORED_ACCESS","acceso monitorado");
define("MONITORED_CITATIONS","citaciones monitoradas");
define("MOVE_TO","mover para");
define("MY_FOLDERS","Mis Carpetas");
define("ADD_FOLDER","añadir carpeta");
define("INCOMING_FOLDER","Carpeta de Entrada");
define("SHOW_FOLDERLIST_BY","mirar lista por:");
define("DATE_SORT","Fecha");
define("MY_RANKING","Mi clasificación");
define("EDIT_FOLDER","Editar Carpeta");
define("DELETE_FOLDER","Apagar Carpeta");
define("FOLDER_NAME","Nombre de la Carpeta");
define("MOVE_FOLDER_TO","Mover Para");
define("BUTTON_MOVE","mover");
define("BUTTON_CANCEL","cancelar");
define("BUTTON_REMOVE","apagar");
define("BUTTON_EDIT","editar");
define("BUTTON_CREATE","crear");
define("MOVE_CONTENT_TO_OTHER_FOLDER","mover contenído para otra carpeta");
define("REMOVE_CONTENT","apagar contenído");
define("SHOW_BY_RATE"," por Ranking");
define("SHOW_BY_DATE"," por Fecha");

/*
 USER LINKS
*/

define("REMOVE_LINK","remover dirección eletrónica");
define("EDIT_LINK","editar dirección eletrónica");
define("ADD_LINK","añadir dirección eletrónica");
define("LINK_TITLE","Título de la dirección eletrónica");
define("LINK_URL","URL de la dirección eletrónica");
define("LINK_DESCRIPTION","Descripción de la dirección eletrónica");
define("IN_HOME","añadir a primera página");
define("DO_YOU_REALY_WANT_TO_REMOVE_IT","Desea realmente apagar la dirección eletrónica?");
define("ENVIAR_ARTIGO_POR_EMAIL","Enviar artículo por e-mail");
define("SEND","enviar e-mail");
define("CLOSE","cerrar ventana");
define("ARTICLE_SUBMITED_WITH_SUCCESS","artículo enviado com éxito");
define("SEARCHING_IN","procurando em");
define("SIMILARITY","releváncia");
/*
Collexis Instances Name
*/
define("ARR","SCI_OVERALL|SciELO Regional,SCI_SCIELOBR|SciELO Brasil,SCI_SCIELOCL|SciELO Chile,SCI_SCIELOCB|SciELO Cuba,SCI_SCIELOESP| SciELO España,SCI_SCIELOVE|SciELO Venezuela,SCI_SCIELOSP|SciELO Salud Pública,SCI_SCIELOSS|SciELO Ciências Sociales");

define("FULL_TEXT","texto completo");
}
?>
