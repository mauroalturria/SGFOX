*!*	--------------------------------------------------------------
*!*	PRESTACIONES QUE SE UTILIZAN PARA EL CONTROL DE DEMORAS
*!*	--------------------------------------------------------------
lparameters mopcion,mbusco
mfecnull = ctod("01/01/1900")
do case
case mopcion = 1 && busco
		mret = Sqlexec(mcon1,"SELECT Prestacions.PRE_codprest, Prestacions.PRE_descriprest, " + ;
			"Prestacions.PRE_codservicio, Prestacions.PRE_especialidad " + ;
			",Tabturdemora.* " + ;
			" FROM Prestacions,Tabturdemora "+;
			"WHERE Prestacions.PRE_fechapasiva IS NULL " + ;
			"AND Prestacions.PRE_AgendaTurnos = 'S' " + ;
			"and TD_fecpasiva = ?mfecnull and TD_codprest = PRE_codprest " + ;
			"ORDER BY PRE_especialidad, PRE_descriprest " ,"mwkPrestDem")

	case mopcion = 2 && actualiza


	case mopcion = 3 && baja

endcase

if mret <= 0
*	messagebox("ERROR DE LECTURA ", 48, "VALIDACION")
	return .f.
endif
