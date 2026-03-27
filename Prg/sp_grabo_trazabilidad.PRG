*
* Trazabilidad : Grabo - Trazo, Informo - Movimiento .
*
Lparameters mtipo,mremito,mremitodoc,mgln,mlglndestino,mcuit,mgtin,mserie,mlote,;
	mvence,mevento,morden,mlentidad,mlafiliad,mpartida,mnropof

If vartype(mlentidad) <> "N"
	mlentidad = 0
Endif

If vartype(mlafiliad) <> "C"
	mlafiliad = ""
Endif

If vartype(mpartida) <> "C"
	mpartida = ""
Endif

If vartype(mnropof) <> "C"
	mnropof = ""
Endif

muser = Alltrim(mwkusuario.idusuario)
mfech = sp_busco_fecha_serv("DT")

If mtipo <> 3 && Eliminacion

	Do case
	Case mtipo = 1 && Recepción
		mltp = 'R' 
	Case mtipo = 2 && Dispensación
		mltp = 'D'
	Case mtipo = 4 && Finaliza Empaque
		mltp = 'F'
	Endcase

*!*	If mtipo = 1 && Recepción
*!*		mltp = 'R'
*!*	Else         && Dispensación
*!*		mltp = 'D'
*!*	Endif

	If mltp = 'R'
	
		Use in select("mwkctrltra")
		mret = sqlexec(mcon1,"select * from TabTraMov"+;
			" where TTM_gtin = ?mgtin and TTM_serie = ?mserie and TTM_tipomov = ?mltp","mwkctrltra")
		
		*and TTM_transcod > 0 
			
		If mret > 0
			If used("mwkctrltra")
				If reccount("mwkctrltra")>0

*					mtxt = "EL ARTICULO TIENE UNA EVENTO RECEPCION"+chr(13)+;
*						"TRAZADO FAVORABLEMENTE EL DIA "+ttoc(mwkctrltra.TTM_fechormov)

					mtxt = "EL ARTICULO TIENE UN EVENTO RECEPCION REGISTRADO"

					Use in select("mwkctrltra")
					Messagebox(mtxt,48,"Atención")
					Return .F.

				Endif
			Endif
		Endif
	Else
		mret = 1
	Endif

	If mret > 0
		mret  = sqlexec(mcon1,"insert into TabTraMov "+;
			"(TTM_remitoint,TTM_remitodoc,TTM_glnorg,TTM_glndes,TTM_cuitorg,TTM_gtin,TTM_serie,"+;
			"TTM_lote,TTM_vence,TTM_evento,TTM_afiliado,TTM_idobrasoc,TTM_transcod,TTM_transerr,"+;
			"TTM_transtxte,TTM_traorden,TTM_fechormov,TTM_idusuario,"+;
			"TTM_tipomov,TTM_partida,TTM_nropof) "+;
			"values "+;
			"(?mremito,?mremitodoc,?mgln,?mlglndestino,?mcuit,?mgtin,?mserie,?mlote,?mvence,"+;
			"?mevento,?mlafiliad,?mlentidad,0,'','',?morden,?mfech,?muser,?mltp,?mpartida,?mnropof)")

		If mret > 0
			Use in select("mwkctrltra")
			mret = sqlexec(mcon1,"select * from TabTraMov"+;
				" where TTM_gtin = ?mgtin and TTM_serie = ?mserie and TTM_tipomov = ?mltp"+;
				" and TTM_idusuario = ?muser and TTM_fechormov = ?mfech","mwkctrltra")
		Endif
	Endif

Else && Eliminación

	mret = 1
	If Used("mwktragtin")
		If Reccount("mwktragtin") > 0
			If Empty(mwktragtin.ltrazado)
&& 				Se procura eliminar un registro que por error ingreso en el maestro de movimientos,
&& 				pero que aun no paso por ningun circuito de trazabilidad
				mdel = mwktragtin.lregistro
				mret = sqlexec(mcon1,"delete from TabTraMov where id = ?mdel")
			Endif
		Endif
	Endif

Endif

If mret < 0
	Messagebox("Error al Registrar Movimiento",26,"Error")
	On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.

