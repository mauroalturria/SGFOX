*
* Busqueda Planilla de Tratamiento con estado vigente
*
Lparameters mregistro

If used("mwkctrla")
	Use in mwkctrla
Endif

mret = sqlexec(mcon1,"select * from TabFarmPlan where TFP_registracio=?mregistro and TFP_estado=1","mwkctrla")

If mret < 0
	Messagebox("EN CONSULTA DE PLANILLAS DE TRATAMIENTO"+chr(10)+;
		"NOTIFIQUE EL ERROR",16,"ERROR")
Endif
