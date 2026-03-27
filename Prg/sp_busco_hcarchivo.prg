****
** Busco codigo de barra 
****

parameter  mnregistrac

	mret= sqlexec(mcon1," select * from TabHCArchivo where hca_registrac = ?mnregistrac", "mwkhcarchivo" )

	if mret < 0
		messagebox('NO SE ENCONTRO. REINTENTE', 16, 'Validacion')
		mret = 0
	endif