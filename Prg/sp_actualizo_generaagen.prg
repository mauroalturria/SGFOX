*!* ***************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*!*	*****************************

mret=sqlexec(mcon1,'UPDATE medpresta SET generaagen=?mbgenera, usuario=?midusu ' +;
				   'WHERE codmed=?mncodmed and diasem=?mddiasem')
				   
if mret < 0
	messagebox('ERROR DE CURSOR, AVISAR A SISTEMAS!!!','VALIDACION')
	mret=0
	
endif 				   