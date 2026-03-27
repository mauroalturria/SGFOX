select vale_proto
scan
	mcodadmision = val_codadmision
	mproto = val_nroprotocolo
	wait windows transf(recno()) nowait
	mfecha = ctot(dtoc(val_fechasolicitud)+" " +strtran(val_horasolicitud,".",":"))
	requery('pacienteshci')
	mhci = pacienteshci.pac_codhci
	requery('tabprotocolo')
	if reccount('tabprotocolo')=0

		insert into Tabprotocolo (tpestado, tpfecharetiro,tpobserva, tpprotocolo,tpregistrac, tpusuario);
			values (2,mfecha,'SIST',mproto,mhci,"CFUNES")
	endif
endscan
