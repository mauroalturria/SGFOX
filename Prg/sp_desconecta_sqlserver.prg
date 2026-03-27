Local cError

cError = ""

* Si no está definido mconsql en SETEOS, saltamos esta parte.
IF TYPE("mconSql") = "U"
  RETURN 
ENDIF

Try
	If mconSql > 0
		=SQLDisconnect(mconSql)
	Endif
Catch To oErr
	cError = cError + [  Linea: ] + Str(oErr.Lineno) + Chr(10)

	cError = cError +[  Mensaje: ] + oErr.Message + Chr(10)

	cError = cError +[  Procedure: ] + oErr.Procedure + Chr(10)

	cError = cError +[  Detalles: ] + oErr.Details 

	Messagebox(cError,16,"Cerrar conexión SqlServer")
Finally

Endtry

mconSql = 0
