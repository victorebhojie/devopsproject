import json as j, urllib.request

with urllib.request.urlopen("https://raw.githubusercontent.com/victorebhojie/devopsproject/master/data.json") as url:

    d = j.loads(url.read().decode())
    open("C:/Users/user/Desktop/devopsproject/tem.xml", "w")

import xml.etree.cElementTree as e        
def xml():
    r = e.Element("Employee")

    e.SubElement(r,"Name").text = d["Name"]

    e.SubElement(r,"Designation").text = d["Designation"]

    e.SubElement(r,"Salary").text = str(d["Salary"])

    e.SubElement(r,"Age").text = str(d["Age"])

    a = e.ElementTree(r)

    a.write("C:/Users/user/Desktop/devopsproject/tem.xml")
xml()    