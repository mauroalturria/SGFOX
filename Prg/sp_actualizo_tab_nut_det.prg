****
** Actualizo Datos de Alimentacion
****
lparameters nopcion, mid, mpresta, mvale,mfechacarga,mobserva,mcant,mhora
if type('mcant')#"N"
	mcant = 1
endif
if type('mhora')#"N"
	mfhora = sp_busco_fecha_serv('DT')
	mhora = hour(mfhora)*100 + minute(mfhora)
endif

mfechanull = ctot("01/01/1900")
if nopcion = 1  &&&  alta o modificacion
	mret =sqlexec(mcon1, "insert into TabNutDetalle "+;
		"( TND_idPaciente,TND_codPrest,TND_NroVale,TND_FHoraCarga"+;
		",TND_observa, TND_fecbaja,TND_Cantidad,TND_hora )"+;
		" values (?mid, ?mpresta, ?mvale, ?mfechacarga, ?mobserva,?mfechanull, ?mcant,?mhora  )")
	if mret<1
		=aerr(eros)
		messagebox(eros(3))
	endif

endif