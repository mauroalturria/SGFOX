****
** actualizo planes de entidades
****

Parameter  miabm, mForm

Local nIdPrepaga
Local mAbreviatura
Local mDescripcion

mAbreviatura = Trim(mForm.txtAbrevia.Value)
mDescripcion = Trim(mForm.txtDescri.Value)
mEntAgrupa   = mForm.pEntAgrupa
mEntDescrip  = mForm.pEntDescrip

mret = SQLExec(mcon1, "select * from Planes "+;
	" where codentAg = ?mEntAgrupa ","mwkveodes")

If mret<=0
	Messagebox("ERROR EN LA LECTURA DE PLANES",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

If Reccount('mwkveodes') == 0
**verificar que exista en la tabla prepagas. Recuperar ID
**Sin o existe, habria que dar de alta la prepaga tambien?
	mret = SQLExec(mcon1,"select * from Prepagas where idprepaga = ?mEntAgrupa","mwkPrepaga" )
	If mret<=0
		Messagebox("ERROR EN LA LECTURA DE PREPAGAS",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif


	If Reccount("mwkPrepaga") == 0
**Grabamos la prepaga.
		mret = SQLExec(mCon1,"insert into prepagas (descripcion,idprepaga) values(?mEntDescrip,?mEntAgrupa)" )
		If mret<=0
			Messagebox("ERROR EN LA ESCRITURA DE PREPAGAS",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

**Recuperamos el ID de la prepaga.
		mret = SQLExec(mCon1,"select * from prepagas where idprepaga = ?mEntAgrupa","mwkPrepaga")
		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE PREPAGAS",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

    ENDIF
    
**Mandamos a grabar el plan.
	Do sp_grabo_plan With mwkPrepaga.Id,mAbreviatura,mEntAgrupa,mDescripcion
   	

Else

	Do sp_grabo_plan With mwkveodes.idprepaga,mAbreviatura,mEntAgrupa,mDescripcion

Endif
