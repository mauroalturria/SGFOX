****
** Medicos con vencimiento
****
parameter mbusco

mfecturno = ttod(mwkfecserv.fechahora)
mfecnull 	= ctod('01/01/1900')

mfecpasms = ' id > 1 and ( fecpasivap > ?mfecturno or fecpasivap = ?mfecnull )'
*mfecpasms = ' id > 1 and ( fecpasivap > ?mfecturno or fecpasivap = ?mfecnull )'


*!*	mfecpasms = ' id>1 and  (estado = 1 or fecpasiva > ?mfecturno or '+;
*!*		'(dguardia= 1 and (fecpasivag = ?mfecha2  or fecpasivag > ?mfecturno)) )  '

mret = sqlexec(mcon1, "select * from prestadores "+;
	"where "+ mfecpasms + mbusco+;
	"order by nombre ","mwklista")

if mret < 0
	= aerr(eros)
	messagebox(eros(3),16,'VALIDACION')
endif
