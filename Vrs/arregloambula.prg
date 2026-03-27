select arregloambula
scan
	mregis = NROREGISTRac
	requery('b_unif')
	if reccount('b_unif')>0
		miregis = b_unif.REG_nroregistracO
		requery('b_ambulaerror')
		update b_ambulaerror set EA_nroregistrac = miregis
		requery('b_ambuerror')
		update b_ambuerror set nroregistrac= miregis
	endif
endscan
