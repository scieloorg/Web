    



    var text = "";
    var main = this;
    var w;
    var IE4 = (document.all && !document.getElementById) ? true : false;
    var NS4 = (document.layers) ? true : false;
    var IE5 = (document.all && document.getElementById) ? true : false;
    var NS6 = (document.getElementById && !document.all) ? true : false;
    var language = "";
    
    function OpenWindow()
    {
    	if (text == "") 
    	{
    		return;
    	}
    	
    	if (w && !w.closed)
    	{
    		w.focus();
    		return;
    	}
    	wHeight = 350;
    	wWidth = 430;
    	wTop = 0;
    	wLeft = screen.availWidth - wWidth;
    
    	features = "height=" + wHeight + ",width=" + wWidth + "resizable=yes,scrollbars=yes";
    
    	if (NS4 || NS6)
    	{
    		features += ",screenY=" + wTop + ",screenX=" + wLeft;
    	}
    	else
    	{
    		features += ",top=" + wTop + ",left=" + wLeft;
    	}
    
    	w = open("","_Teste", features);
    	w.document.open();
    	w.document.write(text);
    	w.document.close();
    }
    
    function CloseWindow()
    {
    	if (w && !w.closed)
    	{
    		w.close();
    	}
    }

    function CreateWindowHeader(title, imgsrc, lng)
    {
		text  = "<html>\n";
		text += " <head>\n";
		text += "  <title>" + title + "</title>\n";
		text += " </head>\n";
		text += " <body bgcolor=\"#FFFFFF\" link=\"#000080\" vlink=\"#800080\" >\n";
		text += "   <img src=\"" + imgsrc + "\"><br>\n";
        language = lng;
    }
    
    function InsertAuthor(author, url)
    {
	text += "   <table>\n";    
    	text += "    <tr>\n"; 
    	text += "     <td valign=\"top\"><font face=\"Symbol\">·</font>&nbsp;</td>\n"; 
    	text += "     <td>\n"; 
    	text += "      <font face=\"Verdana\" size=\"1\">\n"; 
    	text += "       <a href=\"javascript:void(0)\" onclick=\"opener.location='"; 
    	text += url;
    	text += "'; self.close();\" onmouseover=\"opener.status='"; 
    	text += url;
    	text += "'; return true;\" onmouseout=\"opener.status='';\">"; 
    	text += author; 
    	text += "</a>\n"; 
    	text += "      </font>\n"; 
    	text += "     </td>\n"; 
    	text += "    </tr>\n";         
	text += "   </table>\n";
    }
    
    function CreateWindowFooter()
    {
		text += "   <p>\n";
		text += "    <center>\n";
		text += "  <form>\n";
		text += "     <input type=\"Button\" value=\"";
		
        switch (language)
        {
            case 'es': text += "Cerrar"; break;
            case 'pt': text += "Fechar"; break;
            default:   text += "Close"; 
        }
	
		text += "\" onclick=\"self.close();\">";
		text += "    </center>\n";
		text += "   </p>\n";
		text += "  </form>\n";
		text += " </body>\n";
		text += "</html>\n";
    } 
