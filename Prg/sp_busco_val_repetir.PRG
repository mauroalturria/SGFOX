*
* Informes a Repetir
*
lparameters mOpcion, mfecdes, mfechas, mwhere

do case
	case mOpcion = 1  && Guardia
		mcwhere = " and Val_TipoPaciente = 'GUA' "
	case mOpcion = 2  && Ambulatorio
		mcwhere = " and Val_TipoPaciente = 'AMB' "
	case mOpcion = 3  && Internación
		mcwhere = " and Val_TipoPaciente = 'INT' "
	otherwise
		mcwhere = ''
endcase

mret = sqlexec(mcon1, "select " + ;
	" valesasist.VAL_codadmision, valesasist.VAL_codservvale," + ;
	" valesasist.VAL_NroProtocolo, Val_CodPun, VAL_fechasolicitud," + ;
	" Val_codValeAsist, Val_TipoPaciente, tabprotocolo.tpobserva as ver, " + ;
	" tabprotocolo.tpusuario "+;
	" from valesasist " + ;
	" join tabprotocolo on tpprotocolo = valesasist.VAL_NroProtocolo and tpestado = 7"+;
	" where VAL_fechasolicitud >= ?mfecdes and " + ;
	" VAL_fechasolicitud <= ?mfechas " + ;
	mwhere +mcwhere , "mwkValsInf")


if mret <=0
	messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	aerror(eros)
	return .f.
endif

