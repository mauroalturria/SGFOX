Parameters tnOpcion, tnId, tnCal, tnCodMed, tdFechaApli, tnNroReg, tcObs, tnVacuna,tcLote,tnVencim,tnUbica
*set step on
ldNull  = Ctod("01/01/1900")
ldfechoy  = sp_busco_fecha_serv('DT')

Do Case
	Case tnOpcion = 1 && ALTA
		lcSql =" Insert Into TabVacReg 	(VAR_Cal, VAR_CodAmbito, VAR_CodMed, VAR_FecPasiva, VAR_FechaApli, "+;
			" VAR_FechaHora, VAR_NroReg, VAR_Obs, VAR_Vacuna,VAR_Lote,VAR_Vto,VAR_ubicacion) values ( " +;
			"?tnCal, ?mxambito, ?tnCodMed, ?ldNull, ?tdFechaApli, "+;
			" ?ldfechoy, ?tnNroReg, ?tcObs, ?tnVacuna, ?tcLote,?tnVencim ,?tnUbica)"

	Case tnOpcion = 2 && MODIFICACION
		tcObsmod = Alltrim(tcObs)+"x Mod.codmed"+Transform(tnCodMed)
		lcSql = "Update TabVacReg Set VAR_FecPasiva = ?ldfechoy, VAR_Obs =?tcObsmod Where Id = ?tnId "
		If !prg_ejecutosql(lcSql)
			Return .F.
		Endif
		lcSql = "Insert Into TabVacReg (VAR_Cal, VAR_CodAmbito, VAR_CodMed, VAR_FecPasiva, VAR_FechaApli, "+;
			" VAR_FechaHora, VAR_NroReg, VAR_Obs, VAR_Vacuna,VAR_Lote,VAR_Vto,VAR_ubicacion) "+;
			" values (?tnCal, ?mxambito, ?tnCodMed, ?ldNull, ?tdFechaApli, ?ldfechoy, ?tnNroReg, ?tcObs, ?tnVacuna, ?tcLote,?tnVencim ,?tnUbica	)"

	Case tnOpcion = 3&& BAJA
		lcSql = "Update TabVacReg Set VAR_FecPasiva = ?ldfechoy,VAR_Obs =?tcObs Where Id = ?tnId "

Endcase


If !prg_ejecutosql(lcSql)
	Return .F.
Endif
