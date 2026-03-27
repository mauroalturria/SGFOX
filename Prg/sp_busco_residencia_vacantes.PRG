*
* Vacantes de residencias
*
mret = sqlexec(mcon1,"select TRV_especialidad,TRV_vacantes,* from TabResVac"+;
	" where TRV_anio=?mranio and TRV_evento=?mreven","mwkvacantes")
