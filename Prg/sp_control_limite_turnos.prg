*** busqueda de prestaciones con turnos
Lparameters  xmcodentag ,xmnroregistrac,xmcodprest,xmccodesp,xmlimite,xmescons ,mbusca

mrespta = 1
Select * From mwkExcEsp Where EXE_TipoExclusion = 3 And EXE_CodEspecialidad = xmccodesp ;
	AND EXE_CodEntidad = xmcodentag Into Cursor mwknolim
If Reccount('mwknolim') = 0
	Select * From mwkExcPres Where PXE_TipoExclusion = 3 And PXE_CodPrestacion = xmcodprest;
		AND PXE_CodEntidad = xmcodentag Into Cursor mwknolim
	midia = sp_busco_fecha_serv("DD")
	If Reccount('mwknolim') = 0
		fechainimes = midia -Day(midia)+1
		mret = SQLExec(mcon1, "select codesp,codprest,fechatur,codreserva  from turnos " + ;
			" where afiliado = ?xmnroregistrac and tipoturno<>1 and " + ;
			" fechatur > {fn curdate()} "+mbusca, "mwkveoturlimn")
		mret = SQLExec(mcon1, "select codesp,codprest,fechatur,codreserva  from turnos " + ;
			" where afiliado = ?xmnroregistrac and tipoturno<>1 and " + ;
			" fechatur between ?fechainimes and  {fn curdate()} "+mbusca, "mwkveoturlimv")

		If mret < 0
			Messagebox("ERROR EN LA LECTURA DE INCIDENTES DE SEGURIDAD",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif
		Select * From mwkveoturlimn Union All Select * From mwkveoturlimv Into Cursor mwkveoturlim
		If Reccount('mwkveoturlim')>0
			If xmescons = 1
				If mwkusuario.codigovax = 54035
					xmlimite =5
				Endif
				Select *,Month(fechatur) As mes From mwkveoturlim Group By codreserva,fechatur  Into Cursor mwkturmes
				Select Count(mes) As cuantos ,mes From mwkturmes GROUP BY mes Into Cursor mwkturpormes
				Select mes,Iif(mes = 1,'Enero',Iif(mes = 2,'Febrero',Iif(mes = 3,'Marzo',;
					Iif(mes = 4,'Abril',Iif(mes = 5,'Mayo',Iif(mes = 6,'Junio',;
					IIF(mes = 7,'Julio',Iif(mes = 8,'Agosto',Iif(mes = 9,'Septiembre',;
					Iif(mes = 10,'Octubre',Iif(mes = 11,'Noviembre','Diciembre'))))))))))) 	As nmes;
					From mwkturpormes Where cuantos>xmlimite Into Cursor mwknoturxmes
				If Reccount('mwknoturxmes') >0
					cmimes=''
					Select mwknoturxmes
					Scan
						cmimes = cmimes+Chr(13)+ mwknoturxmes.nmes
					Endscan
					Messagebox( "NO PUEDE DARLE TURNOS EN ESTOS MESES"+cmimes,64,"Control de limites")
					mrespta = 1
				Endif
			Else
				Select * From mwkveoturlim ;
					Where codesp Not In (Select EXE_CodEspecialidad From  mwkExcEsp Where EXE_TipoExclusion = 3 And EXE_CodEntidad = xmcodentag);
					AND  codprest  Not In (Select PXE_CodPrestacion From  mwkExcPres Where PXE_TipoExclusion = 3 And PXE_CodEntidad = xmcodentag);
					INTO Cursor mwkveoturlimite

				If Reccount('mwkveoturlimite')>xmlimite
					mrespta = 0
				Endif
			Endif
		Endif
	Endif
Endif

Return mrespta
