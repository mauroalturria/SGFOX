*******************
* Busqueda de Demanda insatisfecha
********************

lparameters pFechaD, pFechaH
mfechas = ''
if vartype(pFechaH)= "D"
	mfechas = ' And FechaSol < ?pFechaH '
endif
mRet = SqlExec( mcon1, ' Select TurnosInsatis.* ,'+ ;
	' ENT_descrient ,' + ;
	' Prestadores.Nombre as PRES_NOM ,' + ;
	' Registracio.REG_nombrepac ,' + ;
	' Prestacions.PRE_Descriprest ,' + ;
	' Prestacions.Pre_Especialidad ' + ;
	' From TurnosInsatis, Entidades, Prestadores, Prestacions, Registracio ' + ;
	' Where Fechasol >= ?pFechaD ' + mfechas +;
	' and Entidades.Ent_CodEnt = TurnosInsatis.CodEnt And ' + ;
	' Prestadores.Id = TurnosInsatis.CodMed And ' + ;
	' Prestacions.PRE_CodPrest = TurnosInsatis.CodPrest And  ' + ;
	' Registracio.reg_nroregistrac = TurnosInsatis.Afiliado ' + ;
	' Union ' + ;
	' Select TurnosInsatis.* ,'+ ;
	' ENT_descrient ,' + ;
	' Prestadores.Nombre as PRES_NOM ,' + ;
	' Preregistra.nombre as REG_nombrepac ,' + ;
	' Prestacions.PRE_Descriprest ,' + ;
	' Prestacions.Pre_Especialidad ' + ;
	' From TurnosInsatis, Entidades, Prestadores, Prestacions, Preregistra ' + ;
	' Where Fechasol >= ?pFechaD And FechaSol < ?pFechaH And ' + ;
	' Entidades.Ent_CodEnt = TurnosInsatis.CodEnt And ' + ;
	' Prestadores.Id = TurnosInsatis.CodMed And ' + ;
	' Prestacions.PRE_CodPrest = TurnosInsatis.CodPrest And ' + ;
	' Preregistra.Id = TurnosInsatis.Afiliado ' + ;
	' Order By FechaSol Desc ' ;
	, 'mwkTurnosInsatis' )
if mRet < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS" ,16, "Validacion")
endif
