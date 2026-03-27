*****************************************************************************
* Cabecera del memo
parameters mopc,midm,mntipomod,mncargoa ,mncargos ,mncodmeda,mncodmeds,mnestado,mnnom,mnobserva ,mnreemp,mntelef;
	,mntipoabm,mntipocobro ,mntotalhs,mnvigencia ,mntipomot,mnmotivo,mncodmedr,mnmat,nsesion,npac

if vartype(mncodmedr)#"N"
	mncodmedr = 1
	mnmat = ''
endif
if vartype(nsesion)#"N"
	nsesion = 1
endif
if vartype(npac)#"N"
	npac= 0
endif
fecaudi   = sp_busco_fecha_serv('DT')
mccampo = ''
mvcampo = ''
if mxambito >1
	mccampo = ", codambito "
	mvcampo = ", ?mxambito "
	mccampoupd = ", codambito  = ?mxambito "
ENDIF
do case
	case mopc = 1
		mret = sqlexec(mcon1," select id from TabMEMemos where MEM_codmed = ?mncodmeda and MEM_fecvigend =?mfecvigend "+;
			" and MEM_fecvigenh = ?mfecvigenh and MEM_tipoABM = ?mntipoabm and MEM_tipoMod = ?mntipomod and MEM_estado = ?mnestado "+;
			" and MEM_codmedremp = ?mncodmedr and MEM_agrupa = ?nsesion and MEM_nombre = ?mnnom ","mwkexiste")
		midm = mwkexiste.id
		if reccount("mwkexiste") = 0
			mret = sqlexec(mcon1," INSERT INTO TabMEMemos( MEM_cargo , MEM_cargoSolic , MEM_codesp , MEM_codmed , "+;
				" MEM_codmedSolic , MEM_estado , MEM_fechahora , MEM_fecvigend , MEM_fecvigenh , MEM_motivo , MEM_nombre , "+;
				" MEM_observaciones , MEM_reemplazo , MEM_telefono , MEM_tipoABM , MEM_tipoCobro , "+;
				" MEM_tipoMod , MEM_tipomot , MEM_totalHoras , MEM_usuario , MEM_vigencia ,MEM_codmedremp,MEM_matricula,MEM_pacientes ,MEM_agrupa   &mccampo )" +;
				"  values (?mncargoa , ?mncargos ,?mccodesp,?mncodmeda, ?mncodmeds, ?mnestado, ?fecaudi,        " +;
				"  ?mdfecVigenD, ?mdfecVigenh, ?mnmotivo, ?mnnom, ?mnobserva , ?mnreemp, ?mntelef, ?mntipoabm ," +;
				"  ?mntipocobro , ?mntipomod, ?mntipomot, ?mntotalhs, ?midusu, ?mnvigencia ,?mncodmedr, ?mnmat ,?npac,?nsesion &mvcampo )")

			mret = sqlexec(mcon1," select id from TabMEMemos where MEM_codmed = ?mncodmeda and  "+;
				" MEM_estado = ?mnestado and  MEM_fecvigend = ?mdfecVigenD and  MEM_tipoABM = ?mntipoabm "+;
				" and MEM_usuario = ?midusu  and MEM_fechahora = ?fecaudi order by MEM_fechahora desc","mwkexiste" )
		else
			mret = sqlexec(mcon1," update TabMEMemos set MEM_cargo = ?mncargoa  ,MEM_cargoSolic = ?mncargos  ,MEM_codesp = ?mccodesp, MEM_codmed = ?mncodmeda, "+;
				" MEM_codmedSolic = ?mncodmeds, MEM_estado = ?mnestado, MEM_fechahora = ?fecaudi, MEM_fecvigend = ?mdfecVigenD, MEM_fecvigenh = ?mdfecVigenh,"+;
				" MEM_motivo = ?mnmotivo, MEM_nombre = ?mnnom, "+;
				" MEM_observaciones = ?mnobserva , MEM_reemplazo = ?mnreemp, MEM_telefono = ?mntelef, MEM_tipoABM = ?mntipoabm , MEM_tipoCobro = ?mntipocobro , "+;
				" MEM_tipoMod = ?mntipomod, MEM_tipomot = ?mntipomot, MEM_totalHoras = ?mntotalhs, MEM_usuario = ?midusu, MEM_vigencia = ?mnvigencia  "+;
				" MEM_codmedremp = ?mncodmedr, MEM_matricula = ?mnmat &mccampoupd ,MEM_pacientes = ?npac "+;
				" where id = ?midm " )
		endif
		if mret < 0
			messagebox("Los datos No se pudieron Grabar en la franja, avisar a sistemas",16, "Validacion")
			mret=0
		else
*			wait 'Los Datos Se guardaron Exitosamente!!!' window nowait timeout 120
		endif
	case mopc = 2
		mret = sqlexec(mcon1," update TabMEMemos set  MEM_estado = ?mnestado "+;
			" where id = ?midm " )
		if mncodmeda > 1
			mret = sqlexec(mcon1," INSERT INTO TabMElog( MEL_Codmed , MEL_Estado , MEL_FecHora , MEL_Idmemo , MEL_Observaciones,MEL_usuario ) "+;
				"  values (?mncodmeda, ?mnestado,?fecaudi,?midm , ?mnobserva,0 )")
		else
			mret = sqlexec(mcon1," INSERT INTO TabMElog( MEL_Codmed , MEL_Estado , MEL_FecHora , MEL_Idmemo , MEL_Observaciones,MEL_usuario ) "+;
				"  values (?mncodmeda, ?mnestado,?fecaudi,?midm , ?mnobserva,?midusu )")
		endif
	case mopc = 3 &&&actualizo total de horas
		mret = sqlexec(mcon1," select MEM_totalHoras,MEM_pacientes  from TabMEMemos where id = ?midm ","mwkexiste")
		mispac = nvl(mwkexiste.MEM_pacientes ,0)+ npac
		mishoras = nvl(mwkexiste.MEM_totalHoras,0)+ mntotalhs
		mret = sqlexec(mcon1," update TabMEMemos set  MEM_totalHoras = ?mishoras,MEM_pacientes = ?mispac "+;
			" where id = ?midm " )
	case mopc = 4 &&&actualizo total de horas
		mret = sqlexec(mcon1," update TabMEMemos set  MEM_totalHoras = ?mntotalhs "+;
			" where id = ?midm " )
	case mopc = 99 &&& Anulación
		mret = sqlexec(mcon1," update TabMEMemos set MEM_estado = 99, MEM_fechahora = ?fecaud "+;
				" where id = ?midm " )
endcase
