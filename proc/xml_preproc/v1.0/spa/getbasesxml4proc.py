#!/usr/bin/env python2.7
import os

#show directory local
print "dir local: "+os.getcwd()

#check if exists scilistaxml.lst 
if os.path.exists("../serial/scilistaxml.lst"):
    print "Content of scilistaxml.lst"
    os.system("cat ../serial/scilistaxml.lst")
else:
    print "Error: scilistaxml.lst not exists in ../serial "
    exit("check scilistaxml.lst")

#Build a list from scilistxml.lst
print "\nBuilding a list from scilistxml.lst \n"

list=[]
file=open('../serial/scilistaxml.lst','r')
for row in file:
    list.append(row.split())
file.close()

#Copy bases    
for issue in list:
    print "Working Issue > "+issue[0]+" "+issue[1]
    if os.path.exists('../serial/'+issue[0]):
        print "Directory exists: ../serial/"+issue[0]
    else:
        print "Create directory: ../serial/"+issue[0]
        os.mkdir('../serial/'+issue[0])

    print "Copying Bases from /bases/xml.000/serial/" + issue[0] + "/" +issue[1] + "\n"
    if os.path.exists('/bases/xml.000/spa/spa.000/serial/' + issue[0] + '/' +issue[1]):
        #example:  cp -rp /bases/xml.000/serial/    <acron>     /   <issue>     / ../serial/<acron>/
        os.system('cp -rp /bases/xml.000/spa/spa.000/serial/' + issue[0] + '/' +issue[1] + '/ ../serial/'+issue[0])
    else:
        print '/bases/xml.000/spa/spa.000/serial/' + issue[0] + '/' +issue[1] + ": Not found\n"
    

#Finalization
print "\n scilistaxml.lst worked! \n"
vt=raw_input("Wold you like to view the directory tree? \npress y [yes] > ")
if vt == 'y':
    acronlist=[]
    for acron in list:
        if acron[0] not in acronlist:
            acronlist.append(acron[0])
    
    for acron in acronlist:
            os.system('tree ../serial/'+acron)
else:
    exit("\nFinished!")
