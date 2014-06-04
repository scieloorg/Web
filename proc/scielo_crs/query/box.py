

def folder_path(path, pid):
    return path + '/' + pid[1:2] + '/' + pid[1:10] + '/' + pid[10:14]


def filename(path, pid):
    return folder_path(path, pid) + '/' + pid
