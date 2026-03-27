*
* Buscar mensajes para un protocolo - medico o ambos
*
Lparameters mproto,mcmed,mestado,mtodos 
mbusco = ''

If vartype(mtodos) # "N"
*	mbusco  = mbusco + " and tipoest > 0  "   &&& si no pide todos omite los de alta
	mbusco  = mbusco + " and TAM_estado > 0  "   &&& si no pide todos omite los de alta	
	mfecomp = sp_busco_fecha_serv('DT') - 86400 && 24 hs.
	mbusco  = mbusco + ' and TAM_Fechah >= ?mfecomp '
Endif

If !empty(mestado)
	mbusco = mbusco + " and TAM_estado = ?mestado "
Endif
If !empty(mproto)
	mbusco = mbusco + " and TAM_protocolo = ?mproto "
Endif
If vartype(mcmed) = "N"
	mbusco = mbusco + " and TAM_codmed = ?mcmed"
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 

mret = SQLEXEC(mcon1," select TAM_Fechah,TAM_mensaje,Tabestados.Descrip,TAM_codmed," +;
	"TAM_estado,TAM_protocolo,TAM_usuario,REG_nombrepac,TabAmbulatorio.codestado, tipoest " + ;
	" from TabAmbMsg,TabAmbulatorio,Registracio,Tabestados, tabtipoaltas" +;
	" where TabAmbulatorio.protocolo = TabAmbMsg.TAM_protocolo" +;
	" and TabAmbulatorio.nroregistrac = Registracio.REG_nroregistrac" +;
	" and Tabestados.Propietario = 2 and TabAmbMsg.TAM_Estado = Tabestados.Estado " + ;
	" and tabtipoaltas.id = codestado " + mbusco + mccpoamb   +;
	" group by TabAmbMsg.id","mwkprotomsg")


If mret < 0
	Messagebox("EN BUSQUEDA DE MENSAJES"+chr(10)+;
	"AVISE A SISTEMAS", 16, "ERROR")
Endif
