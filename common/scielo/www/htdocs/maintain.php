<?php include("old2new.inc"); ?>

<HTML>
<HEAD>
	<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
	<TITLE>SciELO system message</TITLE>
</HEAD>
<BODY LINK="#0000ff" VLINK="#800080" BGCOLOR="#ffffff">
    <TABLE CELLSPACING=0 BORDER=0 CELLPADDING=7 WIDTH="100%">
    <TR><TD WIDTH="20%" VALIGN="TOP">
    <P ALIGN="CENTER">
    <a href="http:/"><IMG SRC="img/fbpelogp.gif" border=0></a>
    </P></TD>
    <TD WIDTH="60%" VALIGN="MIDDLE">
    <P ALIGN="center"><FONT class="nomodel" SIZE=+1 COLOR="#000080">SciELO system message
    </FONT></P>
    </TD><TD WIDTH="20%" VALIGN="TOP">&nbsp;</TD></TR>
    </TABLE><BR>
    <TABLE BORDER=0 WIDTH="100%"><TR><TD WIDTH="20%">&nbsp;</TD><TD WIDTH="60%">
    <P ALIGN="CENTER"><FONT class="nomodel" COLOR="#800000">
	
	<?php
		switch (strtolower($lng))
		{
			case "en":
				echo "System is either being updated or<BR> temporarily inactive due to technical improvements.<BR>" .
    			     "Please check later or contact us through the e-mail below.";
				break;
			case "es":
			    echo "El sistema se está actualizando o<BR> se  están haciendo mejoras t&eacute;cnicas.<BR>" .
			         "Por favor, intente más tarde o cont&aacute;ctenos por el e-mail.";
				 break;
		
		    case "pt":
				echo "O sistema está sendo atualizado ou<br> estão sendo executadas melhorias técnicas.<br>" .
		    		 "Por favor, tente mais tarde ou contate-nos pelo e-mail.";
				break;
		}
    ?>
    </FONT></P>
    </TD><TD WIDTH="20%" VALIGN="TOP">&nbsp;</TD></TR></TABLE>
    <BR><BR>
    <p align="center">
    <a href="mailto:scielo@bireme.br"><IMG SRC="img/e-mailt.gif" border=0 alt="scielo@bireme.br"></a><BR>
    </center>
	<P>&nbsp;</P>
</BODY>
</HTML>
