*
* Busco Derivaciones
*
Parameter mfecdes, mfechas

If vartype(mfechas) # "T"
	mfechas = sp_busco_fecha_serv("DT")
Endif

mfecdesant = dtot(ttod(mfecdes) - 6)

mret = sqlexec(mcon1, "select tabderivacion.id, tabderivacion.codent, codint, denpolicial, " + ;
	"derivadopor, diagnostico, edad, tabderivacion.estado, tabderivacion.fechahora, notifica, " + ;
	"nroafi, nroregistrac, observa, padron, sexo, traslado, usuario, " + ;
	"ENT_descrient, REG_nombrepac, tabsectorint.descrip as sectorint, "+;
	"fechahoraingreso, tabderivacion.habitacion, tabderivacion.cama,"+;
	"REG_numdocumento as nrodocumento, TabEstados.Descrip as estado1,'R' as ltipreg, Ent_Tipo" + ;
	" from tabderivacion, registracio, entidades, tabsectorint, TabEstados  " + ;
	" where nroregistrac = REG_nroregistrac and " + ;
	" tabderivacion.codent = ENT_codent and codint = tabsectorint.id and " + ;
	" tabderivacion.fechahora >= ?mfecdesant " + ;
	" and tabderivacion.fechahora < ?mfecdes " + ;
	" And tabderivacion.Estado = TabEstados.Estado "+ ;
	" And TabEstados.Propietario = 81 and tabderivacion.Estado in(0,5) " + ;
	" order by tabderivacion.fechahora", "mwkderiva3a")

If mret < 0
	=Aerror(merror)
	Messagebox(merror(3))
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif

mret = sqlexec(mcon1, "select tabderivacion.id, tabderivacion.codent, codint, denpolicial, " + ;
	"derivadopor, diagnostico, edad, tabderivacion.estado, tabderivacion.fechahora, notifica, " + ;
	"nroafi, nroregistrac, observa, padron, sexo, traslado, usuario, " + ;
	"ENT_descrient, REG_nombrepac, tabsectorint.descrip as sectorint, "+;
	"fechahoraingreso, tabderivacion.habitacion, tabderivacion.cama,"+;
	"REG_numdocumento as nrodocumento, TabEstados.Descrip as estado1,'R' as ltipreg, Ent_Tipo" + ;
	" from tabderivacion, registracio, entidades, tabsectorint, TabEstados  " + ;
	" where nroregistrac = REG_nroregistrac and " + ;
	" tabderivacion.codent = ENT_codent and codint = tabsectorint.id and " + ;
	" tabderivacion.fechahora >= ?mfecdes " + ;
	" and tabderivacion.fechahora < ?mfechas " + ;
	" And tabderivacion.Estado = TabEstados.Estado "+ ;
	" And TabEstados.Propietario = 81" + ;
	" order by tabderivacion.fechahora", "mwkderiva3")

If mret < 0
	=Aerror(merror)
	Messagebox(merror(3))
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif

*!*	If mret < 0
*!*		=aerr(eros)
*!*		Do prg_error with eros,'sp_buscoderivaciones1',transf(mfecdes)
*!*		Cancel
*!*	Endif

mret = sqlexec(mcon1, "select tabderivacion.id, tabderivacion.codent, codint, "  + ;
	"denpolicial, derivadopor, diagnostico, edad, tabderivacion.estado, " + ;
	"tabderivacion.fechahora, notifica, nroafi, nroregistrac, " + ;
	"observa, padron, tabderivacion.sexo, traslado, " + ;
	"tabderivacion.usuario, ENT_descrient, nombre as REG_nombrepac, " + ;
	"tabsectorint.descrip as sectorint, fechahoraingreso, tabderivacion.habitacion, " + ;
	"tabderivacion.cama,preregistra.nrodocumento, TabEstados.Descrip as estado1,'P' as ltipreg, Ent_Tipo" + ;
	" from tabderivacion, preregistra, entidades, tabsectorint, TabEstados " + ;
	" where nroregistrac = preregistra.id and " + ;
	" tabderivacion.codent = ENT_codent and codint = tabsectorint.id and " + ;
	" tabderivacion.fechahora >= ?mfecdes " + ;
	" and tabderivacion.fechahora < ?mfechas " + ;
	" And tabderivacion.Estado = TabEstados.Estado "+ ;
	" And TabEstados.Propietario = 81" + ;
	" order by tabderivacion.fechahora", "mwkderiva4")

If mret < 0
	=Aerror(merror)
	Messagebox(merror(3))
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif

mret = sqlexec(mcon1, "select tabderivacion.id, tabderivacion.codent, codint, "  + ;
	"denpolicial, derivadopor, diagnostico, edad, tabderivacion.estado, " + ;
	"tabderivacion.fechahora, notifica, nroafi, nroregistrac, " + ;
	"observa, padron, tabderivacion.sexo, traslado, " + ;
	"tabderivacion.usuario, ENT_descrient, nombre as REG_nombrepac, " + ;
	"tabsectorint.descrip as sectorint, fechahoraingreso, tabderivacion.habitacion, " + ;
	"tabderivacion.cama,preregistra.nrodocumento, TabEstados.Descrip as estado1,'P' as ltipreg, Ent_Tipo " + ;
	"from tabderivacion, preregistra, entidades, tabsectorint, TabEstados  " + ;
	"where nroregistrac = preregistra.id and " + ;
	"tabderivacion.codent = ENT_codent and codint = tabsectorint.id and " + ;
	"tabderivacion.fechahora >= ?mfecdesant " + ;
	" and tabderivacion.fechahora < ?mfecdes " + ;
	" And tabderivacion.Estado = TabEstados.Estado "+ ;
	" And TabEstados.Propietario = 81 and tabderivacion.Estado in(0,5) " + ;
	"order by tabderivacion.fechahora", "mwkderiva4a")

If mret < 0
	=Aerror(merror)
	Messagebox(merror(3))
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Else
	Select * from mwkderiva3 ;
		union all ;
		select * from mwkderiva4 ;
		union all ;
		select * from mwkderiva3a ;
		union all ;
		select * from mwkderiva4a ;
		into cursor mwkderiva
Endif

*!*	If mret < 0
*!*		=aerr(eros)
*!*		Do prg_error with eros,'sp_buscoderivaciones2',transf(mfecdes)
*!*		Cancel
*!*	Else

Return
