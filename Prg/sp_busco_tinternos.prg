*
* Busqueda de Internos asignados al Legajo - ID -
*
Lparameters mIdlegajo
If used('mwkinternos')
	Use in mwkinternos
Endif
mfecnull = ctod("01/01/1900")
mret = sqlexec(mcon3, "select * from TTInternos where IdLegajo=?mIdLegajo and FechaHasta=?mfecnull","mwkinternos")
If mret <= 0
	Messagebox("ERROR EN BUSQUEDA DE INTERNOS PARA EL LEGAJO REQUERIDO"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
