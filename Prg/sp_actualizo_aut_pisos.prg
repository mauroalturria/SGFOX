****
** actualizo la tabla de oaUser
****
Parameter mOpcion, mCodVax, mAutoriza

Do Case
	Case mOpcion = 1

		mret = sqlexec(mcon1, "update oaUser set Autorizaciones = ?mAutoriza " + ;
			"where CodigoVax = ?mCodVax  ")

Endcase


If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	Do prg_cancelo
endif
