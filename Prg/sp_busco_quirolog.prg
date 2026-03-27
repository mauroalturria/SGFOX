*********
* Busco cambios de Quirofano
*********
lparameters mid, lctabla
if vartype(lcTabla)#"C"
	lctabla = "mwkdetquiro"
endif
mret = sqlexec(mcon1,"select TabQuirofanoLog.*,tabEstados.descrip,tabusuario.nomape,tabEstados.estado as estadoori "+;
	" from TabQuirofanoLog "+;
	" left join tabEstados on tabEstados.id = TabQuirofanoLog.estado "+;
	" left join tabusuario on TabQuirofanoLog.usuario = tabusuario.codigovax "+;
	" where idQuirof=?mid order by fechahora desc ",lctabla)
if mret < 0
	=aerror(eros)
*!*		?EROS(3)
	messagebox("ERROR DE LECTURA",48,"VALIDACION")
	return .f.
endif
