*!* Actualizacion de detalle de presupuesto
*!*	tabpdetPresupuesto
Lparameters mabm

mfecnull = CTOD("01/01/1900")
mfechoy  = sp_busco_fecha_serv("DD")
Do Case 
	Case mabm = 1
		&& Insert 
		mret = SQLExec(mcon1, "insert into tabpdetpresupuesto " + ;
			"(Idpreocon, IdDetP, Incluye, Precio, TipoPres,fecpasiva)" +;
			" values( ?mcodprest, ?mIdPresu, 1, ?mvalor, 2,?mfecnull )")

	Case mabm = 2
		&& Update
		mret = SQLExec(mcon1, "Update tabpdetpresupuesto " + ;
			"Set Idpreocon = ?mcodprest, " + ;
			"IdDetP = ?mIdPresu, " + ;
			"Incluye = 1, " + ;
			"Precio = ?mvalor, " + ;
			"TipoPres = 2 where id = ?mId")
			
	Case mabm = 3
		&& Delete
		mret = SQLExec(mcon1, "Update tabpdetpresupuesto " + ;
			"Set fecpasiva = ?mfechoy  where id = ?mId")
Endcase

If mret <= 0
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	Cancel 
Endif		