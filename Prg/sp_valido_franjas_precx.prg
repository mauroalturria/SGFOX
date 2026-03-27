*Validaciones Y Grabo en TABPQFRAN

parameters ldfecI,ldfecH,lnCol,lnDia,lnTurno,lnQuiro,lnDura,lnServ,lcEspe,lnCant,lnhoraini


if messagebox("QUIERE DAR DE ALTA " + alltrim(lcEspe) + " ? ",4,"ALTA DE FRANJA HORARIA") = 6

	local lnGrabo

	lnGrabo = 0
	horahasta = int((int(lnhoraini/100)*60+mod(lnhoraini,100)+ lnDura* lnCant)/60)*100+;
		mod((int(lnhoraini/100)*60+mod(lnhoraini,100)+ lnDura* lnCant),60)
	lnGrabo = 0
	select *,;
		int((int(PQF_horaInicio/100)*60+mod(PQF_horaInicio,100)+ PQF_duracion * PQF_cantidad)/60)*100+;
		mod((int(PQF_horaInicio/100)*60+mod(PQF_horaInicio,100)+ PQF_duracion * PQF_cantidad),60) as hhasta ;
		from mwktabpqfran_temp where pqf_dia = lnDia and;
		pqf_quirofano = lnQuiro and !(pqf_fecvigend>ldfecH or pqf_fecvigenh<ldfecI);
		into cursor mwkfranvig


	select * from mwkfranvig where lnhoraini<hhasta and horahasta>PQF_horaInicio into cursor mwkexistefran
	if reccount('mwkexistefran')>0
		lcMsg = "ESTA FRANJA ESTA UTILIZADA"
		lnGrabo = 1
	endif
	if lnGrabo = 1
		messagebox("ESTA FRANJA ESTA UTILIZADA TOTAL O PARCIALMENTE",64,"Control de Franjas")
*!*	* Modifico
*!*			lcSQL = "Update TabPQFran Set pqf_cantidad = ?lnCant, pqf_dia = ?lnDia, pqf_quirofano = ?lnQuiro, pqf_Servicio = ?lnServ, pqf_turno = ?lnTurno, pqf_especialidad = ?lcEspe,"+;
*!*				"pqf_duracion = ?lnDura, pqf_fecvigend = ?ldDiaI, pqf_fecvigenh = ?ldDiaH ,PQF_horaInicio = ?lnhoraini where id = ?lnID"

*!*			if !Prg_EjecutoSql(lcSQL)
*!*				return .f.
*!*			endif

		return 1
	else
* Agrego
		lcSQL="Insert Into tabPQFran (pqf_cantidad,pqf_dia,pqf_quirofano,pqf_servicio,pqf_turno,pqf_especialidad,"+;
			"pqf_duracion,pqf_fecvigend,pqf_fecvigenh,PQF_horaInicio) values" +;
			"(?lnCant,?lnDia,?lnQuiro,?lnServ,?lnTurno,?lcEspe,?lnDura,?ldFecI,?ldFecH, ?lnhoraini)"

		if !Prg_EjecutoSql(lcSQL)
			return .f.
		endif

*		Messagebox("SE DIO DE ALTA " + Upper(lcEspe),0,"ALTA DE FRANJA HORARIA",3000)

		return 2
	endif
else

endif
