*
* Actualizacion de Observaciones - Estados ( Monitor1 )
* Update x mwkvalobs > a 0 ó mtipmov = 2
*

Lparameters mtipmov,mcodigo,mcodpun,mobserv,mfecmov,msubestado,mevoluc,mmed,mfecest

*!* mtipmov = 1 && Alta
*!* mtipmov = 2 && Modifica

mactu = .f.
Do sp_busco_monitor1_valobs with mcodpun
If used('mwkvalobs')
	If mtipmov = 1
		If reccount('mwkvalobs') = 0
			mret = sqlexec(mcon1,"insert into TabValObs (TVO_Codigovax,TVO_Codpun,"+;
				"TVO_Obser,TVO_Fechamov,TVO_SubEstado,TVO_evolucion,TVO_Codmed, "+;
				"TVO_FechaEstudio ) "+;
				"values (?mcodigo,?mcodpun,?mobserv,?mfecmov,?msubestado,?mevoluc ,?mmed, "+;
				"?mfecest)")
			If mret < 0
				Messagebox("ERROR EN LA GRABACION"+chr(10)+;
					"MAESTRO DE VALES OBS/ESTADOS",48,"Validacion")
				Return
			Endif
		Else
			mactu = .t.
		Endif
	Else
		mactu = .t.
	Endif
	If mactu
		mbusid = mwkvalobs.id
		mret=sqlexec(mcon1,"update TabValObs set TVO_Obser=?mobserv,TVO_SubEstado=?msubestado,"+;
			"TVO_Fechamov=?mfecmov, TVO_evolucion=?mevoluc, TVO_Codmed = ?mmed, "+;
			"TVO_FechaEstudio= ?mfecest "+;
			"where TabValObs.id=?mbusid")
		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION"+CHR(10)+;
				"MAESTRO DE VALES OBS/ESTADOS",48,"Validacion")
			Return
		Endif
	Endif
Endif
