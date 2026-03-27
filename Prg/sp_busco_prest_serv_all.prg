****
* Busca prestaciones por servicio
****
parameter mcodserv

if used('mwkprestserv')
	use in mwkprestserv
endif

mfecpas = ctod('01/01/1900')

mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest " + ;
	"FROM prestacions " + ;
	"where (pre_fechapasiva is null or " + ;
	"fechapasiva = ?mfecpas)  and " + ;
	"codserv = ?mcodserv " , "mwkprestserv")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "Err sp_busco_prestacion_serv"
endif
