*
* Busqueda de Comentarios para Orden de Trabajo
*
Lparameters motrab,mestado

If used('mwkcoment')
	Use in mwkcoment
Endif

mret = sqlexec(mcon1,"select * from TabMantAudit where idot=?motrab and idEstado=?mestado","mwkcoment")

If mret < 0
	Messagebox("EN BUSQUEDA DE COMENTARIOS PARA LA O.T."+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
