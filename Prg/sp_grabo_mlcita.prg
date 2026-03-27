*!*
*!* Grabo TabMlCita que es la cabecera de mlaboral, tb grabo TabMlPreocup que es el detalle del personal preocup.
*!* Cada vez que actualizo lleno un registro en la la tabla Tabmlauditoria para tener una auditoria
*!*
** Marcelo Torres, 07/08/2012.
** Se elimino grabacion de parametro mFINTRAT en las 2 tablas. No existe el campo FINTRAT.
** Se elimino grabacion de parametro mTAREASOBSERPRO en tabla TABMLAUDITORIA. No existe el campo TAREASOBSERVPRO.

*!*	Lparameters mCertificado,mDiagnostico,mJustifDias,mJustifFechaD,mFecHoraAtenc,;
*!*		mProbAltaFec,mJustifFechaH,mReducHoraD,mTareaLivFechad,mReducHoraH,mTareaLivFechah,;
*!*		mCitaFecha,mCitaHora,mReducCantHora,mJustificacion,mLegajo,mMedAsistente,;
*!*		mObservAlta,mJustifObserv,mRegistracion,mTareaLiv,mReducHora,mCitaTipo,;
*!*		mFecAlta,mJustifHoraD,mApto,mAptoFecha,mobservaciones,;
*!*		mid,mTabla,mCitaEstado,mIdMedAtiende,mCitaIdMedico,mReducObserv,;
*!*		mTareasObserv,mIdRelac,mMedExtCertif,mdiagnosid,;
*!*		mNoJusCertificado,mNoJustifFechaD,mNoJustifFechah,mNoJustComent,;
*!*		mNoJustifMedico,mNojustDias,mNojustHorad,mIdTareaLiv,;
*!*		mJustifObservAudit,mReducObservAudit,mTareasObservAudit,mNoJustComentAudit,;
*!*		mDiagnosticoAudit,mobservacionesAudit,mObservAltaAudit,mFinTrat,mtareasobserpro,mAbm

LPARAMETERS mid,mJustifObservAudit,mReducObservAudit,mTareaObservAudit,mNoJustComentAudit,mDiagnosticoAudit,;
mObservacionesAudit,mObservAltaAudit,mCitaIdMedico,mIdMedAtiende,mJustifObserv,mReducObserv,;
mTareasObserv,mNoJustComent,mDiagnostico,mJustifFechaD,mJustifFechaH,mJustifDias,mCertifAusJus,;
mEspeAusJus,mFecRetJus,mHoraRetJus,mCertifRetJus,mEspeRetJus,mNoJustifFechaD,mNoJustifFechaH,;
mNoJustifDias,mCertifAusNoJus,mEspeAusNoJus,mFecRetNoJus,mHoraretNoJus,mCertifRetNoJus,mEspeRetNoJus,;
mProbAltaFec,mReducFecD,mTareaLivFecd,mReducFecH,mTareaLivFech,mObservAlta,mTareaLiv,mIdTareaLiv,;
mReducHora,mFecAlta,mFinTrat,mFecHoraAtenc,mCitaFecha,mCitaHora,mReducCantHora,mIdEstSolic,;
mJustificacion,mLegajo,mMedAsistente,mRegistracion,mobservaciones,mCitatipo,mApto,mAptoFecha,;
mTabla,mCitaEstado,mdiagnosid,mtareasobserpro,mAbm,mIdRelac,mMedExtCertif,mFecProxCita,mHoraProxCita

*!*	,miform analizar alternativa de frmmlab02 para pasaje de parametros

Select mwkusuario
mcodigoVax = codigoVax

** Por compatibilidad en tabla Auditoria. Ver de sacar.
mReducHoraD = 0
mReducHoraH = 0

Do Case
Case mAbm = 1  &&Nuevo registro.

** Marcelo Torres
** Esta parte no iria. Toma antes el id antes de grabar...tipico de aplicacion monousuario.
*!*		mret = SQLExec(mcon1, "select MAX(id) AS ID from TabMLCita","mwkMaxCita") && Agregar campo para sacar el max id
*!*		mIdCita = Id + 1

*!*		If !Empty(mIdRelac)
*!*			mIdCita = mIdRelac
*!*		Endif
    
    mIdCita = 0
    lcSql = ""
    
    TEXT TO lcSql NOSHOW ADDITIVE TEXTMERGE FLAGS 1 PRETEXT 7
         INSERT INTO TabMLCita(
        Legajo,           
        CitaFecha,
		CitaHora,         
        Diagnostico,                       
		JustifFechaD,     
		JustifFechaH,     
		JustifDias,       
		Certificado,              		
		EspeAusJus,       
		JustifObserv,     				
		FecRetJus,         
		justifhorad,      
		CertifRetJus,     
		EspeRetJus,       				
		NoJustifFechaD,    
		NoJustifFechah,   
		NojustDias,       		
		NoJusCertificado, 
		NoJustifMedico,  		
		NoJustComent,    				
		NoJusRetFec,      
		NojustHorad,      
		CertifRetNoJus,   
		EspeRetNoJus,     				
		FecAlta,          
		ObservAlta,       				
		TareaLiv,          
		IdTareaLiv,       
		TareaLivFechad,   
		TareaLivFechah,   
		TareasObservPro,  		
		HorarioReducFecD, 	
		HorarioReducFecH, 				
		ReducCantHora,    
		ReducHora,        
		ReducObserv,      		
		FecHoraAtenc,     
		ProbAltaFec,      						
		Justificacion,    				
		MedAsistente,     				
		Registracion,     		
		CitaTipo,         				
		Apto,             		
		AptoFecha,        		
		observaciones,    		
		CitaEstado,       		
		IdMedAtiende,     		
		CitaIdMedico,     						
		IdRelac,          		
		TareasObserv,     		
		diagnosid,
		FecProxCita,
		HoraProxCita)        			
		values(           
		?mLegajo,         
		?mCitaFecha,      
		?mCitaHora,       
		?mDiagnostico,       			
		?mJustifFechaD,       
		?mJustifFechaH,      
		?mJustifDias,        
		?mCertifAusJus,      		
		?mEspeAusJus,        
		?mJustifObserv, 				
		?mFecRetJus,          
		?mHoraRetJus,         
		?mCertifRetJus,       
		?mEspeRetJus,         				
		?mNoJustifFechaD,     
		?mNoJustifFechah,    
		?mNoJustifDias,      						
		?mCertifAusNoJus,     
		?mEspeAusNoJus,      
		?mNoJustComentAudit, 				
		?mFecRetNoJus,        
		?mHoraRetNoJus,      
		?mCertifRetNoJus,    
		?mEspeRetNoJus,      				
		?mFecAlta,            
		?mObservAlta,        				
		?mTareaLiv,           
		?mIdTareaLiv,        
		?mTareaLivFecD,      
		?mTareaLivFecH,      
		?mtareasobserpro,    				
		?mReducFecD,         
		?mReducFecH,        		
		?mReducCantHora,     
		?mReducHora,         
		?mReducObserv,       				
		?mFecHoraAtenc,      
		?mProbAltaFec,       								
		?mJustificacion,     				
		?mMedAsistente,      	
		?mRegistracion,      		
		?mCitaTipo,          		
		?mApto,              
		?mAptoFecha,         		
		?mobservaciones,     		
		?mCitaEstado,        		
		?mIdMedAtiende,      		
		?mCitaIdMedico,      		
		?mIdCita,            		
		?mTareasObserv,      				
		?mdiagnosid,
		?mFecProxCita,
		?mHoraProxCita) 
		
		ENDTEXT
		
		**Ejecutamos INSERT
		mret = SQLExec(mcon1,lcSql)
		 
		**"MedExtCertif,"     +;  
		**"?mMedExtCertif,"      +;
		
		
		
      
*!*		mret = SQLExec(mcon1,"INSERT INTO TabMLCita(Certificado,Diagnostico,"+;
*!*			"JustifDias,JustifFechaD,FecHoraAtenc,"+;
*!*			"ProbAltaFec,JustifFechaH,ReducHoraD,TareaLivFechad,ReducHoraH,TareaLivFechah,"+;
*!*			"CitaFecha,CitaHora,ReducCantHora,Justificacion,Legajo,MedAsistente,"+;
*!*			"ObservAlta,JustifObserv,Registracion,"+;
*!*			"TareaLiv,ReducHora,CitaTipo,FecAlta,Apto,AptoFecha,observaciones,justifhorad,"+;
*!*			"CitaEstado,IdMedAtiende,CitaIdMedico,ReducObserv,IdRelac,TareasObserv,"+;
*!*			"MedExtCertif,diagnosid,NoJusCertificado,NoJustifFechaD,"+;
*!*			"NoJustifFechah,NoJustComent,NoJustifMedico,NojustDias,NojustHorad,IdTareaLiv,"+;
*!*			"TareasObservPro) "+;
*!*			"values(?mCertificado,?mDiagnostico,?mJustifDias,?mJustifFechaD,?mFecHoraAtenc,?mProbAltaFec,"+;
*!*			"?mJustifFechaH,?mReducHoraD,?mTareaLivFechad,?mReducHoraH,"+;
*!*			"?mTareaLivFechah,?mCitaFecha,?mCitaHora,"+;
*!*			"?mReducCantHora,?mJustificacion,?mLegajo,?mMedAsistente,"+;
*!*			"?mObservAlta,?mJustifObserv,?mRegistracion,?mTareaLiv,?mReducHora,?mCitaTipo,"+;
*!*			"?mFecAlta,?mApto,?mAptoFecha,?mobservaciones,?mjustifhorad,"+;
*!*			"?mCitaEstado,?mIdMedAtiende,?mCitaIdMedico,?mReducObserv,"+;
*!*			"?mIdCita,?mTareasObserv,?mMedExtCertif,?mdiagnosid,?mNoJusCertificado,"+;
*!*			"?mNoJustifFechaD,?mNoJustifFechah,?mNoJustComent,?mNoJustifMedico,"+;
*!*			"?mNojustDias,?mNojustHorad,?mIdTareaLiv,?mtareasobserpro)")

	If mret < 0
		Messagebox("ERROR EN ACTUALIZACION CITA",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif
        
    **------------- Recupero el ID del registro.
    USE IN SELECT("mwkIdTemp")
    IF mCitaTipo == 2  &&Enfermedad
       mret = SQLExec(mcon1,"select id, citaidmedico, fechoraatenc, legajo from Tabmlcita where " +;
       "citaidmedico = ?mCitaIdMedico and FecHoraAtenc = ?mFecHoraAtenc and Legajo = ?mLegajo", +;
       "mwkIdTemp")
    ELSE               &&Preocupacional    
       mret = SQLExec(mcon1,"select id, citaidmedico, fechoraatenc, registracion from Tabmlcita where " +;
       "citaidmedico = ?mCitaIdMedico and FecHoraAtenc = ?mFecHoraAtenc and Registracion = ?mRegistracion", +;
       "mwkIdTemp")
    ENDIF
    
    If mret < 0
		Messagebox("ERROR AL RECUPERAR ID TABLA MLCITA",16,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif
    
    IF mwkIdTemp.ID = 0
       MESSAGEBOX("No se pudo recuperar el registro insertado. Avise a Sistemas.",16,"Error")
       USE IN SELECT("mwkIdTemp")
       RETURN .f.
    ENDIF
       
    mIdCita = mwkIdTemp.Id   
    
    USE IN SELECT("mwkIdTemp")
    **------------- Actualizo el campo 
    mret = SQLEXEC(mcon1,"update Tabmlcita set IdRelac = ?mIdCita where ID = ?mIdCita")
    If mret < 0
		Messagebox("ERROR AL ACTUALIZAR CAMPO IDRELAC TABLA MLCITA",16,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif
    
    ** Devolvemos el nuevo nro. de cita.
    mId = mIdCita

	**If !mTabla    &&si no es preocupacional
	** Marcelo Torres, 17/10/2014
	** Grabo el log tambien de PREOCUPACIONAL
	    lcSql = ""
	    
	    TEXT TO lcSql NOSHOW ADDITIVE TEXTMERGE FLAGS 1 PRETEXT 7
		INSERT INTO Tabmlauditoria(
		    Certificado,    
		    Diagnostico,    
			JustifDias,     
			JustifFechaD,   
			FecHoraAtenc,   
			ProbAltaFec,    
			JustifFechaH,   
			ReducHoraD ,    
			TareaLivFechad, 
			ReducHoraH,     
			TareaLivFechah, 
			CitaFecha,      
			CitaHora,       
			ReducCantHora,  
			Justificacion,  
			Legajo,         
			MedAsistente,   
			ObservAlta,      
			JustifObserv,   
			Registracion,   
			TareaLiv,       
			ReducHora,      
			CitaTipo,       
			FecAlta,        
			Apto,           
			AptoFecha,      
			observaciones,  			
			justifhorad,    
			CitaEstado,     
			IdMedAtiende,   
			CitaIdMedico,   
			ReducObserv,    
			IdRelac,        
			TareasObserv,   
			MedExtCertif,   
			diagnosid,      
			NoJusCertificado,
			NoJustifFechaD, 
			NoJustifFechah, 
			NoJustComent,   
			NoJustifMedico, 
			NojustDias,     
			NojustHorad,    
			IdTareaLiv     						 
			) values( 
			?mCertifAusJus,   
			?mDiagnostico,   
			?mJustifDias,    
			?mJustifFechaD,  
			?mFecHoraAtenc,  
			?mProbAltaFec,   
			?mJustifFechaH,  
			?mReducHoraD ,   
			?mTareaLivFecd,
			?mReducHoraH,    
			?mTareaLivFech,   
			?mCitaFecha,     
			?mCitaHora,      
			?mReducCantHora, 
			?mJustificacion, 
			?mLegajo,        
			?mMedAsistente,  
			?mObservAlta,    
			?mJustifObserv , 
			?mRegistracion,  
			?mTareaLiv,      
			?mReducHora,     
			?mCitaTipo,      
			?mFecAlta,       
			?mApto,          
			?mAptoFecha,     
			?mobservaciones, 			
			?mHoraRetJus,     
			?mCitaEstado,    
			?mIdMedAtiende,  
			?mCitaIdMedico,  
			?mReducObserv,   
			?mIdCita,        
			?mTareasObserv,  
			?mMedExtCertif,  
			?mdiagnosid,     
			?mCertifAusNoJus, 
			?mNoJustifFechaD,
			?mNoJustifFechah,
			?mNoJustComentAudit,   
			?mEspeAusNoJus,   
			?mNoJustifDias,   
			?mHoraRetNoJus,   
			?mIdTareaLiv)
        
        ENDTEXT
        **fecRetJus,      
        **?mFecRetJus,      
        **TareasObservPro
        **?mtareasobserpro
        
        mret = SQLExec(mcon1,lcSql)
        
		If mret < 0
			Messagebox("ERROR EN ACTUALIZACION TABLA AUDITORIA.",16,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif
	**Endif

	If mTabla
		mfechapasiva = Ctod('01/01/1900')
		Select mwkEstudios
		Scan
			mIdEstudio = IdEstudio
			mObservEst = Descr
			midcondicion = CondEstudio
			
			IF mwkEstudios.borrado <> "X"  &&No ingresamos los items borrados.
   			   mret = SQLExec(mcon1,"INSERT INTO TabMlPreocup(IdEstudio,IdCita,Observaciones,idcondicion,fechapasiva)"+;
				      " values(?mIdEstudio,?mIdCita,?mObservEst,?midcondicion,?mfechapasiva)")
			   If mret < 0
				  Messagebox("ERROR EN ACTUALIZACION TABLA PREOCUPACIONAL.",26,"ERROR")
				  EXIT
			   ENDIF
			ENDIF
			   
		ENDSCAN
		
		IF mRet < 0
		   Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		   Return .F.
		ENDIF
				
	Endif

Case mAbm = 2
	mret  =  SQLExec(mcon1,"update TabMlCita set " +;
	    "Certificado=?mCertifAusJus,      "+; &&mCertificado
		"Diagnostico=?mDiagnostico,      "+;
		"JustifDias=?mJustifDias,        "+;
		"JustifFechaD=?mJustifFechaD,    "+;
		"FecHoraAtenc=?mFecHoraAtenc,    "+;
		"ProbAltaFec=?mProbAltaFec,      "+;
		"JustifFechaH=?mJustifFechaH,    "+;
		"HorarioReducFecD=?mReducFecD,"   +;
		"TareaLivFechad=?mTareaLivFecd,"+;
		"HorarioReducFecH=?mReducFecH,"   +;
		"TareaLivFechah=?mTareaLivFech,"+;
		"CitaFecha=?mCitaFecha,          "+;
		"ReducCantHora=?mReducCantHora,  "+;
		"Justificacion=?mJustificacion,  "+;
		"FecAlta=?mFecAlta,              "+;
		"Legajo=?mLegajo,                "+;
		"MedAsistente=?mMedAsistente,    "+;
		"ObservAlta=?mObservAlta,        "+;
		"JustifObserv=?mJustifObserv,    "+;
		"Registracion=?mRegistracion,    "+;
		"TareaLiv=?mTareaLiv,            "+;
		"ReducHora=?mReducHora,          "+;
		"CitaTipo=?mCitaTipo,            "+;
		"Apto=?mApto,                    "+;
		"AptoFecha=?mAptoFecha,          "+;
		"observaciones=?mobservaciones,  "+;
		"justifhorad=?mHoraRetJus,"      +;
		"CitaEstado=?mCitaEstado,        "+;
		"IdMedAtiende=?mIdMedAtiende,    "+;
		"CitaIdMedico=?mCitaIdMedico,    "+;
		"ReducObserv=?mReducObserv,      "+;
		"NoJusCertificado=?mCertifAusNoJus,"+;
		"NoJustifFechaD=?mNoJustifFechaD,"+;
		"NoJustifFechah=?mNoJustifFechah,"+;
		"NoJustComent=?mNoJustComentAudit," +;  &&mNoJustComent
		"TareasObserv=?mTareasObserv,    "+;
		"MedExtCertif=?mMedExtCertif,    "+;
		"diagnosid=?mdiagnosid,          "+;
		"NoJustifMedico=?mEspeAusNoJus,"  +;  &&mNoJustifMedico
		"NojustDias=?mNoJustifDias,      "+;  &&mNojustDias
		"NojustHorad=?mHoraRetNoJus,      "+; &&mNojustHorad
		"IdTareaLiv=?mIdTareaLiv,        "+;
		"TareasObservPro=?mtareasobserpro,"+;  
		"EspeAusJus=?mEspeAusJus,"         +;  &&Especialidad Ausencia Justificada
		"EspeRetJus=?mEspeRetJus,"         +;  &&Especialidad Retiro Justificado 
		"EspeRetNoJus=?mEspeRetNoJus,"     +;  &&Especialidad Retiro NO justificado
		"FecRetJus=?mFecRetJus,"           +;  &&Fecha Retiro Justificado
		"CertifRetJus=?mCertifRetJus,"     +;  &&Certificado Retiro justificado
		"NoJusRetFec=?mFecRetNoJus,"       +;  &&Fecha Retiro NO justificado
		"CertifRetNoJus=?mCertifRetNoJus," +;  &&Certificado Retiro No justificado
		"FecProxCita=?mFecProxCita,"       +;
		"HoraProxCita=?mHoraProxCita"      +;
		" where id=?mid")
** FinTrat=?mFinTrat,

	If mret < 0
		Messagebox("ERROR EN ACTUALIZACION CITA",16,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

    
	If Type('frmmlab08') = 'O'
		Select mwkCitaHistorial
		mIdCita  = IdRelac
	Else
		If Used('mwkHoraCitaSelec')
			Select mwkHoraCitaSelec
			mIdCita  = IdRelac
		Endif
	Endif

	**If !mTabla    &&si no es preocupacional
	** Marcelo Torres, 17/10/2014
	** Grabo el log de PREOCUPACIONAL
*!*			mret = SQLExec(mcon1,"INSERT INTO Tabmlauditoria(Certificado,Diagnostico,"+;
*!*				"JustifDias,JustifFechaD,FecHoraAtenc,"+;
*!*				"ProbAltaFec,JustifFechaH,ReducHoraD ,TareaLivFechad,ReducHoraH,TareaLivFechah,"+;
*!*				"CitaFecha,CitaHora,ReducCantHora,Justificacion,Legajo,MedAsistente,"+;
*!*				"ObservAlta,JustifObserv,Registracion,"+;
*!*				"TareaLiv,ReducHora,CitaTipo,FecAlta,Apto,AptoFecha,observaciones,justifhorad,"+;
*!*				"CitaEstado,IdMedAtiende,CitaIdMedico,ReducObserv,IdRelac,TareasObserv,"+;
*!*				"MedExtCertif,diagnosid, NoJusCertificado,NoJustifFechaD,"+;
*!*				"NoJustifFechah,NoJustComent,NoJustifMedico,NojustDias,NojustHorad,IdTareaLiv"+;
*!*				") "+;
*!*				"values(?mCertificado,?mDiagnosticoAudit,?mJustifDias,?mJustifFechaD,?mFecHoraAtenc,?mProbAltaFec,"+;
*!*				"?mJustifFechaH,?mReducHoraD ,?mTareaLivFechad,?mReducHoraH,"+;
*!*				"?mTareaLivFechah,?mCitaFecha,?mCitaHora,"+;
*!*				"?mReducCantHora,?mJustificacion,?mLegajo,?mMedAsistente,"+;
*!*				"?mObservAltaAudit,?mJustifObservAudit ,?mRegistracion,?mTareaLiv,?mReducHora,?mCitaTipo,"+;
*!*				"?mFecAlta,?mApto,?mAptoFecha,?mobservacionesAudit,?mjustifhorad,"+;
*!*				"?mCitaEstado,?mIdMedAtiende,?mCitaIdMedico,?mReducObservAudit,"+;
*!*				"?mIdCita,?mTareasObservAudit,?mMedExtCertif,?mdiagnosid,?mNoJusCertificado,"+;
*!*				"?mNoJustifFechaD,?mNoJustifFechah,?mNoJustComentAudit,?mNoJustifMedico,"+;
*!*				"?mNojustDias,?mNojustHorad,?mIdTareaLiv)")  &&,?mtareasobserpro)")

           mret = SQLExec(mcon1,"INSERT INTO Tabmlauditoria(Certificado,Diagnostico,"+;
			"JustifDias,JustifFechaD,FecHoraAtenc,"+;
			"ProbAltaFec,JustifFechaH,ReducHoraD ,TareaLivFechad,ReducHoraH,TareaLivFechah,"+;
			"CitaFecha,CitaHora,ReducCantHora,Justificacion,Legajo,MedAsistente,"+;
			"ObservAlta,JustifObserv,Registracion,"+;
			"TareaLiv,ReducHora,CitaTipo,FecAlta,Apto,AptoFecha,observaciones,justifhorad,"+;
			"CitaEstado,IdMedAtiende,CitaIdMedico,ReducObserv,IdRelac,TareasObserv,"+;
			"MedExtCertif,diagnosid, NoJusCertificado,NoJustifFechaD,"+;
			"NoJustifFechah,NoJustComent,NoJustifMedico,NojustDias,NojustHorad,IdTareaLiv"+;
			") "+;
			"values(?mCertifAusJus,?mDiagnosticoAudit,?mJustifDias,?mJustifFechaD,?mFecHoraAtenc,?mProbAltaFec,"+;
			"?mJustifFechaH,?mReducHoraD ,?mTareaLivFecd,?mReducHoraH,"+;
			"?mTareaLivFech,?mCitaFecha,?mCitaHora,"+;
			"?mReducCantHora,?mJustificacion,?mLegajo,?mMedAsistente,"+;
			"?mObservAltaAudit,?mJustifObserv ,?mRegistracion,?mTareaLiv,?mReducHora,?mCitaTipo,"+;
			"?mFecAlta,?mApto,?mAptoFecha,?mobservacionesAudit,?mHoraRetJus,"+;
			"?mCitaEstado,?mIdMedAtiende,?mCitaIdMedico,?mReducObservAudit,"+;
			"?mIdCita,?mTareasObserv,?mMedExtCertif,?mdiagnosid,?mCertifAusNoJus,"+;
			"?mNoJustifFechaD,?mNoJustifFechah,?mNoJustComentAudit,?mEspeAusNoJus,"+;
			"?mNoJustifDias,?mHoraRetNoJus,?mIdTareaLiv)") 
            **,TareasObservPro
            **,?mtareasobserpro
            
		If mret < 0
			Messagebox("ERROR EN ACTUALIZACION TABLA AUDITORIA",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

	**Endif

	If mTabla
		Select mwkHoraCitaSelec
		mIdCita = IdRelac
		mfechapasiva = Ctod('01/01/1900')
		mfechaborrar = sp_busco_fecha_serv('DD')     
		
		Select mwkEstudios
		Scan
			If mwkEstudios.Id = 0 .and. mwkEstudios.borrado <> "X"  &&Agregamos registro
				mIdEstudio = IdEstudio
				mObservEst = Descr
				midcondicion = CondEstudio
				mret  =  SQLExec(mcon1,"INSERT INTO TabMlPreocup(IdEstudio,IdCita,Observaciones,idcondicion,fechapasiva) "+;
					"values(?mIdEstudio,?mIdCita,?mObservEst,?midcondicion,?mfechapasiva) ")

				If mret < 0
					Messagebox("ERROR EN ACTUALIZACION TABLA PREOCUPACIONAL.",26,"ERROR")
					EXIT
				Endif
           
			ENDIF
			
			IF mwkEstudios.borrado == "X"   &&Marcamos como borrado.
			   midDelete = mwkEstudios.id
			   mRet = SQLEXEC(mCon1,"update TabMlPreocup set fechapasiva = ?mFechaBorrar where id = ?midDelete" )
			ENDIF			
			
		ENDSCAN
		
		IF mRet < 0
		   Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		   Return .F.
		ENDIF
		
*!*	*!*     Borro los que fueron borrados
*!*			mfechapasiva = sp_busco_fecha_serv('DD')
*!*			Select mwkdelete
*!*			Scan
*!*				midDelete = idDelete
*!*				mret  =  SQLExec(mcon1,"update TabMlPreocup set fechapasiva = ?mfechapasiva where id = ?midDelete")
*!*				If mret < 0
*!*					Messagebox("ERROR EN ACTUALIZACION TABLA PREOCUPACIONAL.",26,"ERROR")
*!*					EXIT
*!*				Endif
*!*			ENDSCAN
*!*			
*!*			IF mRet < 0
*!*			   Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*			   Return .F.
*!*			ENDIF
		
	Endif

Case mAbm = 3

Endcase

RETURN .t.
