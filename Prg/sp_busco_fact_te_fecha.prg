****
** Busca los items de facturas y n. credito
****
parameters mpvta,mfechd,mfechh

mret= sqlexec(mcon1,'select nrocte,importeb,fechahora,reg_nombrepac, ENT_descrient,idusuario,nroregistracio '+;
	' from TabdetalleFac '+;
	' left join tabfacturas on TabdetalleFac.nrofactura 	= tabfacturas.nrocte ' +;
	" left join entidades 	on tabfacturas.codent 		= entidades.ENT_codent " +;
	" left join tabusuario	on tabfacturas.usuario 		= tabusuario.codigovax " +;
	' left join registracio on registracio.registracio 	= tabfacturas.nroregistracio ' +;
	' where fechacte>=?mfechd and fechacte<=?mfechh and tabfacturas.ptovta =?mpvta '+;
	" and tipobono=28 and observa = 'LLAMADAS TELEFONICAS REALIZADAS DURANTE LA INTERNACION'"  ,'mwkfacTE')
&&and tipocomp = tpocte
if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, REINTENTE", 16, "Validación")
endif
