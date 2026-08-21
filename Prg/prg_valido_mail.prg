Lparameters email,lmsg && la cuenta
If Vartype(lmsg)<>"L"
	lmsg = .F.
ENDIF
nreduce = 0
If lmsg
	nposarro = At("@",email )
	If nposarro = 0 Or nposarro<3 Or nposarro > Len(Alltrim(email ))-5 ;
			or At(" ",Alltrim(email ))>0 Or At(",",email )>0 Or At(".",email ) = 0;
			or (nposarro > 0 And (At("NOTIENE",Upper(email ))>0 Or At("NO TIENE",Upper(email ))>0 ))
		Return .F.
	Endif
ENDIF

npuntos = At('.',Substr(email,nposarro),3)
loRegExp = Createobject("VBScript.RegExp")
loRegExp.IgnoreCase = .T.
loRegExp.Pattern =  '^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)­*)\.([A-Za-z]{2,})$'
If npuntos >0
	nreduce = nposarro+At('.',Substr(email,nposarro),3)-2
	m.valid = loRegExp.Test(LEFT(m.email,nreduce ))
Else
	m.valid = loRegExp.Test(m.email)
Endif
Release loRegExp
If (!m.valid OR nreduce >0) And lmsg
	If 	Messagebox("EL MAIL ES EL INDICADO POR EL PACIENTE?",4+32,"Dirección de mail rechazada")=6
		m.valid= .T.
	Endif
Endif
Return M.valid
