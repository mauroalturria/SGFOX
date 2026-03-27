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
do case
	case mabm = 0
		mret = sqlexec(mcon1, "select * from TabPacVip where TPV_NroReg = ?mreg ","mwkctrl")
		miusufec = iif(vartype(mestado) # "N",', TPV_FechaMod = ?mfecha  '," ,TPV_Usuario = ?miusu, TPV_FechaMod = ?mfecha  ")
		mestado = iif(vartype(mestado) # "N",nvl(mwkctrl.TPV_Estado,0),mestado)
		if reccount("mwkctrl")>0
			miobserva = iif(mobs="*",TPV_Observa ,mobs)
			mret = sqlexec(mcon1, "update TabPacVip set TPV_Audit = 1, TPV_Observa = ?miobserva,TPV_FechaMod = ?mfecha "+;
				miusufec + ",TPV_Estado = ?mestado &cupdt where TPV_NroReg = ?mreg ")
		else
			mret = sqlexec(mcon1, "insert into TabPacVip (TPV_NroReg, TPV_Estado, TPV_Audit, "+;
				"TPV_Observa,TPV_FechaMod, TPV_Usuario &cinsd)"+;
				" values ( ?mreg, ?mestado, 1, ?mobs,?mfecha,?miusu  &cinsv )")
&&TPV_FechaMod, TPV_Usuario ,?mfecha,?miusu
		endif
	case mabm = 1
		mestado = iif(vartype(mestado) # "N",0,mestado)
		mret = sqlexec(mcon1, "insert into TabPacVip (TPV_NroReg, TPV_Estado, TPV_Audit, "+;
			"TPV_Observa ,TPV_FechaMod,TPV_Usuario  &cinsd )"+;
			" values ( ?mreg, 0, 1, ?mobs,?mfecha,?miusu &cinsv )")
&&TPV_FechaMod,,TPV_Usuario   ?mfecha,,?miusu
	case mabm = 2    &&saca señal de auditoria
		mret = sqlexec(mcon1, "update TabPacVip set TPV_Audit = 0 where TPV_NroReg = ?mreg ")
endcase
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
