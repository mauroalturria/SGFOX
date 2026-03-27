DO sp_conexion
	lcSql ="SELECT Turnos.ID, codmed, diasem, fechatur,horatur, "+;
		" hhmmTur, Turnos.tipoturno, Tabtipoturno.Abreviatura "+;
		" FROM Turnos INNER JOIN Tabtipoturno "+;
		" ON  Turnos.tipoturno = Tabtipoturno.tipoturno "+;
		" WHERE  fechatur BETWEEN '2021-09-01' AND '2021-09-30'"+;
		" AND Turnos.tipoturno  <>9 "+;
		" AND  afiliado = 0 "
		 
	If !Prg_EjecutoSql(lcSql,"mwkturno_di")
		Return .F.
	Endif

	Select nombre,PRE_especialidad, PRE_descriprest,fechatur,Transform(hhmmTur,"@L 99:99") As hora,Abreviatura ;
		,mwkturno_di.codmed,mwkturno_di.diasem, fecVigend,fecVigenH, hhmmDes, hhmmHas,codserv;
		,hhmmTur,horatur,tipoturno,PRE_codprest, pre_duracion,PRE_turnosmultip ,mwkturno_di.Id,sala ;
		From mwkmedprestDI,mwkturno_di;
		WHERE mwkmedprestDI.codmed =  mwkturno_di.codmed    ;
		AND mwkmedprestDI.diasem =  mwkturno_di.diasem And hhmmDes <=  mwkturno_di.hhmmTur ;
		AND hhmmHas>=  mwkturno_di.hhmmTur And fecVigend <=  mwkturno_di.fechatur ;
		AND fecVigenH>=  mwkturno_di.fechatur ;
		ORDER By  mwkturno_di.Id,mwkmedprestDI.codmed,mwkmedprestDI.diasem,hhmmDes, cantidad ;
		Into Cursor mwkturnopres
		SELECT * FROM mwkturnopres GROUP BY id INTO CURSOR libres
		DO sp_desconexion