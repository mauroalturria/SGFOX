****
** Grabo Prestaciones Derivadas
****
Lparameters mabm

Do Case
	Case mabm = 1
	
		mret = SQLExec(mcon1, "insert into TabPPrestDer (PDCodPrest, PDValor, PDIdPresu)" +;
			" values( ?mcodprest, ?mvalor, ?mIdPresu )")

	Case mabm = 2
	
		mret = SQLExec(mcon1, "update TabPPrestDer set PDCodPrest = ?mcodprest" +;
			" ,PDValor = ?mvalor, PDIdPresu = ?mIdPresu where id = ?mId ")

	Case mabm = 3
	
		mret = SQLExec(mcon1, "Delete from TabPPrestDer Where id = ?mId ")

	Case mabm = 4
	
		mret = SQLExec(mcon1, "Delete from TabPPrestDer Where PDIdPresu = ?mIdPresu ")
		
Endcase

If mret < 0
	=Aerr(eros)
	Messagebox(eros(3))
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
Endif
