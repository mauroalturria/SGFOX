****
** inserto datos de alta transitoria
****

parameter mopcion, mbusco, mFhIngreso, mCodadmision, mEstado, mDiagnostico;
			, mObservaciones, musuarioIng ,mCodCIE9, mCodmed, mCodprest, mDestino, ;
			mFhEgreso, mUsuarioSal, mcodent, mprest

if mopcion= 1		&& inserto nuevo registro
	mret = sqlexec(mcon1, "insert into TabAltaTrans(CodCIE9, Codadmision,"+;
					" Codmed, Codprest, Destino, Diagnostico, Estado, FhEgreso,"+;
					" FhIngreso,Observaciones,UsuarioSal, codent, prestacion ) " + ;
					" values(?mCodCIE9, ?mCodadmision, ?mCodmed, ?mCodprest, ?mDestino, ?mDiagnostico, " + ;
					" ?mEstado, ?mFhEgreso, ?mFhIngreso, ?mObservaciones, ?mUsuarioSal, ?mcodent, ?mprest)")
	if mret > 0
		messagebox('ALTA TRANSITORIA REGISTRADA', 64,'Validacion')
	else
		messagebox('ERROR EN EL EGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')	
	endif
endif
if mopcion= 2		&& actualizo ingreso
	mret = sqlexec(mcon1, "update TabAltaTrans set FhIngreso = ?mFhIngreso "+;
				", Estado = ?mEstado, Diagnostico = ?mDiagnostico"+;
				", Observaciones = ?mObservaciones, usuarioIng = ?musuarioIng "+;
				" where Codadmision = ?mCodadmision " + mbusco )
	if mret > 0
		messagebox('INGRESO REGISTRADO', 64,'Validacion')
	else
		messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')	
	endif
					
endif					
if mopcion= 3		&& actualizo todos los datos
	mret = sqlexec(mcon1, "update TabAltaTrans set CodCIE9 = ?mCodCIE9 , codent = ?mCodent, "+;
					" Codmed = ?mCodmed, Codprest = ?mCodprest, Destino = ?mDestino, prestacion = ?mprest,"+;
					" Diagnostico = ?mDiagnostico, Estado = ?mEstado, FhEgreso = ?mFhEgreso,"+;
					" FhIngreso = ?mFhIngreso, Observaciones = ?mObservaciones,UsuarioSal = ?mUsuarioSal ) " + ;
					" where Codadmision = ?mCodadmision " + mbusco )
					
endif					
	if mret < 0
		messagebox("ERROR EN LA ACTUALIZACION DE DATOS, AVISAR A SISTEMAS", 16, "Validacion")		
	endif	
	