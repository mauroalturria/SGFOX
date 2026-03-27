*
* Busqueda de Estado y Codcie en Ambulatorio
*
Lparameters mlproto

Use in select("mwkestcod")

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 

mret = sqlexec(mcon1,"select TabCiap2E.Descripcion as lcodcie,tabtipoaltas.descrip as lestado"+;
	" from tabambulatorio"+;
	" left join tabtipoaltas on tabtipoaltas.id = tabambulatorio.codestado"+;
	" left join TabCiap2E on TabCiap2E.id = tabambulatorio.codcie9"+;
	" where protocolo = ?mlproto" + mccpoamb,"mwkestcod")

If mret < 0
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.

