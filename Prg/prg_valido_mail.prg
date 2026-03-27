lparameters email,lmsg && la cuenta
if vartype(lmsg)<>"L"
	lmsg = .f.
endif
loRegExp = createobject("VBScript.RegExp")
loRegExp.IgnoreCase = .t.
loRegExp.pattern =  '^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)­*)\.([A-Za-z]{2,})$'
m.valid = loRegExp.Test(m.email)
release loRegExp
if !m.valid
	if lmsg
		nposarro = at("@",email )
		if nposarro = 0 or nposarro<3 or nposarro > len(alltrim(email ))-5 ;
				or at(" ",alltrim(email ))>0 or at(",",email )>0 or at(".",email ) = 0;
				or (nposarro > 0 and (at("NOTIENE",upper(email ))>0 or at("NO TIENE",upper(email ))>0 ))
		else
			if 	messagebox("EL MAIL ES EL INDICADO POR EL PACIENTE?",4+32,"Dirección de mail rechazada")=6
				m.valid= .t.
			endif
		endif
	endif
endif
return M.valid
