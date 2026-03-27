****
** busco sectores preferido
****
Parameter mabm

mfecpas = ctod('01/01/1900')

Do case
	Case  mabm = 1		&& por alta

		mret = sqlexec(mcon1, "select tabsectores.id, tabsectores.descrip, preferido, " + ;
				"codusuario, idUsuario " + ;
				"from tabsectores,tabsectorusuario " + ;
				"Inner Join tabusuario on tabusuario.ID = tabsectorusuario.codusuario " + ;
				"where preferido = 1 and " + ;
				"codsector = tabsectores.id and " + ;
				"tabsectorusuario.fecpasiva = ?mfecpas " + ;
				"order by tabsectores.descrip", "mwksectPref")
Endcase

If mret < 0
	=aerror(err)
	Messagebox('ERROR '+err(3), 16,'Validacion')
	Do prg_cancelo
Endif
