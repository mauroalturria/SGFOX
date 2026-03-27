do sp_conexion

mfecha1 = ctod('01/01/1900')
mfecha = date()
mret = sqlexec(mcon1, "select * " +  ;
	"from prestadores " + ;
	"where fecpasivap = ?mfecha1 and (dguardia =1 and (fecpasivag = ?mfecha1 or fecpasivag>=?mfecha)) " + ;
	" or (dambula =1 and (fecpasiva = ?mfecha1 or fecpasiva>=?mfecha)) " + ;
	" " , "mwktodosc")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
	
endif	
=sqldisconnect(mcon1)
