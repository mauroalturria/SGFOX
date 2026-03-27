****
** Busca los items de facturas y n. credito
****

parameters mpvta,mnroreg,mfech

mret= sqlexec(mcon1,'select nrocte,importeb,cuenta from TabdetalleFac '+;
	' left join tabfacturas on TabdetalleFac.nrofactura = tabfacturas.nrocte ' +;
	' where nroregistracio = ?mnroreg and fechacte>=?mfech and tabfacturas.ptovta =?mpvta '+;
	" and tipobono=28 and observa = 'LLAMADAS TELEFONICAS REALIZADAS DURANTE LA INTERNACION'" ,'mwkfacTE')
&&and tipocomp = tpocte
if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, REINTENTE", 16, "Validación")
endif
