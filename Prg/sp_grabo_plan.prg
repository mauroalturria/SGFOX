PARAMETERS mIdPrepaga,mAbreviatura,mCodent,mDescripcion

LOCAL mId

**Grabamos el registro
	**mId = mwkveodes.idprepaga

	mret = SQLExec(mcon1, "insert into Planes (abreviaent,Abreviatura,codentag,descripcion,FecPasivaPlan,IdPrepaga) "+;
		" values( ?mAbreviatura,'',?mCodent,?mDescripcion,'1900-01-01',?mIdPrepaga)")

	If mret<=0
		Messagebox("ERROR EN LA ESCRITURA DE PLANES",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

**Recuperar el registro grabado y tomar el ID para actualizar.
	mret = SQLExec(mcon1,"select id from Planes where AbreviaEnt = ?mAbreviatura and codentag = ?mCodent and descripcion = ?mDescripcion and IdPrepaga = ?mIdPrepaga","mwkveodes")

	If mret<=0
		Messagebox("ERROR EN LA CONSULTA ID DE PLANES",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif
	
**Actualizo el ID
    mId = mwkveodes.Id
    
	mret = SQLExec(mcon1,"update Planes set Abreviatura = Id where ID = ?mId")

	If mret<=0
		Messagebox("ERROR EN LA ESCRITURA DE PLANES",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	ENDIF
	
	
RETURN .t.
	