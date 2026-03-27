*** Muestra error
***
lparameters mierror,miprg,misvar
if type('misvar')="U" 
	misvar=''
endif	

if used ('mwkusuario')
	if mwkusuario.sector="SISTEMAS"
		messagebox("PRG: "+miprg+chr(13)+"ERROR: "+mierror(3))
*		messagebox(misvar)
	else
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	endif
else
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
endif
