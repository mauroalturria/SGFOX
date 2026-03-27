
Parameter mabm,mNombre,mapellido,mlegajo,mespecialidad,mbipper,mid

Dimension cf(100)
Store '' to cf

mfecnull   = ctod("01/01/1900")

Do case
Case mabm = 1
	mret =	sqlexec(mcon1,"select legajo from tabManttecnico where legajo = ?mlegajo"+;
	" and FechaPasiva = ?mfecnull","mwkValidTec")
	
	If reccount('mwkValidTec') > 0
		Messagebox("TÉCNICO EXISTENTE",16,"VALIDACION")
		grabo = .f.
		Return
	Endif
	
	mret =	sqlexec(mcon1,"insert into tabManttecnico (Nombre,apellido," +;
		"legajo,Idespecialidad,bipper,fechapasiva)" +;
		" values(?mNombre,?mapellido,?mlegajo,?mespecialidad,?mbipper,?mfecnull)")

Case mabm = 2
	mret =	sqlexec(mcon1,"update tabManttecnico set Nombre = ?mNombre, apellido = ?mapellido,"+;
		"legajo = ?mlegajo, IdEspecialidad = ?mespecialidad, bipper = ?mbipper"+;
		" where id = ?mid and FechaPasiva = ?mfecnull")
		
Case mabm = 3
	
*!*		mret =	sqlexec(mcon1," select * from tabMantdettecn where"+;
*!*			" idTecnico = ?mid ","mwkValidc")
*!*			
*!*		
*!*		If reccount('mwkValidc') > 0
*!*			Messagebox("TÉCNICO VINCULADO A UNA ORDEN DE TRABAJO",16,"VALIDACION")
*!*			grabo = .f.
*!*			Return
*!*		Endif
	
	mfec = sp_busco_fecha_serv('DD')
	
*!*	mret = sqlexec(mcon1,"delete from tabManttecnico where id = ?mid ")
	
	mret = sqlexec(mcon1,"update tabManttecnico set fechapasiva = ?mfec where id = ?mid ")
	
Endcase


If mret<1
	=aerr(eros)
	Messagebox(eros(2))
Endif
