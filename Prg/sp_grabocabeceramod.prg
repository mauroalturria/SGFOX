lparameters mabm,mid,mmodulo,mdetalle,mplantilla,mvalor,mObserva,mGrabo
mfechacarga = sp_busco_fecha_srv2('DT')
mret = sqlexec(mcon1, "SELECT id FROM TabPModulo where Descripcion = ?mmodulo and id<>?mid " , "mwkcontrol")
nreg = reccount("mwkcontrol")
IF mGrabo = 'C'
	IF  nreg >0
		messagebox('YA EXISTE ESTE MODULO EN ARCHIVO',48,'Validacion')
	ELSE 
		mret = sqlexec(mcon1, "insert into TabPModulo (Descripcion , Detalle , Plantilla , Valor , FechaUA ,Observa)"+;
			" values( ?mmodulo, ?mdetalle, ?mplantilla, ?mvalor, ?mfechacarga, ?mObserva )")
	ENDIF 
ELSE
     mret = sqlexec(mcon1, "UPDATE TabPModulo SET Descripcion = ?mmodulo,Detalle = ?mDetalle ,Plantilla = ?mPlantilla " +;
	 ", Valor = ?mValor , FechaUA = ?mfechacarga ,Observa = ?mObserva where id = ?mid ") 	      
ENDIF 
