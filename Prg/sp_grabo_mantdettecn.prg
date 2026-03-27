** Marcelo Torres, 21/06/2017
** Le quité el DELETE y lo reemplacé por el update dentro de la iteración de registros.
** Tambien se agrega el control de errores.
Parameters  midot

Local lResult

lResult = .T.

*!*	mret = SQLExec(mcon1, "DELETE FROM tabMantDetTecn WHERE idot = ?midot")

Select mwkMantdetTecnico
Scan
	mId             = Id
	mFechaHoraAsig 	= FechaHoraAsig
	mcomentario    	= comentario
	midTecnico      = idTecnico
	mComentarioDesa = Nvl(comentariodesasig,'')
	mfechahoradesasig = Iif(Empty(fechahoradesasig),.Null.,fechahoradesasig)

	If mId > 0

		mRet = SQLExec(mcon1,"update tabMantDetTecn set " + ;
			"comentario = ?mcomentario," +;
			"FechaHoradesasig = ?mfechahoradesasig," +;
			"ComentarioDesasig = ?mcomentario " + ;
			"where id = ?mId")

	Else

		mRet = SQLExec(mcon1, "INSERT INTO  tabMantDetTecn(idot,"+;
			"idTecnico,FechaHoraAsig,comentario,FechaHoradesasig,ComentarioDesasig) "+;
			" values(?midot,?midTecnico,?mFechaHoraAsig,?mcomentario,"+;
			" ?mfechahoradesasig,?mComentarioDesa)")
	Endif

	If mRet<=0
		Messagebox("ERROR EN GRABACION TABMANTDETTECN. Valor idot : " + Alltrim(Str(midot)),26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		lResult = .F.
		Exit
	Endif

Endscan

Return lResult
