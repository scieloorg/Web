
    var language = 0;
    var startDate = "19700101";
    var limitDate = "20371231";

    var messages = [
        [   // english messages
            "Invalid date!",
            "Initial date is greater than final date!",
            "Date outside valid range: %s to %s"
        ],
        [   // portuguese messages
            "Data Inválida!",
            "Data inicial é maior que a data final!",
            "Data fora da faixa válida: %s a %s"
        ],
        [   // spanish messages
            "Fecha inválida!",
            "¡La fecha inicial es mayor que la fecha final!",
            "Fecha fuera del rango válido: %s al %s"
        ]
    ];
    
    var months = [
        // English abreviated month names
        [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ],
        // Portuguese abreviated month names
        [ "Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez" ],
        // Spanish abreviated month names
        [ "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic" ]
    ];    
    
    var lastDay = [31,28,31,30,31,30,31,31,30,31,30,31];
    function setLanguage(lang)
    {
        switch(lang)
        {
            case "en": language = 0; break;
            case "pt": language = 1; break;
            case "es": language = 2; break;
        }
    }
       
    function setStartDate(date)
    {
        startDate = date.substring(0,8); 
	if (date.length==6) startDate += '01'; 
    }
    
    function setLastDate(date)
    {
        limitDate = date.substring(0,8);
	if (date.length==6) limitDate += getLastDayOftheMonth(date.substring(4,6),date.substring(0,4));
    }
    function getLastDayOftheMonth(month,year){
	day = lastDay[month-1];
	if (month == 2) {
		if (isLeapYear(year)){
			day = 29;
		}
	}
	return day;
    }    
    function CreateSelect (name, type, defaultOption, reversed)
    {
        var i = 0;
        var lim1 = 1;
        var lim2 = 0;
        var value = 0;
        var option = 0;
        if (type == 'd') {
		// mudança para melhorar a performance da carga da página 20060313
		document.write(' <input type="hidden" name="' + name + '" value="'+defaultOption+'">\n');
		return;
	}


        document.write(' <select name="' + name + '" size="1">\n');
//        document.write('  <option value=""></option>\n');
        
        switch (type)
        {
            case 'd': lim1 = 1; lim2 = 31; break;
            case 'm': lim1 = 1; lim2 = 12; break;
            case 'y': lim1 = startDate.substring(0,4); lim2 = limitDate.substring(0,4); break;
        }
        if (reversed)
        {           
            for (i = lim2; i >= lim1; i--)
            {
                value = i < 10 ? '0' + i : i;
                option = type == 'm' ? months[language][i-1] : value;
                
                if (defaultOption == i)
                {
                    document.write('  <option value="' + value + '" selected>' + option + '</option>\n');            
                }
                else
                {
                    document.write('  <option value="' + value + '">' + option + '</option>\n');            
                }
            }
        }
        else
        {
            for (i = lim1; i <= lim2; i++)
            {
                value = i < 10 ? '0' + i : i;
                option = type == 'm' ? months[language][i-1] : value;

                if (defaultOption == i)
                {
                    document.write('  <option value="' + value + '" selected>' + option + '</option>\n');            
                }
                else
                {
                    document.write('  <option value="' + value + '">' + option + '</option>\n');            
                }
            }
        }          
        
        document.write(' </select>\n');
    }

    function CreateForm(initDate, finalDate)
    {
        var stdt = startDate.substring(0,4);
        var lmdt = limitDate.substring(0,4);
        if (initDate == '') initDate = startDate;
        if (finalDate == '') finalDate = limitDate;
        
	// mudança para melhorar a performance da carga da página 20060313

	initDate += '01';
	finalDate += getLastDayOftheMonth(finalDate.substring(4,6),finalDate.substring(0,4));
	// mudança para melhorar a performance da carga da página 20060313

        var defInitDay =   1 * initDate.substring(6,8);
        var defInitMonth = 1 * initDate.substring(4,6);
        var defInitYear =  1 * initDate.substring(0,4);
        
        var defFinalDay =   1 * finalDate.substring(6,8);
        var defFinalMonth = 1 * finalDate.substring(4,6);
        var defFinalYear =  1 * finalDate.substring(0,4);

        document.open();
        document.write('<form name="aux_form">');
        switch (language)
        {
            case 0:
                document.write('Initial Date: ');
                CreateSelect('mi', 'm', defInitMonth, false);
                CreateSelect('di', 'd', defInitDay, false);
                CreateSelect('yi', 'y', defInitYear, false);
        
                document.write('&nbsp;&nbsp;&nbsp;');
        
                document.write('Final Date: ');
                CreateSelect('mf', 'm', defFinalMonth, true);
                CreateSelect('df', 'd', defFinalDay, true);
                CreateSelect('yf', 'y', defFinalYear, true);
                break;
                
            case 1:
                document.write('Data Inicial: ');
                CreateSelect('di', 'd', defInitDay, false);
                CreateSelect('mi', 'm', defInitMonth, false);
                CreateSelect('yi', 'y', defInitYear, false);
        
                document.write('&nbsp;&nbsp;&nbsp;');
        
                document.write('Data Final: ');
                CreateSelect('df', 'd', defFinalDay, true);
                CreateSelect('mf', 'm', defFinalMonth, true);
                CreateSelect('yf', 'y', defFinalYear, true);
                break;
            
            case 2:
                document.write('Fecha Inicial: ');
                CreateSelect('di', 'd', defInitDay, false);
                CreateSelect('mi', 'm', defInitMonth, false);
                CreateSelect('yi', 'y', defInitYear, false);
        
                document.write('&nbsp;&nbsp;&nbsp;');
        
                document.write('Fecha Final: ');
                CreateSelect('df', 'd', defFinalDay, true);
                CreateSelect('mf', 'm', defFinalMonth, true);
                CreateSelect('yf', 'y', defFinalYear, true);
                break;
        }
        
        document.write('</form>');
        document.close();
    }
    
    function isValidDate (strDay, strMonth, strYear)
    {
        if (strDay == "" && strMonth == "" && strYear == "") return true;
        
        // Checks if strDay, strMonth and strYear are integer numbers
        var intDay = parseInt(strDay, 10);        
        if ( isNaN(intDay) ) return false;
        
        var intMonth = parseInt(strMonth, 10);        
        if ( isNaN(intMonth) ) return false;

        var intYear = parseInt(strYear, 10);        
        if ( isNaN(intYear) ) return false;
        
        if (intMonth < 1 || intMonth > 12) return false;
        
        if (intDay < 1) return false;

        // Months with 31 days
        if (intMonth == 1 || intMonth == 3  || intMonth == 5 || intMonth == 7 || 
            intMonth == 8 || intMonth == 10 || intMonth == 12) {
            if (intDay > 31) return false;            
        // Months with 30 days
        } else if (intMonth == 4 || intMonth == 6 || intMonth == 9 || intMonth == 11) {
            if (intDay > 30) return false;
        // February has 29 days on leap year or 28 days
        } else if (isLeapYear (intYear) ) {
            if (intDay > 29) return false;
        } else {
            if (intDay > 28) return false;
        }
        
        
        return true;
    }
    
        function isLeapYear (intYear)
        {           
            if (intYear % 100 == 0)
            {
                if (intYear % 400 == 0) return true;                
            }
            else
            {
                if (intYear % 4 == 0) return true;
            }   
            return false;
        }
    function validate()
    {   
        var af = document.aux_form;
        var mf = document.main_form;
        
        // mudança para melhorar a performance da carga da página 20060313
	//var afdi = af.di.options[af.di.selectedIndex];
        var afdi = af.di;
        var afmi = af.mi.options[af.mi.selectedIndex];
        var afyi = af.yi.options[af.yi.selectedIndex];

        // mudança para melhorar a performance da carga da página 20060313
        //var afdf = af.df.options[af.df.selectedIndex];
        var afdf = af.df;
        var afmf = af.mf.options[af.mf.selectedIndex];
        var afyf = af.yf.options[af.yf.selectedIndex];
        var error;

	af.df.value = getLastDayOftheMonth(afmf.value, afyf.value);
        if ( !isValidDate(afdi.value, afmi.value, afyi.value) )
        {
            showMessage(0);
            af.di.focus();
            return false;
        }
        mf.dti.value = formatDateIso(afdi.value, afmi.value, afyi.value);

        // Initial date must be >= startDate
        error = checkDates (startDate, mf.dti.value);
        if (error != 0)
        {
            switch(error)
            {
                case 1: af.yi.focus(); break;
                case 2: af.mi.focus(); break;
                case 3: af.di.focus(); break;
            }
        
            mf.dti.value = "";
            showMessage (2, formatDate(startDate), formatDate(limitDate));            
            return false;
        }
        
        if ( !isValidDate(afdf.value, afmf.value, afyf.value) )
        {
            showMessage(0);
            af.df.focus();
            return false;
        }
                        
        mf.dtf.value = formatDateIso(afdf.value, afmf.value, afyf.value);

        // Final date must be <= limitDate
        error = checkDates (mf.dtf.value, limitDate);
        if (error != 0)
        {
            switch(error)
            {
                case 1: af.yf.focus(); break;
                case 2: af.mf.focus(); break;
                case 3: af.df.focus(); break;
            }
                
            mf.dtf.value = "";
            showMessage (2, formatDate(startDate), formatDate(limitDate));
            return false;
        }
        
        error = checkDates(mf.dti.value, mf.dtf.value)
        if (error !=  0)
        {
            switch(error)
            {
                case 1: af.yf.focus(); break;
                case 2: af.mf.focus(); break;
                case 3: af.df.focus(); break;
            }
            
            mf.dti.value = "";            
            showMessage (1);
            return false;
        }
                              
        function showMessage(msg)
        {
            var message = messages[language][msg];
            
            // Replaces any occurrence of %s inside the message by the respective function argument
            for (var i = 1; i < arguments.length; i++)
            {
                message = message.replace (/%s/i,arguments[i]);
            }
            
            alert (message);
        }
        
        function formatDateIso(intDay, intMonth, intYear)
        {
            if (intDay == "" && intMonth == "" && intYear == "")
                return "";
            // intDay * 1 to convert to number. parseInt returns 0 when intDay has format '0[1-9]'
            return intYear * 10000 + intMonth * 100 + intDay * 1;
        }
        
        function checkDateRange (date)
        {
            if ( date != "" && (date < startDate || date > limitDate) )
            {
                return false;
            }

            return true;
        }        
        
        function formatDate (isoDate)
        {
            // mudança para melhorar a performance da carga da página 20060313
	//return ( language ? isoDate.substring(6,8) + "/" + isoDate.substring(4,6) : 
        //                        isoDate.substring(4,6) + "/" + isoDate.substring(6,8) ) + "/" + isoDate.substring(0,4);
		return months[language][isoDate.substring(4,6)-1] + "/" + isoDate.substring(0,4) ;
        }
        
        function checkDates(date1, date2)
        {
            if (date1 != "" && date2 != "")
            {
                var year1  = date1.substring(0,4);
                var month1 = date1.substring(4,6);
                var day1   = date1.substring(6,8);
                
                var year2  = date2.substring(0,4);
                var month2 = date2.substring(4,6);
                var day2   = date2.substring(6,8);
                
                if (year1 > year2) return 1;
    
                if (year1 == year2)
                {
                    if (month1 > month2) return 2;
                    if (month1 == month2 && day1 > day2) return 3;
                }
            }
            return 0;
        }
        
        return true;
    }
    
    
