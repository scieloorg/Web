#!/usr/bin/env python2.7
# coding: utf-8
import os
import shutil

from datetime import datetime
import xmlpreproc_config


COLLECTION = xmlpreproc_config.COLLECTION
CISIS_DIR = xmlpreproc_config.CISIS_DIR
XML_SERIAL_LOCATION = xmlpreproc_config.XML_SERIAL_LOCATION
MAIL_TO = xmlpreproc_config.MAIL_TO
MAIL_CC = xmlpreproc_config.MAIL_CC
MAIL_BCC = xmlpreproc_config.MAIL_BCC
PROC_SERIAL_LOCATION = xmlpreproc_config.PROC_SERIAL_LOCATION

ERROR_FILE = 'scilista-erros.txt'
MSG_ERROR_FILE = 'msg-erro.txt'
MSG_OK_FILE = 'msg-ok.txt'

SAVED_AOP = '{}/aop'.format(PROC_SERIAL_LOCATION)
DELLIST = []

REGISTERED_ISSUES_FILENAME = '{}/registered_issues.txt'.format(PROC_SERIAL_LOCATION)
SCILISTA_XML = '{}/scilistaxml.lst'.format(PROC_SERIAL_LOCATION)
SCILISTA = '{}/scilista.lst'.format(PROC_SERIAL_LOCATION)
ISSUE_DB = '{}/issue/issue'.format(PROC_SERIAL_LOCATION)
XML_ISSUE_DB = '{}/issue/issue'.format(XML_SERIAL_LOCATION)


PROC_DATETIME = datetime.now().isoformat().replace('T', ' ')[:-7]


def os_system(cmd):
    print('Executando: \n>>>{}'.format(cmd))
    try:
        os.system(cmd)
        return True
    except:
        print('>>> Error: Command not found')


def check_issue_db(filename):
    if os.path.isfile(filename):
        return os.path.getmtime(filename), os.path.getsize(filename)
    return None, None


def select_title_issue_code_databases():
    inform_step('XMLPREPROC: Seleciona as bases title, issue e code', '')
    x, x_size = check_issue_db(XML_ISSUE_DB+'.mst')
    h, h_size = check_issue_db(ISSUE_DB+'.mst')
    doit = False
    if x is not None:
        if h is not None:
            if x > h:
                doit = True
        else:
            doit = True
    if doit:
        for folder in ['title', 'issue', 'code']:
            os_system(
                'cp -r {}/{} {}'.format(
                    XML_SERIAL_LOCATION,
                    folder,
                    PROC_SERIAL_LOCATION
                    )
                )


def get_instructions(errors):
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
    print('dir local: {}'.format(os.getcwd()))


def file_create(filename):
    path = os.path.dirname(filename)
    if path != '' and not os.path.isdir(path):
        os.makedirs(path)
    open(filename, 'w').write('')


def inform_error(filename, msg):
    texto = 'Error: {}\n'.format(msg)
    print(texto)
    open(filename, 'a').write(texto)


def inform_step(step, msg):
    text = '{}: {}\n'.format(step, msg)
    print(text)


def validate_line_format(parts):
    if len(parts) == 2:
        return True
    if len(parts) == 3 and parts[2] == 'del':
        return True


def get_registered_issues():
    registered_issues = []
    if os.path.isfile(REGISTERED_ISSUES_FILENAME):
        registered_issues = open(REGISTERED_ISSUES_FILENAME, 'r').readlines()
    print(registered_issues)
    PFT = "v930,' ',if v32='ahead' then v65*0.4, fi,|v|v31,|s|v131,|n|v32,|s|v132,v41/"
    cmd = 'mx {} "pft={}" now | sort -u > {}'.format(
            ISSUE_DB,
            PFT,
            REGISTERED_ISSUES_FILENAME)
    items = []
    if os_system(cmd) is True:
        if os.path.isfile(REGISTERED_ISSUES_FILENAME):
            registered_issues = open(REGISTERED_ISSUES_FILENAME, 'r').readlines()
    print(registered_issues)
    for item in registered_issues:
        parts = item.strip().split()
        items.append(parts[0].lower() + ' ' + parts[1])
    return items


def mst_filename(local, acron, issueid):
    return '{}/{}/{}/base/{}.mst'.format(
            local,
            acron,
            issueid,
            issueid
            )


def base_filename(local, acron, issueid):
    return mst_filename(
            local,
            acron,
            issueid
            )[:-4]


def exist_base(local, acron, issueid):
    return os.path.exists(
        mst_filename(local, acron, issueid)
        )


def verificar_bases_para_coletar(acron, issueid):
    xml_mst_filename = mst_filename(XML_SERIAL_LOCATION, acron, issueid)
    proc_mst_filename = mst_filename(PROC_SERIAL_LOCATION, acron, issueid)
    xml_base_filename = base_filename(XML_SERIAL_LOCATION, acron, issueid)
    proc_base_filename = base_filename(PROC_SERIAL_LOCATION, acron, issueid)

    append_commands = []
    copy_items = []
    para_processar = [proc_mst_filename, proc_base_filename+'.xrf']
    msg = None
    inform_step('XMLPREPROC: COLETA XML', 'Verificar dados para coleta de {} {}'.format(acron, issue))
    if os.path.exists(xml_mst_filename):
        if 'nahead' in issueid and os.path.exists(proc_mst_filename):
            inform_step(
                'COLETA XML',
                'Encontradas duas bases nahead {} {}:\n  {}\n  {}\n'.format(
                    acron, issue,
                    xml_mst_filename, proc_mst_filename))
            saved_aop_mst_filename = mst_filename(SAVED_AOP, acron, issueid)
            saved_aop_base_filename = base_filename(SAVED_AOP, acron, issueid)
            if os.path.exists(saved_aop_mst_filename):
                if os.path.getsize(saved_aop_mst_filename) < os.path.getsize(proc_mst_filename):
                    inform_step('XMLPREPROC: COLETA XML', saved_aop_base_filename)
                    shutil.copyfile(saved_aop_mst_filename, proc_mst_filename)
                    shutil.copyfile(saved_aop_base_filename+'.xrf', proc_base_filename+'.xrf')
                    DELLIST.append(saved_aop_base_filename+'.mst')
                    DELLIST.append(saved_aop_base_filename+'.xrf')
            else:
                inform_step('XMLPREPROC: COLETA XML', proc_base_filename)
                saved_aop_path = os.path.dirname(saved_aop_mst_filename)
                if not os.path.isdir(saved_aop_path):
                    os.makedirs(saved_aop_path)
                try:
                    shutil.copyfile(proc_mst_filename, saved_aop_mst_filename)
                    shutil.copyfile(proc_base_filename+'.xrf', saved_aop_base_filename+'.xrf')
                except:
                    pass
            append_nahead = '{}mx {} from=2 append={} -all now tell=1'.format(
                        CISIS_DIR,
                        xml_base_filename,
                        proc_base_filename
                    )
            append_commands.append(append_nahead)
            #print('Comando para juntar as bases nahead:\n{}'.format(append_nahead))
            """
            resp = raw_input('Tecle J para juntar as duas.\nTecle X para usar {}.\nTecle H para usar {}\nTecle E para indicar erro\n'.format(xml_base_filename, proc_base_filename))
            if resp.upper() == 'J':
                append_commands.append(append_nahead)
            elif resp.upper() == 'X':
                copy_items.append((xml_base_filename, proc_base_filename))
            elif resp.upper() == 'H':
                pass
            else:
                msg = 'Nenhuma decisao tomada para as duas bases nahead {} {}:\n  {}\n  {}\n'.format(
                    acron, issue,
                    xml_mst_filename, proc_mst_filename)
            """
        else:
            copy_items.append((xml_base_filename, proc_base_filename))
        if len(copy_items) > 0:
            path = os.path.dirname(proc_mst_filename)
            if not os.path.isdir(path):
                os.makedirs(path)
            if not os.path.isdir(path):
                msg = 'Nao foi possivel criar {}'.format(path)
    else:
        msg = 'Not found {}'.format(xml_mst_filename)
    return (copy_items, append_commands, msg, para_processar)


def coletaxml(xml_item, proc_item):
    xml_mst_filename = xml_item+'.mst'
    proc_mst_filename = proc_item+'.mst'
    xml_xrf_filename = xml_item+'.xrf'
    proc_xrf_filename = proc_item+'.xrf'

    msg = []
    inform_step('XMLPREPROC: COLETA XML', 'Coletar {}'.format(xml_item))
    if os.path.exists(xml_mst_filename):
        path = os.path.dirname(proc_mst_filename)
        if not os.path.isdir(path):
            os.makedirs(path)
        if os.path.isdir(path):
            shutil.copyfile(xml_mst_filename, proc_mst_filename)
            shutil.copyfile(xml_xrf_filename, proc_xrf_filename)
        else:
            msg.append('Nao foi possivel criar {}'.format(path))
    if not os.path.exists(proc_mst_filename):
        msg.append('Nao foi possivel criar {}'.format(proc_mst_filename))
    if not os.path.exists(proc_xrf_filename):
        msg.append('Nao foi possivel criar {}'.format(proc_xrf_filename))

    return msg


def read_scilista(scilista_filename):
    items = []
    if os.path.isfile(scilista_filename):
        items = [item.strip() for item in open(scilista_filename, 'r').readlines()]
    return items


def sort_scilista(scilista_items):
    items = []
    dellist = []
    prlist = []
    naheadlist = []
    issuelist = []
    for item in list(set([item.strip() for item in items])):
        if item.endswith('del'):
            dellist.append(item)
        elif item.endswith('pr'):
            prlist.append(item)
        elif item.endswith('nahead'):
            naheadlist.append(item)
        else:
            issuelist.append(item)
    return sorted(dellist) + sorted(prlist) + sorted(naheadlist) + sorted(issuelist)


def join_scilistas():
    items = []
    items = list(set(read_scilista(SCILISTA)+read_scilista(SCILISTA_XML)))
    return sort_scilista(items)


def save_new_scilista(items):
    content = '\n'.join(items)+'\n'
    open(SCILISTA, 'w').write(content)
    inform_step('JOIN SCILISTAS', SCILISTA + '+' + SCILISTA_XML)
    print('===\n'+content+'===')


def send_mail(mailto, mailbcc, mailcc, subject, scilista_date, msg_filename):
    _mailbcc = ''
    if mailbcc is not None:
        _mailbcc = '-b "{}"'.format(mailbcc)
    _subject = '[XML PREPROC][{}][{}] {}'.format(
            COLLECTION,
            scilista_date[:10],
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
    instructions = "Nenhum erro encontrado. Colecao sera iniciado em breve."
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
        COLLECTION,
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
    print(msg)
    return msg_file


inform_step('XMLPREPROC: INICIO', '{} {}'.format(COLLECTION, PROC_DATETIME))

print_local_dir()
file_create(ERROR_FILE)
if not os.path.isfile(SCILISTA):
    file_create(SCILISTA)

scilista_ok = False
SCILISTA_DATETIME = 'NONE'
SCILISTAXML_ITEMS = []
SCILISTA_ITEMS = read_scilista(SCILISTA)
coletar_copy_items = []
coletar_append_commands = []
arquivos_esperados_para_processar = []

if os.path.exists(SCILISTA_XML):
    scilista_ok = True

    SCILISTA_DATETIME = datetime.fromtimestamp(
                            os.path.getmtime(SCILISTA_XML)).isoformat().replace('T', ' ')
    os_system('dos2unix {}'.format(SCILISTA_XML))
    SCILISTAXML_ITEMS = read_scilista(SCILISTA_XML)

    inform_step('XMLPREPROC: SCILISTA', '{}'.format(SCILISTA_DATETIME))

    select_title_issue_code_databases()
    REGISTERED_ISSUES = get_registered_issues()

    inform_step('XMLPREPROC: SCILISTA TESTE', '')
    n = 0
    for item in SCILISTAXML_ITEMS:
        n += 1
        parts = item.split()
        if validate_line_format(parts) is not True:
            inform_error(ERROR_FILE, 'Linha {}: "{}" tem formato invalido'.format(n, item))
            scilista_ok = False
        else:
            acron, issueid = parts[0], parts[1]
            issue = '{} {}'.format(acron, issueid)
            if issue not in REGISTERED_ISSUES:
                inform_error(ERROR_FILE, 'Linha {}: "{}" nao esta registrado'.format(n, issue))
                scilista_ok = False
            elif not exist_base(XML_SERIAL_LOCATION, acron, issueid):
                bfilename = mst_filename(XML_SERIAL_LOCATION, acron, issueid)
                inform_error(ERROR_FILE, 'Linha {}: "{}" nao localizado'.format(n, bfilename))
                scilista_ok = False
            else:
                copy_items, append_commands, msg, para_processar = verificar_bases_para_coletar(acron, issueid)
                arquivos_esperados_para_processar.extend(para_processar)
                if msg is None:
                    coletar_append_commands.extend(append_commands)
                    coletar_copy_items.extend(copy_items)
                else:
                    scilista_ok = False
                    inform_error(ERROR_FILE, msg)
else:
    inform_error(ERROR_FILE, '{} not found'.format(SCILISTA_XML))


comments = ''
coletaxml_ok = False
if scilista_ok is True:
    coletaxml_ok = True
    for xml_item, proc_item in coletar_copy_items:
        errors = coletaxml(xml_item, proc_item)
        if len(errors) > 0:
            inform_error(ERROR_FILE, '\n'.join(errors))
            coletaxml_ok = False
    if coletaxml_ok is True:
        inform_step('XMLPREPROC: COLETA XML', 'Verifica se ha arquivos nao coletados')
        for file in arquivos_esperados_para_processar:
            if not os.path.exists(file):
                coletaxml_ok = False
                inform_error(ERROR_FILE, 'Coleta incompleta. Falta {}'.format(file))
    if coletaxml_ok is True:
        SCILISTA_ITEMS = join_scilistas()
        for item in SCILISTAXML_ITEMS:
            if item not in SCILISTA_ITEMS:
                coletaxml_ok = False
                inform_error(ERROR_FILE, 'Nova scilista. Falta {}'.format(item))
        if coletaxml_ok is True:
            for command in coletar_append_commands:
                inform_step('XMLPREPROC: COLETA XML', command)
                os_system(command)
            for delitem in DELLIST:
                print('Deleted {}'.format(delitem))
                os.unlink(delitem)
            save_new_scilista(SCILISTA_ITEMS)

comments = '{}: {} itens\n{}: {} itens\n'.format(
        SCILISTA_XML,
        len(SCILISTAXML_ITEMS),
        SCILISTA,
        len(SCILISTA_ITEMS))

subject = 'Erros encontrados'
errors = None
if coletaxml_ok is True:
    subject = 'OK'
else:
    errors = open(ERROR_FILE, 'r').read()
msg_filename = create_msg_file(SCILISTA_DATETIME, PROC_DATETIME, errors, comments)

send_mail(MAIL_TO, MAIL_BCC, MAIL_CC, subject, SCILISTA_DATETIME, msg_filename)

print("\n"*3)
print("="*30)

print("Proximo passo:")
print('Executar processar.sh')

