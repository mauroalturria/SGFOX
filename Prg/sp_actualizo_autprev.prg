**********
* Actualiza Datos de Autorizaciones
*********
Parameters mopcion,mid,mvalor

Do Case
Case mopcion = 1
	mret = 1
	mret = SQLExec(mcon1,"update AutPrevias set APV_observaciones = ?mvalor"+;
		" where id = ?mid")
Case mopcion = 2
	mret = SQLExec(mcon1,"update AutPrevias set APV_fechacirugia = ?mvalor "+;
		" where id = ?mid")
Case mopcion = 3
	mret = SQLExec(mcon1,"update AutPrevias set APV_CantEfectuadas = ?mvalor "+;
		" where id = ?mid")
Case mopcion = 4
	mret = SQLExec(mcon1,"update AutPrevias set APV_idagrupador = ?mvalor "+;
		" where id = ?mid")
Case mopcion = 5
	mret = SQLExec(mcon1,"update AutPrevias set APV_CantEfectuadas = ?mvalor,APV_CantAutorizada = ?mvalor "+;
		" where id = ?mid")
Endcase
If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif

