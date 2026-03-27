****
** elimino componentes de la dieta
****

parameter midpac, mbusca
if type('mbusca')#"C"
	mbusca=''
endif
mret = sqlexec(mcon1, "delete from TabNutDetalle " + ;
	" where TND_idPaciente = ?midpac " + mbusca )
If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif