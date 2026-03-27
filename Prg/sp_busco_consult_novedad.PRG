Lparameters mIdPase

mfecnull = Ctod("01/01/1900")

mret = SQLExec(mcon1,"select TabApaUbica.* " + ;
	"from TabApaUbica " + ;
	"where TabApaUbica.TAU_Idpase = ?mIdPase and TAU_idapa > 0 " + ;
	"and TAU_FPasiva = ?mfecnull and TAU_averiado = 1 ","mwkubinov")

If mret =< 0
	Messagebox("ERROR DE LECTURA DE CONSULTORIOS CON NOVEDADES",48,"VALIDACION")
	Return .F.
Endif