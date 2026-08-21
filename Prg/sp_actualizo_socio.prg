Parameters mape, mid, mob,mdt,mForm,meven,mpac,dq,mprio,mids
*!************************************************************************************
*!* Rutinas del Boton de Guardado:
*!* Parametros Apellido y Nombre(mape);ID de Motivo (mid);Observacion(mob);
*!* Fecha/Hora en que comienza ha ser atendido (mdt); Nombre del form que lo llama(mForm)
*!*************************************************************************************
*!***********************************************
*!* Traigo el mayor Id para generar el autonumerico
*!***********************************************
If Vartype(mprio)="U"
	mprio = 0
ENDIF
GuardoDatosSQL = .T.
If Vartype(mids)#"N"
	If Vartype(mpidsocio)#"N"
		mpidsocio = 0
	Endif
	mids = mpidsocio
Endif
midsocio =  mids
mnombre = IIF(USED('mwkusuarios'),Allt(mwkusuarios.idusuario),Allt(mwkusuario.idusuario))

If mconsql = 0
	sp_conecta_sqlserver()
Endif
If mconsql > 0  &&sqlserver

	mret=SQLExec(mconsql,"SELECT MAX(IdSocio) as IdSocio FROM sqluser.SOCIO","mwkrreg")

	If mret < 0
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("No se puede acceder a algunos Datos - tabla SOCIOS",0+64,"Usuario")
		GuardoDatosSQL = .F.
	Else
		maten   = Sys(0)
		mdtF    = sp_busco_fecha_serv('DT')


		If mForm = "frmMesa1"

			midpers= Nvl(mwkrreg.IdSocio,0) + 1
			mret =SQLExec(mconsql,"INSERT INTO sqluser.Socio(ApellidoNombre, Atendido, "+;
				"HoraLLegada,IdMotivo,IdSocio,Observacion,Operadora,puestoAtencion,PrioridadAt,CodEntidad)"+;
				"VALUES (?mape,0,?mdt,?mid,?midpers,?mob,?mnombre,?maten,?mprio, ?mCodEnt)")
			If mret<0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
			mret_v =SQLExec(mconsql,"select OperadorA from sqluser.Socio "+;
				" where Horallegada=?mdt and atendido = 0 "+;
				" and Operadora= ?mnombre "+;
				" and  IdSocio= ?midpers",'mwkQuienGraba')
			If mret_v<0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif

		Else

			If meven=1
				If dq = 0
					mret =SQLExec(mconsql,"UPDATE sqluser.Socio SET "+;
						"HoraFinalizacion=?mdtf, atendido=1, "+;
						"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
						"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
						"WHERE IdSocio= ?mids")
					If mret<0
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Endif
*!*					if mid = 57
*!*						do sp_busco_socio with 3,' Where  SOCIO.paciente = "'+mpac+'" and IdMotivo = 27 ',"mwksocSI"
*!*						select mwksocSI
*!*						scan
*!*							midSocioSI = IdSocio
*!*							mret =sqlexec(mcon1,"UPDATE Socio SET "+;
*!*								"HoraFinalizacion=?mdtf, atendido=1, "+;
*!*								"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
*!*								"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
*!*								"WHERE IdSocio= ?midSocioSI ")
*!*						endscan
*!*					endif

				Else
					If dq = 8
						mObsR = Left(frmMesa2.pg.pgDatos.edtobservacion.Value,250)
						mret =SQLExec(mconsql,"UPDATE sqluser.Socio SET "+;
							"HoraFinalizacion=?mdtf, "+;
							"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
							"OperadoraA=?mnombre, Paciente=?mpac, prioridadat = ?mprio, "+;
							"Observacion=?mobsr " + ;
							"WHERE IdSocio= ?mids")
						If mret<0
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Endif
					Else

						mret =SQLExec(mconsql,"UPDATE sqluser.Socio SET "+;
							"HoraFinalizacion=?mdtf, "+;
							"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
							"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
							"WHERE IdSocio= ?mids")
						If mret<0
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Endif
					Endif
				Endif
			Else
				If !Empty(mape)
					mret =SQLExec(mconsql,"UPDATE sqluser.Socio SET HoraAtencion=?mdt,atendido =1, "+;
						" OperadoraA= ?mnombre "+;
						" WHERE IdSocio= ?midSocio and HoraAtencion is null ")
					If mid = 57
*!*						do sp_busco_socio with 3,' Where  SOCIO.paciente = "'+mpac+'" and IdMotivo = 27 ',"mwksocSI"
*!*						select mwksocSI
*!*						scan
*!*							midSocioSI = IdSocio
*!*							mret =sqlexec(mcon1,"UPDATE Socio SET "+;
*!*								"HoraFinalizacion=?mdtf, atendido=1, "+;
*!*								"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
*!*								"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
*!*								"WHERE IdSocio= ?midSocioSI ")
*!*						endscan
					Endif


				Else
					mret =SQLExec(mconsql,"UPDATE sqluser.Socio SET HoraAtencion= null ,atendido = 0, "+;
						" OperadoraA= null "+;
						" WHERE IdSocio= ?mids")
				Endif
				If mret<0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif

			Endif
		Endif

		If mret > 0
			If meven=1
				Messagebox("Se Guardaron los Datos Exitosamente!!!",0+64,"Usuario")
				GuardoDatosSQL = .T.
			Else
				If Empty(mape)
					mret_v =SQLExec(mconsql,"select OperadorA,horaAtencion from sqluser.Socio "+;
						" where IdSocio = ?midSocio and horaAtencion is null ",'mwkQuienGraba')
					If Reccount('mwkQuienGraba')>0
						Messagebox("Se Descartaron los Datos Exitosamente!!!",0+64,"Usuario")
						GuardoDatosSQL = .T.
					Endif
				Else
					mret_v =SQLExec(mconsql,"select OperadorA,horaAtencion from sqluser.Socio "+;
						" where OperadoraA like ?mnombre "+;
						" and  IdSocio = ?midSocio and horaAtencion is not null ",'mwkQuienGraba')
					If mret_v > 0

						If Eof('mwkQuienGraba')
							Messagebox("Este Paciente fue llamado por Otro Operador ",64,'Usuario')
							GuardoDatosSQL = .F.
						Else
							GuardoDatosSQL = .T.
						Endif
					Else
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						GuardoDatosSQL = .F.
					Endif
				Endif
			Endif
		Else

			Messagebox("No se Actualizaron, avisar a sistemas del siguiente error",0+64,"Usuario")
			GuardoDatosSQL = .F.
		Endif
	Endif

Else

	mret=SQLExec(mcon1,"SELECT	MAX(IdSocio) as IdSocio FROM SOCIO","mwkrreg")

	If mret < 0
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("No se puede acceder a algunos Datos",0+64,"Usuario")
		GuardoDatosSQL = .F.
	Else
 		maten   = Sys(0)
		mdtF    = sp_busco_fecha_serv('DT')


		If mForm = "frmMesa1"
			midpers= Nvl(mwkrreg.IdSocio,0) + 1
			mret =SQLExec(mcon1,"INSERT INTO Socio(ApellidoNombre, Atendido, "+;
				"HoraLLegada,IdMotivo,IdSocio,Observacion,Operadora,puestoAtencion,PrioridadAt,CodEntidad)"+;
				"VALUES (?mape,0,?mdt,?mid,?midpers,?mob,?mnombre,?maten,?mprio, ?mCodEnt)")
			If mret<0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
			mret_v =SQLExec(mcon1,"select OperadorA from Socio "+;
				" where Horallegada=?mdt and atendido = 0 "+;
				" and Operadora= ?mnombre "+;
				" and  IdSocio= ?midpers",'mwkQuienGraba')
			If mret_v<0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else

			If meven=1
				If dq = 0
					mret =SQLExec(mcon1,"UPDATE Socio SET "+;
						"HoraFinalizacion=?mdtf, atendido=1, "+;
						"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
						"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
						"WHERE IdSocio= ?mids")
					If mret<0
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Endif
*!*					if mid = 57
*!*						do sp_busco_socio with 3,' Where  SOCIO.paciente = "'+mpac+'" and IdMotivo = 27 ',"mwksocSI"
*!*						select mwksocSI
*!*						scan
*!*							midSocioSI = IdSocio
*!*							mret =sqlexec(mcon1,"UPDATE Socio SET "+;
*!*								"HoraFinalizacion=?mdtf, atendido=1, "+;
*!*								"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
*!*								"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
*!*								"WHERE IdSocio= ?midSocioSI ")
*!*						endscan
*!*					endif

				Else
					If dq = 8
						mObsR = Left(frmMesa2.pg.pgDatos.edtobservacion.Value,250)
						mret =SQLExec(mcon1,"UPDATE Socio SET "+;
							"HoraFinalizacion=?mdtf, "+;
							"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
							"OperadoraA=?mnombre, Paciente=?mpac, prioridadat = ?mprio, "+;
							"Observacion=?mobsr " + ;
							"WHERE IdSocio= ?mids")
						If mret<0
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Endif
					Else

						mret =SQLExec(mcon1,"UPDATE Socio SET "+;
							"HoraFinalizacion=?mdtf, "+;
							"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
							"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
							"WHERE IdSocio= ?mids")
						If mret<0
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Endif
					Endif
				Endif
			Else
				If !Empty(mape)
					mret =SQLExec(mcon1,"UPDATE Socio SET HoraAtencion=?mdt,atendido =1, "+;
						" OperadoraA= ?mnombre "+;
						" WHERE IdSocio= ?midSocio and HoraAtencion is null ")
					If mid = 57
*!*						do sp_busco_socio with 3,' Where  SOCIO.paciente = "'+mpac+'" and IdMotivo = 27 ',"mwksocSI"
*!*						select mwksocSI
*!*						scan
*!*							midSocioSI = IdSocio
*!*							mret =sqlexec(mcon1,"UPDATE Socio SET "+;
*!*								"HoraFinalizacion=?mdtf, atendido=1, "+;
*!*								"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
*!*								"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
*!*								"WHERE IdSocio= ?midSocioSI ")
*!*						endscan
					Endif


				Else
					mret =SQLExec(mcon1,"UPDATE Socio SET HoraAtencion= null ,atendido = 0, "+;
						" OperadoraA= null "+;
						" WHERE IdSocio= ?mids")
				Endif
				If mret<0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif

			Endif
		Endif

		If mret > 0
			If meven=1
				Messagebox("Se Guardaron los Datos Exitosamente!!!",0+64,"Usuario")
				GuardoDatosSQL = .T.
			Else
				If Empty(mape)
					mret_v =SQLExec(mcon1,"select OperadorA,horaAtencion from Socio "+;
						" where IdSocio = ?midSocio and horaAtencion is null ",'mwkQuienGraba')
					If Reccount('mwkQuienGraba')>0
						Messagebox("Se Descartaron los Datos Exitosamente!!!",0+64,"Usuario")
						GuardoDatosSQL = .T.
					Endif
				Else
					mret_v =SQLExec(mcon1,"select OperadorA,horaAtencion from Socio "+;
						" where OperadoraA like ?mnombre "+;
						" and  IdSocio = ?midSocio and horaAtencion is not null ",'mwkQuienGraba')
					If mret_v > 0

						If Eof('mwkQuienGraba')
							Messagebox("Este Paciente fue llamado por Otro Operador ",64,'Usuario')
							GuardoDatosSQL = .F.
						Else
							GuardoDatosSQL = .T.
						Endif
					Else
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						GuardoDatosSQL = .F.
					Endif
				Endif
			Endif
		Else

			Messagebox("No se Actualizaron, avisar a sistemas del siguiente error",0+64,"Usuario")
			GuardoDatosSQL = .F.
		Endif
	Endif

Endif

Return GuardoDatosSQL
