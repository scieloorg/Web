import os


def folder_path(path, pid):
    if len(pid) == 23:
        subdir = 'art'
    else:
        subdir = 'ref'

    r = path + '/' + subdir + '/' + pid[1:2] + '/' + pid[1:10] + '/' + pid[10:14]
    if not os.path.isdir(r):
        os.makedirs(r)
    return r


def filename(path, pid):
    return folder_path(path, pid) + '/' + pid


def folder_files(path):
    _files = []
    for path1 in os.listdir(path):
        for path2 in os.listdir(path + '/' + path1):
            for path3 in os.listdir(path + '/' + path1 + '/' + path2):
                _files += os.listdir(path + '/' + path1 + '/' + path2 + '/' + path3)
    return _files


def files(path, articles=True, references=True):
    r1 = []
    r2 = []
    if articles:
        r1 = folder_files(path + '/art')
    if references:
        r2 = folder_files(path + '/ref')
    return r1 + r2
