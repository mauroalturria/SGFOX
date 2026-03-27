Parameters tnOpcion, tnId, tnidInf, ttFecLog, tnTipoLog, tcDescrip

tnUsuario = mwkusuario.codigovax
Do Case
	Case tnOpcion = 1
		Text To lcSql Textmerge Noshow Pretext 7
			Insert Into InformesLog
			(DocumentoBase, FechaLog, IdInforme, TipoLog, Usuario) 
			Values (?tcDescrip, ?ttFecLog , ?tnidInf, ?tnTipoLog, ?tnUsuario)
		Endtext   

	Case tnOpcion = 2
		Text To lcSql Textmerge Noshow Pretext 7
			Update InformesLog Set 
				DocumentoBase = ?tcDescrip, 
				FechaLog = ?ttFecLog, 
				IdInforme = ?tnidInf, 
				TipoLog =  ?tnTipoLog, 
				Usuario = ?tnUsuario
			Where id = ?tnId 

		Endtext   
	
	Otherwise

endcase

If !prg_ejecutosql(lcSql,"mwkAux",.t. )
	Return .f.
Endif