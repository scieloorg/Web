import os
import sys

class XRefQuery:
    def __init__(self, xref_script_path, username, password, email, path, max):
        self.max = max
        self.xref_script_path = xref_script_path
        self.username = username
        self.password = password
        self.email = email
        self.path_temp = path_temp
    
    
    def execute_submission(self, list_filename, result_filename):
        f = open(list_filename, 'r')
        items = f.readlines()
        f.close()
        
        f = open('report.txt', 'w')
        f.write(str(len(items)))
        f.close()
        
        files = [] 
        k = 0
        for item in items:
            file = item.replace("\n", "").replace("\r", "")
            
            files.append(file)
            if len(files) == self.max:
                k += 1
                doi_batch_id = str(k)
                xml_filename = self.path_temp + '/' + doi_batch_id + '.xml'
                self.build_and_submit_xml(doi_batch_id, xml_filename, result_filename)
                
        if len(files) > 0:
            k += 1
            doi_batch_id = str(k)
            xml_filename = self.path_temp + '/' + doi_batch_id + '.xml'
            self._build_and_submit_xml(doi_batch_id, xml_filename, result_filename) 
             
    def _build_and_submit_xml(self, doi_batch_id, xml_list, xml_filename, result_filename):
        if len(xml_list)>0:
            self._build_xml(xml_list, self.email, doi_batch_id, xml_filename)
            if os.path.isfile(xml_filename):
                self._submit_xml(xml_filename, result_filename)
    
    
    
    def _submit_xml(self, xml_file, result_filename):
        os.system('cd ' + self.xref_script_path)
        cmd = 'sh ./CrossRefQuery.sh -f ' + xml_file + ' -t d -a live -u ' + self.username + ' -p ' +  self.password + ' -r piped >> ' + result_filename
		print(cmd)
		os.system(cmd)
    
    def _build_xml(self, files, email, doi_batch_id, filename):
        f = open(filename, 'w')
        xml = '<?xml version="1.0" encoding="iso-8859-1"?>'
        xml += '<query_batch version="2.0" xmlns="http://www.crossref.org/qschema/2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
        xml += '<head><email_address>' + email + '</email_address><doi_batch_id>' + doi_batch_id + '</doi_batch_id></head>'
        xml += '<body>'
        xml += self._get_xml_content_and_move(files)
        xml +'</body></query_batch>'
        f.write(xml)
        f.close()
        return (os.path.isfile(filename))
    
    def _get_xml_content_and_move(files):
        for f in files:
            xml += self._get_xml_content(f)
            self._move_new_to_sent(f)
        return xml
        
    def _move_new_to_sent(self, file):
        r = ''
        if os.path.isfile(file):
            path = file[0:file.rfind('/')]
            file = file[file.rfind('/')+1]
            path_sent = file.replace('new', 'sent')
            if not os.path.exists(path_sent):
                try:
                    os.makedirs(path_sent)
                except:
                    print('Unable to create ' + path_sent)
            if os.path.exists(path_sent):
                try: 
                    os.rename(path + '/' + file, path_sent + '/' + file)
                    r = path_sent + '/' + file
                        
                except:
                    print('Unable to rename ' + path + '/' + file + ' ' +  path_sent + '/' + file)
        return r
    
    def _get_xml_content(self, file):
        f = open(file, 'r')
        content = f.read()
        f.close()
        
        return content
        
params = ['', 'path of CrossRefQuery.sh', 'username', 'password', 'e-mail',  'temp path', 'max ref by submission ( < 15)', 'xml list filename', 'result filename', ]
           
if len(sys.argv) != len(params):
    print('Usage:')
    i = 0
    for param in params:
        i += 1
        print('Parameter ' + str(i) +': ' +  param
    
else:
    xref_script_path = sys.argv[1]
    username = sys.argv[2]
    password = sys.argv[3]
    email = sys.argv[4]
    path_temp = sys.argv[5]
    max = sys.argv[6]
    list_filename = sys.argv[7]
    result_filename = sys.argv[8]
    
    xref_query = XRefQuery( xref_script_path, username, password, email, path_temp, max)
    xref_query.execute_submission(list_filename, result_filename)
    
        
        
