
	mregis =  3508499
		miregis =     2896150
		requery('b_ambulaerror')
		update b_ambulaerror set EA_nroregistrac = miregis
		requery('b_ambuerror')
		update b_ambuerror set nroregistrac= miregis
*LOCATE FOR empty(reg_nroregistrac)  and id>            179777 and !inlist(nroregistrac, 1,802902,3594121,3662066,3508499)
