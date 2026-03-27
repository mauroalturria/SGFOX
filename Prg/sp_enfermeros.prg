*
* Maestro de Enfermeros x Sector
*
Use In Select("mwkenfer")

mfnull = Ctod("01/01/1900")

mret = SQLExec(mcon1,"select * from tabusuario"+;
	" where descrip like '%ENFER%'"+;
	" and fecpasiva = ?mfnull"+;
	" order by nomape","mwkenfer")

If mret < 0
	=Aerror(merror)
	Messagebox(merror(3))
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.

