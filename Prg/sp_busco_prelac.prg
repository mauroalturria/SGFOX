****
** Controlo para baja o modificacion
****
Lparameters mid,narch
Do Case
Case narch = 1
	mret = SQLExec(mcon1, "SELECT count(id) as ctrl FROM TabPrCPago "+;
		" where CodCPago = ?mid " , "mwkcontrol")
Case narch = 2
	mret = SQLExec(mcon1, "SELECT count(id) as ctrl FROM TabPrConce "+;
		" where CodConce = ?mid " , "mwkcontrol")
Case narch = 3
*!*		mret = sqlexec(mcon1, "SELECT count(id) as ctrl FROM TabPrMod "+;
*!*			" where CodModulo = ?mid  " , "mwkcontrol")
Case narch = 4
	mret = SQLExec(mcon1, "SELECT count(id) as ctrl FROM TabPrPrest "+;
		" where CodPrest = ?mid " , "mwkcontrol")
Case narch = 5
	mret = SQLExec(mcon1, "SELECT count(id) as ctrl FROM TabPDetPresupuesto"+;
		" where idPreOCon = ?mid and tipopres = 5" , "mwkcontrol")
Endcase
If mret < 0
	=Aerr(eros)= 2
	Messagebox(eros(3))
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
Endif
