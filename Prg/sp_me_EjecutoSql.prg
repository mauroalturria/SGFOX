Parameters formulario, fecha1, fecha2

mf1 = prg_dtoc(fecha1)
mf2 = prg_dtoc(fecha2 + 1)

*!***********************
*!**Conecto los motivos
*!***********************
If formulario= 0
	mret = SQLEXEC(mcon1,"Select motivotext, idmotivo "+;
		"from motivos order by motivotext","mwkmotivos1")
	If mret < 0
		Do log_errores with error(), message(), message(1), program(), lineno()
		Messagebox("Los Motivos no estan  disponibles - Informar a Sistemas",0+64,"Conexion")
	Endif
Endif
*!*****************************************
*!*Connecto Personas que estan  sin atender
*!*****************************************

*!*
mTIPOPAC = "INT" && "AMB" "INT" "GUA"

If formulario = 1 or formulario = 0

	mret = SQLEXEC(mcon1,"SELECT	SOCIO.HoraLLegada, MOTIVOS.MotivoText,"+;
		" SOCIO.ApellidoNombre, SOCIO.Observacion, "+;
		" SOCIO.HoraAtencion,ObservaA, Horafinalizacion,"+;
		" paciente,MOTIVOS.MotivoText, operadora, OperadoraA, "+;
		" puestoatencion,  "+;
		" SOCIO.IdSocio, MOTIVOS.IdMotivo,SOCIO.PrioridadAt, "+;
		" ENT_DESCRIENT, entidexclu.fecpasiva as fecpasiva_Excl " + ;
		" FROM	SOCIO " + ;
		" inner JOIN MOTIVOS ON SOCIO.IdMotivo = MOTIVOS.IdMotivo " + ;
		" LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent " + ;
		" LEFT JOIN entidexclu On SOCIO.codentidad = entidexclu.codent And tpopac=?mTIPOPAC " + ;
		" WHERE	SOCIO.HoraAtencion is Null AND SOCIO.Atendido=0 "+;
		" ORDER	BY SOCIO.HoraLLegada ","mwkLLegadas")

	If mret < 0
		Do log_errores with error(), message(), message(1), program(), lineno()
		Messagebox("No esta disponibles la lista de Esperas - Informar a Sistemas",0+64,"Conexion")
	Endif

Else

	mret = SQLEXEC(mcon1," SELECT HoraLLegada "+;
		" FROM	SOCIO where Atendido = 1 ","mwkctrldia")
	Select mwkctrldia
	If reccount('mwkctrldia')>0
		Calculate min(HoraLLegada) to limiteDia
	Else
		limiteDia = dtot(ttod(mwkfecserv.fechahora))
	Endif
	If fecha1 < fecha2
		vbusco =" AND SOCIO.HoraAtencion between ?mf1 and ?mf2 "
	Else
		fecha2 = fecha1 +1
		vbusco =" AND SOCIO.HoraAtencion >= ?fecha1 and SOCIO.HoraAtencion < ?fecha2 "
	Endif

	mret = SQLEXEC(mcon1," SELECT SOCIO.HoraLLegada, MOTIVOS.MotivoText, "+;
		" SOCIO.ApellidoNombre, SOCIO.Observacion, "+;
		" SOCIO.HoraAtencion, ObservaA, Horafinalizacion,"+;
		" A.MotivoText, operadora, OperadoraA,"+;
		" puestoatencion, SOCIO.IdSocio, "+;
		" MOTIVOS.IdMotivo,SOCIO.IdMotivoA,paciente,SOCIO.PrioridadAt, "+;
		" ENT_DESCRIENT, entidexclu.fecpasiva as fecpasiva_Excl " + ;
		" FROM	SOCIO " + ;
		" inner JOIN MOTIVOS ON SOCIO.IdMotivo = MOTIVOS.IdMotivo " + ;
		" inner JOIN MOTIVOS as A ON SOCIO.IdMotivoA = A.IdMotivo " + ;
		" LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent " + ;
		" LEFT JOIN entidexclu On SOCIO.codentidad = entidexclu.codent And tpopac=?mTIPOPAC " + ;
		" WHERE	 SOCIO.Atendido = 1 "+ vbusco +;
		" ORDER	BY SOCIO.HoraLLegada ","mwkAtendidoA")
	If mret < 0
		Do log_errores with error(), message(), message(1), program(), lineno()
		Messagebox("No esta disponibles la lista de Atendidos - Informar a Sistemas",0+64,"Conexion")
	Else
		If fecha1 < limiteDia
			mret = SQLEXEC(mcon1," SELECT SOCIO.HoraLLegada, MOTIVOS.MotivoText, "+;
				" SOCIO.ApellidoNombre, SOCIO.Observacion, "+;
				" SOCIO.HoraAtencion, ObservaA, Horafinalizacion,"+;
				" A.MotivoText, operadora, OperadoraA,"+;
				" puestoatencion, SOCIO.IdSocio, "+;
				" MOTIVOS.IdMotivo,SOCIO.IdMotivoA,paciente,SOCIO.PrioridadAt, "+;
				" ENT_DESCRIENT, entidexclu.fecpasiva as fecpasiva_Excl " + ;
				" FROM	SOCIOHIS as SOCIO " + ;
				" inner JOIN MOTIVOS ON SOCIO.IdMotivo = MOTIVOS.IdMotivo " + ;
				" inner JOIN MOTIVOS as A ON SOCIO.IdMotivoA = A.IdMotivo " + ;
				" LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent " + ;
				" LEFT JOIN entidexclu On SOCIO.codentidad = entidexclu.codent And tpopac=?mTIPOPAC " + ;
				" WHERE	SOCIO.Atendido = 1 "+ vbusco +;
				" ORDER	BY SOCIO.HoraLLegada ","mwkAtendidoH")
			If mret < 0
				Do log_errores with error(), message(), message(1), program(), lineno()
				Messagebox("No esta disponible la lista de Atendidos - Informar a Sistemas",0+64,"Conexion")
			Else
				Select * from mwkAtendidoA;
					union;
					select * from mwkAtendidoh into cursor mwkAtendidos
			Endif
		Else

			Select * from mwkAtendidoA;
				into cursor mwkAtendidos
		Endif
	Endif
Endif
