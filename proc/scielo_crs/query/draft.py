import os
import tempfile
import urllib2
import shutil


MX = ''
DB = ''
PFT_QUERY = ''


def get_pid_list():
    result = tempfile.NamedTemporaryFile(delete=False)
    result.close()

    cmd = MX + ' ' + DB + ' btell=0 "tp=h" lw=999 "pft=ref(mfn-1,v91),' ',v880,' ',v881/" now -all | sort > ' + result
    print(cmd)
    os.system(cmd)

    pid_list = []
    pid_index = {}

    index = 0
    fp = open(result.name, 'r')
    for i in fp.readlines():

        proc_date, pid, previous_pid = i.strip('\r').strip('\n').split(' ')

        if not proc_date in pid_index.keys():
            pid_index[proc_date] = index

        pid_list.append(proc_date, pid)

        index += 1
        if len(previous_pid) > 0:
            pid_list.append(proc_date, previous_pid)
            index += 1

    fp.close()

    return (pid_list, pid_index)


def generate_xml_article(self, pid, xml_filename):
    cmd = MX + ' ' + DB + ' btell=0 "hr=' + pid + ' or r=' + pid + '" lw=999 "pft=@' + PFT_QUERY + '" now > ' + xml_filename
    print(cmd)
    os.system(cmd)


def new_xml_files(pid_list, pid_indexes, limit_date):
    if not limit_date:
        limit_date = '00000000'

    if limit_date:
        index = pid_indexes.get(limit_date, 0)

    for i in range(index, len(pid_list)):
        pid, proc_date = pid_list[i]
        if is_processed(pid):

            exist = self.processed_folder.exist(pid)
            if not exist:
                exist = self.pending_folder.exist(pid)
            if not exist:
                exist = self.new_folder.exist(pid)
            if not exist:
                self.cisis.generate_xml_article(pid, self.new_folder.location(pid))


def pending_requests():


def processed_requests():


def 

def folder_path(path, pid):
    return path + '/' + pid[1:2] + '/' + pid[1:10] + '/' + pid[10:14]


def filename(path, pid):
    return folder_path(path, pid) + '/' + pid


class Article(object):

    def __init__(self, author, source, year):
        self.author = author
        self.source = source
        self.year = year


class CrossRefQueryProcessor(object):

    def __init__(self, username, pswd, cisis, new_path, processed_path, pending_path, query_results_path):
        self.new_folder = FileFolder(new_path)
        self.processed_folder = FileFolder(processed_path)
        self.query_results_folder = FileFolder(query_results_path)
        self.pending_folder = FileFolder(pending_path)
        self.cisis = cisis
        self.url_query_doi = 'http://doi.crossref.org/servlet/query?usr=' + username + '&pwd=' + pswd + '&format=unixsd&qdata='

    def new_files(self, pid_list, limit_date):
        if not limit_date:
            limit_date = '00000000'

        for pid, proc_date in pid_list:
            if int(proc_date) > int(limit_date):
                exist = self.processed_folder.exist(pid)
                if not exist:
                    exist = self.pending_folder.exist(pid)
                if not exist:
                    exist = self.new_folder.exist(pid)
                if not exist:
                    self.cisis.generate_xml_article(pid, self.new_folder.location(pid))

    def query_doi(self, xml_filename):
        pid = os.path.basename(xml_filename)
        query_expr = open(xml_filename, 'r').read()
        response = urllib2.urlopen(self.url_query_doi + query_expr)
        ign, doi = self.process_doi_query_result(response)
        if ign == pid:
            if doi is None:
                if not self.pending_folder.exist(pid):
                    shutil.move(xml_filename, self.pending_folder.location(pid))
            else:
                if not os.path.isfile(self.processed_folder(pid)):
                    shutil.move(xml_filename, self.processed_folder.location(pid))
                self.save_doi(pid, doi)

    def query_metadata(self, doi):
        response = urllib2.urlopen(self.url_query_metadata + doi)
        ign, metadata = self.process_metadata_query_result(response)
        if ign == doi:
            return self.process_metadata(metadata)

    def save_doi(self, pid, doi):
        self.query_results_folder.put(pid, doi)

    def process_doi_query_result(self, response):
        pid = ''
        doi = None
        return (pid, doi)

    def process_metadata_query_result(self, response):
        pid = ''
        doi = None
        return (pid, doi)

    def process_new(self):
        for f in os.listdir(self.new_path):
            self.query_doi(self.new_path + '/' + f)

    def process_pending(self):
        for f in os.listdir(self.pending_path):
            self.query_doi(self.pending_path + '/' + f)

    def doi(self, pid):
        return self.query_results_folder.get(pid)
