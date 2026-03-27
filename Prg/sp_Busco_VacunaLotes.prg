lcSql = ''
mHoy = sp_busco_fecha_serv('DD')

*Text To lcSql Noshow Textmerge Pretext 7
lcSql = "Select * " + ;
	"from TabVacunaLotes " + ;
	"where VLT_fechavencimiento >= ?mHoy "

If !prg_ejecutosql(lcSql, "mwkVacLotes")
	Return .F.
Endif