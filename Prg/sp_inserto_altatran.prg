****
** inserto datos de alta transitoria
****

parameter mCodCIE9, mCodadmision, mCodmed, mCodprest, mDestino, mDiagnostico, ;
			mEstado, mFhEgreso, mFhIngreso, mObservaciones, mUsuario


	mret = sqlexec(mcon1, "insert into TabAltaTrans(CodCIE9, Codadmision,"+;
					" Codmed, Codprest, Destino, Diagnostico, Estado, FhEgreso,"+;
					" FhIngreso,Observaciones,Usuario ) " + ;
					" values(?mCodCIE9, ?mCodadmision, ?mCodmed, ?mCodprest, ?mDestino, ?mDiagnostico, " + ;
					" ?mEstado, ?mFhEgreso, ?mFhIngreso, ?mObservaciones, ?mUsuario)")
					
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")		
	DO sp_desconexion WITH "error"
		cancel
	endif	
	