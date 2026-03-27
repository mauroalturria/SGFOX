****
** busco grupo del usuario sector
****
		   

parameter  mcodsec

	mret = sqlexec(mcon1, "select tabnivel.tipoturno,TabTipoTurno.grupo " + ;
		" from tabnivel,TabTipoturno  "+;
		" where tabnivel.tipoturno = TabTipoTurno.tipoturno and nivel = ?mcodsec ", "mwkTXN")

select distinct grupo from mwkTXN into cursor mwkTXNG