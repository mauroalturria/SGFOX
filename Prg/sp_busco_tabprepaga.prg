****
** busco en tabla prepaga
****

parameter mncodmed

mret = sqlexec(mcon1,'select * from tabprepaga where codmed = ?mncodmed', 'mwkprepaga')

if mret < 0
	messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS',13,'Validacion')
	CANCEL
endif