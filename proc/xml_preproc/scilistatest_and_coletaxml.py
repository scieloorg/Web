#!/usr/bin/env python2.7
# coding: utf-8
import os
import shutil

from datetime import datetime


def default_config_vars():
    return [
            'COLLECTION',
            'XML_SERIAL_LOCATION',
            'MAIL_TO',
            'MAIL_CC',
            'MAIL_TO_TEST',
            'MAIL_BCC',
            'TEST',
        ]


def get_config_filename():
    curr = os.getcwd()
    folders = curr.split('/')
    return 'xmlpreproc_config_'+folders[2]+'.ini'


def read_config(config_filename, default):
    config = None
    if os.path.isfile(config_filename):
        config = {}
        items = open(config_filename, 'r').readlines()
        for item in items:
            item = item.strip()
            if '=' in item:
                k, v = item.split('=')
                if k in default:
                    k = k.strip()
                    v = v.strip()
                config[k] = v
        d = config.get('TEST', 'true')
        config['TEST'] = d.lower() != 'false'
        if set(default).issubset(set(config.keys())):
            return config, None
        else:
            return None, 'Invalid format \n{}'.format(open(config_filename).read())
    else:
        return None, 'Not found {}'.format(config_filename)


def check_config(config, msg, name):
    errors = None
    if config is None:
        print('####')
        print('')
        print('    ERROR')
        print('')
        print('####')
        content = open('xmlpreproc_config.ini.template').read()
        errors = '========\n  ERROR: {}\n    Criar o arquivo {} que contenha a seguinte configuracao\n========\n{}'.format(msg, name, content)
    else:
        curr = os.getcwd()
        folders = curr.split('/')
        motivos = []
        if '/'+folders[2]+'/serial' not in config.get('XML_SERIAL_LOCATION'):
            motivos.append('Esperado a pasta {} em {}'.format(
                folders[2]+'/serial', config.get('XML_SERIAL_LOCATION')))
        if not os.path.isdir(config.get('XML_SERIAL_LOCATION')+'/issue'):
            motivos.append('Esperado a pasta issue em {}'.format(
                config.get('XML_SERIAL_LOCATION')))
        if len(motivos) > 0:
            errors = 'Valor invalido de XML_SERIAL_LOCATION {} para {}. {}.'.format(
                config.get('XML_SERIAL_LOCATION'),
                config.get('COLLECTION'),
                ' e '.join(motivos))
    return errors


LOG_FILE = 'xmlpreproc_outs.log'
ERROR_FILE = 'xmlpreproc_outs_scilista-erros.txt'
MSG_ERROR_FILE = 'xmlpreproc_outs_msg-erro.txt'
MSG_OK_FILE = 'xmlpreproc_outs_msg-ok.txt'
PROC_DATETIME = datetime.now().isoformat().replace('T', ' ')[:-7]

default = default_config_vars()
config_filename = get_config_filename()
CONFIG, msg = read_config(config_filename, default)
errors = check_config(CONFIG, msg, config_filename)
if errors is not None:
    exit(errors)


PROC_SERIAL_LOCATION = '../serial'
REGISTERED_ISSUES_FILENAME = '{}/registered_issues.txt'.format(PROC_SERIAL_LOCATION)
SCILISTA_XML = '{}/scilistaxml.lst'.format(PROC_SERIAL_LOCATION)
SCILISTA = '{}/scilista.lst'.format(PROC_SERIAL_LOCATION)
ISSUE_DB = '{}/issue/issue'.format(PROC_SERIAL_LOCATION)
XML_ISSUE_DB = '{}/issue/issue'.format(CONFIG.get('XML_SERIAL_LOCATION'))


def os_system(cmd, display=True):
    """
    Execute a command
    """
    msg = '_'*30 + '\n#  Executando: \n#    >>> {}'.format(cmd)
    inform_step(msg, display=display)
    os.system(cmd)
    inform_step('_'*30, display=display)


def fileinfo(filename):
    """
    Return mtime, size of a file
    """
    if os.path.isfile(filename):
        return os.path.getmtime(filename), os.path.getsize(filename)
    return None, None


def get_more_recent_title_issue_databases():
    # v1.0 scilistatest.sh [8-32]
    """
    Check which title/issue/code bases are more recent:
        - from serial
        - from XML serial
    if from XML, copy the databases to serial folder
    """
    inform_step('XMLPREPROC: Seleciona as bases title e issue mais atualizada', '')
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
        inform_step('XMLPREPROC: Copia as bases title e issue de {}'.format(CONFIG.get('XML_SERIAL_LOCATION')), '')
        for folder in ['title', 'issue']:
            os_system(
                'cp -r {}/{} {}'.format(
                    CONFIG.get('XML_SERIAL_LOCATION'),
                    folder,
                    PROC_SERIAL_LOCATION
                    )
                )
    else:
        inform_step('XMLPREPROC: Use as bases title e issue de {}'.format(PROC_SERIAL_LOCATION), '')


def file_delete(filename):
    if os.path.exists(filename):
        try:
            os.unlink(filename)
        except:
            print('Unable to delete {}'.format(filename))


def file_create(filename):
    path = os.path.dirname(filename)
    if path != '' and not os.path.isdir(path):
        os.makedirs(path)
    open(filename, 'w').write('')


def inform_error(filename, msg):
    texto = 'Error: {}\n'.format(msg)
    print(texto)
    open(filename, 'a').write(texto)


def inform_step(step, msg='', display=True):
    text = '{}: {}\n'.format(step, msg)
    if msg == '':
        text = step + '\n'
    if display is True:
        print(text)
    open(LOG_FILE, 'a').write(text)


def validate_scilista_item_format(parts):
    if len(parts) == 2:
        return True
    if len(parts) == 3 and parts[2] == 'del':
        return True


# mx_pft(ISSUE_DB, PFT, REGISTERED_ISSUES_FILENAME)
def mx_pft(base, PFT, display=False):
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
    os_system(cmd, display)
    if os.path.isfile(result):
        r = [item.strip() for item in open(result, 'r').readlines()]
        os.unlink(result)
    return r or []


def get_registered_issues():
    """
    Check the issue database
    Return a list of registered issues
    """
    registered_issues = read_file_lines(REGISTERED_ISSUES_FILENAME)
    if os.path.isfile(ISSUE_DB+'.mst'):
        PFT = "v930,' ',if v32='ahead' then v65*0.4, fi,|v|v31,|s|v131,|n|v32,|s|v132,v41/"
        registered_issues = mx_pft(
                            ISSUE_DB,
                            PFT)
        open(REGISTERED_ISSUES_FILENAME, 'w').write('\n'.join(registered_issues))
    elif CONFIG.get('TEST') is False:
        registered_issues = []
    items = []
    for item in registered_issues:
        parts = item.strip().split()
        if len(parts) == 2:
            items.append(parts[0].lower() + ' ' + parts[1])
    return items


def db_filename(local, acron, issueid, extension=''):
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


def check_ahead(proc_db_filename, xml_db_filename):
    msg = 'Encontradas duas bases nahead \n {}\n {}.'.format(
            xml_db_filename, proc_db_filename)

    done = False
    xml_aop = sorted(get_articles(xml_db_filename))
    proc_aop = sorted(get_articles(proc_db_filename))

    t = len(proc_aop)
    if t > len(list(set(proc_aop))):
        inform_error(ERROR_FILE, 'Found duplication in {}'.format(proc_db_filename))

    for item in xml_aop:
        if item in proc_aop:
            done = True
            break
    if done is False:
        # fazer append
        inform_step(
            'COLETA XML',
            '{}\nExecutara o append'.format(msg))
        return 'mx {} from=2 append={} -all now'.format(
                    xml_db_filename,
                    proc_db_filename
                )
    inform_step(
            'COLETA XML',
            '{}\nDesnecessario executar append pois tem mesmo conteudo'.format(msg))


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
    xml_mst_filename = db_filename(CONFIG.get('XML_SERIAL_LOCATION'), acron, issueid, '.mst')
    proc_mst_filename = db_filename(PROC_SERIAL_LOCATION, acron, issueid, '.mst')
    xml_db_filename = db_filename(CONFIG.get('XML_SERIAL_LOCATION'), acron, issueid)
    proc_db_filename = db_filename(PROC_SERIAL_LOCATION, acron, issueid)

    mx_append_db_commands = None
    items_to_copy = None
    expected_db_files_in_serial = [proc_mst_filename, proc_db_filename+'.xrf']
    error_msg = None
    if os.path.exists(xml_mst_filename):
        if 'nahead' in issueid and os.path.exists(proc_mst_filename):
            mx_append_db_commands = check_ahead(proc_db_filename, xml_db_filename)
            if mx_append_db_commands is None:
                items_to_copy = (xml_db_filename, proc_db_filename)
        else:
            items_to_copy = (xml_db_filename, proc_db_filename)
    else:
        error_msg = 'Not found {}'.format(xml_mst_filename)
    return (items_to_copy, mx_append_db_commands, error_msg, expected_db_files_in_serial)


def coletaxml(xml_item, proc_item):
    xml_mst_filename = xml_item+'.mst'
    proc_mst_filename = proc_item+'.mst'
    xml_xrf_filename = xml_item+'.xrf'
    proc_xrf_filename = proc_item+'.xrf'

    errors = []
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


def read_file_lines(filename):
    items = []
    if os.path.isfile(filename):
        items = [item.strip() for item in open(filename, 'r').readlines()]
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
    if CONFIG.get('TEST') is True:
        mailto = CONFIG.get('MAIL_TO_TEST')
        mailcc = CONFIG.get('MAIL_TO_TEST')
        mailbcc = CONFIG.get('MAIL_TO_TEST')

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
    if CONFIG.get('TEST') is False:
        os_system(cmd)
    else:
        print(cmd)


def create_msg_instructions(errors=None):
    instructions = "Nenhum erro encontrado. Processamento sera iniciado em breve."
    fim = '[pok]'
    if len(errors) > 0:
        fim = ''
        instructions = """
Foram encontrados erros no procedimento de coleta de XML.
Veja abaixo.
Caso o erro seja na scilistaxml ou fasciculo nao registrado,
faca as correcoes e solicite o processamento novamente.
Caso contrario, aguarde instrucoes.

Erros
-----
{}
    """.format(errors)
    return instructions, fim


def get_email_message(scilista_date, proc_date, instructions, scilista_content, diffs, fim, numbers):
    return """
    ATENCAO: Mensagem automatica. Nao responder a este e-mail.

Prezados,

Colecao: {}
Data   da scilista:    {}
Inicio da verificacao: {}

{}


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
        numbers,
        instructions,
        diffs,
        scilista_content,
        fim
        )


def create_msg_file(scilista_date, proc_date, errors=None, comments=None, diffs=None):
    errors = errors or ''
    msg_file = MSG_ERROR_FILE if len(errors) > 0 else MSG_OK_FILE
    scilista_content = open(SCILISTA_XML).read() if os.path.isfile(SCILISTA_XML) else 'Not found {}'.format(SCILISTA_XML)
    instructions, fim = create_msg_instructions(errors)
    msg = get_email_message(scilista_date, proc_date, instructions, scilista_content, diffs, fim, comments)

    open(msg_file, 'w').write(msg)
    inform_step(msg)
    return msg_file


def check_scilista(scilistaxml_items, registered_issues):
    # v1.0 scilistatest.sh [36] (scilistatest.py)
    # v1.0 scilistatest.sh [41] (checkissue.py)
    inform_step('SCILISTA TESTE', '{} itens'.format(len(scilista_items)))
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

            # v1.0 scilistatest.sh [41] (checkissue.py)
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
    # v1.0 coletaxml.sh [16] (getbasesxml4proc.py)
    expected = []
    coleta_items = coleta_items or []
    inform_step('COLETA XML', 'Coletar {} itens'.format(len(coleta_items)))
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


def check_coletados(expected):
    coletaxml_ok = True
    inform_step('COLETA XML', 'Verificar se coleta foi bem sucedida')
    for file in expected:
        if not os.path.exists(file):
            coletaxml_ok = False
            inform_error(ERROR_FILE, 'Coleta incompleta. Falta {}'.format(file))
    return coletaxml_ok


def get_new_scilista(scilistaxml_items, scilista_items):
    # v1.0 coletaxml.sh [20] (joinlist.py)
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


def list_diff(lista_maior, lista_menor):
    return [item for item in lista_maior if item not in lista_menor]


inform_step('XMLPREPROC: INICIO', '{} {}'.format(CONFIG.get('COLLECTION'), PROC_DATETIME))

inform_step('dir local: {}'.format(os.getcwd()))
file_create(ERROR_FILE)
file_create(LOG_FILE)
if not os.path.isfile(SCILISTA):
    file_create(SCILISTA)
for f in [MSG_OK_FILE, MSG_ERROR_FILE]:
    file_delete(f)


result = False
expected = []
comments = ''
SCILISTA_DATETIME = None
scilistaxml_items = []
q_scilistaxml_items = 0
if os.path.exists(SCILISTA_XML):
    scilista_items = read_file_lines(SCILISTA)

    SCILISTA_DATETIME = datetime.fromtimestamp(
                os.path.getmtime(SCILISTA_XML)).isoformat().replace('T', ' ')

    # v1.0 scilistatest.sh [6]
    os_system('dos2unix {}'.format(SCILISTA_XML))

    scilistaxml_items = read_file_lines(SCILISTA_XML)
    q_scilistaxml_items = len(scilistaxml_items)

    inform_step('XMLPREPROC: SCILISTA', '{}'.format(SCILISTA_DATETIME))
    get_more_recent_title_issue_databases()

    if os.path.isfile(ISSUE_DB+'.mst') or CONFIG.get('TEST') is True:
        # v1.0 scilistatest.sh
        registered_issues = get_registered_issues()
        coleta_items = check_scilista(scilistaxml_items, registered_issues)
        # v1.0 coletaxml.sh
        expected = coletar_items(coleta_items)
        if check_coletados(expected):
            scilista_items = get_new_scilista(scilistaxml_items, scilista_items)
    else:
        inform_error(ERROR_FILE, 'Not found {}'.format(ISSUE_DB+'.mst'))
else:
    inform_error(ERROR_FILE, 'Not found {}'.format(SCILISTA_XML))


errors = open(ERROR_FILE, 'r').read().strip()
subject = 'OK'
next_action = 'Executar processar.sh'
if len(errors) > 0:
    subject = 'Erros encontrados'
    next_action = 'Fazer correcoes'

diffs = list_diff(scilista_items, scilistaxml_items)

comments = '{}: {} itens\n{}: {} itens ({} nao XML)'.format(
    SCILISTA_XML,
    q_scilistaxml_items,
    SCILISTA,
    len(scilista_items),
    len(diffs))

diffs = '' if len(diffs) == 0 else 'Conteudo de scilista.lst nao XML ({})\n{}\n'.format(len(diffs), '-'*len('Conteudo de scilista.lst nao XML')) + '\n'.join(diffs) + '\n'

# v1.0 scilistatest.sh [43-129]
msg_filename = create_msg_file(SCILISTA_DATETIME, PROC_DATETIME, errors, comments, diffs)
send_mail(CONFIG.get('MAIL_TO'), CONFIG.get('MAIL_BCC'), CONFIG.get('MAIL_CC'), subject, SCILISTA_DATETIME, msg_filename)


# v1.0 coletaxml.sh [21-25]
inform_step("\n"*3)
inform_step("="*30)
inform_step("Proximo passo:")
inform_step(next_action)
exit(next_action)
