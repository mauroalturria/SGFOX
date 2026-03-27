****
** Grabo Histotia Clinica en Maestro Laboratorios
****

Parameters mnhc1, mnom1, msex1, mfec1

mret = sqlexec(mcon1, "SELECT * FROM TabHcLab " + ;
	"where THL_nrohclinica = ?mnhc1", "mwkHcLab")

If mret < 0
	=aerr(eros)
	Messagebox(eros(3), 48, "Validacion")
Else

	mfechor = sp_busco_fecha_serv("DT")

	If reccount('mwkHcLab')= 0

		mret = sqlexec(mcon1, "insert into TabHcLab " + ;
			"(THL_fechamov, THL_fecnacimiento, THL_nombrepac, THL_nrohclinica, "+;
			"THL_sexo) values "+;
			"(?mfechor, ?mfec1, ?mnom1, ?mnhc1, ?msex1)" )

		If mret < 0
			=aerr(eros)
			Messagebox(eros(3), 48, "Validacion")
		Else
		    Messagebox("Registro incorporado al Maestro de Laboratorio",0,"Validacion")	
		Endif

	Else

		mret = sqlexec(mcon1,"update TabHcLab set THL_fechamov = ?mfechor, THL_fecnacimiento = ?mfec1, "+;
			"THL_nombrepac = ?mnom1,THL_sexo = ?msex1 "+;
			"where THL_nrohclinica = ?mnhc1")

		If mret < 0
			=aerr(eros)
			Messagebox(eros(3), 48, "Validacion")
		Else
		    Messagebox("Registro actualizado del Maestro de Laboratorio",0,"Validacion")	
		Endif

	Endif

	Use in mwkHcLab

Endif
