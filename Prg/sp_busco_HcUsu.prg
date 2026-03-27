parameters mfechad, mfechah, mbusco

*!*	mfechad = cTod("11/08/2009")
*!*	mfechah = mfechad + 5
*!*	mbusco = ""

mfd = prg_dtoc(mfechad)
mfh = prg_dtoc(mfechah + 1)

mret = sqlexec(mcon1, "select TabHcUsuario.*, TabHCEstado.Hce_Descrip "+;
	"From TabHcUsuario "+;
	"left join TabHCEstado on TabHCEstado.hce_id = TabHcUsuario.hcu_estado " + ;
	"where hcu_Fecha >= ?mfd  and hcu_Fecha < ?mfh " + mBusco ,"mwkHcUsu")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
	canc
endif

