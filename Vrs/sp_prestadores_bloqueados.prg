**** 
** Medicos bloqueados between date
****
public mcon1
do sp_conexion

	mfecpas = ctod('01/01/1900')
	mfecha	= sp_busco_fecha_serv('DD')
	
	mret = sqlexec(mcon1, "select nombre, bloquedesde, bloquehasta " + ;
 						"from prestadores " + ;
 						"where fecpasiva = ?mfecpas and " + ;
     					"bloquehasta >= ?mfecha " + ;
 						"order by nombre" , "mwkpresta")
 						
 						
copy to med_bloque xls

=sqldisconnect(mcon1) 						