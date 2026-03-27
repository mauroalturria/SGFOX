*
* Busqueda de Insumos GTIN
*
Lparameters mbusca, mtipo

If vartype(mtipo) <> "N"
	mtipo = 1
Endif

Use in select("mwkgtin")

mwhere = iif(mtipo=1," TGT_gtin = "," TGT_InsCod = ") + "?mbusca"

mret = sqlexe(mcon1,"select * from TabTraGTIN where "+mwhere ,"mwkgtin")

If mret < 0
	Messagebox("Error al consultar GTIN de Producto",26,"Error")
	On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .f.
Endif

Return .T.
