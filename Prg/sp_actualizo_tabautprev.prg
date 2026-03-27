**********
* Actualiza Datos de Autorizaciones ambulatorias
*********
Parameters mopcion,mid,mvalor

Do Case
Case mopcion = 1
	mret = 1
	mret = SQLExec(mcon1,"update tabAutPrevias  set APV_observaciones = ?mvalor"+;
		" where id = ?mid")
Case mopcion = 2
	mret = SQLExec(mcon1,"update tabAutPrevias  set APV_fechacirugia = ?mvalor "+;
		" where id = ?mid")
Case mopcion = 3
	mret = SQLExec(mcon1,"update tabAutPrevias  set APV_CantEfectuadas = ?mvalor "+;
		" where id = ?mid")
Case mopcion = 4 &&& esta es la unica valida en uso
	mret = SQLExec(mcon1,"update tabAutPrevias  set apv_agrupa = ?mvalor "+;
		" where id = ?mid")
Endcase
If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif

