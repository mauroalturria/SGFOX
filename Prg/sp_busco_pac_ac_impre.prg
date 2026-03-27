*
* Alta Complejidad Ambulatorio
*
Lparameters mprotocolo, mlprestador,mtipopac

Use In Select("mwkdatimp")
If Vartype(mtipopac)#"C"
	mtipopac ="AMB"
Endif
mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif
IF mtipopac ="AMB"
	mret = SQLExec(mcon1,"select registracio.REG_nombrepac, registracio.reg_nrohclinica,entidades.ENT_descrient,ENT_nroprestadorexterno, TabAmbulatorio.protocolo,"+;
		" Registracio.REG_nroregistrac,Afiliacion.AFI_nroafiliado,REG_telefonos " + ;
		"from TabAmbulatorio "+;
		" join registracio on REG_nroregistrac = TabAmbulatorio.nroregistrac "+;
		" join entidades on ent_codent = TabAmbulatorio.codent "+;
		" join AFILIACION on (AFILIACION.registracio = Registracio.REG_nroregistrac "+;
		"and AFILIACION.AFI_codentidad = TabAmbulatorio.codent) "+;
		" where TabAmbulatorio.protocolo = ?mprotocolo "+ mccpoamb +;
		" group by REG_nroregistrac","mwkdatimp")
ELSE
	mret = SQLExec(mcon1,"select registracio.REG_nombrepac, registracio.reg_nrohclinica,entidades.ENT_descrient,ENT_nroprestadorexterno, guardia.protocolo,"+;
		" Registracio.REG_nroregistrac,Afiliacion.AFI_nroafiliado,REG_telefonos " + ;
		"from guardia "+;
		" join registracio on REG_nroregistrac = guardia.nroregistrac "+;
		" join entidades on ent_codent = guardia.codent "+;
		" join AFILIACION on (AFILIACION.registracio = Registracio.REG_nroregistrac "+;
		"and AFILIACION.AFI_codentidad = guardia.codent) "+;
		" where guardia.protocolo = ?mprotocolo "+ mccpoamb +;
		" group by REG_nroregistrac","mwkdatimp")

endif
If mret <= 0
	Messagebox("CONSULTA DATOS DEL PACIENTE",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Use In Select("mwkpredat")

mret = SQLExec(mcon1,"select prestadores.nombre,prestadores.matriculas,tabusuario.codigovax "+;
	" from prestadores left join tabusuario on prestadores.id = tabusuario.idcodmed "+;
	" Where prestadores.id = ?mlprestador","mwkpredat")

If mret <= 0
	Messagebox("CONSULTA DATOS DEL PROFESIONAL",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif


Return .T.
