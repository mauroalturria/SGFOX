*
* Busqueda de protocolos politraumatizados
*
Parameters mdesde, mhasta

If used("mwkprotpoli")
	Use in mwkprotpoli
Endif

If used("mwkprotpol")
	Use in mwkprotpol
Endif

mret = sqlexec(mcon1,"SELECT Guardia.codprest, Tabguaevol.EG_motConsulta,"+;
	" Tabguaevolmed.EGM_codmed,Tabguaevolmed.EGM_evol, Guardia.protocolo,"+;
	" Guardia.fechahoraing,Guardia.nroregistrac,REGISTRACIO.REG_nombrepac"+;
	" FROM TabGuaEvol, Guardia, Tabguaevolmed"+;
	" join REGISTRACIO on REG_nroregistrac = Guardia.nroregistrac "+;
	" WHERE Guardia.protocolo = Tabguaevol.EG_protocolo"+;
	" AND Tabguaevol.EG_protocolo = Tabguaevolmed.EGM_proto"+;
	" AND (Guardia.fechahoraing >= ?mdesde AND Guardia.fechahoraing <= ?mhasta"+;
	" AND Guardia.codprest = 42030723)"+;
	" AND Guardia.protocolo not in (select FT_protocolo from TabFichaTraumatologica)","mwkprotpoli")

If mret < 0
	=aerror(merror)
	Messagebox("EN CONSULTA DE PROTOCOLOS POLITRAUMATIZADOS"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	Return
Endif

mret = sqlexec(mcon1,"SELECT id, nombre,codesp,codespe,cast(matriculas as integer) as matricula  FROM prestadores  " + ;
	" union  SELECT ID , nombre,'    ' as codesp,gerenciadora  as codespe,matricula  FROM TabMedExterno " + ;
	" where gerenciadora = 0" +;
	" ORDER BY nombre", "mwkMedicogua" )

If mret > 0
	Select protocolo from mwkprotpoli ;
		where (at('TRAUMA',upper(egm_evol))>0 or at('TRAUMA',upper(eg_motconsulta))>0);
		order by protocolo;
		into cursor mwkproto 
	Select protocolo,REG_nombrepac,fechahoraing,mwkMedicogua.nombre,egm_evol,eg_motconsulta ;
		from mwkprotpoli ;
		join mwkMedicogua on mwkMedicogua.id = EGM_codmed ;
		where protocolo in( select protocolo from mwkproto );
		order by protocolo;
		into cursor mwkprotpol
Else
	=aerror(merror)
	Messagebox("EN CONSULTA MEDICOS DE GUARDIA/REEMPLAZANTES"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
Endif
