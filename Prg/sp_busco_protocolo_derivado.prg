*
* Protocolos derivados
*
Lparameters mestado,mmded,mfech,mtodos
mbusco = ''
if vartype(mtodos) # "N"
	mbusco = mbusco + " and tipoest > 0  "   &&& si no pide todos omite los de alta
	mfecomp = sp_busco_fecha_serv('DT') - 86400 && 24 hs.
	mbusco = mbusco + ' and fechahoraing >= ?mfecomp '
endif

mret = sqlexec(mcon1,"select TabGuaDeriv.*,REG_nombrepac "+;
	" from TabGuaDeriv,guardia,registracio,tabtipoaltas,Guardiaprestacion  "+;
	" where TGD_estado = ?mestado and " +;
	" protocolo = TGD_protocolo and nroregistrac = REG_nroregistrac and " +;
	" tabtipoaltas.id = codestado and " + ;
	" TGD_medDer=?mmded and TGD_fechaVer=?mfech"+;
	" and Guardiaprestacion.codprest = Guardia.codprest "+;
	" and Guardiaprestacion.codserv = 8000 " + mbusco +;
	" group by TabGuaDeriv.id ","mwkverder")

If mret < 1
	Messagebox("En BUSQUEDA DE PROFESIONALES HABILITADOS",16,"error")
Endif

