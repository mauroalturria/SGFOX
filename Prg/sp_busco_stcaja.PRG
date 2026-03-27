*!*	Caja -> Puesto
lparameters lnOpcion, lnIdPuesto, lnId, lcBusco, lcCursor

If Vartype(lcBusco)#"C"
	lcBusco = ""
Endif 	

If Vartype(lcCursor)#"C"
	lcCursor = "mwkCaja"
Endif 	

Do Case
	case lnOpcion = 1 && COMPLETO PARA GRID
		mret = sqlexec(mcon1,"select TabStCaja.*, " + ;
			"a.Descrip as Edificio, " + ;
			"b.Descrip as Rack, " + ;
			"Descripcion as Sector " + ;
			"from TabStCaja " + ;
			"Left Join TabEstados as a on a.Id = TabStCaja.Cj_idedif " + ;
			"Left Join TabEstados as b on b.Id = TabStCaja.Cj_idrack " + ;
			"Left Join Sdep on Sdep.Id = TabStCaja.Cj_IdSector " + ;
			" where 1=1 " + lcBusco , lcCursor)

*!*		case lnOpcion = 2 && UN SOLO PUESTO
*!*		
*!*			mret = sqlexec(mcon1,"select * from TabStCaja " + ;
*!*				" where CJ_IdStPuesto = ?lnIdPuesto " + lcBusco, lcCursor)

	case lnOpcion = 3 && UNA CAJA
		mret = sqlexec(mcon1,"select * from TabStCaja " + ;
			" where Id = ?lnId " + lcBusco, lcCursor)

	case lnOpcion = 4 && COMPLETO + busqueda
		mret = sqlexec(mcon1,"select * from TabStCaja " + ;
			" where 1=1 " + lcBusco, lcCursor)

otherwise

endcase
	
If mRet <= 0
	Messagebox("ERROR DE LECTURA DE CAJAS ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 
	

