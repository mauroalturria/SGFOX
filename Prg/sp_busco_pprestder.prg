****
** Busco Prestaciones Derivadas
****

mret = SQLExec(mcon1, "Select TabPPrestDer.Id, prestacions.pre_descriprest, " + ;
		"prestacions.Pre_CodPrest, PdValor, PDIdPresu " + ;
		"From TabPPrestDer, prestacions where " + ;
		"prestacions.Pre_CodPrest = TabPPrestDer.PdCodPrest and " + ;
		"PDIdPresu = ?mIdPresu group by Id ", "mwkPPrestDer")

If mret < 0
	=Aerr(eros)
	Messagebox(eros(3))
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
Endif
