Lparameters mOpcion, mId,mApv_estado, mApv_fechaauditoria,mApv_subestadopend,mApv_observaciones ,mApv_operauditoria,;
	mApv_codsector,mApv_urgencia, mAPV_Proveedor,mAPV_Cama,mApv_cantautorizada,mAPV_FechaCirugia ,mApv_cantsolicitada,;
	mApv_codinsusolic, mApv_codmedicosolic,mAPV_servicio , mApv_diagnostico, mApv_fechasolicitud,mApv_Registracio,;
	mApv_opersolicitud, mApv_presinsu,mApv_protocolo, mApv_resprev,mAPV_Reshistclin,mApv_DescripSolic,mAPV_agrupa,mAPV_fecharealiza,;
	mapv_codprestsolic,mApv_tipomuestra,mapv_idrubro


jj=0
If Vartype(mApv_observaciones) #"C"
	mApv_observaciones = ''
Endif
If Len(mApv_observaciones)>0
	jj = Int(Len(Alltrim(mApv_observaciones))/250)
	For i = 0 To jj
		clin = "linea" + Padl(i,3,"0")
		Public &clin
	Next

	mApvobservaciones = prg_concat(Alltrim(mApv_observaciones),0)
Else
	mApvobservaciones = "''"
Endif
If Vartype(mApvobservaciones )#"C"
	mApvobservaciones = "''"
Endif

If Vartype(mApv_tipomuestra) <> "N"
	mApv_tipomuestra = 0
ENDIF
If Vartype(mapv_idrubro) <> "N"
	mapv_idrubro = 0
Endif
Do Case
Case mOpcion = 1

Case mOpcion = 2
	ajj = jj+1+Int(Len(Alltrim(mApv_resprev))/250)
	For i = jj+1 To ajj
		clin = "linea" + Padl(i,3,"0")
		Public &clin
	Next
	mApvresprev = prg_concat(Alltrim(mApv_resprev),jj+1)
	If Vartype(mApvresprev )#"C"
		mApvresprev = "''"
	Endif
	bjj = ajj+1+Int(Len(Alltrim(mAPV_Reshistclin))/250)
	For i = ajj+1 To bjj
		clin = "linea" + Padl(i,3,"0")
		Public &clin
	Next
	mApvReshistclin = prg_concat(Alltrim(mAPV_Reshistclin),ajj+1)
	If Vartype(mApvReshistclin )#"C"
		mApvReshistclin = "''"
	Endif

	If Vartype(mApv_DescripSolic)="C"
		cjj = bjj+1+Int(Len(Alltrim(mApv_DescripSolic))/250)
		For i = bjj+1 To cjj
			clin = "linea" + Padl(i,3,"0")
			Public &clin
		Next
		mApvDescripSolic = prg_concat(Alltrim(mApv_DescripSolic),bjj+1)
	Else
		mApvDescripSolic = ''
	Endif
	If Vartype(mApvDescripSolic )#"C"
		mApvDescripSolic = "''"
	Endif


	If mId = 0 && desde frmautorambu07

		mRet = SQLExec(mcon1,"Insert into TabAutPrevias( Apv_Registracio, " + ;
			" Apv_codmedicosolic, Apv_diagnostico,Apv_cantsolicitada, " + ;
			" Apv_fechasolicitud,  APV_FechaCirugia , APV_fecharealiza , " + ;
			"  Apv_observaciones, Apv_opersolicitud, " + ;
			" Apv_protocolo, Apv_resprev, Apv_presinsu, Apv_subestadopend, " + ;
			" Apv_urgencia, APV_Reshistclin, Apv_estado, Apv_DescripSolic ,APV_Agrupa ,APV_servicio,"+;
			" Apv_codinsusolic,apv_codprestsolic,APV_Proveedor,APV_Cama,Apv_codsector, Apv_codmuestra, apv_idrubro   )"+;
			" Values " + ;
			" (?mApv_Registracio,?mApv_codmedicosolic, ?mApv_diagnostico,?mApv_cantsolicitada, " + ;
			" ?mApv_fechasolicitud, ?mAPV_FechaCirugia , ?mAPV_fecharealiza, " + ;
			+ mApvobservaciones + ", ?mApv_opersolicitud, " + ;
			" ?mApv_protocolo, " + mApvresprev + ", ?mApv_presinsu, 1, " + ;
			" ?mApv_urgencia, " + mApvReshistclin + ", ?mApv_estado, " + mApvDescripSolic+ ",?mAPV_agrupa, ?mAPV_servicio,"+;
			" ?mApv_codinsusolic,?mapv_codprestsolic,?mAPV_Proveedor,?mAPV_Cama,?mApv_codsector,?mApv_tipomuestra,?mapv_idrubro  )")

		mRet = SQLExec(mcon1,"select id,Apv_presinsu from TabAutPrevias " + ;
			" Where Apv_Registracio = ?mApv_Registracio and Apv_protocolo = ?mApv_protocolo  "+;
			" and APV_FechaCirugia   = ?mAPV_FechaCirugia order by id desc","mwkctrlins")
		Select mwkctrlins
		Go Top
		If Reccount("mwkctrlins")>0 And Empty(mwkctrlins.Apv_presinsu )
			mid = mwkctrlins.Id
			mRet = SQLExec(mcon1,"Update TabAutPrevias Set Apv_presinsu = ?mApv_presinsu "+;
				" Where Id = ?mId ")
				Do log_errores With ALLTRIM(mApv_protocolo)+"-"+LEFT(mApvDescripSolic,20)+"-"+ALLTRIM(mApv_presinsu ),;
					 "SIN PRESINSU", myip, mwkexe.nomexe, 0
		Endif

	Else

		mRet = SQLExec(mcon1,"Update TabAutPrevias Set  APV_FechaCirugia   = ?mAPV_FechaCirugia , APV_fecharealiza = ?mAPV_fecharealiza, " + ;
			" Apv_codmedicosolic = ?mApv_codmedicosolic, Apv_diagnostico = ?mApv_diagnostico, " + ;
			" Apv_fechasolicitud = ?mApv_fechasolicitud,  " + ;
			" Apv_observaciones = " + mApvobservaciones + ", " + ;
			" Apv_opersolicitud = ?mApv_opersolicitud, APV_servicio  = ?mAPV_servicio , Apv_cantautorizada = ?mApv_cantsolicitada," + ;
			" Apv_protocolo = ?mApv_protocolo, Apv_resprev = " + mApvresprev + ", " + ;
			" Apv_urgencia = ?mApv_urgencia, APV_Reshistclin = " + mApvReshistclin + ", "  + ;
			" Apv_estado = ?mApv_estado, Apv_DescripSolic = " + mApvDescripSolic+ " ,Apv_codsector = ?mApv_codsector, " + ;
			" Apv_codinsusolic = ?mApv_codinsusolic,apv_codprestsolic = ?mapv_codprestsolic "+;
			" Where Id = ?mId ")

	Endif

Case mOpcion = 3

&& CAMBIO DE ESTADO
	mRet = SQLExec(mcon1,"Update TabAutPrevias Set " + ;
		"Apv_estado = ?mApv_estado " + ;
		"Where Id = ?mId ")


Case mOpcion = 4

&& CAMBIO DE ESTADO && AUDITORIA
	mRet = SQLExec(mcon1,"Update TabAutPrevias Set " + ;
		" Apv_estado = ?mApv_estado, Apv_fechaauditoria = ?mApv_fechaauditoria, " + ;
		" Apv_subestadopend = ?mApv_subestadopend,   " + ;
		"  Apv_observaciones = " + mApvobservaciones + " , Apv_cantautorizada = ?mApv_cantautorizada," + ;
		" Apv_operauditoria = ?mApv_operauditoria, Apv_urgencia = ?mApv_urgencia,"+;
		" Apv_codsector = ?mApv_codsector , APV_Proveedor = ?mAPV_Proveedor,APV_Cama = ?mAPV_Cama " + ;
		" Where Id = ?mId ")
Case mOpcion = 5
	mApv_codsector = Iif(Vartype(mApv_codsector)#"C",'QUI',mApv_codsector)
&& CAMBIO DE ESTADO && AUDITORIA
	mRet = SQLExec(mcon1,"Update TabAutPrevias Set " + ;
		" Apv_estado = ?mApv_estado, Apv_fechaauditoria = ?mApv_fechaauditoria, " + ;
		" Apv_subestadopend = ?mApv_subestadopend,   " + ;
		"  Apv_observaciones = " + mApvobservaciones + " , " + ;
		" Apv_operauditoria = ?mApv_operauditoria,"+;
		" Apv_codsector = ?mApv_codsector " + ;
		" Where Id = ?mId ")
Case mOpcion = 6
&& CAMBIO DE rubro && AUDITORIA
	mRet = SQLExec(mcon1,"Update TabAutPrevias Set " + ;
		" APV_servicio  = ?mAPV_servicio " + ;
		" Where Id = ?mId ")
	mApvobservacion = "Cambio de rubro"
	mRet = SQLExec(mcon1,"Insert into TabAutPrevLog " + ;
		"(APL_IdAutPrev, APL_Estado, APL_Observaciones, APL_Operador, APL_FecHora) " + ;
		"Values " + ;
		"(?mId, ?mApv_estado, ?mApvobservacion , ?mApv_operauditoria, ?mApv_fechaauditoria)")
Case mOpcion = 7
&& CAMBIO DE ESTADO && MEDICO && REPROGRAMACION
	mRet = SQLExec(mcon1,"select Apv_estado,Apv_fechasolicitud,Apv_observaciones  from TabAutPrevias " + ;
		" Where Id = ?mId ","mwkctrlrp")

	mApv_observaciones = mApv_observaciones +Chr(10)+mwkctrlrp.Apv_observaciones
	If Len(mApv_observaciones)>0
		jj = Int(Len(Alltrim(mApv_observaciones))/250)
		For i = 0 To jj
			clin = "linea" + Padl(i,3,"0")
			Public &clin
		Next

		mApvobservaciones = prg_concat(Alltrim(mApv_observaciones),0)
	Else
		mApvobservaciones = "''"
	Endif
*** saco esto Apv_estado = ?mApv_estado, 05/10 se vuelve aponer xq cambio de fecha de cirgia cambia estado y fecha de solicitud
	If Vartype(mApv_estado)<>"N"
		mApv_estado = mwkctrlrp.Apv_estado
		mApv_fechasolicitud = mwkctrlrp.Apv_fechasolicitud
	Endif
	If !Inlist(Vartype(mApv_fechasolicitud),"D","T")
		mApv_fechasolicitud = mwkctrlrp.Apv_fechasolicitud
	Endif
	mRet = SQLExec(mcon1,"Update TabAutPrevias Set " + ;
		"  APV_FechaCirugia   = ?mAPV_FechaCirugia ,Apv_estado = ?mApv_estado,Apv_fechasolicitud= ?mApv_fechasolicitud, " + ;
		"  Apv_observaciones = " + mApvobservaciones  + ;
		" Where Id = ?mId ")
Endcase

If mRet <= 0
	Messagebox("ERROR AL GUARDAR LA AUTORIZACION",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	mresp = .F.
	Return .F.
Endif

Return .T.
