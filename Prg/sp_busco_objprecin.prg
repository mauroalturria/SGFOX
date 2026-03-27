Lparameters mOpcion, mBusco, mName

If Vartype(mName)#"C"
	mName = "mwkObjPrecin"
Endif 

mFecNull = Ctod("01/01/1900")

Do Case
	case mOpcion = 1 && completo
		mret = Sqlexec(mcon1,"Select TabPaseObjPrecin.*, " + ;
			"(piso || descrip || numero) as lugar " + ;
			"from TabPaseObjPrecin  " + ;
			"Left Join TabUbicacion on TabPaseObjPrecin.OPR_idubica = TabUbicacion.Id " + ;
			"where OPR_FecPasiva = ?mFecNull " + mBusco, mName)

	otherwise

endcase

If mret <= 0
	Messagebox("ERROR DE LECTURA DE OBJETOS CON PRECINTOS", 48, "VALIDACION")
	Return .f.
Endif 


