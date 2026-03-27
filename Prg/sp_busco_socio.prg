parameters tnOpcion, tcWhere, tcCursor,fecha1,fecha2

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif
if vartype(fecha1)#"D"
	fecha1 = sp_busco_fecha_serv("DD")
	fecha2 = fecha1
endif
mf1 = prg_dtoc(fecha1)
mf2 = prg_dtoc(fecha2 + 1)

if vartype(tcCursor) # "C"
	tcCursor= 'mwkLLegadas'
endif

mTIPOPAC = iif(vartype(mTIPOPAC) #"C","'INT'",mTIPOPAC)
do case
	case tnOpcion < 2
		lcSql = 'SELECT	SOCIO.HoraLLegada, MOTIVOS.MotivoText,'+;
			' SOCIO.ApellidoNombre, SOCIO.Observacion, '+;
			' SOCIO.HoraAtencion,ObservaA, Horafinalizacion,'+;
			' paciente,MOTIVOS.MotivoText, operadora, OperadoraA, '+;
			' puestoatencion,  '+;
			' SOCIO.IdSocio, MOTIVOS.IdMotivo,SOCIO.PrioridadAt, '+;
			' ENT_DESCRIENT, entidexclu.fecpasiva as fecpasiva_Excl,codentidad ' + ;
			' FROM	SOCIO ' + ;
			' inner JOIN MOTIVOS ON SOCIO.IdMotivo = MOTIVOS.IdMotivo ' + ;
			' LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent ' + ;
			' LEFT JOIN entidexclu On SOCIO.codentidad = entidexclu.codent And tpopac in ('+mTIPOPAC +')' + ;
			' WHERE	SOCIO.HoraAtencion is Null AND SOCIO.Atendido=0 '+;
			' ORDER	BY SOCIO.HoraLLegada '
		
		if !Prg_EjecutoSql(lcSql,tcCursor,.t.)
			return .f.
		endif

	case tnOpcion = 2 &&Atendidos
		mret = sqlexec(mcon1," SELECT HoraLLegada "+;
			" FROM	SOCIO where Atendido = 1 ","mwkctrldia")
		select mwkctrldia
		if reccount('mwkctrldia')>0
			calculate min(HoraLLegada) to limiteDia
		else
			limiteDia = dtot(ttod(mwkfecserv.fechahora))
		endif
		if fecha1 < fecha2
			tcWhere = tcWhere+ " AND SOCIO.HoraAtencion between ?mf1 and ?mf2 "
		else
			fecha2 = fecha1 +1
			tcWhere = tcWhere+ " AND SOCIO.HoraAtencion >= ?fecha1 and SOCIO.HoraAtencion < ?fecha2 "
		endif

		lcSql = " SELECT SOCIO.HoraLLegada, MOTIVOS.MotivoText, "+;
			" SOCIO.ApellidoNombre, SOCIO.Observacion, "+;
			" SOCIO.HoraAtencion, ObservaA, Horafinalizacion,"+;
			" A.MotivoText, operadora, OperadoraA,"+;
			" puestoatencion, SOCIO.IdSocio, "+;
			" MOTIVOS.IdMotivo,SOCIO.IdMotivoA,paciente,SOCIO.PrioridadAt, "+;
			" ENT_DESCRIENT, entidexclu.fecpasiva as fecpasiva_Excl,codentidad " + ;
			" FROM	SOCIO " + ;
			" inner JOIN MOTIVOS ON SOCIO.IdMotivo = MOTIVOS.IdMotivo " + ;
			" inner JOIN MOTIVOS as A ON SOCIO.IdMotivoA = A.IdMotivo " + ;
			" LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent " + ;
			" LEFT JOIN entidexclu On SOCIO.codentidad = entidexclu.codent And tpopac=?mTIPOPAC " + ;
			" WHERE	 SOCIO.Atendido = 1 "+ tcWhere +;
			" ORDER	BY SOCIO.HoraLLegada "
		if !Prg_EjecutoSql(lcSql,"mwkAtendidoA",.t.)
			return .f.
		endif
		if fecha1 < limiteDia
			lcSql = ' SELECT SOCIO.HoraLLegada, MOTIVOS.MotivoText, '+;
				' SOCIO.ApellidoNombre, SOCIO.Observacion, '+;
				' SOCIO.HoraAtencion, ObservaA, Horafinalizacion,'+;
				' A.MotivoText, operadora, OperadoraA,'+;
				' puestoatencion, SOCIO.IdSocio, '+;
				' MOTIVOS.IdMotivo,SOCIO.IdMotivoA,paciente,SOCIO.PrioridadAt, '+;
				' ENT_DESCRIENT, entidexclu.fecpasiva as fecpasiva_Excl,codentidad ' + ;
				' FROM	SOCIOHIS as SOCIO ' + ;
				' inner JOIN MOTIVOS ON SOCIO.IdMotivo = MOTIVOS.IdMotivo ' + ;
				' inner JOIN MOTIVOS as A ON SOCIO.IdMotivoA = A.IdMotivo ' + ;
				' LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent ' + ;
				' LEFT JOIN entidexclu On SOCIO.codentidad = entidexclu.codent And tpopac=?mTIPOPAC ' + ;
				' WHERE	SOCIO.Atendido = 1 '+ tcWhere+;
				' ORDER	BY SOCIO.HoraLLegada '
			if !Prg_EjecutoSql(lcSql,'mwkAtendidoH',.t.)
				return .f.
			endif
			select * from mwkAtendidoA;
				union;
				select * from mwkAtendidoh into cursor &tcCursor
		else

			select * from mwkAtendidoA;
				into cursor &tcCursor
		endif


	case tnOpcion = 3  && busqueda de protocolo en solic.cambio de cama
		lcSql = 'SELECT	HoraLLegada, ApellidoNombre, Observacion, '+;
			'  HoraAtencion, Horafinalizacion, '+;
			' paciente,operadora, OperadoraA, '+;
			' puestoatencion, Atendido, ENT_DESCRIENT as entidad, '+;
			' IdSocio,PrioridadAt,codentidad,ObservaA '+;
			' FROM	SOCIO ' + ;
				" LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent " + tcWhere +;
			' ORDER	BY SOCIO.HoraLLegada '

		if !Prg_EjecutoSql(lcSql,tcCursor,.t.)
			return .f.
		endif
	case tnOpcion = 4  && busqueda de protocolo por criterio

		lcSql = 'SELECT	SOCIO.HoraLLegada, MOTIVOS.MotivoText,'+;
			' SOCIO.ApellidoNombre, SOCIO.Observacion, '+;
			' SOCIO.HoraAtencion,ObservaA, Horafinalizacion,'+;
			' paciente,MOTIVOS.MotivoText, operadora, OperadoraA, '+;
			' puestoatencion,  '+;
			' SOCIO.IdSocio, MOTIVOS.IdMotivo,SOCIO.PrioridadAt, '+;
			' ENT_DESCRIENT, entidexclu.fecpasiva as fecpasiva_Excl,codentidad,CAST( HoraLLegada as date) as dia ' + ;
			' FROM	SOCIO ' + ;
			' inner JOIN MOTIVOS ON SOCIO.IdMotivo = MOTIVOS.IdMotivo ' + ;
			' LEFT JOIN ENTIDADES ON SOCIO.codentidad = ENTIDADES.ENT_codent ' + ;
			' LEFT JOIN entidexclu On SOCIO.codentidad = entidexclu.codent And tpopac in ('+mTIPOPAC +')' + ;
			 tcWhere +;
			' ORDER	BY SOCIO.HoraLLegada DESC '
		if !Prg_EjecutoSql(lcSql,tcCursor,.t.)
			return .f.
		endif

	otherwise

endcase
