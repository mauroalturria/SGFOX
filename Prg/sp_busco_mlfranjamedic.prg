*************
***** Busco franja de medicos
*************

parameters mcodigovax

mret = sqlexec(mcon1, "SELECT * FROM tabmlmedico left join"+;
	" tabmlfranja on tabmlfranja.idmedico= tabmlmedico.id ","mwkFranjaMedico")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
