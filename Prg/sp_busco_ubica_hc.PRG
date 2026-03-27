*
* Datos de H.C. y Pacientes según ubicación
*
Lparameters mcodub

If used('mwkubihc')
	Use in mwkubihc
Endif

mret = sqlexec(mcon1,"select REG_nrohclinica,REG_nombrepac,HCA_fechainic"+;
	" from TabHcArchivo join Registracio on REG_nroregistrac = TabHcArchivo.HCA_registrac"+;
	" where TabHcArchivo.hca_motFalta = ?mcodub","mwkubihc")

If mret < 0
	Messagebox("EN CONSULTA DE H.C. SEGUN UBICACION"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
