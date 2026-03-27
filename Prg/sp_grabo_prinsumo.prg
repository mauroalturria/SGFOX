****
** Grabo Modulos prestaciones
****
lparameters mabm,mcodInsumo,mvalor,mid
if mabm = 1
	mid=0
endif
mfecnull = CTOD("01/01/1900")
mret = sqlexec(mcon1, "SELECT id FROM Tabpinsumo where codInsumo = ?mcodInsumo" ,"mwkcontrol")
nreg = reccount("mwkcontrol")
do case
	case mabm = 1   		&& Alta
		if nreg >0
*				messagebox('YA EXISTE EL INSUMO',48,'Validacion')
		else
			mret = sqlexec(mcon1, "insert into TabpInsumo (codInsumo,pvalor)"+;
				" values( ?mcodInsumo,?mvalor)")

		endif
	case mabm = 2
		mret = sqlexec(mcon1, "update TabpInsumo  "+;
			" set pvalor = ?mvalor "+;
			" where id= ?mid")
	case mabm = 3
		mret = sqlexec(mcon1," SELECT iddetp FROM Tabpdetpresupuesto where tipopres = 3 and IdPreoCon = ?mcodInsumo and fecpasiva = ?mfecnull ",+;
			"mwkValidacion")
		select mwkValidacion
		if reccount() = 0
			mret = sqlexec(mcon1, "delete from TabpInsumo  where codInsumo= ?mcodInsumo ")
		else
			nDialogType = 4 + 32 + 256
			if messagebox("ESTE INSUMO SE ENCUENTRA ASOCIADO A UN PRESUPUESTO,¿DESEA ELIMINARLO DE TODAS FORMAS",nDialogType,"VALIDACIÓN") = 6
				mret = sqlexec(mcon1, "delete from TabpInsumo  where codInsumo= ?mcodInsumo ")
			endif
		endif
endcase
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif

