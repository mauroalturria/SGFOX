Parameters tnOpcion, tnId, tcCurDat


Do Case
Case tnOpcion  = 1
	If tnId    = 0
		lcSql  = " Insert into TabQuiroProtoPrest (TPP_IdQuiroProto, TPP_CodPrest, " + ;
			" TPP_Via, TPP_Principal, TPP_codigo,TPP_DesPrest, " + ;
			" TPP_FecAlta, TPP_CodigoVax, TPP_FecPasiva, TPP_VaxPasiva )" + ;
			" Values (?&tcCurDat..TPP_IdQuiroProto, ?&tcCurDat..TPP_CodPrest, " + ;
			" ?&tcCurDat..TPP_Via, ?&tcCurDat..TPP_Principal, ?&tcCurDat..TPP_codigo,?&tcCurDat..TPP_DesPrest, " + ;
			" ?&tcCurDat..TPP_FecAlta, ?&tcCurDat..TPP_CodigoVax, ?&tcCurDat..TPP_FecPasiva, ?&tcCurDat..TPP_VaxPasiva)"
	Else
		lcSql = " Update TabQuiroProtoPrest " + ;
			" Set "+;
			" TPP_IdQuiroProto = ?&tcCurDat..TPP_IdQuiroProto, " + ;
			" TPP_CodPrest  = ?&tcCurDat..TPP_CodPrest , " + ;
			" TPP_DesPrest  = ?&tcCurDat..TPP_DesPrest,"+;
			" TPP_Via	    = ?&tcCurDat..TPP_Via , " + ;
			" TPP_Principal = ?&tcCurDat..TPP_Principal, " + ;
			" TPP_codigo    = ?&tcCurDat..TPP_codigo " + ;
			" Where Id = ?tnId "
	Endif
Case tnOpcion = 2
	lcSql     = " Update TabQuiroProtoPrest " + ;
		"Set " + ;
		"TPP_FecPasiva = ?&tcCurDat..TPP_FecPasiva, " + ;
		"TPP_VaxPasiva = ?&tcCurDat..TPP_VaxPasiva " + ;
		"Where Id = ?tnId "
Otherwise
ENDCASE

If !Prg_EjecutoSql(lcSql,"",.F.)
	Return .F.
Endif
