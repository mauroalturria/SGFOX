****
** actualizo ingredientes no compatibles con dietas
****

parameter  miabm, mdesc,magrup

	do sp_veo_descri with mcon1,'TabNutAgr','TNA_Descripcion',mdesc
	if eof('mwkveodes')	and miabm=1
		select mwkTNagr 
		calculate max(TNA_CodAgr) to mcod
		mcod = mcod+1
		mret = sqlexec(mcon1, "insert into TabNutAgr (TNA_Descripcion, TNA_CodAgr ) "+;
		" values( ?mdesc, ?mcod)")
	else
		if miabm=1
			messagebox('EXISTE ESTA DESCRIPCION EN ARCHIVO',48,'Validacion')	
		else
			mret = sqlexec(mcon1, "update TabNutAgr set TNA_Descripcion=?mdesc "+;
			"  where TNA_CodAgr = ?magrup ")
		endif
	endif
if mret < 0
	=aerr(eros)
	messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	Messagebox(eros(3))
	mret = 0
endif