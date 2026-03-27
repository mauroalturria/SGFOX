*****************
* Buscar mensajes para un protocolo - medico o ambos
***************
lparameters mproto,mcmed,mestado,mtodos
mbusco = ''
if vartype(mtodos) # "N"
	mbusco = mbusco + " and tipoest > 0  "   &&& si no pide todos omite los de alta
	mfecomp = sp_busco_fecha_serv('DT') - 86400 && 24 hs.
	mbusco = mbusco + ' and fechahoraing >= ?mfecomp '
endif
If !empty(mestado)
	mbusco = mbusco + " and TGM_estado = ?mestado "
Endif
If !empty(mproto)
	mbusco = mbusco + " and TGM_protocolo = ?mproto "
Endif
If vartype(mcmed) = "N"
	mbusco = mbusco + " and TGM_codmed = ?mcmed"
Endif

mret = SQLEXEC(mcon1," select TGM_Fechah,TGM_mensaje,Tabestados.Descrip,TGM_codmed,"+;
	" TGM_estado,TGM_protocolo,TGM_usuario,REG_nombrepac,tipoest "+;
	" from TabGuaMsg,guardia,registracio,Tabestados,tabtipoaltas,Guardiaprestacion "+;
	" where  protocolo = TGM_protocolo and nroregistrac = REG_nroregistrac " +;
	" and Propietario = 2 and TGM_Estado = Estado and tabtipoaltas.id = codestado " + ;
	" and Guardiaprestacion.codprest = Guardia.codprest "+;
	" and Guardiaprestacion.codserv = 8000 " +mbusco +;
	" group by TabGuaMsg.id ","mwkprotomsg")	

If mret < 0
	Messagebox("EN BUSQUEDA DE MENSAJES"+chr(10)+"AVISE A SISTEMAS", 16, "ERROR")
Endif
