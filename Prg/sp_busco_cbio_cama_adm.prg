*!*	----------------------------------------------------------------------------
*!*	----------------------------------------------------------------------------
Parameters mcCodAdmision, mdfechaE, mcBusco

If Vartype(mcBusco) <> "C"
	mcBusco = ""
Endif 	

mret = sqlexec(mcon1, "select lugarintern.* " +;
	"from lugarintern "+;
	"where LUG_PACIENTES = ?mcCodAdmision and lug_fechaegreso >= ?mdfechaE " + mcBusco +;
	"group by LUG_PACIENTES, lug_fechaegreso, LUG_habitacion, LUG_cama  ", "mwkcbiocama")

if mret<1
	=aerr(eros)
	messagebox (eros(3))
endif

