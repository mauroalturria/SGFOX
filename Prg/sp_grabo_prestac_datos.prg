lparameters mpre_codprest, mpre_EdadDesde,mpre_EdadHasta, mpre_AgendaTurnos ,mPRE_Lateralidad  
if mpre_AgendaTurnos=1
	magenda = ", pre_AgendaTurnos = 'S' "
else
	magenda = ", pre_AgendaTurnos = NULL "
endif
magenda = ''
mret = sqlexec(mcon1, "Update prestacions set pre_EdadDesde = ?mpre_EdadDesde, PRE_Lateralidad = ?mPRE_Lateralidad  ,pre_EdadHasta = ?mpre_EdadHasta "+magenda + ;
	" where pre_codprest = ?mpre_codprest ")

if mret <= 0
	messagebox("Error al generar la actualización", 48, "Validación")
	canc
endif
