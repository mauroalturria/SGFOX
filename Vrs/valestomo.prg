select admisiones
scan
	mcuenta = admision
	mret = sqlexec(mcon1, "select PAC_codhci ,PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision  "+;
		" FROM pacientes "+ ;
		" where  PAC_codadmision  = ?mcuenta " +;
		" ","mwkbuspacie")
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
	endif
	if reccount( "mwkbuspacie")>0
		mnroreg = PAC_codhci
		mfecadm = PAC_fechaadmision
		mfec = mfecadm - 30
		mfecalta  = nvl(PAC_fechaalta,ctod("01/01/1900"))
		select admisiones
		replace nreg with mnroreg
*!*			requery('vales_realprest')
*!*			select vales_realprest
*!*			if reccount('vales_realprest')>0
*!*				copy to array datos
*!*				select vales
*!*				append from array datos
*!*				update vales set admision = mcuenta where empty(admision)
*!*			endif
		requery('guardiasw')
		if reccount('guardiasw')>0
			select guardiasw
			copy to array datos
			select guardia
			append from array datos
			update guardia set admision = mcuenta where empty(admision) and nregis = mnroreg
			go top	
		endif
	endif
	select admisiones
endscan
