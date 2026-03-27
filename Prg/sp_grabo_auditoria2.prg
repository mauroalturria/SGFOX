****
** Actualizo datos para auditoria
****
parameter mabm, mreg, mobs,mestado,mcondicion, lvalaut 

cupdt 	= ''
cinsd	= ''	
cinsv	= ''	
if vartype(mcondicion)= "N"
	cupdt 	= ', TPV_Condicion = ?mcondicion '
	cinsd	= ', TPV_Condicion '	
	cinsv	= ', ?mcondicion '	
endif
miusu = mwkusuario.codigovax
mfecha = sp_busco_fecha_serv("DT")
mret = sqlexec(mcon1, "select * from TabPacVip where TPV_NroReg = ?mreg ","mwkctrl")
miusufec = " ,TPV_Usuario = ?miusu, TPV_FechaMod = ?mfecha  "
if reccount("mwkctrl")>0
	miobserva = TPV_Observa 
	mret = sqlexec(mcon1, "update TabPacVip set TPV_Audit = 0, TPV_Observa = ?miobserva "+;
		miusufec + ",TPV_Estado = ?mestado &cupdt where TPV_NroReg = ?mreg ")
else
	mret = sqlexec(mcon1, "insert into TabPacVip (TPV_NroReg, TPV_Estado, TPV_Audit, "+;
		"TPV_Observa,TPV_FechaMod, TPV_Usuario &cinsd)"+;
		" values ( ?mreg, ?mestado, 0, ?mobs,?mfecha,?miusu  &cinsv )")
endif
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
