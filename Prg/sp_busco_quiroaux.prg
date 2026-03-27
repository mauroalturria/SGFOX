*********
* Busco Auxiliares de Quirofano
*********
lparameters mtipo, mcursor, mfecha
mfecnull = ctod("01/01/1900")
if vartype(mfecha)="D"
	mbusfec = " and ( FecPasiva = ?mfecnull or FecPasiva >= ?mfecha) "
else
	mbusfec = " and FecPasiva = ?mfecnull  "
endif 	

mret = sqlexec(mcon1,"select *  from TabQuirAux "+;
	" where (categoria = ?mtipo or id = 1) " + mbusfec +;
	" order by Descripcion " ,mcursor)
if mret < 1
	=aerr(eros)
	messagebox(eros(3)+'AVISE A SISTEMAS', 64,'Validacion')
endif

