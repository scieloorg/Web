import os
from datetime import datetime

import doi_box as doi_box
import article_box as article_box
import crossref as crossref


def new_xml_files(limit_date=None):
    if limit_date is None:
        limit_date = datetime.now().isoformat().replace('-', '')[0:8]
    article_box.new_xml_files(limit_date)


def query(new=True, pending=True):
    for f in article_box.get_xml_to_process(new, pending):
        _pid = os.path.basename(f)
        pid, doi = crossref.query_doi(open(f).read())
        if _pid == pid:
            doi_box.save(pid, doi)
        else:
            print('ERROR: ' + _pid + ' returned ' + pid)


def pids(doi):
    return doi_box.get_pids(doi)


def doi(pid):
    return doi_box.get_doi(pid)
