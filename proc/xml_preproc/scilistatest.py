#!/usr/bin/env python2.7
# coding: utf-8
import os


def read_ini_file():
    PARAMETERS = {}
    for item in open('xml_preproc.ini').readlines():
        item = item.strip()
        if '=' in item:
            NAME, VALUE = item.split('=')
            PARAMETERS[NAME] = VALUE
    return PARAMETERS


def get_registered_issues():
    REGISTERED_ISSUES = '../serial/registered.txt'
    ISSUE_DB = '../serial/issue/issue'
    PFT = "v930,' ',if v32='ahead' then v65*0.4, fi,|v|v31,|s|v131,|n|v32,|s|v132,v41/ "
    CMD = 'mx {} "pft={}" now | sort -u > {}'.format(ISSUE_DB, PFT, REGISTERED_ISSUES)
    os.system(CMD)

    registered_issues = None
    if os.path.isfile(REGISTERED_ISSUES):
        registered_issues = open(REGISTERED_ISSUES, 'r').read()
        registered_issues = registered_issues.lower()
    return registered_issues


def inform_error(fbug, msg):
    print(msg)
    fbug.write(msg)


PARAMETERS = read_ini_file()
XMLPREPROC_XML_SERIAL_PATH = PARAMETERS.get('XMLPREPROC_XML_SERIAL_PATH')
registered_issues = get_registered_issues()
SCILISTA_XML = '../serial/scilistaxml.lst'

# Show directory local
print('dir local: {}'.format(os.getcwd()))

# Create error file
fbug = open('scilista-erros.txt', 'w')
fbug.write('')

# Check if exists scilistaxml.lst
if not os.path.exists(SCILISTA_XML):

    print('Error: Not found {}'.format(SCILISTA_XML))
    fbug.write('Error: Not found {}\n'.format(SCILISTA_XML))
    exit('check {}'.format(SCILISTA_XML))

print('----------------------------------------------\n')

# Builds a list from scilistxml.lst

NOT_REGISTERED = []
n = 0
for row in open(SCILISTA_XML, 'r').readlines():
    n += 1
    row = row.strip()
    print('Checking line {}'.format(row))
    acron = None
    issueid = None
    _del = None
    if len(row) > 0:
        items = row.split(' ')
        if len(items) == 2:
            acron, issueid = items
        elif len(items) == 3:
            acron, issueid, _del = items
    valid = False
    if acron is not None and issueid is not None:
        if _del in [None, 'del']:
            path = '{}/{}/{}'.format(XMLPREPROC_XML_SERIAL_PATH, acron, issueid)
            if os.path.exists(path):
                valid = True
                issue = '{} {}'.format(acron, issueid)
                if issue not in registered_issues:
                    NOT_REGISTERED.append(issue)
            else:
                msg = 'Error: Fasciculo nao localizado: {}'.format(path)
                inform_error(fbug, msg)

    if valid is False:
        msg = 'Error: Conteudo invalido da linha {}: {}'.format(n, row)
        inform_error(fbug, msg)
fbug.close()


not_registered = '\n'.join(NOT_REGISTERED) if len(NOT_REGISTERED) > 0 else ''
open('./NOT_REGISTERED.txt', 'w').write(not_registered)
