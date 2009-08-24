#!/usr/bin/env python

from lxml import etree
from doaj_config import *

log_file = open('../output/doaj/file_log_01.txt','w')
#schema = StringIO('../xsd/doajArticles.xsd')
schema = open('../xsd/doajArticles.xsd')
xmlschema_doc = etree.parse(schema)
xmlschema = etree.XMLSchema(xmlschema_doc)
#xml = StringIO('../output/doaj/file_01.xml')
xml = open('../output/doaj/file_01.xml')
doc = etree.parse(xml)
log_file.write(str(xmlschema.validate(doc)))
