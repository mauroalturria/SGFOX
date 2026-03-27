****
**  Busco Texto para retiro de Estudios por items del vale
****

parameter nroitem 

mccpoamb = ''
If mxambito >1
	mccpoamb = ' codambito = ?mxambito and '
Endif

mbus = "and subserv in ('',"+ iif( AT('TURNOS',mwkexe.nomexe )>0,"'A'",iif(inlist(mwkexe.nomexe,"GUARDIA",'ADMISION'),"'G'", "''") )+") "
if !used('mwkubicaserv')
	mret = sqlexec(mcon1, 'select descrip from tabubicaserv '+;
		'where &mccpoamb codserv = 1 ', 'mwkubicaserv')
endif
for f = 1 to nroitem
	mprest = item_vale(f,1)
	mret = sqlexec(mcon1, 'select descrip from tabubicaserv where &mccpoamb codprest = ?mprest '+mbus, 'mwkubiser')
	if mret < 0
		messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE', 16,'Validacion')
		do prg_cancelo
	endif

	if reccount ('mwkubiser')>0
		midesc = alltrim(mwkubiser.descrip)
		insert into mwkubicaserv (descrip) values (alltrim(item_vale(f,3)))
		insert into mwkubicaserv (descrip) values (midesc )
	endif
next

if reccount ('mwkubicaserv')>0
	for f = 1 to nroitem
		insert into mwkubicaserv (descrip) values ("*"+left(alltrim(item_vale(f,3)),36))
	next
else
if !used('mwkubiser')
	mret = sqlexec(mcon1, 'select descrip from tabubicaserv '+;
		'where &mccpoamb codserv = 1 ', 'mwkubiser')
endif
endif
select mwkubicaserv
go top
