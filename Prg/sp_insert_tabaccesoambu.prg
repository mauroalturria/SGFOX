****
** Control de accesos a pacientes Ambulatorio HCE
****
Lparameter mpcodestado, mpcodmed, mpprotocolo, mpusuario, mtipoacceso
&& mtipoacceso = 5 acceso desde evolucion - 11 impresion HDO - 11 impresion ART/PAMI 12. evolucion planilla atencion

If vartype(mpusuario) # "N"
	mpusuario = 0
Endif

If vartype(mtipoacceso) # "N"
	mtipoacceso = 0
Endif

mpfechaMod = sp_busco_fecha_serv('DT')

mret = sqlexec(mcon1, "insert into TabAmbAcc"+;
	" (codestado,codmed,fechaMod,protocolo,tipoacceso,usuario)"+;
	" values(?mpcodestado,?mpcodmed,?mpfechaMod,?mpprotocolo,?mtipoacceso,?mpusuario)")

If mret < 0
	Messagebox("EN DOMCUMENTACION DEL ACCESO A LA HCE, AMBULTORIO" + chr(10) + ;
		"AVISE A SISTEMAS",16,"ERROR")

	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()	

	Return .f.
Endif

