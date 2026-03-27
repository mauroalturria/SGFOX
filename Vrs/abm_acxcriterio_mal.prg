Do sp_conexion

Set Step On
*!*	Use c:\desaguemes\altacod.Dbf In 0 Shared
*!*	Use c:\desaguemes\bajacod.Dbf In 0  Shared
Requery('prestambac')
*!*	Select * From view13  Where inscodpuntero Not In (Select inscodpuntero From prestambac) Into Cursor agrego
Select * From prestambac Where inscodpuntero  not In (Select inscodpuntero From view13  ) Into Cursor borro
Select borro
Scan
	mcod =  borro.inscodpuntero 
	mRet = SQLExec(mcon1," DELETE FROM INSCRITERIOSOLIC WHERE  Agru = 35 AND PreIn = 'P' AND INSCodPuntero = ?mcod ")
	If mRet<1
		Set Step On
	Endif
Endscan
*!*	Select agrego
*!*	Scan
*!*		mcod =  agrego.inscodpuntero 
*!*		mRet = SQLExec(mcon1," insert into INSCRITERIOSOLIC ( Agru,PreIn ,INSCodPuntero , Criterio ) values (35, 'P' ,?mcod,16 ) ")
*!*		If mRet<1
*!*			Set Step On
*!*		Endif
*!*	Endscan
Do sp_desconexion
