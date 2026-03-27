****
** confirmacion de la confirmacion del vale de insumos guardia 
****
lparameters mapro	

	mret = sqlexec(mcon1, "update guardiavale set aprobado = ?mapro " + ;
							" where aprobado = 7 and codserv = 5410")
							
	if mret < 0
		=aerr(eros)
		messagebox(eros(2),16,'Validacion')
	endif							
	