#!/usr/bin/env python2.7
import os
import logging
import shutil
import urllib2


logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(message)s',
    filename='app.log')


def info(msg):
    logging.info(msg)


def read_lines(filename):
    with open(filename) as f:
        r = f.readlines()
    return r


def read_filename(filename):
    with open(filename) as f:
        r = f.read()
    return r


def write_filename(filename, content, mode='w'):
    with open(filename, mode) as f:
        f.write(content)


def read_scielo_issn_lists(input_file):
    journals = []
    for line in read_lines(input_file):
        columns = line.strip().split('|')
        if len(columns) == 3:
            journal_title, issn_pid, issn = columns
            journals.append((journal_title, issn_pid, issn))
    info('Total de ISSNS: ' + str(len(journals)))
    return journals


def read_scimago_list(scimago_list_file):
    scimago_journals = {}
    if os.path.isfile(scimago_list_file):
        for item in read_lines(scimago_list_file):
            item = item.strip().split('|')
            if len(item) == 2:
                issn_id, scimago_id = item
                scimago_journals[issn_id] = scimago_id
    info('Total de SCIMAGO ID (INICIO): ' + str(len(scimago_journals)))
    return scimago_journals


def write_scimago_list(scimago_journals, scimago_list_file):
    items = sorted([k+'|'+v for k, v in scimago_journals.items()])
    info('Total de SCIMAGO ID (FIM): ' + str(len(items)))
    shutil.copy2(scimago_list_file, scimago_list_file+'.bkp')
    write_filename(scimago_list_file, '\n'.join(items))


def get_new_scimago_list(scimago_journals, input_items, scrap_error_file):
    new_scimago_journals = {}
    new_items = [(journal_title, issn_pid, issn)
                 for journal_title, issn_pid, issn in input_items
                 if issn_pid not in scimago_journals.keys()]
    total = len(new_items)
    info('Total de ISSN para obter SCIMAGO ID: ' + str(total))
    n = 0
    for item in new_items:
        journal_title, issn_pid, issn = item
        if issn_pid in new_scimago_journals.keys():
            info('Ja registrado: '+issn_pid)
        else:
            info('Consultar '+issn_pid)
            scimago_id = get_scimago_id(issn, scrap_error_file)
            if scimago_id is not None:
                new_scimago_journals[issn_pid] = scimago_id
        n += 1
        info(
            '  Executado: get_scimago_id('+issn_pid+'): ' +
            str(n)+'/'+str(total))
    return new_scimago_journals


def url_journal_search(alt_issn):
    return 'http://www.scimagojr.com/journalsearch.php?q='+alt_issn + \
        '&tip=iss&clean=0'


def url_journal_img(scimago_id):
    return 'http://www.scimagojr.com/journal_img.php?id=' + scimago_id + \
        '&title=false'


def get_url(url):
    req = urllib2.urlopen(url)
    return req.read()


def get_scimago_id(issn, scrap_error_file):
    alt_issn = issn.replace('-', '')
    url = url_journal_search(alt_issn)
    with open('temp_scimago_id.txt', 'wb') as f:
        f.write(get_url(url))
    if os.path.isfile('temp_scimago_id.txt'):
        s = read_filename('temp_scimago_id.txt')
        if 'no results were found' in s:
            info('  No results were found.')
        elif 'journalsearch.php?q=' in s:
            items = s.split('journalsearch.php?q=')
            _id = items[-1]
            _id = _id[:_id.find('&')]
            info('  Obtido scimago_id: '+_id)
            return _id
        else:
            info('  SCRAP FAILED: RESULT CHANGED')
            write_filename(scrap_error_file, url+'\n'+s, 'a')
    else:
        info('temp_scimago_id.txt not found.')


def download_graphic(issn_pid, scimago_id, images_path):
    alt_issn_pid = issn_pid.replace('-', '')
    image_filename = images_path+'/'+alt_issn_pid+'.gif'
    with open(image_filename, 'wb') as f:
        f.write(get_url(url_journal_img(scimago_id)))
    if os.path.isfile(image_filename):
        return image_filename


def generate_xml(scimago_journals, xml_file):
    total = len(scimago_journals)
    n = 0
    xml = '<SCIMAGOLIST>\n'
    for issn_pid, scimago_id in scimago_journals.items():
        alt_issn_pid = issn_pid.replace('-', '')
        xml += ' <title ISSN="'+alt_issn_pid + \
               '" SCIMAGO_ID="'+scimago_id+'"/>\n'
        n += 1
    xml += '</SCIMAGOLIST>'
    write_filename(xml_file, xml)
    info('Total de SCIMAGO ID: '+str(total))


def download_images(scimago_journals, images_path, report_filename, xml_file):
    images_failed = []
    total = len(scimago_journals)
    n = 0
    xml = '<SCIMAGOLIST>\n'
    for issn_pid, scimago_id in scimago_journals.items():
        image_file = download_graphic(issn_pid, scimago_id, images_path)
        if image_file is None:
            images_failed.append(issn_pid+'|'+scimago_id)
        else:
            alt_issn_pid = issn_pid.replace('-', '')
            xml += ' <title ISSN="'+alt_issn_pid + \
                   '" SCIMAGO_ID="'+scimago_id+'"/>\n'
        n += 1
        info('  Executado: download('+scimago_id+'): '+str(n)+'/'+str(total))
    xml += '</SCIMAGOLIST>'
    write_filename(xml_file, xml)

    info('Total de SCIMAGO ID: '+str(len(scimago_journals)))
    info('Total de imagens em ' + images_path + ': ' +
         str(len(os.listdir(images_path))))
    if len(images_failed) > 0:
        content = 'These ISSN PID has no images\n'
        content += '\n'.join(images_failed)
        write_filename(report_filename, content)
        info('Relatorio: '+report_filename)


def report_not_processed(scielo_journals, scimago_journals, reports_path):
    # identifica todos os ISSN PID
    journal_titles = {}
    for jtitle, issn_id, issn in scielo_journals:
        journal_titles[issn_id] = jtitle

    not_found = [(issn, jtitle)
                 for issn, jtitle in journal_titles.items()
                 if issn not in scimago_journals.keys()]
    if len(not_found) > 0:
        items = [item[0] for item in not_found]
        write_filename(
            reports_path+'/issn_notfound.txt',
            'These ISSN PID has no SCIMAGO ID\n' + '\n'.join(items))

        items = [item[1]+'|'+item[0] for item in not_found]
        write_filename(
            reports_path+'/journal_notfound.txt',
            'These journals has no SCIMAGO ID\n' + '\n'.join(items))

        info('Total de SCIMAGO ID nao encontrado: '+str(len(not_found)))
        info('Relatorio: '+reports_path+'/issn_notfound.txt')
        info('Relatorio: '+reports_path+'/journal_notfound.txt')


def main():
    SCIMAGO_LIST_FILE = '../data/scimago_id_list.txt'
    SCIMAGO_LIST_DIR = '../data'
    REPORTS_PATH = '../reports'
    TMP_DIR = '../temp'
    TMP_IMG_PATH = '../temp/images'
    SCIELO_LIST_FILE = '../temp/temp_issns.txt'
    REPORT_SCRAP = '../reports/scrap_error.txt'
    XML = '../temp/meuXML.xml'

    if not os.path.isdir(REPORTS_PATH):
        os.makedirs(REPORTS_PATH)
    if not os.path.isdir(SCIMAGO_LIST_DIR):
        os.makedirs(SCIMAGO_LIST_DIR)
    if not os.path.isdir(TMP_DIR):
        os.makedirs(TMP_DIR)
    if not os.path.isdir(TMP_IMG_PATH):
        os.makedirs(TMP_IMG_PATH)

    write_filename('app.log', '')

    # le uma lista de journal title, issn_id, issn (eletronico ou impresso)
    scielo_journals = read_scielo_issn_lists(SCIELO_LIST_FILE)

    # le a lista de ISSN PID e SCIMAGO ID, se existir
    scimago_journals = read_scimago_list(SCIMAGO_LIST_FILE)

    # atualiza a lista de ISSN PID e SCIMAGO ID, se ha novos ISSN PID
    write_filename(REPORT_SCRAP, '')
    new_scimago_journals = get_new_scimago_list(
        scimago_journals, scielo_journals, REPORT_SCRAP)
    if len(new_scimago_journals) > 0:
        scimago_journals.update(new_scimago_journals)
        write_scimago_list(scimago_journals, SCIMAGO_LIST_FILE)

    # gera XML que eh usado no site SciELO
    generate_xml(scimago_journals, XML)

    # informa os ISSNs para os quais nao encontrou scimago
    report_not_processed(scielo_journals, scimago_journals, REPORTS_PATH)
    info('fim')

if __name__ == '__main__':
    main()
