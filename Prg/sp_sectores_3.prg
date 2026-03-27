****
** Sectores, para vales asistenciales
****

If used('mwksectores')
	Use in mwksectores
Endif

mret = sqlexec(mcon1, "select  NPSDescripcion as Descripcion, id, NPSSector as codigo"+;
" from npsec order by NPSDescripcion", "mwksectores")

If mret < 0
	=aerror(eros)
	Messagebox("EN CONSULTA DE SECTORES"+chr(10)+;
		eros(3)+chr(10)+;
		"AVISE A SISTEMAS", 16, "ERROR")
Endif
