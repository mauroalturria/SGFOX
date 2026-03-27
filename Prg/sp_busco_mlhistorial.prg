***************
****   Busca el historial de las citas 
***************
parameters mlegajo,mIdRelac
***CitaEstado son los vigentes.
**mIdRelac = iif(empty(mIdRelac),'IdRelac',str(mIdRelac))

mWhere = ""

IF VARTYPE(mLegajo) = "N" .and. mLegajo > 0 &&buscamos por legajo
*!*	   mret  = sqlexec(mcon1,"select leg_apellido,leg_Nombre,Leg_id "+;
*!*		" from legajos where leg_id = ?mLegajo" ,"MwkLegajo")
   sp_busco_mllegajo(0,mLegajo)
   
   mWhere = " legajo = " + ALLTRIM(STR(mlegajo))+ " "
ENDIF

IF VARTYPE(mIdRelac) = "N" .and. mIdRelac > 0 &&buscamos por nro. de id

*!*	   mret  = sqlexec(mcon1,"select leg_apellido,leg_Nombre,Leg_id "+;
*!*		" from legajos where Leg_FechaEgr is null" ,"MwkLegajo")
   
   sp_busco_mllegajo()
   
   IF !EMPTY(mWhere)
      mWhere = mWhere + " and IdRelac = ?mIdRelac "
   ELSE
      mWhere = " Id = " + ALLTRIM(STR(mIdRelac))+" "
   ENDIF
      
ENDIF
   
*!*	mret  = sqlexec(mcon1,"select leg_apellido,leg_Nombre,Leg_id "+;
*!*		" from legajos where leg_id = ?mLegajo" ,"MwkLegajo")

if used('mwkCitaHistorial')
	select mwkCitaHistorial
	use
endif
*!*	mret = sqlexec(mcon1," select *,Registracion->Reg_nombrepac,cast(0 as Integer) AS NumCita "+;
*!*		" from TabMlCita "+;
*!*		" where legajo =?mlegajo and CitaEstado = 1 and IdRelac =  "+ mIdRelac, "mwkCitaHistorial01")

mret = sqlexec(mcon1," select *,Registracion->Reg_nombrepac,cast(0 as Integer) AS NumCita "+;
	" from TabMlCita "+;
	" where" + mWhere, "mwkCitaHistorial01")
	

select * from mwkCitaHistorial01 ;
	left join MwkLegajo on leg_id = legajo into cursor mwkCitaHistorial02

if used('mwkCitaHistorial')
	use in mwkCitaHistorial
endif

use dbf("mwkCitaHistorial02") in 0 again alias mwkCitaHistorial


If mRet<=0
	Messagebox("ERROR EN LA LECTURA HISTORIAL DE ATENCION",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
