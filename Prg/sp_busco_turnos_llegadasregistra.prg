Lparameters lfecha, lcLetras, lopcion

Do Case

Case lopcion = 1

	lcsql = "SELECT REG_nombrepac, TNL_FechaHoraIng, horatur, TNL_numdocumento, "+;
		" {fn TIMESTAMPDIFF(SQL_TSI_MINUTE, TNL_FechaHoraIng, horatur)} AS DIFE, TNL_TIPO, " + ;
		"TNL_Numerador, TabTurneroLog.id as idtl, ENT_descrient, SER_descripserv, ESP_descripcion,preregistra   "+;
		" FROM TabTurneroLog "+;
		" LEFT JOIN REGISTRACIO ON REGISTRACIO.REG_numdocumento = TabTurneroLog.TNL_numdocumento "+;
		" INNER JOIN Turnos ON Turnos.afiliado = REGISTRACIO.REG_nroregistrac AND TURNOS.fechatur = ?lfecha AND CONFIRMADO = 0 "+;
		" INNER JOIN Entidades ON Turnos.CodEnt = Entidades.Ent_CodEnt "+;
		" INNER JOIN PRESTACIONS ON Turnos.CodPrest = PRESTACIONS.Pre_CodPrest "+;
		" INNER JOIN SERVICIOS ON PRE_codservicio = SER_codserv "+;
		" INNER JOIN ESPECIALID ON PRE_especialidad = ESP_codesp "+;
		" WHERE TNL_IdLlama IS NULL AND TNL_TIPO in ( " + lcLetras + ") AND TNL_numdocumento > 0 AND NVL(REG_nroregistrac,0) > 0 "+;
		" and TNL_CodigoVax is null and preregistra = 0" + ;
		" ORDER BY DIFE ASC"

	If !PRG_EJECUTOSQL(lcsql,"mwkturnpacretardo1")
		Return .F.
	Endif

Case lopcion = 2

	lcsql = "SELECT nombre as REG_nombrepac, TNL_FechaHoraIng, horatur, TNL_numdocumento, "+;
		" {fn TIMESTAMPDIFF(SQL_TSI_MINUTE, TNL_FechaHoraIng, horatur)} AS DIFE, TNL_TIPO, " + ;
		"TNL_Numerador, TabTurneroLog.id as idtl, ENT_descrient, SER_descripserv, ESP_descripcion,preregistra   "+;
		" FROM TabTurneroLog "+;
		" LEFT JOIN  PREREGISTRA ON PREREGISTRA.nrodocumento = TabTurneroLog.TNL_numdocumento "+;
		" INNER JOIN Turnos ON Turnos.afiliado = PREREGISTRA.id AND TURNOS.fechatur = ?lfecha AND CONFIRMADO = 0 "+;
		" INNER JOIN Entidades ON Turnos.CodEnt = Entidades.Ent_CodEnt "+;
		" INNER JOIN PRESTACIONS ON Turnos.CodPrest = PRESTACIONS.Pre_CodPrest "+;
		" INNER JOIN SERVICIOS ON PRE_codservicio = SER_codserv "+;
		" INNER JOIN ESPECIALID ON PRE_especialidad = ESP_codesp "+;
		" WHERE TNL_IdLlama IS NULL and preregistra = 1 AND TNL_TIPO in ( " + lcLetras + ") AND " + ;
		" TNL_numdocumento > 0 AND NVL(Turnos.afiliado,0) > 0 "+;
		" and TNL_CodigoVax is null " + ;
		" ORDER BY DIFE ASC"

	If !PRG_EJECUTOSQL(lcsql,"mwkturnpacretardo2")
		Return .F.
	Endif

*		" WHERE (TNL_IdLlama IS NULL or TNL_IdLlama = 2668536 ) and preregistra = 1 AND TNL_TIPO in ( " + lcLetras + ") AND TNL_numdocumento > 0 AND NVL(Turnos.afiliado,0) > 0 "

* -------------------------------------------------------------------
* Para hacer una prueba de preregistrados usar la siguiente consulta:
* -------------------------------------------------------------------

*!*		mret = SQLExec(mcon1,"SELECT nombre as REG_nombrepac, TNL_FechaHoraIng, horatur, TNL_numdocumento, "+;
*!*			" {fn TIMESTAMPDIFF(SQL_TSI_MINUTE, TNL_FechaHoraIng, horatur)} AS DIFE, TNL_TIPO, " + ;
*!*			"TNL_Numerador, TabTurneroLog.id as idtl, ENT_descrient, SER_descripserv, ESP_descripcion,preregistra   "+;
*!*			" FROM TabTurneroLog "+;
*!*			" LEFT JOIN  PREREGISTRA ON PREREGISTRA.nrodocumento = TabTurneroLog.TNL_numdocumento "+;
*!*			" INNER JOIN Turnos ON Turnos.afiliado = PREREGISTRA.id AND TURNOS.fechatur = ?lfecha AND CONFIRMADO = 0 "+;
*!*			" INNER JOIN Entidades ON Turnos.CodEnt = Entidades.Ent_CodEnt "+;
*!*			" INNER JOIN PRESTACIONS ON Turnos.CodPrest = PRESTACIONS.Pre_CodPrest "+;
*!*			" INNER JOIN SERVICIOS ON PRE_codservicio = SER_codserv "+;
*!*			" INNER JOIN ESPECIALID ON PRE_especialidad = ESP_codesp "+;
*!*			" WHERE (TNL_IdLlama IS NULL or TNL_IdLlama = 2668536 ) and preregistra = 1 AND TNL_TIPO in ( " + lcLetras + ") AND TNL_numdocumento > 0 AND NVL(Turnos.afiliado,0) > 0 "+;
*!*			" ORDER BY DIFE ASC","mwkturnpacretardo2")

*!*	Return mret

Case lopcion = 3

	Select * From Mwkturnpacretardo1 Union Select * From Mwkturnpacretardo2 Into Cursor Mwkturnpacretardo

	Select Alltrim(Reg_nombrepac) As Reg_nombrepac,Tnl_numdocumento,Ttoc(horatur,2) As horatur,;
		Ttoc(Tnl_fechahoraing,2) As Tnl_fechahoraing,Round(Val(Dife),0) As Dife, ;
		int((horatur - ltfecha) / 60) As treal, ;
		(Alltrim(Alltrim(TNL_TIPO) + "-"+ Transform(TNL_Numerador))) As Nro, idtl, ENT_descrient, SER_descripserv, ESP_descripcion, Iif(Mwkturnpacretardo.preregistra = 1,"!"," ") As preregistracion;
		from Mwkturnpacretardo;
		INTO Cursor Mwkturnpacretardo ;
		Order By treal  Asc

Endcase
