*************************
* Proceso de depuracion
**************************
lparameters retraso
set escape off
if vartype(retraso)#"N"
	retraso= 2
endif

ldesco = .f.
if !used("mwkserver1")
	ldesco = .t.
	do sp_conexion
endif
mfecproc1 = sp_busco_fecha_serv('DT')
mfecproc  = ttod(mfecproc1)
mfecproc  = mfecproc  - retraso
mfecingre = ttod(mfecproc1) - 2
if (hour(mfecproc1) >6 and  hour(mfecproc1)< 10) or retraso>0
	mret = sqlexec(mcon1, "select * from socio where cast(horallegada as date) < ?mfecproc "+;
	"and Atendido = 0 and idmotivo <>27 order by HoraLLegada ", "mwksinatender")
	mret = sqlexec(mcon1, "select * from socio where cast(horallegada as date) < ?mfecproc "+;
	"and Atendido = 1 and idmotivo = 57 order by HoraLLegada ", "mwktendidos")
	select mwksinatender
	if reccount('mwksinatender')>0
		go top
		select * from mwksinatender where !((inlist(idmotivo,27) and ;
			nvl(paciente,'*') in (select paciente from mwktendidos )) ;
			or (inlist(idmotivo,27) and ;
			horallegada <mfecingre )) ;
			and idmotivo>0 order by HoraLLegada into cursor mwksinatender2

		if reccount('mwksinatender2')>0
			go top
			mfecproc = ttod(horallegada)
		endif
	endif
	mret = sqlexec(mcon1, "select * from socio where cast(horallegada as date) < ?mfecproc ", "mwksaco")

	if mret > 0
		if !eof("mwksaco")
			select mwksaco
			go top

			do while !eof('mwksaco')
				scat memv
				m.Atendido =iif(mwksaco.Atendido,1,0)
				m.idreg    = mwksaco.id
				mret =sqlexec(mcon1," INSERT INTO Sociohis(ApellidoNombre, Atendido, "+;
					" HoraAtencion,HoraFinalizacion,HoraLLegada,IdMotivo,"+;
					"  IdSocio,ObservaA, Observacion,Operadora, "+;
					" OperadoraA, puestoAtencion,IdMotivoA, paciente)"+;
					" VALUES (?m.ApellidoNombre,?m.Atendido,?m.HoraAtencion,"+;
					" ?m.HoraFinalizacion, ?m.HoraLLegada, ?m.IdMotivo, "+;
					" ?m.IdSocio, ?m.Observacion, ?m.ObservaA, "+;
					" ?m.Operadora,?m.OperadoraA,?m.puestoAtencion,?m.IdMotivoA,?m.paciente)")

				if mret < 0
					messagebox("NO SE REALIZA CORRECTAMENTE LA OPERACION" + chr(13) + ;
						"VERIFIQUE LA INFORMACION", 16,"Validacion")
					cancel
				else

					mret = sqlexec(mcon1, "Delete From Socio Where id = ?m.idreg ")
					if mret < 0
						mok =.f.
					endif
				endif

				skip 1 in mwksaco
			enddo
		endif
	endif
endif
set escape on
if 	ldesco
	do sp_desconexion
endif

*	.lbltitle.caption	= "PROCESO TERMINADO, Registros Procesados " + alltrim(str(mpaso))
*	.lbltask.caption	= ""


