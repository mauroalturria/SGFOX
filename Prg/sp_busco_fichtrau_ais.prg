*
* Busco Ficha Traumatológica AIS
*
Lparameters mlid

mretorno = .T.
Use in select("mwkbusais")

mret = sqlexec(mcon1,"select FT_idficha,FTV_descripcion from TabFichaTrauval2"+;
" join TabFichaTrauval on TabFichaTrauval.id = TabFichaTrauval2.FT_idAis"+;
" where FT_idficha = ?mlid","mwkbusais")

If mret < 0
	Messagebox("EN CONSULTA DE AIS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	mretorno = .F.
Endif

Return mretorno