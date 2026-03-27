****
** busco Ultima fecha hora de actualizacion de Vales de Nutricion
****
mret = sqlexec(mcon1, "SELECT Fecha_UAct_Alim, FechaControl1 FROM TabDatos ", "mwkUfan")
if mret<1
	=aerr(eros)
	Message(eros(3))
endif
