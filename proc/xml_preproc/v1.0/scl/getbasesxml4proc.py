#!/usr/bin/env python2.7
import os

#Directory to CISIS
#cisis_dir = '~/cisis/5.6.alfa2/linux/lindG4/'
cisis_dir = '/usr/local/bireme/cisis/5.5.pre02/linux/lindG4/'

#Show directory local
print "dir local: %s" % os.getcwd()+'\n'

#Create file errors
#fbugs = open('scilista-erros.txt', 'w')

#Check if exists scilistaxml.lst
if os.path.exists("../serial/scilistaxml.lst"):
    print "Content of ../serial/scilistaxml.lst:"
    os.system("cat ../serial/scilistaxml.lst")
else:
    print "Error: scilistaxml.lst not exists in ../serial "
    exit("check ../serial/scilistaxml.lst")

#Builds a list from scilistxml.lst
lst = []
f = open('../serial/scilistaxml.lst', 'r')
for row in f:
    lst.append(row.split())
f.close()

#Copy Bases
for issue in lst:
    try:
        print "\nWorking Issue > "+issue[0]+" "+issue[1]
        if os.path.exists('../serial/'+issue[0]):
            print "Directory exists: ../serial/"+issue[0]
        else:
            print "Create directory: ../serial/"+issue[0]
            os.mkdir('../serial/'+issue[0])
    except IndexError:
        print 'Erro na linha da scilista:'+issue[0]
        #fbugs.write(issue[0]+'\tfasciculo ilegivel - corrigir\n')
        continue

    print "Copying Bases from /bases/xml.000/serial/" + issue[0] + "/" + issue[1] + "\n"
    if os.path.exists('/bases/xml.000/serial/' + issue[0] + '/' + issue[1]):
        #Caso seja nahead e a base ja exista em ../serial, faz append dos dados.
        if 'nahead' in issue[1] and os.path.exists('../serial/'+issue[0] + "/" + issue[1] + "/base/" + issue[1] + ".mst"):
            print 'Foram identificadas bases tipo NAHEAD iguais.\n'
            print issue[0]+' '+issue[1]+'\n'
            app_nahead = cisis_dir+'mx /bases/xml.000/serial/'+issue[0]+'/'+issue[1]+'/base/'+issue[1]+' from=2 append=../serial/'+issue[0]+'/'+issue[1]+'/base/'+issue[1]+' -all now tell=1'
            print 'O comando abaixo sera executado:'
            print app_nahead
            raw_input('\nTecle ENTER para continuar...\n ')
            #Append nahead
            os.system(app_nahead)
        else:
            #Copy bases
            #example:  cp -rp /bases/xml.000/serial/    <acron>     /    <issue>     / ../serial/<acron>/
            os.system('cp -rp /bases/xml.000/serial/' + issue[0] + '/' + issue[1] + '/ ../serial/'+issue[0])
    else:
        print '/bases/xml.000/serial/' + issue[0] + '/' + issue[1] + ": Not found\n"
	print 'O fasciculo ' + issue[0] + '/' + issue[1] + ": Nao foi localizado\n"
        #fbugs.write(issue[0] + ' ' + issue[1] + '\tfasciculo nao localizado - verificar\n')

#Close file bugs
#fbugs.close()

#Finalization
print "\nscilistaxml.lst worked! \n"

exit("\nFinished!")
