****
** busco Ultima fecha hora de actualizacion de Vales de Guardia
****

mret = sqlexec(mcon1, "SELECT Fecha_Uval_Gua, Vale_Gua_Block  FROM TabDatos ", "mwkUfgua")
if mwkUfgua.Vale_Gua_Block = .f.
	mret = sqlexec(mcon1, "update TabDatos set Vale_Gua_Block = 1")
endif		
if mret<1
	=aerr(eros)
	Message(eros(3))
endif
