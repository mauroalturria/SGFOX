
susp
*do while !eof('mwkentcont')

*	ment = mwkentcont.entidad
*	mcon = mwkentcont.contrato
*	mfal = mwkentcont.fecalta
*	mfba = iif(mwkentcont.fecbaja = { / /  }, ctod('01/01/1900'), mwkentcont.fecbaja)
	
*	mret = sqlexec(mcon1, 'insert into entidcontr1 values(?mcon, ?ment, ?mfal, ?mfba)')
	
*	skip 1 in mwkentcont

*enddo

do while !eof('mwkveo')

	ment = mwkveo.entidad
	mcon = mwkveo.contrato
	mtip = iif(isnull(mwkveo.tipo), '', mwkveo.tipo)

	mret = sqlexec(mcon1, 'update entidcontr1 set tipo = ?mtip ' + ;
							'where entidad = ?ment and contrato = ?mcon')
							
	skip 1 in mwkveo
	
enddo	