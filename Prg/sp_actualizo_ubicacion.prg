**************************
** Actualiza consultorios
**************************
Lparameters mabm,mid,mhabil,mpiso,mdesc,mmnro,minter
Do Case
Case mabm=0
	mret=SQLExec(mcon1,"update Tabubicacion set habilitado = ?mhabil "+;
		" where id= ?mid ")
Case mabm=1

	mret=SQLExec(mcon1,"insert into Tabubicacion (piso, descrip, numero,habilitado,interno,codambito,centromedico ) "+;
		" values ( ?mpiso, ?mdesc, ?mmnro, 1,?minter,?mxambito,?mxcentromedico )")

Case mabm=2
	mret=SQLExec(mcon1,"update Tabubicacion set habilitado= ?mhabil,interno= ?minter" +;
		" where id= ?mid ")
Endcase
If mret < 0
	Messagebox('ERROR AL ACTUALIZAR, REINTENTE',64,'Validacion')
	Do prg_cancelo
Endif
