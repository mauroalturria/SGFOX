****
**  Actualizacion de tabmensaje
****

parameter mcual, mid, mcodent, mtexto

mfecha1 = datetime()
mfecha2 = ctot('01/01/1900')
musub	= ''

if mcual = 1	&& Alta
	mret = sqlexec(mcon1,'insert into entidmodalidad ' + ;
					'values(?mcodent, ?mfecha1, ?mfecha2, ?mtexto, trim(?midusu), ?musub)')
endif
	
if mcual = 2	&& Modificacion
	mret = sqlexec(mcon1,'update entidmodalidad ' + ;
					'set modalidad = ?mtexto, usualta = ?midusu, fecalta = ?mfecha1 ' + ;
					'where id = ?mid')
endif
if mcual = 3	&& Baja
	mret = sqlexec(mcon1,'update entidmodalidad ' + ;
					'set usubaja = ?midusu, fecbaja = ?mfecha1 ' + ;
					'where id = ?mid')
endif

if mret < 0
	messagebox('ERROR EN LA ACTUALIZACION DE ENTIDMODALIDAD, AVISE EN SISTEMAS',16,'Validacion')
	CANCEL
endif