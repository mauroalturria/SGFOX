*Validaciones Y Grabo en TABPQFRAN

Parameters ldfecI,ldfecH,lnDia,lnTurno,lnQuiro,lnDura,lnServ,lcEspe,lnCant,lnhoraini

If Messagebox("QUIERE DAR DE ALTA " + Alltrim(lcEspe) + " ? ",4,"ALTA DE FRANJA HORARIA") = 6

	Local lnGrabo

	lnGrabo = 0

	horahasta = Int((Int(lnhoraini/100)*60+Mod(lnhoraini,100)+ lnDura* lnCant)/60)*100+;
		mod((Int(lnhoraini/100)*60+Mod(lnhoraini,100)+ lnDura* lnCant),60)

	lnGrabo = 0

	Select *,;
		int((Int(PQF_horaInicio/100)*60+Mod(PQF_horaInicio,100)+ PQF_duracion * PQF_cantidad)/60)*100+;
		mod((Int(PQF_horaInicio/100)*60+Mod(PQF_horaInicio,100)+ PQF_duracion * PQF_cantidad),60) As hhasta ;
		from mwktabpqfran_temp Where pqf_dia = lnDia And;
		pqf_quirofano = lnQuiro And !(pqf_fecvigend>ldfecH Or pqf_fecvigenh<ldfecI);
		into Cursor mwkfranvig


	Select * From mwkfranvig Where lnhoraini<hhasta And horahasta>PQF_horaInicio Into Cursor mwkexistefran

	If Reccount('mwkexistefran')>0
		lcMsg = "ESTA FRANJA ESTA UTILIZADA"
		lnGrabo = 1
	Endif

	If lnGrabo = 1
		Messagebox("ESTA FRANJA ESTA UTILIZADA TOTAL O PARCIALMENTE",64,"Control de Franjas")
*!*	* Modifico
*!*			lcSQL = "Update TabPQFran Set pqf_cantidad = ?lnCant, pqf_dia = ?lnDia, pqf_quirofano = ?lnQuiro, pqf_Servicio = ?lnServ, pqf_turno = ?lnTurno, pqf_especialidad = ?lcEspe,"+;
*!*				"pqf_duracion = ?lnDura, pqf_fecvigend = ?ldDiaI, pqf_fecvigenh = ?ldDiaH ,PQF_horaInicio = ?lnhoraini where id = ?lnID"

*!*			if !Prg_EjecutoSql(lcSQL)
*!*				return .f.
*!*			endif

		Return 1
	Else
* Agrego
		lcSQL="Insert Into tabPQFran (pqf_cantidad,pqf_dia,pqf_quirofano,pqf_servicio,pqf_turno,pqf_especialidad,"+;
			"pqf_duracion,pqf_fecvigend,pqf_fecvigenh,PQF_horaInicio) values" +;
			"(?lnCant,?lnDia,?lnQuiro,?lnServ,?lnTurno,?lcEspe,?lnDura,?ldFecI,?ldFecH, ?lnhoraini)"

		If !Prg_EjecutoSql(lcSQL)
			Return .F.
		Endif

*		Messagebox("SE DIO DE ALTA " + Upper(lcEspe),0,"ALTA DE FRANJA HORARIA",3000)

		Return 2
	Endif
Else

* Cancelo el Alta
	Return 1

Endif
