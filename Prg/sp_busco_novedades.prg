Parameters mOpcion, mid, mfechades, mfechahas

Do Case
	Case mOpcion = 1
		mret = sqlexec(mcon1, "Select TabGuaNov.NOV_fecha, " + ;
			"Tabusuario.nomape, TabEstados.Descrip, TabGuaNov.NOV_Detalle, TabGuaNov.Id " + ;
			"from TabGuaNov "+;
			"Inner Join Tabusuario On Tabusuario.codigovax = NOV_CodMed " + ;
			"Inner Join TabEstados On TabEstados.Id   = NOV_Tipo " + ;
			"Where NOV_fecha >= ?mFechades and NOV_fecha < ?mFechahas " + ;
			"","mwkGuaNov")
			
	Case mOpcion = 2
		mret = sqlexec(mcon1, "Select TabGuaNov.* " + ;
			"from TabGuaNov "+;
			"Where TabGuaNov.ID = ?mid " + ;
			"","mwkGuaNov")
	
EndCase 
								
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR",48,"VALIDACION")
	Canc
endif					