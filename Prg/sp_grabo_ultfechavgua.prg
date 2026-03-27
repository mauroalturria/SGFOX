****
** grabo Ultima fecha hora de actualizacion de Vales de Guardia
****
lparameters mfecha
if vartype(mfecha)="T"
	mret = sqlexec(mcon1, "update TabDatos set Fecha_Uval_Gua = ?mfecha,Vale_Gua_Block = 0")
else
	mret = sqlexec(mcon1, "update TabDatos set Vale_Gua_Block = 0")
endif

if mret<1
	=aerr(eros)
	Message(eros(3))
endif
