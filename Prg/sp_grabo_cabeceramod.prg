lparameters mabm,mid,mmodulo,mdetalle,mplantilla,mvalor,mObserva,mGrabo
mfechacarga = sp_busco_fecha_srv2('DT')
mfechaAlta = sp_busco_fecha_srv2('DT')
SELECT mwkusuario
mcodigoVax = codigoVax

IF mGrabo = 'C'
    mret = sqlexec(mcon1, "SELECT id FROM TabPModulo where Descripcion = ?mmodulo  " , "mwkcontrol")
    nreg = RECCOUNT()
	IF  nreg >0
		messagebox('YA EXISTE ESTE MODULO EN ARCHIVO',48,'Validacion')
	ELSE 
	    
		mret = sqlexec(mcon1, "insert into TabPModulo (Descripcion , Detalle , Plantilla , Valor , FechaUA ,Observa)"+;
			" values( ?mmodulo, ?mdetalle, ?mplantilla, ?mvalor, ?mfechacarga, ?mObserva )")
		mret = sqlexec(mcon1, "SELECT id FROM TabPModulo where Descripcion = ?mmodulo " , "mwkMaxId")
		SELECT mwkMaxId
		mid = id
		mret = sqlexec(mcon1, "insert into TabPModAudit(FecAlta,IdModulo,valor) values(?mfechaAlta,?mid,?mvalor)")	
    ENDIF 		
	
ELSE
     mret = sqlexec(mcon1, "select valor from tabpmodulo where id = ?mid ","mwkValorModulo")
				IF Valor <> mValor 
				   mret = sqlexec(mcon1, "insert into TabPModAudit(FecAlta,IdModulo,valor,usuario)"+;
				   " values(?mfechaAlta,?mid,?mvalor,?mcodigovax)")
				endif
     mret = sqlexec(mcon1, "UPDATE TabPModulo SET Descripcion = ?mmodulo,Detalle = ?mDetalle ,Plantilla = ?mPlantilla " +;
	 ", Valor = ?mValor , FechaUA = ?mfechacarga ,Observa = ?mObserva where id = ?mid ") 	      
ENDIF 
