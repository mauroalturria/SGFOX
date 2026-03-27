**********
*	Lectura de sugerencias del profesional
**********
PARAMETERS mcodmed

mret = sqlexec(mcon1, "select *  from Tabsmc   ", "mwksmc")

if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif
