import box as box


pid_doi_path = ''
doi_pid_path = ''


def save_pid_doi(self, pid, doi):
    f = open(box.filename(pid_doi_path, pid), 'w')
    f.write(doi)
    f.close()


def get_doi(pid):
    return open(box.filename(pid_doi_path, pid)).read()


def get_pids(doi):
    return []
