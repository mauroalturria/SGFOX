***
*** Busqueda de usuario
***
parameter midusua, mpasswo

mfecpas = ctod('01/01/1900')
mfechoy = sp_busco_fecha_serv('DD')
mret = sqlexec(mcon1, "select * from tabusuario " + ;
	"where idusuario = ?midusua and password = ?mpasswo " + ;
	" and fecpasiva = ?mfecpas ", "mwkusuario")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion") 
	do prg_cancelo
endif	