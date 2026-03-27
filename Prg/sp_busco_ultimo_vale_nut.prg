****
** Busca ultimo vale en Nutricion
****
lparameters fechaant 

mret =sqlexec(mcon1, "select TND_FHoraCarga from Tabnutpaciente,TabNutDetalle "+;
	" where TNP_Fecha >= ?fechaant and Tabnutpaciente.ID = Tabnutdetalle.TND_idPaciente "+;
	" and tnp_codserv = 0 order by TND_FHoraCarga desc", "mwkdietas")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
