**********
* Actualizo hora de desconexion y observaciones
*********
parameters mid,mfecha,mobserva

mret = SQLEXEC(mcon1," update TabAccesoInt set horahasta = ?mfecha  "+;
	",Comentarios = ?mobserva where id = ?mid " )
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
endif





