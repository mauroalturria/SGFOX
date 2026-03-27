*!*
lcSql = ''

*Text To lcSql Noshow Textmerge Pretext 7
lcSql = "Select VP_idPoblacion , VP_orden , VP_poblacion " + ;
	"from TabVacPobl " + ;
	"Order by VP_orden "

If !prg_ejecutosql(lcSql, "mwkVacPobl0")
	Return .F.
Else
	Select *,VP_idPoblacion+2000000 As idvac From mwkVacPobl0 Into Cursor mwkVacPobl
Endif


