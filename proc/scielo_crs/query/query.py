import os
import sys
from datetime import datetime

import doi_box as doi_box
import article_box as article_box
import crossref as crossref


def new_xml_files(articles=True, references=True, limit_date=None):
    if limit_date is None:
        limit_date = datetime.now().isoformat().replace('-', '')[0:8]

    article_box.new_xml_files(article_box._get_pid_list(limit_date), articles, references)


def query(articles=True, references=True, new=True, pending=True):
    for f in article_box.get_xml_files_list(articles, references, new, pending):
        _pid = os.path.basename(f)
        pid, doi = crossref.query_doi(open(f).read())
        if _pid == pid:
            doi_box.save(pid, doi)
            article_box.change_status(f, pid, True)
        else:
            article_box.change_status(f, _pid, False)


def main():
    import argparse

    parser = argparse.ArgumentParser(description='CrossRef Query utility')
    parser.add_argument('--articles', help='query doi only for articles', action='store_true')
    parser.add_argument('--references', help='query doi only for references', action='store_true')
    parser.add_argument('--pending', help='query doi only for pending items', action='store_true')
    parser.add_argument('--new', help='query doi only for new/updated items', action='store_true')
    parser.add_argument('update_from', help='update query data from a given date (YYYYMMDD)')

    args = parser.parse_args()

    if args.articles or args.references:
        limit_date = args.update_from if len(args.update_from) == 8 else None
        if args.update_from:
            print('Updating from ' + limit_date)
            new_xml_files(args.articles, args.references, limit_date)
        if args.new or args.pending:
            print('Querying...')
            query(args.articles, args.references, args.new, args.pending)
    else:
        print('Nothing')

if __name__ == '__main__':
    main()
