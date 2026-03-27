*
* Fichadas de Medicos de Guardia
*
Lparameters mabm,mcodmed,mestado,mfecent,msalida,mpautad

Do case
Case mabm = 1 && nuevo

	mret = sqlexec(mcon1,"insert into TabGuaFich (TGF_codmed,TGF_estado,TGF_fichaEnt,TGF_fichaSal,TGF_salPact) "+;
		"values (?mcodmed,?mestado,?mfecent,?msalida,?mpautad)")

Case mabm = 2 && actualizo

	mfecnull = ctod("01/01/1900")
	mret = sqlexec(mcon1,"update TabGuaFich set TGF_estado=?mestado,TGF_fichasal=?msalida "+;
		"where TGF_codmed=?mcodmed and TGF_fichasal=?mfecnull and TGF_fichaEnt=?mfecent")

*!*    TGF_estado=1
Endcase

If mret < 0
	Messagebox("EN BUSQUEDA DEL PROFESIONAL EN FICHADAS",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
Endif
