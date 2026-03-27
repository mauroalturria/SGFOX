*******
*	Actualiza los datos de actualizacion de ejecutames y modo de acceso
*******
lparameters maccesoExe , maccesoIni , marchivoAct , mmodo, mfecha 

if Vartype(mfecha) # "T"
	ldFecha = sp_busco_fecha_serv('DT')
Else
	ldFecha = mfecha
Endif 	

*!*	mret = SqlExe(mCon1, "Select * from TabExeLog " + ;
*!*		"Where IPEquipo = ?lcmyip" + ;
*!*		"And archivoAct = ?lnCodExe", "mwkexeLog")

*!*	if mret <= 0
*!*		messagebox("Error al generar la actualización", 48, "Validación")
*!*	endif
*!*	if reccount("mwkexeLog")=0
	mret = SqlExe(mCon1, "Insert into TabExeLog (IPEquipo , accesoExe ,"+;
		" accesoIni , archivoAct , fechaUlt , modo ) "+;
		"Values (?myip , ?maccesoExe , ?maccesoIni , ?marchivoAct , ?ldFecha,"+;
		" ?mmodo )")
*!*		lnId = mwkexeLog.id
*!*		mret = SqlExe(mCon1, "Update TabExeLog Set FechaUlt = ?ldFecha Where id = ?lnId")
*!*	endif

if mret <= 0
	=aerr(eros)
	messagebox("Error al generar la actualización", 48, "Validación")
endif
