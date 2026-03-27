*
* Busqueda de Registros Nutricion a Depurar
*
Lparameters mcfechas

If used('mwksaco1')
	Use in mwksaco1
Endif

If used('mwksaco2')
	Use in mwksaco2
Endif

mret = sqlexec(mcon1,"select * from TabNutDetalle where TND_FHoraCarga < ?mcFecHas","mwksaco1")
If mret < 0
	Messagebox("EN ARCHIVO NUTRICION DETALLES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif

mret = sqlexec(mcon1,"select * from TabNutPaciente where TNP_Fecha < ?mcFecHas","mwksaco2")
If mret < 0
	Messagebox("EN ARCHIVO NUTRICION PACIENTES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif

mpaso = .t.
