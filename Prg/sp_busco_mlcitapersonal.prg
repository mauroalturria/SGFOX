*************
** Consulto la tabla TabMlCita ,para traer todos los legajos para el personal y el nro de registracion para los preocup ****
*************
Parameters mfechad,mfechah,lcWhere, lcWhereLegajo, mCursor

lcWhere = Iif(Empty(lcWhere),'',lcWhere)
lcWhereLegajo = Iif(Empty(lcWhereLegajo),'',lcWhereLegajo)
mCursor = Iif(Vartype(mCursor) # "C", "mwkCitaPersonal01",mCursor)

**SET STEP ON

**mret  = SQLExec(mcon1,"select leg_apellido,leg_Nombre,Leg_id "+;
	" from legajos where Leg_FechaEgr is null " + lcWhereLegajo ,"MwkLegajo")

*!*	mret  = SQLExec(mcon1,"select sf_apellido as leg_apellido,sf_nombre as leg_Nombre,sf_legajo "+;
*!*		" from ZabSf where 1=1 " + lcWhereLegajo ,"MwkLegajo1")

*!*	mret  = sqlexec(mcon1,"select leg_apellido,leg_Nombre,Leg_id "+;
*!*		" from legajos2 where Leg_FechaEgr is null ","MwkLegajo")

*!*	If mret < 0
*!*		=Aerr(eros)
*!*		Messagebox(eros(3))
*!*	Endif

*!*	SELECT UPPER(leg_apellido) as leg_apellido, UPPER(leg_nombre) as leg_nombre, VAL(sf_legajo) as Leg_id ;
*!*	FROM MwkLegajo1 ;
*!*	INTO CURSOR MwkLegajo

**USE IN SELECT("MwkLegajo1")
**Set Step On

Do Case
Case Vartype(mfechad) = "D" .And. Vartype(mfechah) = "D"
	mret = SQLExec(mcon1," select citaTipo as citaTipo2 ,"+;
		" observaciones,ProbAltaFec,citahora,* ,Registracion->Reg_nombrepac from TabMlCita "+;
		" where  CitaFecha >=?mfechad and CitaFecha<=?mfechah "+ lcWhere, "mwkCitaPersonal01")
Case Vartype(mfechad) = "D"
	mret = SQLExec(mcon1," select citaTipo as citaTipo2 ,"+;
		" observaciones,ProbAltaFec,citahora,* ,Registracion->Reg_nombrepac from TabMlCita "+;
		" where  CitaFecha =?mfechad "+ lcWhere, "mwkCitaPersonal01")
Otherwise

	mret = SQLExec(mcon1," select citaTipo as citaTipo2 ,"+;
		" observaciones,ProbAltaFec,citahora,* ,Registracion->Reg_nombrepac from TabMlCita "+;
		" where 1=1 "+ lcWhere, mCursor)
Endcase



If mret < 0
	=Aerr(eros)
	Messagebox(eros(3))
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
Endif

*!*	select * from mwkCitaPersonal01 ;
*!*		inner join MwkLegajo on MwkLegajo.leg_id = mwkCitaPersonal01.legajo into cursor mwkCitaPersonal
** Marcelo Torres, 30/08/2012
** Se agrego el left join para que no excluya los registros de Preocupacional (no tienen nro. de legajo.)
*!*	select * from mwkCitaPersonal01 ;
*!*		left join MwkLegajo on MwkLegajo.leg_id = mwkCitaPersonal01.legajo into cursor mwkCitaPersonal
