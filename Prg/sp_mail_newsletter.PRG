*
* Envio de Mails Newsletter
*
Lparameters mmail, msubject, murl, muser, mpass, mipserver, midentifica

v_mhtml = "c:\temp\news1.mht"
marctem = "c:\temp\newstemp.mht"
morigen = mmail

oCdo = Createobject("CDO.Message")

If File(v_mhtml)
	Delete File &v_mhtml
Endif

If File(marctem)
	Delete File &marctem
Endif

oCdo.CreateMHTMLBody(murl,0,muser,mpass)

oStream = oCdo.getstream()

=oStream.SaveToFile(v_mhtml,1)

oStream = null
oCdo    = Null

Set PROCEDURE TO VFPwinsock

Select mwkdestina
Scan
	o = CREATEOBJECT("VFP_Winsock_Send_Mail")
	o.silence   = .t.
	o.smtp_host = mipserver
	o.from      = mmail
	mlmsg        = alltrim(mwkdestina.tipo) + ' ' + alltrim(mwkdestina.nombre) + ' ' + alltrim(mwkdestina.apellido)
	o.to         = alltrim(mwkdestina.email)
	o.Subject    = alltrim(msubject)
	If midentifica
		march1   = filetostr(v_mhtml)
		mremp    = iif(alltrim(mwkdestina.tipo)='DRA','Estimada : ','Estimado : ') + mlmsg
		march2   = strtran(march1,"[xxxnamexxx]",mremp)
		v_mhtml1 = strtofile(march2,"C:\temp\newstemp.mht")
		v_mhtml2 = "C:\temp\newstemp.mht"
		o.data_MHTML = v_mhtml2
	Else
		o.data_MHTML = v_mhtml
	Endif

	If not o.send()
		msg = "Nº " + o.Erreur + chr(10)+;
			"Dump : " + o.dump()
		Messagebox(msg,16,"ERROR")
		mpaso = .f.
	Else
		mpasoreg = .f.
		Do sp_grabo_logmail with morigen,mwkdestina.email,msubject,'',murl,mlmsg,muser
		If mpasoreg
			mpaso  = .f.
			Messagebox("ENVIO CANCELADO POR"+chr(10)+;
				"ERRORES DE REGISTRO EN MAESTRO",48,"Validación")
			Exit
		Endif
	Endif
	o = Null
Endscan
