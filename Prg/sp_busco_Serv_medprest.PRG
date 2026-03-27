*!*	------------------------------------------------------------ 
*!*	Servicios de Medpresta para una Feha
*!*	------------------------------------------------------------
Lparameters mFecha, mbusco

mDiaSem = dow(mfecha)

mret = Sqlexec(mcon1,"Select Distinct CodServ as CodServ " + ;
	"from MedPresta " + ;
	"where diasem = ?mDiaSem and " + ;
	"fecVigend <= ?mfecha and " + ;
	"fecVigenH >= ?mfecha " + mBusco , "mwkSrvMP")

if mret < 0
	messagebox("ERROR DE LECTURA DE SERVICIOS ",48,"VALIDACION")
	Aerror(eros)
	return .f.
Endif
