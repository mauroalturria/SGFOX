Parameters tnCodBolsa
*--------------------------------------------------------------------------------------
*TEXT To lcSql Textmerge Noshow Pretext 7
lcSql = "select CPRECIRDET.*, INSUMOS.INS_codinsumo, INSUMOS.INS_descriinsumo, Cast(0 as integer) as Pase " + ;
			"from  CPRECIRDET " + ;
			"inner join INSUMOS on INSUMOS.INSUMOS = CPRECIRDET.CodInsumo " + ;
			"where CodBolsa = ?tnCodBolsa " + ;
			"Order by INS_descriinsumo "
*ENDTEXT

If !prg_ejecutosql(lcSql, "mwlBolsaDet", .t.)
	Return .f.
Endif 

*--------------------------------------------------------------------------------------