parameters mn_tabsector_id

mret = sqlexec(mcon1,'Update Tabbonosector  SET sector = 5 WHERE id = ?mn_tabsector_id' )

if mret < 0
	messagebox(' ERROR EN LA ACTUALIZACION DEL REGISTRO',16,'Validacion')
	mret = 0
	cancel	
endif