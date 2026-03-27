****
** desconfirmacion del vale de insumos guardia
****

parameter mprotocolo

	mfmod = ctod("01/01/1900")
	musu  = mwkusuario.codigovax

	delete from confarma where protocolo = mprotocolo 

	&& ver como queda esto && ---------------------------------------
	Set Deleted Off 
	Update confarma Set ulti = .f. where Protocolo = mprotocolo And ulti = .t.
	Set Deleted on
	&& ver como queda esto && ---------------------------------------
	
	
	mret = sqlexec(mcon1, "update guardiavale set aprobado = 0, " + ;
							" usuario = ?musu, fechamodif = ?mfmod " + ;
							" where protocolo = ?mprotocolo and codserv = 5410")
							
							
	if mret < 0
		messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS',16,'Validacion')
		DO sp_desconexion WITH "sp_desconfirmo_vales_insumo_guardia"
		cancel
	endif							