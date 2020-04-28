# coding=utf-8
import os
from datetime import datetime


CISIS = "cisis/mx"


def update_command(db, mfn, count, proc):
    cmd = ("{CISIS} {db} from={mfn} count={count} "
           "\"proc={proc}\""
           " copy={db} now -all").format(
            CISIS=CISIS,
            db=db,
            mfn=mfn,
            count=count,
            proc=proc
        )
    return cmd


def execute(cmd):
    os.system(cmd)


def proc_update_doi(file_path, doi, doi_items):
    """
    Retorna a "proc" que atualiza
    os campos v237 com DOI original e 337 todos os DOI com idioma
    """
    if not file_path:
        raise ValueError("Invalid value for file_path")
    if not doi:
        raise ValueError("Invalid value for DOI")
    proc_d = "'d337d237a237~{}~'".format(doi)
    proc_a337 = [
        ",'a337~^l{}^d{}~'".format(lang, _doi)
        for lang, _doi in doi_items
    ]
    return "if 'hf':v706 and v702='{}' then {} fi".format(
            file_path,
            proc_d + ''.join(proc_a337)
        )


def proc_update_datetime(file_path):
    """
    Retorna a "proc" que atualiza
    os campos v91 (data) e v92 (hora) da atualização
    """
    now = datetime.now().isoformat()
    d = now[:10].replace("-", "")
    t = now[11:16].replace(":", "")
    proc = "'d91d92a91~{}~a92~{}~'".format(d, t)
    return "if v706='o' and v702='{}' then {} fi".format(
            file_path,
            proc
        )


def get_commands_to_update_ohf_records_of_a_doc(
        db, file_path, h_mfn, doi, doi_items):
    """
    Gera dois comandos para atualizar 1 documento os registros:
    - h e f: os campos v237 com DOI original e 337 todos os DOI com idioma
    - o: os campos v91 (data) e v92 (hora) da atualização
    """
    o_mfn = str(int(h_mfn) - 1)
    o_proc = proc_update_datetime(file_path)
    o_cmd = update_command(db, o_mfn, 1, o_proc)
    hf_proc = proc_update_doi(file_path, doi, doi_items)
    hf_cmd = update_command(db, h_mfn, 2, hf_proc)
    return [o_cmd, hf_cmd]
