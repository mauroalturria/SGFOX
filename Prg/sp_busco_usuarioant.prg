parameters midPres,mNum

mret = sqlexec(mcon1," select nomape,usuario ,idpres from tabpauditoria " +;
	" left join tabusuario on tabusuario.id = tabpauditoria.usuario "+;
	" where tabpauditoria.id  = (select max(id) - ?mNum from tabpauditoria "+;
	" where  idPres = ?midPres )  "+;
	" and  tabpauditoria.idPres = ?midPres ","mwkUsuarioAnt")


if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
