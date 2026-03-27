*!* -----------------------------------------------------
*!*	 Msg de Ambulatorio para un medico
*!*	-----------------------------------------------------
lparameters mabm, mCodMed, mproto,mbus, mdesde, mhasta

if vartype(mbus) # "C"
	mbus = ''
endif
if vartype(mdesde) # "D"
	mbusco = ''
else
	mf1 = dtot(mdesde)
	if vartype(mhasta) # "D"
		mf2 = dtot(mdesde+1)
	else
		mf2 = dtot(mhasta+1)
	endif
	mbusco = " and TabAmbMsg.TAM_FechaH >= ?mf1 and TabAmbMsg.TAM_FechaH < ?mf2 "
endif
mbusco = mbusco + mbus

if vartype(mCodMed) # "N"
	mCodMed = 0
endif

do case
	case mabm = 1
		if used('mwkAmbMsgp')
			use in mwkAmbMsgp
		endif
		mret = SQLExec(mcon1,"select TabAmbMsg.Id,TabAmbMsg.TAM_FechaH,TabAmbMsg.TAM_CodMed,"+;
			"TabAmbMsg.TAM_Estado,TabAmbMsg.TAM_Mensaje,TabAmbMsg.TAM_Protocolo,TabAmbMsg.TAM_Usuario,"+;
			"TabUsuario.email,cast(TabambMsg.TAM_Usuario as INTEGER) as codigomed " + ;
			" from TabAmbMsg left join TabUsuario on TabAmbMsg.TAM_Usuario = TabUsuario.IdUsuario " + ;
			" Where TabAmbMsg.TAM_CodMed = ?mCodMed" + ;
			" and not TabAmbMsg.TAM_Protocolo like '%-%' " + mbusco + ;
			" Order by TAM_FechaH Desc","mwkAmbMsgp")
		if !used('mwkMedicosall')
			do sp_medicos_all
		endif
		select mwkAmbMsgp.id,TAM_FechaH,TAM_CodMed,TAM_Mensaje,TAM_Estado,TAM_Protocolo,;
			iif(codigomed = 0,TAM_Usuario,nombre) as TAM_Usuario,email;
			from mwkAmbMsgp left join mwkMedicosall on codigomed = mwkMedicosall.id;
			into cursor mwkAmbMsg
	case mabm = 2
		mret = SQLExec(mcon1,"select TabAmbMsg.Id,TabAmbMsg.TAM_Mensaje as msg," +;
			"b.TAM_Mensaje as Respuesta,TabAmbMsg.TAM_FechaH," +;
			"TabAmbMsg.TAM_Protocolo,TabAmbMsg.TAM_Usuario,TabAmbMsg.TAM_CodMed,"  +;
			"CAST(TabAmbMsg.TAM_Estado AS INTEGER) as TAM_Estado,TabUsuario.email" +;
			" from TabAmbMsg,TabUsuario" +;
			" Left join TabAmbMsg b on TabAmbMsg.id = b.TAM_Protocolo" +;
			" Where TabAmbMsg.TAM_Usuario = TabUsuario.IdUsuario" +;
			" and not TabAmbMsg.TAM_Protocolo like '%-%' " + mbusco + ;
			" Order by TabAmbMsg.TAM_FechaH Desc" ,"mwkAmbMsg")

	otherwise

endcase

if mret < 1
	messagebox("EN LA CONSULTA DE MENSAJES AMBULATORIO"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
endif
