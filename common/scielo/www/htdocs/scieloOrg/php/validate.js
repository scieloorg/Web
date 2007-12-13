function validaSubmit(){ 
	if(document.getElementById("author").value==""){
		alert("Please, fill the field name");
		return false;
	}else if(document.getElementById("email").value==""){
			alert("Please, fill the field email.");
		return false;
	}else if(document.getElementById("comment").value==""){
		alert("Please, fill the field comment");
		return false;
	}
	if(!checkMail(document.getElementById("email").value)){
				alert("Please, fill an valid email");
				return false;
			}
}
function checkMail(mail){
    var er = new RegExp(/^[A-Za-z0-9_\-\.]+@[A-Za-z0-9_\-\.]{2,}\.[A-Za-z0-9]{2,}(\.[A-Za-z0-9])?/);
    if(typeof(mail) == "string"){
        if(er.test(mail)){ return true; }
    }else if(typeof(mail) == "object"){
        if(er.test(mail.value)){ 
                    return true; 
                }
    }else{
        return false;
        }
}