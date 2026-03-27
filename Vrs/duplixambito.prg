SELECT * FROM b_medfamprest  INTO CURSOR base
For nam = 3 To 14

	Select  nam As CodAmbito,  PXE_CodEntidad,  PXE_CodPrestacion,;
		PXE_TipoExclusion,  PXE_VigenciaDesde,  PXE_VigenciaHasta;
		FROM Base Into Cursor nuevo
	Select b_medfamprest
	Append From Dbf('NUEVO')
Next

SELECT * FROM b_medfamesp INTO CURSOR base
For nam = 3 To 14

	Select  nam As CodAmbito,  EXE_CodEntidad,  EXE_CodEspecialidad,EXE_TipoExclusion,;
  EXE_VigenciaDesde, EXE_VigenciaHasta;
		FROM Base Into Cursor nuevo
	Select b_medfamesp
	Append From Dbf('NUEVO')
Next


