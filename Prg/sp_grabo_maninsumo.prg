****
** Grabo Modulos prestaciones
****
lparameters mabm,mcodInsumo,mvalor,mid
if mabm = 1
	mid=0
endif
	mret = sqlexec(mcon1, "SELECT id FROM TabMantinsumo where codInsumo = ?mcodInsumo" ,"mwkcontrol")
	nreg = reccount("mwkcontrol")
	IF nreg > 0
	   *MESSAGEBOX("ESTE INSUMO YA EXISTE",48,"Validación")
	   RETURN .f.
	ENDIF 
	do case
		case mabm = 1   		&& Alta
			if nreg >0
				messagebox('YA EXISTE EL INSUMO',48,'Validacion')
			else
					mret = sqlexec(mcon1, "insert into TabMantinsumo (codInsumo)"+;
					" values( ?mcodInsumo)") 
					
			endif

*!*					ENDIF 
	endcase
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
		messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	endif

