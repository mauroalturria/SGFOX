parameters V_tabla, V_condic
*******************

mret =sqlexec(mcon1,'DELETE FROM TabbonoAsig WHERE id = ?mn_tabsector_id ')

if mret < 0
	messagebox('NO SE PUDO REGISTRAR LA BAJA',16,'Validacion')
	mret=0
	do prg_cancelo
endif