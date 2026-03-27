* Armo Calendario
Parameters anio,mes,ndia



*anio = 2018
*mes = 5

Use In Select("calendario")

Create Cursor calendario (nroweek N(2), clunes N(2), cmartes N(2), cmiercoles N(2), cjueves N(2), cviernes N(2), csabado N(2), cdomingo N(2),;
	cmes N(2), estado N(1), edom N(1), elun N(1), emar N(1), emie N(1), ejue N(1), evie N(1), esab N(1),;
	dlunes d, dmartes d, dmiercoles d, djueves d, dviernes d, dsabado d, ddomingo d)

Set Date Dmy

For semanas = 1 To 53
	Insert Into calendario (nroweek) Values (semanas)
Endfor



*!*	FOR mes = 1 TO 12
If mes < 12
	ultimodia = Day(Datetime(anio,mes+1,1)-1)
Else
	ultimodia = 31
	mes = 12
Endif


For dia = 1 To ultimodia
	fecha = Ctod(Alltrim(Str(dia))+"/"+Alltrim(Str(mes))+"/"+Alltrim(Str(anio)))
	almanaque = Dow(fecha)

	semana = Week(fecha)

	If mes = 12 And semana = 1
		semana = 53
	Endif



*!*	If dia = 1
*!*	thisform.rellenodias(dia,fecha,semana)
*!*	Endif


	Do Case
	Case almanaque = 2
		Update calendario Set clunes = dia, cmes = mes, estado = 1, elun = 1, dlunes = fecha Where nroweek = semana
	Case almanaque = 3
		Update calendario Set cmartes = dia, cmes = mes, estado = 1, emar = 1, dmartes = fecha Where nroweek = semana
	Case almanaque = 4
		Update calendario Set cmiercoles = dia, cmes = mes, estado = 1, emie = 1, dmiercoles = fecha Where nroweek = semana
	Case almanaque = 5
		Update calendario Set cjueves = dia, cmes = mes, estado = 1, ejue = 1, djueves = fecha Where nroweek = semana
	Case almanaque = 6
		Update calendario Set cviernes = dia, cmes = mes, estado = 1, evie = 1, dviernes = fecha Where nroweek = semana
	Case almanaque = 7
		Update calendario Set csabado = dia, cmes = mes, estado = 1, esab = 1, dsabado = fecha Where nroweek = semana
	Case almanaque = 1
		Update calendario Set cdomingo = dia, cmes = mes, estado = 1, edom = 1, ddomingo = fecha Where nroweek = semana
	Endcase

Endfor

****** RELLENO DIAS *******


* Días anteriores

If ndia < 7

fecha = Date(anio,mes,ndia)

dia = Dow(fecha)
semana = Week(fecha)

diaa = Date(Year(fecha),Month(fecha),Day(fecha))-1
diab = Date(Year(fecha),Month(fecha),Day(fecha))-2
diac = Date(Year(fecha),Month(fecha),Day(fecha))-3
diad = Date(Year(fecha),Month(fecha),Day(fecha))-4
diae = Date(Year(fecha),Month(fecha),Day(fecha))-5
diaf = Date(Year(fecha),Month(fecha),Day(fecha))-6

Do Case
Case dia = 2
	Update calendario Set cdomingo = Day(diaa), estado = 0, elun = 0, ddomingo = diaa Where nroweek = semana
Case dia = 3
	Update calendario Set clunes = Day(diaa), estado = 0, elun = 0, dlunes = diaa Where nroweek = semana
	Update calendario Set cdomingo = Day(diab), estado = 0, edom = 0, ddomingo = diab Where nroweek = semana
Case dia = 4
	Update calendario Set cmartes = Day(diaa), estado = 0, elun = 0, dmartes = diaa Where nroweek = semana
	Update calendario Set clunes = Day(diab), estado = 0, emar = 0, dlunes = diab Where nroweek = semana
	Update calendario Set cdomingo = Day(diac), estado = 0, edom = 0, ddomingo = diac Where nroweek = semana
Case dia = 5
	Update calendario Set cmiercoles = Day(diaa), estado = 0, emie = 0, dmiercoles = diaa Where nroweek = semana
	Update calendario Set cmartes = Day(diab), estado = 0, emar = 0, dmartes = diab Where nroweek = semana
	Update calendario Set clunes = Day(diac), estado = 0, elun = 0, dlunes = diac Where nroweek = semana
	Update calendario Set cdomingo = Day(diad), estado = 0, edom = 0, ddomingo = diad Where nroweek = semana
Case dia = 6
	Update calendario Set cjueves = Day(diaa), estado = 0, ejue = 0, djueves = diaa Where nroweek = semana
	Update calendario Set cmiercoles = Day(diab), estado = 0, emie = 0, dmiercoles = diab Where nroweek = semana
	Update calendario Set cmartes = Day(diac), estado = 0, emar = 0, dmartes = diac Where nroweek = semana
	Update calendario Set clunes = Day(diad), estado = 0, elun = 0, dlunes = diad Where nroweek = semana
	Update calendario Set cdomingo = Day(diae), estado = 0, edom = 0, ddomingo = diae Where nroweek = semana
Case dia = 7
	Update calendario Set cviernes = Day(diaa), estado = 0, evie = 0, dviernes = diaa Where nroweek = semana
	Update calendario Set cjueves = Day(diab), estado = 0, ejue = 0, djueves = diab Where nroweek = semana
	Update calendario Set cmiercoles = Day(diac), estado = 0, emie = 0, dmiercoles = diac Where nroweek = semana
	Update calendario Set cmartes = Day(diad), estado = 0, emar = 0, dmartes = diad Where nroweek = semana
	Update calendario Set clunes = Day(diae), estado = 0, elun = 0, dlunes = diae Where nroweek = semana
	Update calendario Set cdomingo = Day(diaf), estado = 0, edom = 0, ddomingo = diaf Where nroweek = semana
Endcase

Endif


* Próximos días

If Month(fecha)<12
*fechaudia = Date(Year(fecha),Month(fecha)+1,Day(fecha))-1
	fechaudia = Date(Year(fecha),Month(fecha)+1,1)-1
Else
	fechaudia = Date(Year(fecha)+1,1,1)-1
Endif

udia = Day(fechaudia)
mes = Month(fecha)
anio = Year(fecha)

*!*	diaa = Day(Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+1)
*!*	diab = Day(Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+2)
*!*	diac = Day(Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+3)
*!*	diad = Day(Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+4)
*!*	diae = Day(Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+5)
*!*	diaf = Day(Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+6)

diaa = Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+1
diab = Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+2
diac = Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+3
diad = Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+4
diae = Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+5
diaf = Date(Year(fechaudia),Month(fechaudia),Day(fechaudia))+6


ldia = Dow(fechaudia)

semana = Week(fechaudia)

If mes = 12 And semana = 1
	semana = 53
Endif


Do Case
Case ldia = 6
	Update calendario Set csabado = Day(diaa), estado = 0, edom = 0, dsabado = diaa Where nroweek = semana
Case ldia = 5
	Update calendario Set csabado = Day(diab), estado = 0, edom = 0, dsabado = diab Where nroweek = semana
	Update calendario Set cviernes = Day(diaa), estado = 0, evie = 0, dviernes = diaa Where nroweek = semana
Case ldia = 4
	Update calendario Set csabado = Day(diac), estado = 0, edom = 0, dsabado = diac Where nroweek = semana
	Update calendario Set cviernes = Day(diab), estado = 0, evie = 0, dviernes = diab Where nroweek = semana
	Update calendario Set cjueves = Day(diaa), estado = 0, ejue = 0, djueves = diac Where nroweek = semana
Case ldia = 3
	Update calendario Set csabado = Day(diad), estado = 0, edom = 0, dsabado = diad Where nroweek = semana
	Update calendario Set cviernes = Day(diac), estado = 0, evie = 0, dviernes = diac Where nroweek = semana
	Update calendario Set cjueves = Day(diab), estado = 0, ejue = 0, djueves = diab Where nroweek = semana
	Update calendario Set cmiercoles = Day(diaa), estado = 0, emie = 0, dmiercoles = diaa Where nroweek = semana
Case ldia = 2
	Update calendario Set csabado = Day(diae), estado = 0, edom = 0, dsabado = diae Where nroweek = semana
	Update calendario Set cviernes = Day(diad), estado = 0, evie = 0, dviernes = diad Where nroweek = semana
	Update calendario Set cjueves = Day(diac), estado = 0, ejue = 0, djueves = diac Where nroweek = semana
	Update calendario Set cmiercoles = Day(diab), estado = 0, emie = 0, dmiercoles = diab Where nroweek = semana
	Update calendario Set cmartes = Day(diaa), estado = 0, emar = 0, dmartes = diaa Where nroweek = semana
Case ldia = 1
	Update calendario Set csabado = Day(diaf), estado = 0, edom = 0, dsabado = diaf Where nroweek = semana
	Update calendario Set cviernes = Day(diae), estado = 0, evie = 0, dviernes = diae Where nroweek = semana
	Update calendario Set cjueves = Day(diad), estado = 0, ejue = 0, djueves = diad Where nroweek = semana
	Update calendario Set cmiercoles = Day(diac), estado = 0, emie = 0, dmiercoles = diac Where nroweek = semana
	Update calendario Set cmartes = Day(diab), estado = 0, emar = 0, dmartes = diab Where nroweek = semana
	Update calendario Set clunes = Day(diaa), estado = 0, elun = 0, dlunes = diaa Where nroweek = semana
Endcase