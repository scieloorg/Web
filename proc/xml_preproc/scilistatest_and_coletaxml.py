#!/usr/bin/env python2.7
# coding: utf-8
import os
import shutil

from datetime import datetime


def default_config():
    """
    CISIS_DIR = '/usr/local/bireme/cisis/5.5.pre02/linux/lindG4/'
    """
    config = {}
    config['COLLECTION'] = 'Nome da Colecao'
    config['CISIS_DIR'] = 'Caminhdo do mx, por exemplo: /usr/local/bireme/cisis/5.5.pre02/linux/lindG4/'
    config['XML_SERIAL_LOCATION'] = 'Caminho do serial onde estao os XML, por exemplo: /bases/xml.000/serial'
    config['MAIL_TO'] = 'Email para (pessoal da producao). Ex.: to@exemplo.com'
    config['MAIL_CC'] = 'Email CC (infra). Ex.: cc@exemplo.com'
    config['MAIL_TO_ALT'] = 'Email para alternativo (desenv). Ex.: altto@exemplo.com'
    config['MAIL_BCC'] = 'Email BCC. Ex: bcc@exemplo.com'
    config['PROC_SERIAL_LOCATION'] = 'Caminho do processamento. Ex.: ../serial'
    config['DESENV'] = 'True para desenvolvimento. False para producao'
    return config


def read_config(default):
    config = None
    if os.path.isfile('xmlpreproc.config'):
        config = {}
        for item in open('xmlpreproc.config', 'r').readlines():
            item = item.strip()
            if '=' in item:
                k, v = item.split('=')
                if k in default.keys():
                    k = k.strip()
                    v = v.strip()
                config[k] = v
        d = config.get('DESENV', 'true')
        config['DESENV'] = d.lower() != 'false'
        if set(config.keys()) == set(default.keys()):
            return config


LOG_FILE = 'xmlpreproc.log'
ERROR_FILE = 'scilista-erros.txt'
MSG_ERROR_FILE = 'msg-erro.txt'
MSG_OK_FILE = 'msg-ok.txt'
PROC_DATETIME = datetime.now().isoformat().replace('T', ' ')[:-7]

default = default_config()
CONFIG = read_config(default)
if CONFIG is None:
    print('####')
    print('')
    print('    ERROR')
    print('')
    print('####')
    content = open('xmlpreproc.config.template').read()

    errors = '========\n  ERROR: Ausencia de arquivo de configuracao ou formato invalido\n    Criar o arquivo xmlpreproc.config que contenha a seguinte configuracao\n========\n{}'.format(content)
    exit(errors)


REGISTERED_ISSUES_FILENAME = '{}/registered_issues.txt'.format(CONFIG.get('PROC_SERIAL_LOCATION'))
SCILISTA_XML = '{}/scilistaxml.lst'.format(CONFIG.get('PROC_SERIAL_LOCATION'))
SCILISTA = '{}/scilista.lst'.format(CONFIG.get('PROC_SERIAL_LOCATION'))
ISSUE_DB = '{}/issue/issue'.format(CONFIG.get('PROC_SERIAL_LOCATION'))
XML_ISSUE_DB = '{}/issue/issue'.format(CONFIG.get('XML_SERIAL_LOCATION'))


def os_system(cmd):
    """
    Execute a command
    """
    inform_step('Executando: \n >>> {}'.format(cmd))
    os.system(cmd)


def fileinfo(filename):
    """
    Return mtime, size of a file
    """
    if os.path.isfile(filename):
        return os.path.getmtime(filename), os.path.getsize(filename)
    return None, None


def get_more_recent_title_issue_code_databases():
    """
    Check which title/issue/code bases are more recent:
        - from serial
        - from XML serial
    if from XML, copy the databases to serial folder
    """
    inform_step('XMLPREPROC: Seleciona as bases title, issue e code mais atualizada', '')
    x, x_size = fileinfo(XML_ISSUE_DB+'.mst')
    h, h_size = fileinfo(ISSUE_DB+'.mst')
    doit = False
    if x is not None:
        if h is not None:
            if x > h:
                doit = True
        else:
            doit = True
    if doit:
        inform_step('XMLPREPROC: Copia as bases title, issue e code de {}'.format(CONFIG.get('XML_SERIAL_LOCATION')), '')
        for folder in ['title', 'issue', 'code']:
            os_system(
                'cp -r {}/{} {}'.format(
                    CONFIG.get('XML_SERIAL_LOCATION'),
                    folder,
                    CONFIG.get('PROC_SERIAL_LOCATION')
                    )
                )
    else:
        inform_step('XMLPREPROC: Use as bases title, issue e code de {}'.format(CONFIG.get('PROC_SERIAL_LOCATION')), '')


def get_instructions(errors):
    """
    Return a error message with instructions
    """
    return """
Foram encontrados erros no procedimento de coleta de XML.
Veja abaixo.
Caso o erro seja na scilistaxml ou fasciculo nao registrado,
faca as correcoes e solicite o processamento novamente.
Caso contrario, aguarde instrucoes.

Erros
-----
{}
    """.format(errors)


def print_local_dir():
    inform_step('dir local: {}'.format(os.getcwd()))


def file_create(filename):
    path = os.path.dirname(filename)
    if path != '' and not os.path.isdir(path):
        os.makedirs(path)
    open(filename, 'w').write('')


def inform_error(filename, msg):
    texto = 'Error: {}\n'.format(msg)
    print(texto)
    open(filename, 'a').write(texto)


def inform_step(step, msg=''):
    text = '{}: {}\n'.format(step, msg)
    if msg == '':
        text = step + '\n'
    print(text)
    open(LOG_FILE, 'a').write(text)


def validate_scilista_item_format(parts):
    if len(parts) == 2:
        return True
    if len(parts) == 3 and parts[2] == 'del':
        return True


# mx_pft(ISSUE_DB, PFT, REGISTERED_ISSUES_FILENAME)
def mx_pft(base, PFT):
    """
    Check the issue database
    Return a list of registered issues
    """
    result = './mx_pft.tmp'
    if os.path.isfile(result):
        os.unlink(result)
    cmd = 'mx {} "pft={}" now | sort -u > {}'.format(
            base,
            PFT,
            result)
    os_system(cmd)
    if os.path.isfile(result):
        r = [item.strip() for item in open(result, 'r').readlines()]
        os.unlink(result)
    return r or []


def get_registered_issues():
    """
    Check the issue database
    Return a list of registered issues
    """
    PFT = "v930,' ',if v32='ahead' then v65*0.4, fi,|v|v31,|s|v131,|n|v32,|s|v132,v41/"
    registered_issues =  mx_pft(
                            ISSUE_DB,
                            PFT)
    open(REGISTERED_ISSUES_FILENAME, 'w').write('\n'.join(REGISTERED_ISSUES_FILENAME))
    items = []
    for item in registered_issues:
        parts = item.strip().split()
        if len(parts) == 2:
            items.append(parts[0].lower() + ' ' + parts[1])
    return items


def base_filename(local, acron, issueid, extension=''):
    return '{}/{}/{}/base/{}{}'.format(
            local,
            acron,
            issueid,
            issueid,
            extension
            )


def get_articles(base):
    """
    Check the issue database
    Return a list of registered issues
    """
    PFT = "if v706='h' then v702/ fi"
    return mx_pft(base, PFT) or []


def check_ahead(proc_base_filename, xml_base_filename):
    inform_step(
        'COLETA XML',
        'Encontradas duas bases nahead:\n  {}\n  {}\n'.format(
            xml_base_filename, proc_base_filename))

    done = False
    xml_aop = sorted(get_articles(xml_base_filename))
    proc_aop = sorted(get_articles(proc_base_filename))

    t = len(proc_aop)
    if t > len(list(set(proc_aop))):
        inform_error(ERROR_FILE, 'Found duplication in {}'.format(proc_base_filename))

    for item in xml_aop:
        if item in proc_aop:
            done = True
            break
    if done is False:
        # fazer append
        inform_step(
            'COLETA XML',
            'Executar: append {} {}'.format(
            xml_base_filename, proc_base_filename))
        return '{}mx {} from=2 append={} -all now'.format(
                    CONFIG.get('CISIS_DIR'),
                    xml_base_filename,
                    proc_base_filename
                )
    inform_step(
            'COLETA XML',
            'Nao executar: append {} {}'.format(
                xml_base_filename, proc_base_filename))


def check_data_for_coleta(acron, issueid):
    """
    Check the existence of acron/issue databases in XML serial
    Copy this databases to serial folder
    If the database is ahead and it exists in serial folder, they should be merged
    Return a tuple items_to_copy, mx_append_db_commands, error_msg, expected_db_files_in_serial
        items_to_copy: bases to copy from XML serial to serial
        mx_append_db_commands: commands to merge aop
        error_msg: error message
        expected_db_files_in_serial: list of files which have to be in serial
    """
    xml_mst_filename = base_filename(CONFIG.get('XML_SERIAL_LOCATION'), acron, issueid, '.mst')
    proc_mst_filename = base_filename(CONFIG.get('PROC_SERIAL_LOCATION'), acron, issueid, '.mst')
    xml_base_filename = base_filename(CONFIG.get('XML_SERIAL_LOCATION'), acron, issueid)
    proc_base_filename = base_filename(CONFIG.get('PROC_SERIAL_LOCATION'), acron, issueid)

    mx_append_db_commands = None
    items_to_copy = None
    expected_db_files_in_serial = [proc_mst_filename, proc_base_filename+'.xrf']
    error_msg = None
    inform_step('COLETA XML', 'Verificar dados para coleta de {} {}'.format(acron, issueid))
    if os.path.exists(xml_mst_filename):
        if 'nahead' in issueid and os.path.exists(proc_mst_filename):
            mx_append_db_commands = check_ahead(proc_base_filename, xml_base_filename)
            if mx_append_db_commands is None:
                items_to_copy = (xml_base_filename, proc_base_filename)
        else:
            items_to_copy = (xml_base_filename, proc_base_filename)
    else:
        error_msg = 'Not found {}'.format(xml_mst_filename)
    return (items_to_copy, mx_append_db_commands, error_msg, expected_db_files_in_serial)


def coletaxml(xml_item, proc_item):
    xml_mst_filename = xml_item+'.mst'
    proc_mst_filename = proc_item+'.mst'
    xml_xrf_filename = xml_item+'.xrf'
    proc_xrf_filename = proc_item+'.xrf'

    errors = []
    inform_step('COLETA XML', 'Coletar {}'.format(xml_item))
    if os.path.exists(xml_mst_filename):
        path = os.path.dirname(proc_mst_filename)
        if not os.path.isdir(path):
            os.makedirs(path)
        if os.path.isdir(path):
            shutil.copyfile(xml_mst_filename, proc_mst_filename)
            shutil.copyfile(xml_xrf_filename, proc_xrf_filename)
        else:
            errors.append('Nao foi possivel criar {}'.format(path))
    if not os.path.exists(proc_mst_filename):
        errors.append('Nao foi possivel criar {}'.format(proc_mst_filename))
    if not os.path.exists(proc_xrf_filename):
        errors.append('Nao foi possivel criar {}'.format(proc_xrf_filename))
    if len(errors) > 0:
        inform_error(ERROR_FILE, '\n'.join(errors))
        return False
    return True


def read_scilista(scilista_filename):
    items = []
    if os.path.isfile(scilista_filename):
        items = [item.strip() for item in open(scilista_filename, 'r').readlines()]
    return items


def sort_scilista(scilista_items):
    items = list(set([item.strip() for item in scilista_items]))
    dellist = []
    prlist = []
    naheadlist = []
    issuelist = []
    for item in items:
        if item.endswith('del'):
            dellist.append(item)
        elif item.endswith('pr'):
            prlist.append(item)
        elif item.endswith('nahead'):
            naheadlist.append(item)
        else:
            issuelist.append(item)
    return sorted(dellist) + sorted(prlist) + sorted(naheadlist) + sorted(issuelist)


def merge_scilistas(scilistaxml_items, scilista_items):
    items = []
    items = list(set(scilistaxml_items+scilista_items))
    return sort_scilista(items)


def save_new_scilista(items):
    content = '\n'.join(items)+'\n'
    open(SCILISTA, 'w').write(content)
    inform_step('JOIN SCILISTAS', SCILISTA + '+' + SCILISTA_XML)
    inform_step('===\n'+content+'===')


def send_mail(mailto, mailbcc, mailcc, subject, scilista_date, msg_filename):
    if CONFIG.get('DESENV') is True:
        mailto = CONFIG.get('MAIL_TO_ALT')
        mailcc = CONFIG.get('MAIL_TO_ALT')
        mailbcc = CONFIG.get('MAIL_TO_ALT')

    d = scilista_date
    if d is not None:
        d = scilista_date[:10]
    _mailbcc = ''
    if mailbcc is not None:
        _mailbcc = '-b "{}"'.format(mailbcc)
    _subject = '[XML PREPROC][{}][{}] {}'.format(
            CONFIG.get('COLLECTION'),
            d,
            subject
        )
    cmd = 'mailx {} {} -c "{}" -s "{}" < {}'.format(
            mailto,
            _mailbcc,
            mailcc,
            _subject,
            msg_filename
        )
    os_system(cmd)


def create_msg_instructions(errors=None):
    instructions = "Nenhum erro encontrado. Processamento sera iniciado em breve."
    fim = '[pok]'
    if len(errors) > 0:
        fim = ''
        instructions = get_instructions(errors)
    return instructions, fim


def get_email_message(scilista_date, proc_date, instructions, scilista_content, fim, comments):
    return """

    ATENCAO: Mensagem automatica. Nao responder a este e-mail.


Prezados,

Colecao: {}
Data da scilista: {}
Data de inicio:   {}

{}

{}

Conteudo da scilistaxml.lst
---------------------------
{}
----

{}
    """.format(
        CONFIG.get('COLLECTION'),
        scilista_date,
        proc_date,
        comments,
        instructions,
        scilista_content,
        fim
        )


def create_msg_file(scilista_date, proc_date, errors=None, comments=None):
    for f in [MSG_OK_FILE, MSG_ERROR_FILE]:
        if os.path.isfile(f):
            try:
                os.unlink(f)
            except:
                file_create(f)
    errors = errors or ''
    msg_file = MSG_ERROR_FILE if len(errors) > 0 else MSG_OK_FILE
    scilista_content = open(SCILISTA_XML).read() if os.path.isfile(SCILISTA_XML) else 'Not found {}'.format(SCILISTA_XML)
    instructions, fim = create_msg_instructions(errors)
    msg = get_email_message(scilista_date, proc_date, instructions, scilista_content, fim, comments)

    open(msg_file, 'w').write(msg)
    inform_step(msg)
    return msg_file


def check_scilista(scilistaxml_items, registered_issues):
    inform_step('SCILISTA TESTE', '')
    coleta_items = []
    scilista_ok = True
    n = 0
    for item in scilistaxml_items:
        n += 1
        parts = item.split()
        if validate_scilista_item_format(parts) is not True:
            inform_error(ERROR_FILE, 'Linha {}: "{}" tem formato invalido'.format(n, item))
            scilista_ok = False
        else:
            acron, issueid = parts[0], parts[1]
            issue = '{} {}'.format(acron, issueid)
            if issue not in registered_issues:
                inform_error(ERROR_FILE, 'Linha {}: "{}" nao esta registrado'.format(n, issue))
                scilista_ok = False
            else:
                items_to_copy, mx_append_db_commands, error_msg, expected_db_files_in_serial = check_data_for_coleta(acron, issueid)    
                if error_msg is None:
                    coleta_items.append((items_to_copy, mx_append_db_commands, expected_db_files_in_serial))
                else:
                    scilista_ok = False
                    inform_error(ERROR_FILE, 'Linha {}: {}'.format(n, error_msg))
    if scilista_ok is True:
        return coleta_items


def coletar_items(coleta_items):
    expected = []
    for items_to_copy, mx_append_db_command, expected_db_files_in_serial in coleta_items:
        expected.extend(expected_db_files_in_serial)
        done = True
        if items_to_copy is not None:
            xml_item, proc_item = items_to_copy
            done = coletaxml(xml_item, proc_item)
        if done and mx_append_db_command is not None:
            inform_step('COLETA XML', mx_append_db_command)
            os_system(mx_append_db_command)
    return expected


def check_expected(expected):
    coletaxml_ok = True
    inform_step('COLETA XML', 'Verifica se ha arquivos nao coletados')
    for file in expected:
        if not os.path.exists(file):
            coletaxml_ok = False
            inform_error(ERROR_FILE, 'Coleta incompleta. Falta {}'.format(file))
    return coletaxml_ok


def get_new_scilista(scilistaxml_items, scilista_items):
    error = False
    scilista_items = merge_scilistas(scilistaxml_items, scilista_items)
    for item in scilistaxml_items:
        if item not in scilista_items:
            error = True
            inform_error(ERROR_FILE, 'Nova scilista. Falta {}'.format(item))
    if error is False:
        save_new_scilista(scilista_items)
        return scilista_items
    return False


inform_step('XMLPREPROC: INICIO', '{} {}'.format(CONFIG.get('COLLECTION'), PROC_DATETIME))

print_local_dir()
file_create(ERROR_FILE)
file_create(LOG_FILE)
if not os.path.isfile(SCILISTA):
    file_create(SCILISTA)


result = False
expected = []
comments = ''
SCILISTA_DATETIME = None

if os.path.exists(SCILISTA_XML):
    SCILISTA_ITEMS = read_scilista(SCILISTA)

    SCILISTA_DATETIME = datetime.fromtimestamp(
                os.path.getmtime(SCILISTA_XML)).isoformat().replace('T', ' ')
    os_system('dos2unix {}'.format(SCILISTA_XML))
    SCILISTAXML_ITEMS = read_scilista(SCILISTA_XML)

    inform_step('XMLPREPROC: SCILISTA', '{}'.format(SCILISTA_DATETIME))
    get_more_recent_title_issue_code_databases()

    if os.path.isfile(ISSUE_DB+'.mst'):
        REGISTERED_ISSUES = get_registered_issues()
        coleta_items = check_scilista(SCILISTAXML_ITEMS, REGISTERED_ISSUES)
        if coleta_items is not None:
            expected = coletar_items(coleta_items)
            if check_expected(expected):
                SCILISTA_ITEMS = get_new_scilista(SCILISTAXML_ITEMS, SCILISTA_ITEMS)
                if SCILISTA_ITEMS is not False:
                    result = True
        comments = '{}: {} itens\n{}: {} itens\n'.format(
            SCILISTA_XML,
            len(SCILISTAXML_ITEMS),
            SCILISTA,
            len(SCILISTA_ITEMS))
    else:
        inform_error(ERROR_FILE, '{} not found'.format(ISSUE_DB))
else:
    inform_error(ERROR_FILE, '{} not found'.format(SCILISTA_XML))


subject = 'Erros encontrados'
errors = None
if result is True:
    subject = 'OK'
else:
    errors = open(ERROR_FILE, 'r').read()

msg_filename = create_msg_file(SCILISTA_DATETIME, PROC_DATETIME, errors, comments)
send_mail(CONFIG.get('MAIL_TO'), CONFIG.get('MAIL_BCC'), CONFIG.get('MAIL_CC'), subject, SCILISTA_DATETIME, msg_filename)

inform_step("\n"*3)
inform_step("="*30)
inform_step("Proximo passo:")
if result is True:
    inform_step('Executar processar.sh')
else:
    inform_step('Fazer correcoes')
