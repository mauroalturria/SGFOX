****
** Grabo Modulos prestaciones
****
lparameters mabm,mid,mcodpres,mdetalle,mvalor,mtipo,mpdetalle
if mabm = 1
	mid=0
endif
morigen = iif(mwkexe.nomexe="PRESUAMB",2,1)

mfechacarga = sp_busco_fecha_srv2('DT')
if !empty(mcodpres)
	mret = sqlexec(mcon1, "SELECT id FROM TabpPrest where CodPrest = ?mcodpres and id<>?mid and porigen = ?morigen " ,"mwkcontrol")
	nreg = reccount("mwkcontrol")
	do case
	case mabm = 1   		&& Alta
		if nreg >0
*			messagebox('YA EXISTE ESTE MODULO-PRESTACION EN ARCHIVO',48,'Validacion')
		else
			mret = sqlexec(mcon1, "insert into TabPPrest (CodPrest,pdetalle,PValor,fechaua,POrigen)"+;
				" values( ?mcodpres,?mpdetalle,?mvalor, ?mfechacarga,?morigen )")

		endif
	case mabm = 2
		mret = sqlexec(mcon1, "update TabPPrest  set CodPrest = ?mcodpres"+;
			" ,pDetalle = ?mdetalle , pValor = ?mvalor "+;
			" , FechaUA = ?mfechacarga  where id=?mid ")
	case mabm = 3
		mret = sqlexec(mcon1, "delete from TabPPrest   where id=?mid ")
	endcase
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
		messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	endif

endif
