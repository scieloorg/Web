<?php
include_once("class_xml_check.php");

$myxml='<?xml version="1.0"?>
<foo>
 <data id="1">
   <name>pepe</name>
   <num>2</num>
 </data>
 <data>
   <name>foo</name>
   <num>5</num>
 </data>
</foo>';

$check = new XML_check();
//if($check->check_url("http://www.w3.org/")) {
if($check->check_string($myxml)) {
  print("XML is well-formed<br/>");
  print("<pre>");
  print("Elements      : ".$check->get_xml_elements()."<br/>");
  print("Attributes    : ".$check->get_xml_attributes()."<br/>");
  print("Size          : ".$check->get_xml_size()."<br/>");
  print("Text sections : ".$check->get_xml_text_sections()."<br/>");
  print("Text size     : ".$check->get_xml_text_size()."<br/>");
  print("</pre>");
} else {
  print("XML is not well-formed<br/>");
  print($check->get_full_error());
}
?>
