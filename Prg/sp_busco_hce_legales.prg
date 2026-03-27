*
* Busqueda de HCE Legales solicitadas
*
Lparameters mwh,mfec1,mfec2

Use in select("mwkhceleg")

*!*	mret = sqlexec(mcon1,"select TLH_fechasol,TLH_protocolo,TLH_estado,REG_nombrepac,TLH_tipo,TabLGHce.id as lid,"+;
*!*		" REG_nroregistrac "+;
*!*		" From TabLGHce"+;
*!*		" Join REGISTRACIO on REG_nroregistrac = TLH_nroregis"+;
*!*		" Where TLH_fechasol >= ?mfec1 and TLH_fechasol <= ?mfec2","mwkhceleg")

mret = sqlexec(mcon1,"select TLH_fechasol,TLH_fechaate,TLH_protocolo,TLH_estado,REG_nombrepac,"+;
	"TLH_tipo,TabLGHce.id as lid,REG_nroregistrac "+;
	" From TabLGHce"+;
	" Join REGISTRACIO on REG_nroregistrac = TLH_nroregis "+;
	" Where " + mwh +;
	" order by TLH_fechasol,REG_nombrepac,TLH_tipo,TLH_protocolo ","mwkhceleg")

If mret < 0
	Messagebox("CONSULTA DE HCE LEGALES SOLICITADAS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.
