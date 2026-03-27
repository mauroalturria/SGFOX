Lparameters mIdObj

mFecHoy = sp_busco_fecha_serv('DT')

mret = Sqlexec(mcon1,"Update TabPaseobjprecin Set " + ;
	"Opr_FecPasiva = ?mFecHoy " + ;
	"Where Id = ?mIdObj ")

If mret <= 0
	Messagebox("ERROR DE LECTURA DE OBJETOS CON PRECINTOS", 48, "VALIDACION")
	Return .f.
Endif 


