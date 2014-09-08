# encoding: utf-8

import os
import sys
import urllib
import urllib2


# author and title
#http://doi.crossref.org/servlet/query?usr=&pwd=&format=unixref&qdata=<?xml version="1.0"?><query_batch version="2.0" xsi:schemaLocation="http://www.crossref.org/qschema/2.0 http://www.crossref.org/qschema/crossref_query_input2.0.xsd" xmlns="http://www.crossref.org/qschema/2.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><head><email_address>bireme.crossref@gmail.com</email_address><doi_batch_id>sfafafafa</doi_batch_id></head><body><query enable-multiple-hits="true" key="key1"><article_title match="exact">Preparation and evaluation of a biomimetic scaffold with porosity gradients in vitro</article_title><author search-all-authors="true">Wang</author></query></body> </query_batch>


def query_batch_url(usr, pswd, xml_query_batch):
    params = {'usr': usr, 'pwd': pswd, 'format': 'unixref', 'qdata': xml_query_batch}
    return 'http://doi.crossref.org/servlet/query?' + urllib.urlencode(params)


def request(url):
    return urllib2.urlopen(url, timeout=15).read()


def registered_pid(query_result):
    pid = ''
    r = query_result[query_result.find('<identifier '):]
    if r != query_result:
        r = r[r.find('>')+1:]
        r = r[0:r.find('<')]
        pid = r
    return pid


def registered_doi(query_result):
    doi = ''
    r = query_result[query_result.find('<doi>'):]
    if r != query_result:
        r = r[r.find('>')+1:]
        r = r[0:r.find('<')]
        doi = r
    return doi


def add_doi_prc(pid, doi):
    return ",'d9881d9237a9881{" + pid + "{a9237{" + doi + "{',"


def query(user, password, query_file):
    path = os.path.dirname(query_file)
    add_doi_prc_file = 'add_doi.prc'

    if os.path.isfile(path + '/' + add_doi_prc_file):
        os.unlink(path + '/' + add_doi_prc_file)

    if os.path.isfile(query_file):
        result = request(query_batch_url(user, password, open(query_file, 'r').read()))
        print(result)
        if result is not None:
            doi = registered_doi(result)
            print(doi)
            pid = registered_pid(result)
            print(pid)
            if doi != '' and pid != '':
                open(path + '/' + add_doi_prc_file, 'w').write(add_doi_prc(pid, doi))


script, user, password, query_file = sys.argv
query(user, password, query_file)
