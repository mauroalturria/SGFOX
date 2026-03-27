parameters mn_tabsector_id,msector

mret = sqlexec(mcon1,'Update Tabbonosector  SET sector = ?msector WHERE id = ?mn_tabsector_id' )

if mret < 0
	messagebox(' ERROR EN LA ACTUALIZACION DEL REGISTRO',16,'Validacion')
	mret = 0
	cancel	
endif