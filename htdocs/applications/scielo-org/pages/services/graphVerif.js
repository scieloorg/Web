/* Funções de Verificação do Formulário */

// verifica o tamanho de um input
function tamanho(objeto) 
{
	if (objeto.value.length != 4) 
	{
		objeto.focus();
		return false;
	}	
	return true;
}
// verifica se o usuario está digitando um numero
function isNumber(objeto)
{
	var ValidChars = "0123456789.";
	var Char;

	for (i = 0; i < objeto.value.length; i++) 
	{ 
		Char = objeto.value.charAt(i); 
		if (ValidChars.indexOf(Char) == -1) 
		{
			objeto.focus();
			return false;
		}
	}
	return true;
}

// Verifica se a data é valida
function dataValida(objeto)
{
	if(objeto.value < 1950)
	{
		objeto.focus();
		return false;
	}
	else if(objeto.value > 2150)
	{
		objeto.focus();
		return false;
	}
	else
	{
		objeto.focus();
		return true;
	}
}

// valida o formulário
function valida_form() 
{
	if (!tamanho(document.form1.startYear)) 
	{
		return false;
	}
	else if(!isNumber(document.form1.startYear))
	{
		return false;
	}
	else if(!dataValida(document.form1.startYear))
	{
		return false;
	}
	else if(document.form1.lastYear.value.length != 0)
	{
		if(!tamanho(document.form1.lastYear))
		{
			return false;
		}
		else if(!isNumber(document.form1.lastYear))
		{
			return false;
		}
		else if(!dataValida(document.form1.lastYear))
		{
			return false;
		}
		else if( document.form1.startYear.value > document.form1.lastYear.value )
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	// se somente startYear tem valor então lastYear fica com o mesmo valor
	// e pesquisamos a estatisticas de um ano especifico
	else if(document.form1.lastYear.value.length == 0 )
	{
		document.form1.lastYear.value = document.form1.startYear.value;
		return true;
	}
	else 
	{
		return true;
	}
}