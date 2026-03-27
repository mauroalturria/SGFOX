******
* Actualizo las observaciones agregadas
******
Parameters mabm,pcodadmision,pnroautpre,pcodmed,ptipo,pgermen,pestado,pfecini,pfec1ctrl,pfecfin
If Vartype(pestado)#"N"
	pestado= 1
Endif
musuario = mwkusuario.Id
mfecnull = Ctod("01/01/1900")
mecfin = Ctod("01/01/2100")
mfecbaja = sp_busco_fecha_serv("DD")
Do Case
	Case mabm = 1

		mret = SQLExec(mcon1,"insert into Zabintaislapac (IAP_Codadmision, IAP_Codmed, IAP_Estado, IAP_Fechora1Control,IAP_FechoraFin, "+;
			"IAP_FechoraInicio,  IAP_TipoAisla,IAP_TipoGermen, UserDbAdd,IAP_idautprevia) "+;
			" values (?pcodadmision,?pcodmed,?pestado,  ?mfecnull,?mecfin,?mfecnull,?ptipo,?pgermen,?musuario,?pnroautpre )")

	Case mabm = 2
		mret = SQLExec(mcon1,"select * from Zabintaislapac"+;
			" where IAP_Codadmision = ?pcodadmision and IAP_FechoraFin =?mecfin  and IAP_idautprevia = ?pnroautpre ","mwkaislaid")

		If Reccount("mwkaislaid")>0
			mid = mwkaislaid.Id

			mret = SQLExec(mcon1,"update Zabintaislapac set IAP_Estado = ?pestado"+;
				" where id = ?mid")
		Else
			mret = SQLExec(mcon1,"insert into Zabintaislapac (IAP_Codadmision, IAP_Codmed, IAP_Estado, IAP_Fechora1Control,IAP_FechoraFin, "+;
				"IAP_FechoraInicio,  IAP_TipoAisla,IAP_TipoGermen, UserDbAdd,IAP_idautprevia) "+;
				" values (?pcodadmision,?pcodmed,?pestado,  ?mfecnull,?mecfin,?mfecnull,?ptipo,?pgermen,?musuario,?pnroautpre)")

		Endif
	Case mabm = 3
		mret = SQLExec(mcon1,"update Zabintaislapac set IAP_Estado = ?pestado,IAP_Fechora1Control = ?pfec1ctrl,IAP_FechoraFin = ?pfecfin,IAP_FechoraInicio = ?pfecini  "+;
			" where IAP_Codadmision = ?pcodadmision and IAP_TipoAisla = ?ptipo and IAP_TipoGermen = ?pgermen and IAP_FechoraFin =?mecfin ")
	Case mabm = 9
		mret = SQLExec(mcon1,"update Zabintaislapac set  IAP_FechoraFin = ?mfecbaja  "+;
			" where IAP_Codadmision = ?pcodadmision  and IAP_FechoraFin =?mecfin ")

Endcase
If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif

