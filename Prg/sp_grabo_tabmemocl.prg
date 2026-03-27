parameters tnOpcion, tnid,tntarea

*!*	if vartype(tcWhere) # "C"
*!*		tcWhere = ' '
*!*	endif

*!*	if vartype(tcCursor) # "C"
*!*		tcCursor= 'mwkmeCL'
*!*	endif
midusunew = mwkusuario.id
mccampo = ''
mvcampo = ''
if mxambito >1
	mccampo = ", codambito "
	mvcampo = ", ?mxambito "
	mccampoupd = ", codambito  = ?mxambito "
endif
fecaudi   = sp_busco_fecha_serv('DT')
do case
	case tnOpcion = 1
		lcSql = "SELECT id from TabMEChklist "+;
			" where MEC_idmemo = ?tnid and MEC_tarea = ?tntarea"
		if !Prg_EjecutoSql(lcSql,"mwkctrcl",.f.)
			return .f.
		endif
		if reccount("mwkctrcl")=0
			lcSql = "insert into TabMEChklist "+;
				" (MEC_fechamod , MEC_idmemo , MEC_tarea , MEC_usuario &mccampo  )"+;
				" values (?fecaudi, ?tnid, ?tntarea, ?midusunew  &mvcampo )"
			if !Prg_EjecutoSql(lcSql,"",.f.)
				return .f.
			endif
		endif
	otherwise
		return .f.
endcase
