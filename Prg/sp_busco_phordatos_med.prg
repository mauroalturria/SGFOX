***
***  busqueda de los datos para las planillas
***
	use in select('mwkpmed')
	use in select("mwkespecag")
	use in select("mwkespecag")
	
mret = sqlexec(mcon1,"SELECT id, nombre FROM prestadores " + ;
	"WHERE dambula = 1 and id > 1 ", "mwkpMed" )

mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
			" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")
