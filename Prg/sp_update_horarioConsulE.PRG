*
* Cancelación / Reprogramación
*
Lparameters mOpcion, mId

Do Case
Case mOpcion = 1 && Reprogramación 
	mtipo = "RT-"

Case mOpcion = 2 && Cancelación
	mtipo = "CT-"

Otherwise
	mtipo = ""

Endcase

mRet = Sqlexec(mCon1, "Update horarioConsulE " + ;
	"set nombre = {fn CONCAT( ?mtipo,nombre ) } where Id = ?mId")

If mRet <= 0
	Messagebox("ERROR EN LA ACTUALIZACION CB REPROGRAMADOS ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

*   Cambio codmed para las reprogramaciones frmturno35
*	mRet = Sqlexec(mCon1, "Update horarioConsulE " + ;
*	"set codmed = codmed + 10000 where Id = ?mId")
