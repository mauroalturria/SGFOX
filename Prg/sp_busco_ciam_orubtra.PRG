*
* Ciam busqueda de origenes, ubicacion, derivaciones, traslado
*

Lparameters mbuscar, mtipo, mdetalle

If used('mwkciambus')
	Use in mwkciambus
Endif

If vartype('mdetalle') <> "C"
	mdetalle = ''
Endif

mretorno = ''

Do case

Case mtipo < 3
	mret = sqlexec(mcon1,"select TCU_nombre as ldato from tabciamubica"+;
		" where id=?mbuscar","mwkciambus")
Case mtipo = 3
	mret = sqlexec(mcon1,"select TCV_luginterna as ldato from TabCiamEvol where TCV_idpedido = ?mbuscar"+;
		" and TCV_fechapasiva is null and TCV_aceptacion='S' order by TCV_fechaevol","mwkciambus")
Case mtipo = 4
	mret = sqlexec(mcon1,"select TCV_luginterna as ldato, TCV_fechaevol from TabCiamTras where TCV_idpedido = ?mbuscar"+;
		" and TCV_fechapasiva is null and TCV_aceptacion='S' order by TCV_fechaevol","mwkciambus")
Endcase

If mret > 0
	Select mwkciambus
	Go bottom
	mretorno = iif(left(mwkciambus.ldato,5) = 'OTROS', mdetalle, mwkciambus.ldato)

	If mtipo = 4
		mhora = left(right(ttoc(mwkciambus.TCV_fechaevol),8),5)
		mretorno = mhora + ' ' + mretorno
	Endif

Endif

Return mretorno

