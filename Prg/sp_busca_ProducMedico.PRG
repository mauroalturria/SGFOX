PARAMETERS mfechad ,mfechaH

    sqlcmd = ''
    mret = SQLExec(mcon1,"SELECT ID as CodMedT , nombre FROM TabMedExterno where gerenciadora = 0 ", "mwkMedicoExterno" )
    mret = SQLExec(mcon1,"select ID as CodMedT , nombre from prestadores ", "mwkMedicoPrest" )


	select CodMedT,nombre from mwkMedicoExterno;
		union all ;
			select CodMedT,nombre from mwkMedicoPrest;
					into cursor mwkMedicTodos
					
	mret = sqlexec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
		" fechahoraate, codestado, guardia.id, prioridad, PRE_descriprest,PRE_especialidad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,"+;
		" guardia.codent, nroregistrac,guardia.codmed,guardia.ID " + ;
		"from prestacions, entidades, especialid,registracio, afiliacion, " + ;
		"guardia  " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codent	= entidades.ENT_codent and " + ;
		" ( guardia.fechahoraate >= ?mfechad and guardia.fechahoraate <= ?mfechaH ) " , "mwkguardia")
 
	sqlcmd = " SELECT 	* FROM  mwkguardia " +;
	" left join " + IIF(mwkMedicTodos.CodMedT > 10000," mwkMedicTodos on mwkMedicTodos.CodMedT = CodMed ",+;
	" mwkMedicTodos on mwkMedicTodos.CodMedT = Codmed") +  " Into Cursor mwkProduccMedic"

	&sqlcmd
   select nombre,fechahoraate,subs(ttoc(fechahoraate,2),1,2)+ ":00" as hora ,codmed,;
   count(codmed) as cantidad from mwkProduccMedic where ttoc(fechahoraate) <> '01/01/1900 00:00:00' group by codmed,hora;
   ORDER BY nombre Into Cursor mwkProduccFinal
		
  if mret<1
   =aerr(eros)
   messagebox(eros(3))
  endif