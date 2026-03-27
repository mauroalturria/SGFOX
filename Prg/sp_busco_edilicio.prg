** buscamos datos edilicios

Lparameters nOpcion, nId, mWhere, mCursor

Local mTabla

mCursor = IIF(VARTYPE(mCursor) <> "C","",mCursor)

mret = 0

Do Case
Case nOpcion = 1  &&edificios
   
    mCursor = IIF(EMPTY(mCursor),"mwkEdificios",mCursor)
    USE IN SELECT("mwkEdificios")
	mret = SQLExec(mcon1,"select id as _id,* from TabEeEdificios",mCursor)

	mTabla = "TABEEEDIFICIOS"

Case nOpcion = 2  &&Plantas
 
    mCursor = IIF(EMPTY(mCursor),"mwkPlantas",mCursor)
    USE IN SELECT("mwkPlantas")
	mret = SQLExec(mcon1,"select id as _id,* from TabEePlantasEdificio where idEdificio = ?nId",mCursor)

	mTabla = "TABEEPLANTASEDIFICIO"

Case nOpcion = 3  &&Areas

**SET STEP ON
    mCursor = IIF(EMPTY(mCursor),"mwkAreas",mCursor)
    USE IN SELECT("mwkAreas")
	mret = SQLExec(mcon1,"select TabEeAreasPlanta.id as _id,* from TabEeAreasPlanta where idPlanta = ?nId and FechaFin = '1900-01-01'",mCursor)

	mTabla = "TABEEAREASPLANTA"

Case nOpcion = 4  &&SubAreas

    mCursor = IIF(EMPTY(mCursor),"mwkSubAreasPlanta",mCursor)
    USE IN SELECT("mwkSubAreasPlanta")
	mret = SQLExec(mcon1,"select id as _id,* from TabEeSubAreasPlanta where idArea = ?nId and FechaFin = '1900-01-01'",mCursor)
	mTabla = "TABEESUBAREASPLANTA"

Case nOpcion = 5  &&Tipos de SubArea x ID

    mCursor = IIF(EMPTY(mCursor),"mwkTipoSubAreaPlanta",mCursor)
    USE IN SELECT("mwkTipoSubAreaPlanta")
	mret = SQLExec(mcon1,"select id as _id,* from TabEeTipoSubAreaPlanta where id = ?nId ",mCursor)
	mTabla = "TABEETIPOSUBAREAPLANTA"

Case nOpcion = 6   &&Tipos de SubArea - Todos
  
    mCursor = IIF(EMPTY(mCursor),"mwkTipoSubAreaPlanta2",mCursor)
    USE IN SELECT("mwkTipoSubAreaPlanta2")
	mret = SQLExec(mcon1,"select id as _id,* from TabEeTipoSubAreaPlanta order by descripcion ",mCursor)
	mTabla = "TABEETIPOSUBAREAPLANTA-2"

CASE nOpcion = 7  &&Buscamos por descripcion de Area.
   
   mCursor = IIF(EMPTY(mCursor),"mwkResuAreas",mCursor)
   USE IN SELECT("mwkResuAreas")
   mret = SQLEXEC(mcon1,"select a.nombre as nomArea,a.id as IdArea,b.nombre as nomPlanta, c.id as IdEdificio, c.Nombre as NomEdificio " +;
                        "from TabEeAreasPlanta as a " + ;
                        "inner join TabEePlantasEdificio as b on a.IdPlanta = b.Id " + ;
                        "inner join TabEeEdificios as c on b.IdEdificio = c.Id " + ;
                        "where " + mWhere + " and a.FechaFin = '1900-01-01' ", mCursor )
	
Endcase

If mret<=0
	Messagebox("ERROR EN LA LECTURA DE " + mTabla,26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Else
	Return .t.
Endif

