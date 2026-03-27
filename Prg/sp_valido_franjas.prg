*Validaciones
*ldDiaI,ldDiaH,lcCol,lnDia,lnTurno,lnQuiro,lnDura,lnServ,lcEspe

Lparameters ldfecI,ldfecH,lnCol,lnDia,lnTurno,lnQuiro,lnDura,lnServ,lcEspe

Local lnGrabo

lnGrabo = 0

*!*	Select mwkquirofanos
*!*	Go top
*!*	Locate For nrodia = 7 And turno = 1
*!*	? Found()
*!*	? Empty(esp_quiro1)
*!*	? Empty(fecd_quiro1)
*!*	? Empty(fech_quiro1)
*!*	Locate For nrodia = 6 And turno = 2
*!*	? Found()
*!*	? Empty(esp_quiro1)
*!*	? Empty(fech_quiro1)
*!*	? esp_quiro1
*!*	? Between(Ctod("29/12/2016"),fecd_quiro1,fech_quiro1)
*!*	? Between(Ctod("29/1/2017"),fecd_quiro1,fech_quiro1)
*!*	? Min("29/12/2016",fecd_quiro1,fech_quiro1)
*!*	? Min(Ctod("29/12/2016"),fecd_quiro1,fech_quiro1)
*!*	? Max(Ctod("29/12/2016"),fecd_quiro1,fech_quiro1)


Select mwkquirofanos
Go Top
Locate For nrodia = lnDia And turno = lnTurno
If Found()
	lcCampo = "esp_quiro" + Alltrim(lnCol)
	If Empty(&lcCampo)
* esta vacío, puedo grabar
		lnGrabo = 0
	Else
		ldCampoF1 = "fecd_quiro"+Alltrim(lnCol)
		ldCampoF2 = "fech_quiro"+Alltrim(lnCol)
		If Empty(&ldCampoF1) And Empty(&ldCampoF2)
*esta vacio, puedo grabar
			lnGrabo = 0
		Else
* Me fijo si está ocupada la franja
			lnGrabo = 0
			If Between(ldfecI,&ldCampoF1,&ldCampoF2) = .F.
			Else
				lnGrabo = lnGrabo + 1
			Endif

			If Between(ldfecH,&ldCampoF1,&ldCampoF2) = .F.
			Else
				lnGrabo = lnGrabo + 1
			Endif
* Me fijo según el resultado
			Do Case
			Case lnGrabo = 0
				lcMsg = ""
			Case lnGrabo = 1
				lcMsg = "PARTE DE ESTA FRANJA ESTA "
			Case lnGrabo = 2
				lcMsg = "ESTA FRANJA YA ESTA TOTALMENTE "
			Endcase
		Endif
	Endif
Endif

Select mwkquirofanos

lcEspecialidad = "mwkquirofanos.esp_quiro"+lnCol
ldFechadesde = "mwkquirofanos.fecd_quiro"+lnCol
ldFechahasta = "mwkquirofanos.fech_quiro"+lnCol
lnTurno = mwkquirofanos.turno
lnDia = mwkquirofanos.nrodia
lnQuiro = Val(lnCol)
lnServ0 = "mwkquirofanos.ser_quiro"+lnCol
lnServ = &lnServ0

If lnGrabo = 1 Or lnGrabo = 2
	If Messagebox(lcMsg + "OCUPADA POR EL SERVICIO" + Chr(13) + "DE " + Alltrim((&lcEspecialidad)) + ", QUE VA " +;
			Chr(13)+"DESDE: " + Dtoc(&ldFechadesde) + " - HASTA: " + Dtoc(&ldFechahasta) + Chr(13) + "¿ QUIERE MODIFICARLA ?",68,"") = 6
		Select mwktabpqfran
		Go Top
		Locate For pqf_especialidad = &lcEspecialidad And pqf_turno = lnTurno And pqf_dia = lnDia And pqf_fecvigend = &ldFechadesde And pqf_fecvigenh = &ldFechahasta
		If Found()
			lnID = mwktabpqfran.Id
		Endif
* Modifico
		lcSQL = "Update TabPQFran Set pqf_cantidad = 6, pqf_dia = ?lnDia, pqf_quirofano = ?lnQuiro, pqf_Servicio = ?lnServ, pqf_turno = ?lnTurno, pqf_especialidad = ?lcEspe,"+;
			"pqf_duracion = ?lnDura, pqf_fecvigend = ?ldDiaI, pqf_fecvigenh = ?ldDiaH where id = ?lnID"
		mret = SQLExec(mcon1,lcSQL) && Cambiar por prg_ejectuo
		If mret < 1
			Messagebox("Error")
		Endif
	Else
		Return
	Endif
	Messagebox("modifico un registro")
Else
* Agrego
	lcSQL="Insert Into tabPQFran (pqf_cantidad,pqf_dia,pqf_quirofano,pqf_servicio,pqf_turno,pqf_especialidad,pqf_duracion,pqf_fecvigend,pqf_fecvigenh) values" +;
		"(6,?lnDia,?lnQuiro,?lnServ,?lnTurno,?lcEspe,?lnDura,?ldFecI,?ldFecH)"
	mret = SQLExec(mcon1,lcSQL) && Cambiar por prg_ejectuo
	If mret < 1
		Messagebox("Error al escribir en la tabla",0,"")
	Endif
	Messagebox("Agregó un registro")
Endif