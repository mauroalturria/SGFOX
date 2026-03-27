*****************************************************************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
******************************************************************************
* Genera una lista con las fechas que tienen Agenda generada el profesional
******************************************************************************

If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
Select mwkmedpresta1f
Scan
	mid = mwkmedpresta1f.Id
	mret=SQLExec(mcon1,"UPDATE medpresta SET fechaUltAgenda=?mdmasX " +;
		"WHERE id = ?mid ")

	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
		mret=0

	Endif
Endscan
