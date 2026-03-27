**********
*	Lectura de sugerencias del profesional
**********
PARAMETERS mbusco

mret = sqlexec(mcon1, " SELECT ID , TAI_codmed , TAI_consultorio , TAI_fecha , "+;
	"TAI_hhmmEgr , TAI_hhmmIng FROM TabAmbIEMed where "+mbusco, "mwkambiemed")

if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif
