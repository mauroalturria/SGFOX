*
* Busqueda de Estado y Codcie en Ambulatorio
*
Lparameters mlproto

Use in select("mwkestcod")

mret = sqlexec(mcon1,"select TabCiap2E.Descripcion as lcodcie,tabtipoaltas.descrip as lestado"+;
	" from Guardia"+;
	" left join tabtipoaltas on tabtipoaltas.id = Guardia.codestado"+;
	" left join TabCiap2E on TabCiap2E.id = Guardia.codcie9"+;
	" where protocolo = ?mlproto","mwkestcod")

If mret < 0
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.

