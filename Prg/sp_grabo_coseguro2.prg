***
** Grabo coseguros de la entidad
***
Parameter miabm,mentidad,mcontrato ,mtipopac,mtipoAtend ,mCredencial,mplan

mplan = Iif(Empty(mplan), "0", Alltrim(Iif(Type('mplan')="N",Str(mplan,3),mplan)))
lmuestra = .T.
Select mwkcose
Scan
	mbono_importe 			= bono_importe
	mcoseguro 				= coseguro
	mreintegro 				= reintegro
	mcant_prestaciones 		= cant_prestaciones
	mporcentaje_contrato 	= porcentaje_contrato
	mrequiereAutorizacion 	= requiere_Autorizacion
	mrequiereDni 			= requiere_Dni
	mrequiereCredencial 	= requiere_Credencial
	mCredencial 			= Iif(Empty(Credencial), "0", Alltrim(Credencial))
	mver_contrato 			= ver_contrato
	mtipoAtend				= Id
	mfecha					= Iif(nuevoreg=1,fecha,fechaant)
	mfechahasta				= fechahasta
	lcambio					= (cambio = 1 )
	mret = SQLExec(mcon1, "select * from coseguros " + ;
		"where tipoAten = ?mtipoAtend  and contrato = ?mcontrato "+;
		"and entidad = ?mentidad and tipopac = ?mtipopac and Credencial  = ?mCredencial " +;
		" and plan = ?mplan and fecha= ?mfecha " , "mwkCoseguros")
	If myip='172.16.1.7'
		Set Step On

		If Messagebox("da de baja",4+16+256,"control")=6
			mret = SQLExec(mcon1, "update coseguros set  fechahasta= '2021-08-01' "+;
				"where tipoAten = ?mtipoAtend  and contrato = ?mcontrato "+;
				"and entidad = ?mentidad and tipopac = ?mtipopac and Credencial  = ?mCredencial " +;
				" and plan = ?mplan and fecha= ?mfecha " )
		Endif
	Endif
	If Reccount("mwkCoseguros")>0 And lcambio And lmuestra
		If 	Messagebox("ESTA COBERTURA YA EXISTE QUIERE MODIFICARLA DE TODAS MANERAS",4, "Validacion") = 7
			Return
		Else
*			mfecha	= iif(nuevoreg=1,fecha,fechaant)
		Endif
		lmuestra = .F.
	Endif
	If Reccount("mwkCoseguros")=0
		mret = SQLExec(mcon1, "insert into coseguros (tipoAten , contrato ,"+;
			" entidad, tipopac,bono_importe,coseguro,reintegro,"+;
			" cant_prestaciones,porcentaje_contrato,"+;
			"requiere_Autorizacion,requiere_Dni,requiere_Credencial, Credencial, plan,"+;
			"ver_contrato,fecha,fechahasta ) values "+;
			" ( ?mtipoAtend , ?mcontrato ,?mentidad, ?mtipopac, ?mbono_importe,"+;
			" ?mcoseguro,?mreintegro,?mcant_prestaciones,?mporcentaje_contrato,"+;
			"?mrequiereAutorizacion,?mrequiereDni,?mrequiereCredencial,?mCredencial,"+;
			"?mplan,?mver_contrato,?mfecha,?mfechahasta)" )
	Else
		nid = mwkCoseguros.Id
		If lcambio
			mret = SQLExec(mcon1, "update coseguros set bono_importe = ?mbono_importe,"+;
				"coseguro = ?mcoseguro,reintegro = ?mreintegro,cant_prestaciones = ?mcant_prestaciones,"+;
				"porcentaje_contrato = ?mporcentaje_contrato,requiere_Autorizacion = ?mrequiereAutorizacion,"+;
				"requiere_Dni = ?mrequiereDni,requiere_Credencial = ?mrequiereCredencial, "+;
				"ver_contrato = ?mver_contrato, fechahasta= ?mfechahasta "+;
				"where tipoAten = ?mtipoAtend  and contrato = ?mcontrato "+;
				"and entidad = ?mentidad and tipopac = ?mtipopac and Credencial  = ?mCredencial " +;
				" and plan = ?mplan and fecha= ?mfecha " )
		Endif
	Endif

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 48, "Validacion")
		Messagebox(eros(3), 48, "Validacion")
	Endif
Endscan
