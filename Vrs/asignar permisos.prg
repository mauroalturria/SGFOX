mfec = ctod("01/01/1900")
set step on
*!*	FOR I = 3753  TO 3792
*!*	*!*	 	INSERT INTO tabusuariofrmcmdalta (codigovax,codcmd,codfrm,codsector,codusuario,fecpasiva) ;
*!*	*!*				values (0,129,236,23,i,mfec)
*!*	*!*			INSERT INTO tabusuariofrmcmdalta (codigovax,codcmd,codfrm,codsector,codusuario,fecpasiva) ;
*!*	*!*			values (0,129,487,23,i,mfec)
*!*	*!*			INSERT INTO tabusuariofrmcmdalta (codigovax,codcmd,codfrm,codsector,codusuario,fecpasiva) ;
*!*	*!*			values (0,130,487,23,i,mfec)
*!*	*!*	 	insert into Tabusuario_sector (codgrupo, codsector,codusuario, fecpasiva,preferido) values ( 10,23,i,mfec,1)
*!*		insert into tabusuario_exe (codusuario, fecpasiva,codigovax,codexe) values ( i,mfec,54035,22)

*!*	next i

*!*	mfec = ctod("01/01/1900")
*!*	set step on
*!*	select consulta
*!*	scan
*!*		i = consulta.id
*!*	 	INSERT INTO tabusuariofrmcmdalta (codigovax,codcmd,codfrm,codsector,codusuario,fecpasiva) ;
*!*				values (0,129,236,23,i,mfec)
*!*			INSERT INTO tabusuariofrmcmdalta (codigovax,codcmd,codfrm,codsector,codusuario,fecpasiva) ;
*!*			values (0,129,487,23,i,mfec)
*!*			INSERT INTO tabusuariofrmcmdalta (codigovax,codcmd,codfrm,codsector,codusuario,fecpasiva) ;
*!*			values (0,130,487,23,i,mfec)
*!*	*!*	 	insert into Tabusuario_sector (codgrupo, codsector,codusuario, fecpasiva,preferido) values ( 10,23,i,mfec,1)
*!*	*!*		insert into tabusuarioexe (codusuario, fecpasiva,codigovax,codexe) values ( i,mfec,54035,22)

*!*	endscan
mfec = ctod("01/01/1900")
set step on
select FALTAN
scan
	i = FALTAN.id
	insert into tabusuario_exe (codusuario, fecpasiva,codigovax,codexe) values ( i,mfec,54035,38)

endscan
*select * from tabusuario_med where id not in (select codusuario from tabusuarioexes where codexe = 25) into cursor faltan
