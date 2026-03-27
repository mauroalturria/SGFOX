****
** grabo un movimiento cuando hay inconsistencia de datos
****

parameter mtipo,mdato,mcontrol

mdatet = sp_busco_fecha_serv('DT')
mret = sqlexec(mcon1, "insert into tabcontrol( TC_Control , TC_Dato , TC_Fecha , TC_Tipo ) " + ;
	"values(?mcontrol, ?mdato, ?mdatet , ?mtipo)")

if mret < 0
	messagebox('NO SE ACTUALIZO TABCONTROL, AVISAR A SISTEMAS', 16, 'Validacion')
	do prg_cancelo
endif
