****
** BUSCO MENSAJES PARA LAS PRESTACIONES
****

parameter mwhere, mopcion

mfecha2 = ctot('01/01/1900')

if mopcion = 1
	mret = sqlexec(mcon1, 'select id, codpres, descrip from turnosprepara ' + ;
		'&mwhere' + ' and fecbaja = ?mfecha2', 'mwkmensaje')
endif
if mopcion = 2
	mret = sqlexec(mcon1, 'select pre_descriprest, descrip, id, codpres '+;
		' from turnosprepara,prestacions  ' + ;
		' where codpres=pre_codprest and PRE_fechapasiva is null  '+;
		' and fecbaja = ?mfecha2', 'mwkmensaje0')
	select pre_descriprest, left(descrip,250) as descrip, id, codpres from mwkmensaje0 into cursor mwkmensaje
endif
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif
