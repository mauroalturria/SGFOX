*
* Trafico telefónico
*
Lparameters mdes,mhas

Use in select("mwktratel")

mret = sqlexec(mcon1,"select fecha,hora,interno as internot,tipo,duracion from TraficoTelefonico"+;
	" where Fecha >= ?mdes and Fecha <= ?mhas","mwktratel")

If mret < 0
	Messagebox("EN CONSULTA LLAMADAS TELEFONICAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.
