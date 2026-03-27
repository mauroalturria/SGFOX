****
** busco Credenciales por entidad
****

parameter mbusca
if empty(mbusca)
	cbusca = ''
else
	cbusca = " and credencial = ?mbusca "
endif
mret = sqlexec(mcon1,"select ID , codent , fpasiva , credencial from TabCredencial " + ;
	" where codent=?mncodent " + cbusca +;
	" order by credencial "  , "mwkTcred")
if mret<1
	=aerr(eros)
*	messagebox(eros(3))
endif