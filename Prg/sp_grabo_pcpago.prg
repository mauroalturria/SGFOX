****
** Grabo Condiciones de Pago
****
lparameters mdesc,mabm,mid
if mabm = 1
	mid=0
endif

if !empty(mdesc)
	mret = sqlexec(mcon1, "SELECT id FROM SQLUser.TabPCPago where CPDetalle= ?mdesc and id<>?mid " , "mwkcontrol")
	nreg = reccount("mwkcontrol")
	do case
		case mabm = 1   		&& Alta
			if nreg >0
				messagebox('EXISTE ESTA CONDICION EN ARCHIVO',48,'Validacion')
			else
				mret = sqlexec(mcon1, "insert into TabPCPago (CPDetalle ) values( ?mdesc )")
			endif
		case mabm = 2
			if nreg >0
				messagebox('EXISTE ESTA CONDICION EN ARCHIVO',48,'Validacion')
			else
				mret = sqlexec(mcon1, "update TabPCPago set CPDetalle = ?mdesc "+;
					" where id=?mid ")
			endif
		case mabm = 3
			mret = sqlexec(mcon1, "delete from TabPCPago where id=?mid ")
	endcase
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
		messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	endif

endif