** Marcelo Torres.
** mAtach: archivos a ser ajuntados
** mdestino: direcciones de destino (separadas por coma)
** cSubject: El asunto.
** cBody: El cuerpo del mensaje.
** cFrom: Direccion desde donde se envia
** cPass: password para enviar
** mShowResult = 1 - .t./ 2 - .f.
Lparameters matach,mdestino, cSubject, cBody, cFrom, cPass, mShowResult, mSmtp, mPuerto, mSSL, lHtmlBody

Local mValor
Local mEmail
Local mPass
Local aEmail
Local nPos
Local nI
Local cSubject
Local lReturn
Local xValor

Dimension aEmail(1)
**cSubject = "GESTIONAR OSUTHGRA - " + Alltrim(thisform.txtnombre.Value) + " - Materiales"
cSubject = Strtran(cSubject,","," ")
cSubject = Strtran(cSubject,".","")
cBody = Iif(Vartype(cBody) <> "C","SANATORIO GÜEMES.-"+CHR(10)+"No responda a esta cuenta."+ CHR(10)+ "Si necesita comunicar algo, hagalo a : auditoriamedica@sg.com.ar",cBody)
mEmail = Iif(Vartype(cFrom) <> "C","",cFrom)
mPass = Iif(Vartype(cPass) <> "C","",cPass)
mShowResult = Iif(Vartype(mShowResult) <> "N",.T.,Iif(mShowResult = 1, .T.,.F.))
mSmtp = Iif(Vartype(mSmtp) <> "C","smtp.gmail.com",mSmtp)
mPuerto = Iif(Vartype(mPuerto) <> "N" ,465,mPuerto)
mSSL = Iif(Vartype(mSSL) <> "N",1,mSSL)

lReturn = .T.

If Empty(mEmail)
** Obtenemos la casilla de mail para enviar correos desde AUDITORIA.
	Do sp_busco_estados With 4, " and tipo = 36 ", "mwkEmail"

	Select mwkEmail
	Go Top

	xValor = ""

	Scan All

		xValor = xValor + Alltrim(mwkEmail.Descrip)+ ";"

	Endscan

	Use In Select("mwkEmail")

	If !Empty(xValor)

**mValor = Left(mValor,Len(mValor) - 1)

**Alines(aEmail,mValor,4,";")

**For nI = 1 To Alen(aEmail,1)

		nPos = 0
		mValor = ""

		Do While .T.

** mValor = aEmail[nI]
			nPos = At(";",xValor)
			mValor = Left(xValor,nPos-1)
			xValor = Right(xValor,Len(xValor)-nPos)

			If Empty(mValor)
				Exit
			Endif

			Do Case
			Case At("MAIL=",mValor) > 0

				nPos = At('=',mValor)
				mEmail = Alltrim(Substr(mValor,nPos+1,Len(mValor)))

			Case At("PASS=",mValor) > 0

				nPos = At('=',mValor)
				mPass = Alltrim(Substr(mValor,nPos+1,Len(mValor)))

			Case At("SMTP=",mValor) > 0
				nPos = At('=',mValor)
				mSmtp = Alltrim(Substr(mValor,nPos+1,Len(mValor)))
				
			Case At("PORT=",mValor) > 0
				nPos = At('=',mValor)
				mPuerto = VAL(Alltrim(Substr(mValor,nPos+1,Len(mValor))))
				
			Endcase

**Next
		Enddo

	Else
		Messagebox("No se pudo enviar el E-mail. No hay cuenta definida como servidor de salida.",16,"Envio")
		Return .F.
	Endif

Endif


** ------------------------- Iniciamos el objeto cdo2000 para envio de emails--------------
loMail = Newobject("Cdo2000", "Cdo2000.fxp")

With loMail
**.cServer = "smtp.gmail.com"
**.nServerPort = 465
**.lUseSSL = .T.
*!*		.cServer = "aspmx.l.google.com"
*!*		.nServerPort = 25
*!*		.lUseSSL = .F.
*!*	    .cServer = "smtp-relay.gmail.com"
*!*		.nServerPort = 587
*!*		.lUseSSL = .t.

	.cServer = mSmtp
	.nServerPort = mPuerto
	.lUseSSL = (mSSL = 1)

	.nAuthenticate = 1 	&& cdoBasic
**.cUserName = "pruebadesarrollo@sg.com.ar"
	.cUserName = mEmail
**.cPassword = "sanatorio8800"
	.cPassword = mPass

* If From address doesn't match any of the registered identities,
*	Gmail will replace it with your default Gmail address
**.cFrom = "pruebadesarrollo@sg.com.ar"
	.cFrom = mEmail

**.cTo = "somebody@otherdomain.com, somebodyelse@otherdomain.com"

**	.cTo = "mtorres@sg.com.ar"
	.cTo = mdestino
	.cSubject = cSubject

* Uncomment next lines to send HTML body
*.cHtmlBody = "<html><body><b>This is an HTML body<br>" + ;
*		"It'll be displayed by most email clients</b></body></html>"

	If !lHtmlBody
		.cTextBody = cBody
	Else
**.cHtmlBody = cBody
		Strtofile(cBody,"c:\tempdoc\bodyhtml.htm")
		.cHtmlBodyUrl = "c:\tempdoc\bodyhtml.htm"
	Endif

* Attachments are optional
* .cAttachment = "myreport.pdf, myspreadsheet.xls"
	.cAttachment = Nvl(matach,"")

Endwith

mError = ""

If loMail.Send() > 0
	For i=1 To loMail.GetErrorCount()
		mError = mError + loMail.Geterror(i)
	Endfor

	If !Empty(mError)
**Do sp_insert_tabCtrlErr With 1, mError , Alltrim(mwkusuario.idusuario), "AUTORIZACIONES",,cSubject
		If mShowResult
			Messagebox("Error al enviar el mail: " + Chr(10) + mError,16,"Mail")
			lReturn = .F.
		Endif
	Endif
* Clear errors
	loMail.ClearErrors()
	lReturn = .F.

Else
	If mShowResult
		Messagebox("Mensaje Enviado.",64,"Mail")
	Endif
	lReturn = .T.
Endif

Return lReturn
