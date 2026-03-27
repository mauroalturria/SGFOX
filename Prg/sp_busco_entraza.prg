*
* Busqueda codigo de entidad maestro trazabilidad
*
Lparameters mentidad

If vartype(mentidad) <> "N"
	Return .F.
Endif

mret = sqlexec(mcon1,"SELECT * FROM TabTraEnt "+;
	" join TabTraEntxEnt "+;
	" on TabTraEnt.Id = Trax_Id and Trax_codent = ?mentidad","mwkcodent")

If mret < 0
	Messagebox("Error al Localizar Movimiento",26,"Error")
	On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.
