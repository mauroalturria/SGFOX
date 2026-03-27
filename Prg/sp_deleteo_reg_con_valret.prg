parameters V_tabla, V_condic, mret
*******************

mret =sqlexec(mcon1,'DELETE FROM ' + V_tabla + ' ' + V_condic)

if mret < 0
	messagebox('NO SE PUDO REGISTRAR LA BAJA',16,'Validacion')
	mret=0
	cancel
endif
return mret
