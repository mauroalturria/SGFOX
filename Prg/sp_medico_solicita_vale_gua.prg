***
** medicos solicitantes de vales ambulatorio
***

parameter mfecdes, mfechas, mbusco1, mopcion,mtipopac

mret =	sqlexec(mcon1, "select pre_codprest,pre_descriprest,pre_especialidad " +;
	"from prestacions " + ;
	" ", "mwkpres")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_medico_solicita_vale1'
endif
if mfecdes = mfechas
	cfecha = " VAL_fechasolicitud = ?mfecdes and "
else
	cfecha = " VAL_fechasolicitud = ?mfecdes and  VAL_fechasolicitud <= ?mfechas and " 
endif
if mopcion<3

	mret = sqlexec(mcon1,"select VAL_medicosolicit, VAL_medicosolicit->nombre, "+;
		"VAL_medicosolicit->codesp, VAL_fechasolicitud, " + ;
		"pia_codprest, pia_cantsolicitada, VAL_OperadorCarga, tabusuario.nomape," + ;
		"VAL_codvaleasist, VAL_codadmision->PAC_codhce, VAL_codadmision->PAC_nombrepaciente " + ;
		"from valesasist, presinsuvas " + ;
		" left join tabusuario on valesasist.VAL_OperadorCarga = tabusuario.codigovax "+;
		"where valesasist = pia_valesasist and " + cfecha +;
		"VAL_codsector = '" + mtipopac +"' " + mbusco1 , "mwktodo")

	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_medico_solicita_vale2'
	endif
	select * from mwktodo,mwkpres;
		where 	pre_codprest = pia_codprest ;
		into cursor mwktodos
else
	mret = sqlexec(mcon1,"select VAL_medicosolicit, VAL_medicosolicit->nombre, "+;
		"VAL_medicosolicit->codesp, VAL_fechasolicitud, " + ;
		"pia_codprest, pia_cantsolicitada,VAL_codvaleasist, VAL_OperadorCarga,  " + ;
		"VAL_codadmision->PAC_codhce, VAL_codadmision->PAC_nombrepaciente ,TabValMedExt.codmed " + ;
		"from presinsuvas ,valesasist " + ;
		" left join TabValMedExt on  TabValMedExt.nrovale = valesasist.VAL_codvaleasist "+;
		"where valesasist = pia_valesasist and " + ;
		"VAL_fechasolicitud >= ?mfecdes and " + ;
		"VAL_fechasolicitud <= ?mfechas and " + ;
		"VAL_codsector = '" + mtipopac + "' "+ mbusco1, "mwktodo")
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_medico_solicita_vale3'
	endif
	mret = SQLExec(mcon1,"SELECT ID , nombre FROM TabMedExterno " + ;
		" where gerenciadora >0 " , "mwkMedicoExt" )
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_medico_solicita_vale4'
	endif
	select mwktodo.*,mwkpres.*,mwkMedicoExt.nombre as medexterno;
		from mwktodo left join mwkMedicoExt on mwktodo.codmed = mwkMedicoExt.id ;
		left join mwkpres on pre_codprest = pia_codprest ;
		into cursor mwktodos

endif
