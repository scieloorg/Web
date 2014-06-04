import os
import tempfile
import urllib2
import shutil


username = ''
pswd = ''
url_query_doi = 'http://doi.crossref.org/servlet/query?usr=' + username + '&pwd=' + pswd + '&format=unixsd&qdata='


def query_doi(xml_query):
    response = urllib2.urlopen(self.url_query_doi + xml_query)
    return handle_response_doi(response)


def handle_response_doi(response):
    pid = ''
    doi = None
    return (pid, doi)

