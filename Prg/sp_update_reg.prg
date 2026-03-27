parameters v_campo, v_tab, v_condic

mret = sqlexec(mcon1,'Update ' + v_tab + ' SET ' + v_campo + v_condic )

if mret < 0
	messagebox(' ERROR EN LA ACTUALIZACION DEL REGISTRO',16,'Validacion')
	mret = 0
	cancel	
endif