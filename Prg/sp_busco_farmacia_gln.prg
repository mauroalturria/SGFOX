*
* Busqueda GLN Proveedor
*
Lparameters mbusca, mtipo

Use in select("mwkgln")

Do case
Case mtipo = 1 && x GLN
	mret = sqlexe(mcon1,"select * from TabTraGLN where TGL_gln  = ?mbusca","mwkgln")

Case mtipo = 2 && x CUIT
	mret = sqlexe(mcon1,"select * from TabTraGLN where TGL_cuit = ?mbusca","mwkgln")

Case mtipo = 3 && x Razon Social aproximacion
	mret = sqlexe(mcon1,"select * from TabTraGLN where ucase(TGL_rsoc) like '%"+upper(mbusca)+"%'","mwkgln")

Endcase

If mret < 0
	Messagebox("Error al consultar GTIN de Producto",26,"Error")
	On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .f.
Endif

Return .T.
