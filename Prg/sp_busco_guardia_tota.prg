Parameters mFecha11,mFecha22,estado

mestado = estado

* Actualización del 08/04/20 a pedido de M. Laino
* 42030723 Prestación de Teleconsulta
* mestado = 1 tomo prestación de Teleconsulta / = 0 excluyo Teleconsulta

mFecha1 = Datetime(Year(mFecha11),Month(mFecha11),Day(mFecha11),0,0,0)
mFecha2 = Datetime(Year(mFecha22),Month(mFecha22),Day(mFecha22),23,59,59)

If mestado = 1
	Consulta = "select Cast(fechahoraing AS DATE)As fecha, Count(guardia.id) as cuenta " + ;
		"from Guardia " +;
		"inner join guardiaprestacion on  guardia.codprest = Guardiaprestacion.codprest and Guardiaprestacion.codserv = 8000 and Guardiaprestacion.fechapasiva = '1900-01-01' " +;
		"where exists(select 1 from guardia where guardia.fechahoraing >=?mFecha1 and guardia.fechahoraing <?mFecha2) and " +;
		"guardia.fechahoraing >= ?mFecha1 and guardia.fechahoraing < ?mFecha2 " + ;
		"GROUP BY Cast(fechahoraing AS DATE)"
Else
	Consulta = "select Cast(fechahoraing AS DATE)As fecha, Count(guardia.id) as cuenta " + ;
		"from Guardia " +;
		"inner join guardiaprestacion on  guardia.codprest = Guardiaprestacion.codprest and Guardiaprestacion.codserv = 8000 and Guardiaprestacion.fechapasiva = '1900-01-01' " +;
		"where exists(select 1 from guardia where guardia.fechahoraing >=?mFecha1 and guardia.fechahoraing <?mFecha2) and " +;
		"guardia.fechahoraing >= ?mFecha1 and guardia.fechahoraing < ?mFecha2 " + ;
		"and guardia.codprest <> 42030723 " +;
		"GROUP BY Cast(fechahoraing AS DATE)"
Endif

* Consulta para estimar por entidades
*!*	mret = SQLExec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient, " + ;
*!*		"guardia.id " + ;
*!*		"from Guardiaprestacion, entidades,  registracio, afiliacion," + ;
*!*		"guardia  " + ;
*!*		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
*!*		"guardia.nroregistrac = afiliacion.registracio and " + ;
*!*		"guardia.codent = afiliacion.AFI_codentidad and " + ;
*!*		"guardia.codprest = Guardiaprestacion.codprest  and " + ;
*!*		"guardia.codent	= entidades.ENT_codent and " + ;
*!*		"guardia.fechahoraing >=?mfecha1 and guardia.fechahoraing <?mfecha2 and Guardiaprestacion.codserv = 8000 " + ;
*!*		"", "mwkGuardiaTot")

mret = SQLExec(mcon1,Consulta,"mwkGuardiaTotal")

If mret < 1
	Messagebox("No se pudo realizar la consulta en Guardias",16,"Error")
Endif

*!*	Select Ttod(mwkGuardiaTot.fechahoraing) As fecha, Count(*) As cuenta From mwkGuardiaTot Group By fecha Into Cursor mwkGuardiaTotal

*!*	Use In mwkGuardiaTot
