Lparameters mOpcion, mfecDes, mBusco

*!*	 Ps_comenta, Ps_fechora, Ps_idestado, Ps_idusuario, Id

Do Case
	case mOpcion = 1 && fecha
		mret = Sqlexec(mcon1,"Select TabPases.*, " + ;
			"TabEstados.Descrip as Estado, " + ;
			"b.Descrip as Tipo " + ;
			"from TabPases " + ;
			"left Join TabEstados On TabEstados.Id = TabPases.Ps_idestado " + ;
			"left Join TabEstados b On b.Id = TabPases.Ps_idtipo " + ;
			"where ps_fechora >= ?mfecDes " + mBusco, "mwkPases")

	otherwise

endcase

If mret <= 0
	Messagebox("ERROR DE LECTURA DE PASES", 48, "VALIDACION")
	Return .f.
Endif 