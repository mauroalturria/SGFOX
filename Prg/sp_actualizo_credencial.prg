****
** actualizo credenciales de entidades
****

parameter  miabm, mdesc,mcod

	mret = sqlexec(mcon1, "select * from Tabcredencial "+;
		" where codent = ?mncodent and credencial= '' ","mwkveodes")
	if reccount('mwkveodes')=0
		mret = sqlexec(mcon1, "insert into Tabcredencial (codent,credencial) "+;
		" values( ?mncodent, '')")
	endif

	mret = sqlexec(mcon1, "select * from Tabcredencial "+;
		" where codent = ?mncodent and credencial= ?mdesc ","mwkveodes")
	if eof('mwkveodes')	and miabm=1
		mret = sqlexec(mcon1, "insert into Tabcredencial (codent,credencial) "+;
		" values( ?mncodent, ?mdesc)")
	else
		if miabm=1
			messagebox('EXISTE ESTA DESCRIPCION EN ARCHIVO',48,'Validacion')	
		else
			mret = sqlexec(mcon1, "update Tabcredencial set credencial= ?mdesc "+;
				" where id = ?mcod ")
		endif
	endif
if mret < 0
	=aerr(eros)
	messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	Messagebox(eros(3))
endif