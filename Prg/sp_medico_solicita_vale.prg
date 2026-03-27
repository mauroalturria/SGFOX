***
** medicos solicitantes de vales ambulatorio
***

parameter mfecdes, mfechas, mbusco1, mopcion,mtipopac

mret =	sqlexec(mcon1, "select pre_codprest,pre_descriprest,pre_especialidad,Pre_retiroestudios " +;
	"from prestacions " + ;
	" ", "mwkpres")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_medico_solicita_vale1'
endif

if used('mwkinicial')
	use in mwkinicial
endif
if used('mwkvales')
	use in mwkvales
endif
if mxambito >1
	mcjoinvales = " inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "
	mbuscov  =  " and pac_codambito=?mxambito " 
else
	mbuscov  = ''
	mcjoinvales = ""
endif
mfecha = mfecdes
if mopcion<3
	for rr = 0 to mfechas-mfecdes
		mfecha = mfecdes + rr
		wait windows ("Procesando "+dtoc(mfecha)) nowait
		mret = sqlexec(mcon1,"select VAL_medicosolicit, VAL_medicosolicit->nombre, "+;
			"VAL_medicosolicit->codesp, VAL_fechasolicitud, VAL_codsector ,val_codservvale, " + ;
			"pia_codprest, pia_cantsolicitada, VAL_OperadorCarga, tabusuario.nomape," + ;
			"VAL_codvaleasist, VAL_codadmision->PAC_codhce, VAL_codadmision->PAC_nombrepaciente " + ;
			"from valesasist "+;
			" inner join presinsuvas on valesasist = pia_valesasist " +mcjoinvales + ;
			" left join tabusuario on valesasist.VAL_OperadorCarga = tabusuario.codigovax "+;
			"where VAL_fechasolicitud = ?mfecha "+mbuscov   , "mwktodo")

		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_medico_solicita_vale2'
		endif
		if used('mwkmedbus')
			select * from mwktodo,mwkpres where pre_codprest = pia_codprest and VAL_codsector = mtipopac;
				&mbusco1 and val_medicosolicit in (select id from mwkmedbus) ;
				into cursor mwktodos
		else
			select * from mwktodo,mwkpres where pre_codprest = pia_codprest and VAL_codsector = mtipopac;
				&mbusco1  into cursor mwktodos
		endif
		if used("mwkvales")
			select mwkvales
			append from dbf("mwktodos")
		else
			select * from mwktodos into cursor mwkinicial
			use dbf('mwkinicial') in 0 again alias mwkvales
		endif
	next
else
	mret = sqlexec(mcon1,"select VAL_medicosolicit, VAL_medicosolicit->nombre, "+;
		"VAL_medicosolicit->codesp, VAL_fechasolicitud, " + ;
		"pia_codprest, pia_cantsolicitada,VAL_codvaleasist, VAL_OperadorCarga,  " + ;
		"VAL_codadmision->PAC_codhce, VAL_codadmision->PAC_nombrepaciente ,TabValMedExt.codmed " + ;
		"from presinsuvas "+;
		"inner join valesasist on valesasist = pia_valesasist " + mcjoinvales +;
		" left join TabValMedExt on  TabValMedExt.nrovale = valesasist.VAL_codvaleasist "+;
		"where " + ;
		"VAL_fechasolicitud >= ?mfecdes and " + ;
		"VAL_fechasolicitud <= ?mfechas and " + ;
		"VAL_codsector = '" + mtipopac + "' "+  mbusco1+mbuscov  , "mwktodo")
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
