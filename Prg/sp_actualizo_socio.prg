parameters mape, mid, mob,mdt,mForm,meven,mpac,dq,mprio,mids
*!************************************************************************************
*!* Rutinas del Boton de Guardado:
*!* Parametros Apellido y Nombre(mape);ID de Motivo (mid);Observacion(mob);
*!* Fecha/Hora en que comienza ha ser atendido (mdt); Nombre del form que lo llama(mForm)
*!*************************************************************************************
*!***********************************************
*!* Traigo el mayor Id para generar el autonumerico
*!***********************************************
IF VARTYPE(mprio)="U"
	mprio = 0
endif
IF VARTYPE(mids)#"N"
	mids = mpidsocio 
ENDIF
midsocio =  mids 
mret=sqlexec(mcon1,"SELECT	MAX(IdSocio) as IdSocio FROM SOCIO","mwkrreg")

if mret < 0
	do log_errores with error(), message(), message(1), program(), lineno()
	messagebox("No se puede acceder a algunos Datos",0+64,"Usuario")
	GuardoDatosSQL = .f.
else
	mnombre = allt(mwkusuario.idusuario)
	maten   = sys(0)
	mdtF    = sp_busco_fecha_serv('DT')


	if mForm = "frmMesa1"
		midpers= nvl(mwkrreg.IdSocio,0) + 1
		mret =sqlexec(mcon1,"INSERT INTO Socio(ApellidoNombre, Atendido, "+;
			"HoraLLegada,IdMotivo,IdSocio,Observacion,Operadora,puestoAtencion,PrioridadAt,CodEntidad)"+;
			"VALUES (?mape,0,?mdt,?mid,?midpers,?mob,?mnombre,?maten,?mprio, ?mCodEnt)")
		if mret<0
			do log_errores with error(), message(), message(1), program(), lineno()
		endif
		mret_v =sqlexec(mcon1,"select OperadorA from Socio "+;
			" where Horallegada=?mdt and atendido = 0 "+;
			" and Operadora= ?mnombre "+;
			" and  IdSocio= ?midpers",'mwkQuienGraba')
		if mret_v<0
			do log_errores with error(), message(), message(1), program(), lineno()
		endif
	else

		if meven=1
			if dq = 0
				mret =sqlexec(mcon1,"UPDATE Socio SET "+;
					"HoraFinalizacion=?mdtf, atendido=1, "+;
					"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
					"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
					"WHERE IdSocio= ?mids")
				if mret<0
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
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

			else
				if dq = 8
					mObsR = frmMesa2.pg.pgDatos.edtobservacion.Value
					mret =sqlexec(mcon1,"UPDATE Socio SET "+;
						"HoraFinalizacion=?mdtf, "+;
						"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
						"OperadoraA=?mnombre, Paciente=?mpac, prioridadat = ?mprio, "+;
						"Observacion=?mobsr " + ;
						"WHERE IdSocio= ?mids")
					if mret<0
						do log_errores with error(), message(), message(1), program(), lineno()
					endif
				else

					mret =sqlexec(mcon1,"UPDATE Socio SET "+;
						"HoraFinalizacion=?mdtf, "+;
						"IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
						"OperadoraA=?mnombre,Paciente=?mpac,prioridadat = ?mprio "+;
						"WHERE IdSocio= ?mids")
					if mret<0
						do log_errores with error(), message(), message(1), program(), lineno()
					endif
				endif
			endif
		else
			if !empty(mape)
				mret =sqlexec(mcon1,"UPDATE Socio SET HoraAtencion=?mdt,atendido =1, "+;
					" OperadoraA= ?mnombre "+;
					" WHERE IdSocio= ?midSocio and HoraAtencion is null ")
				if mid = 57
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
				endif


			else
				mret =sqlexec(mcon1,"UPDATE Socio SET HoraAtencion= null ,atendido = 0, "+;
					" OperadoraA= null "+;
					" WHERE IdSocio= ?mids")
			endif
			if mret<0
				do log_errores with error(), message(), message(1), program(), lineno()
			endif

		endif
	endif

	if mret > 0
		if meven=1
			messagebox("Se Guardaron los Datos Exitosamente!!!",0+64,"Usuario")
			GuardoDatosSQL = .t.
		else
			if empty(mape)
				mret_v =sqlexec(mcon1,"select OperadorA,horaAtencion from Socio "+;
					" where IdSocio = ?midSocio and horaAtencion is null ",'mwkQuienGraba')
				if reccount('mwkQuienGraba')>0
					messagebox("Se Descartaron los Datos Exitosamente!!!",0+64,"Usuario")
					GuardoDatosSQL = .t.
				endif
			else
				mret_v =sqlexec(mcon1,"select OperadorA,horaAtencion from Socio "+;
					" where OperadoraA like ?mnombre "+;
					" and  IdSocio = ?midSocio and horaAtencion is not null ",'mwkQuienGraba')
				if mret_v > 0

					if eof('mwkQuienGraba')
						messagebox("Este Paciente fue llamado por Otro Operador ",64,'Usuario')
						GuardoDatosSQL = .f.
					else
						GuardoDatosSQL = .t.
					endif
				else
					do log_errores with error(), message(), message(1), program(), lineno()
					GuardoDatosSQL = .f.
				endif
			endif
		endif
	else

		messagebox("No se Actualizaron, avisar a sistemas del siguiente error",0+64,"Usuario")
		GuardoDatosSQL = .f.
	endif
endif
return GuardoDatosSQL
