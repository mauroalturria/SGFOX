misql = "SELECT * FROM tabbeepers where bee_fechpasiva='1900-01-01'"

If !prg_ejecutosql(misql,"mwktabbeeperscons")
	Return .F.
Endif

