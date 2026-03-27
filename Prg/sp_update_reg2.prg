parameters mcaja

mret = sqlexec(mcon1,'Update TabHCICajas  SET Cerrada = 1 WHERE id = ?mcaja '  )

if mret < 0
	messagebox(' ERROR EN LA ACTUALIZACION DEL REGISTRO',16,'Validacion')
	mret = 0
	cancel	
endif