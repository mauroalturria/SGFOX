****
** Grabo Modulos Integrales
****
	do sp_grabo_pmodint with .mabm,.mid, .Txtmod.value,;
		.TxeDetalle.value, .TxtValor.value, .TxeObserva.value
lparameters mabm,mid,mmodulo,mdetalle,mplantilla,mvalor,mObserva
if mabm = 1
	mid=0
endif
mfechacarga = sp_busco_fecha_srv2('DT')
	
if !empty(mmodulo)
	mret = sqlexec(mcon1, "SELECT id FROM TabPModulo where Descripcion = ?mmodulo and id<>?mid " , "mwkcontrol")
	nreg = reccount("mwkcontrol")
	do case
		case mabm = 1   		&& Alta
			if nreg >0
				messagebox('YA EXISTE ESTE MODULO EN ARCHIVO',48,'Validacion')
			else
				mret = sqlexec(mcon1, "insert into TabPModulo (Descripcion , Detalle , Plantilla , Valor , FechaUA ,Observa)"+;
					" values( ?mmodulo, ?mdetalle, ?mplantilla, ?mvalor, ?mfechacarga, ?mObserva )")
			endif
		case mabm = 2
			if nreg >0
				messagebox('YA EXISTE ESTE MODULO EN ARCHIVO',48,'Validacion')
			else
				mret = sqlexec(mcon1, "update TabPModulo set Descripcion = ?mmodulo"+;
					" ,Detalle = ?mdetalle , Plantilla = ?mplantilla, Valor = ?mvalor "+;
					" , FechaUA = ?mfechacarga, Observa = ?mObserva where id=?mid ")
			endif
		case mabm = 3
			mret = sqlexec(mcon1, "delete from TabPModulo where id=?mid ")
	endcase
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
		messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	endif

endif