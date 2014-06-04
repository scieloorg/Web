import os
import tempfile

import box as box


MX = ''
DB = ''
PFT_QUERY = ''
new_path = ''
pending_path = ''
processed_path = ''
doi_path = ''


def _get_pid_list(limit_date):
    result = tempfile.NamedTemporaryFile(delete=False)
    result.close()

    if limit_date is None:
        pft = 'v880/,v881/'
    else:
        pft = 'if val(ref(mfn-1,v91)) > val(' + limit_date + '),' ',v880/,v881/ fi'

    cmd = MX + ' ' + DB + ' btell=0 "tp=h" lw=999 "pft=' + pft + '" now -all > ' + result.name
    print(cmd)
    os.system(cmd)

    return [f.strip('\r').strip('\n') for f in open(result.name, 'r').readlines()]


def _get_article_pid_list(pid):
    result = tempfile.NamedTemporaryFile(delete=False)
    result.close()

    cmd = MX + ' ' + DB + ' btell=0 "r=' + pid + '$" lw=999 "pft=v880/" now -all > ' + result.name
    print(cmd)
    os.system(cmd)

    return [f.strip('\r').strip('\n') for f in open(result.name, 'r').readlines()]


def _new_xml_file(pid):
    if is_processed(pid):
        delete_processed(pid)
    if is_pending(pid):
        delete_pending(pid)
    generate_xml_article(pid, box.filename(new_path, pid))


def _new_xml_files(pid_list, articles=True, references=False):
    for pid in pid_list:
        if articles:
            _new_xml_file(pid)
        if references:
            for ref_pid in _get_article_pid_list(pid):
                _new_xml_file(ref_pid)


def generate_xml_article(pid, xml_filename):
    cmd = MX + ' ' + DB + ' btell=0 "hr=' + pid + ' or r=' + pid + '" lw=999 "pft=@' + PFT_QUERY + '" now >> ' + xml_filename
    print(cmd)
    os.system(cmd)


def is_processed(pid):
    return os.path.isfile(box.filename(processed_path, pid))


def is_new(pid):
    return os.path.isfile(box.filename(new_path, pid))


def is_pending(pid):
    return os.path.isfile(box.filename(pending_path, pid))


def delete_processed(pid):
    return os.unlink(box.filename(processed_path, pid))


def delete_pending(pid):
    return os.unlink(box.filename(pending_path, pid))


def get_xml_to_process(new=True, pending=False):
    r = []
    if new:
        for f in os.listdir(new_path):
            r.append(new_path + '/' + f)
    if pending:
        for f in os.listdir(pending_path):
            r.append(pending_path + '/' + f)
    return r


