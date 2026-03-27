*
* Busqueda de Entidad solicitante / Entidades en Gral., detalle
*
Lparameters mbusca, mqentidad

If vartype(mbusca)#"N"
	mbusca=0
Endif

If vartype(mqentidad)#"N"
	mqentidad = 1
Endif

If mqentidad = 1
	If used('mwkciamdeta')
		Use in mwkciamdeta
	Endif
	mret = sqlexec(mcon1,"select TCU_nombre,TCU_direccion,TCU_localdes from tabciamubica"+;
		" where id=?mbusca","mwkciamdeta")
Else
	mret = sqlexec(mcon1,"select * from ENTIDADES where ENT_codent = ?mbusca"+;
		" and ENT_fecpas is null","mwkentidad")
Endif

If mret < 0
	Messagebox("EN BUSQUEDA DE LA ENTIDAD"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
