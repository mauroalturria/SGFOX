Do sp_conexion

Set Step On
Use c:\desaguemes\altacod.Dbf In 0 Shared
Use c:\desaguemes\bajacod.Dbf In 0  Shared
Requery('prestambac')
Select * From altacod Where codigo Not In (Select inscodpuntero From prestambac) Into Cursor agrego
Select * From bajacod Where codigo In (Select inscodpuntero From prestambac) Into Cursor borro
Select borro
Scan
	mcod =  borro.codigo
	mRet = SQLExec(mcon1," DELETE FROM INSCRITERIOSOLIC WHERE  Agru = 36 AND PreIn = 'P' AND INSCodPuntero = ?mcod ")
	If mRet<1
		Set Step On
	Endif
Endscan
Select agrego
Scan
	mcod =  agrego.codigo
	mRet = SQLExec(mcon1," insert into INSCRITERIOSOLIC ( Agru,PreIn ,INSCodPuntero , Criterio ) values (36, 'P' ,?mcod,16 ) ")
	If mRet<1
		Set Step On
	Endif
Endscan
Do sp_desconexion
