*******************
** Claudia Antoniow 
*******************
**Fecha 29/10/2004
*******************
parameters vr_nombre

mret=sqlexec(mcon1,'SELECT * FROM Prestadores where nombre = ?vr_nombre','mwkPrestador')

if mret < 0
	messagebox('ERROR DE VALIDACION, REINTENTE',16,'VALIDACION')
	do prg_cancelo
	mret = 0
endif	
