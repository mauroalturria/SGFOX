*
* Depuracion de Registros Nutricion
*

Lparameters mpage, mtot1, mtot2

With mpage

	mtodok = .t.
	mpasor = 0

	If mtot1 > 0
		Dimension vd[9]
		Select mwksaco1
		Go top
		Scan
			vd[1] = mwksaco1.TND_Cantidad
			vd[2] = mwksaco1.TND_FHoraCarga
			vd[3] = mwksaco1.TND_Hora
			vd[4] = mwksaco1.TND_NroVale
			vd[5] = mwksaco1.TND_codPrest
			vd[6] = mwksaco1.TND_fecBaja
			vd[7] = mwksaco1.TND_idPaciente
			vd[8] = mwksaco1.TND_observa
			vd[9] = mwksaco1.TND_usuario
			
			mret = sqlexec(mcon1, "insert into TabNutHisDet "+;
				"(TND_Cantidad,TND_FHoraCarga,TND_Hora,TND_NroVale,TND_codPrest,"+;
				"TND_fecBaja,TND_idPaciente,TND_observa,TND_usuario)"+;
				" values "+;
				"(?vd[1],?vd[2],?vd[3],?vd[4],?vd[5],?vd[6],?vd[7],?vd[8],?vd[9])")
			
			If mret < 0
				Messagebox("EN HISTORICO DE NUTRICION DETALLE" + chr(10) + ;
					"AVISE A SISTEMAS", 16,"ERROR")
				mtodok = .f.
				Exit
			Endif
			mpasor = mpasor + 1
			.avance("Archivos")
			
		Endscan
		Release vd

		If mtodok
			mret = sqlexec(mcon1, "delete from TabNutDetalle " +;
				"where TND_FHoraCarga < ?mcFecHas")
			If mret < 0
				Messagebox("EN DEPURACION ARCHIVO NUTRICION DETALLE" + chr(10) + ;
					"AVISE A SISTEMAS", 16,"ERROR")
				mtodok = .f.
			Endif
		Endif
		
	Endif

	If mtot2 > 0 and mtodok
		Dimension vd[8]
		Select mwksaco2
		Go top
		Scan
			vd[1] = mwksaco2.TNP_CodFact
			vd[2] = mwksaco2.TNP_CodServ
			vd[3] = mwksaco2.TNP_FecImp
			vd[4] = mwksaco2.TNP_Fecha
			vd[5] = mwksaco2.TNP_Modi
			vd[6] = mwksaco2.TNP_Observaciones
			vd[7] = mwksaco2.TNP_Usuario
			vd[8] = mwksaco2.TNP_codadmision
			
			mret = sqlexec(mcon1, "insert into TabNutHisPac "+;
				"(TNP_CodFact,TNP_CodServ,TNP_FecImp,TNP_Fecha,TNP_Modi,TNP_Observaciones,"+;
				"TNP_Usuario,TNP_codadmision)"+;
				" values "+;
				"(?vd[1],?vd[2],?vd[3],?vd[4],?vd[5],?vd[6],?vd[7],?vd[8])")
			
			If mret < 0
				Messagebox("EN HISTORICO DE NUTRICION PACIENTES" + chr(10) + ;
					"AVISE A SISTEMAS", 16,"ERROR")
				mtodok = .f.
				Exit
			Endif
			mpasor = mpasor + 1
			.avance("Archivos")
			
		Endscan

		If mtodok
			mret = sqlexec(mcon1, "delete from TabNutPaciente " +;
				"where TNP_Fecha < ?mcFecHas")
			If mret < 0
				Messagebox("EN DEPURACION ARCHIVO NUTRICION PACIENTES" + chr(10) + ;
					"AVISE A SISTEMAS", 16,"ERROR")
				mtodok = .f.
			Endif
		Endif
		Release vd
		
	Endif

	If mtodok
		.Label4.caption	= "PROCESO TERMINADO, REG. DEPURADOS " + alltrim(str(mpasor))
	Else
		.Label4.caption	= "INCONVENIENTES EN EL PROCESO"
	Endif
	.CmdClose.setfocus()

Endwith
