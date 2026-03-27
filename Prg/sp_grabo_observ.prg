***
** Grabo presupuesto
****
lparameters mobservaciones,mIDPres, Mestado,musuario,MestadoAux


	mret = sqlexec(mcon1,"select max(id) as id  from tabpauditoria where idpres = ?mIDPres and estadoActual = ?Mestado","mwkIdActual")
	SELECT mwkIdActual
	mid = id
IF EMPTY(MestadoAux)
	mret = sqlexec(mcon1, "UPDATE TabpAuditoria  SET observaciones= ?mobservaciones,usuario=?musuario  where id = ?mid")
ELSE
   	mret = sqlexec(mcon1, "UPDATE TabpAuditoria  SET estadoActual = ?MestadoAux ,observaciones= ?mobservaciones,usuario=?musuario  where id = ?mid")
endif

	

	
	
