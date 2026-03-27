*********************************************************************************
* auditoria de una orden
*********************************************************************************

Parameters midot

mfecnull = ctod("01/01/1900")

*!*	mret = sqlexec(mcon1,"select fechaasig,descrip,comentario,idestado,idot,TabMantaudit.id,codest "+;
*!*	 "from TabMantaudit left join TabMantEst on TabMantEst.codest=idestado" +;
*!*	 " where idot = ?midot","mwkMantAudit")

mret = sqlexec(mcon1,"select fechaasig,descrip,comentario,idestado,idot,TabMantaudit.id,codest "+;
	"from TabMantaudit,TabMantEst where codest=idestado and fecpasiva=?mfecnull" +;
	" and idot=?midot","mwkMantAudit")

If mret < 1
	Messagebox("EN BUSQUEDA DE ESTADOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif

