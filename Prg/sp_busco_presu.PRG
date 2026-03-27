****
** Busco presupuestos
****
Parameters midpre
mfecnull = CTOD("01/01/1900")
msec =  " and (tabpresupuestos.fecpasiva is null or tabpresupuestos.fecpasiva = ?mfecnull) "
mret = sqlexec(mcon1, "SELECT tabpresupuestos.*,entidades.ENT_codent,entidades.ENT_descrient"+;
	" FROM tabpresupuestos"+;
	" left join entidades on ENT_codent = tabpresupuestos.entidad"+;
	" Where id = ?midpre " +msec, "mwkPres")


If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif
mfecpas = ctod("01/01/1900")
mret = sqlexec(mcon1, "SELECT CodAmbito, PA_idAutprevia, PA_idPresu,PA_idTabautpre, PA_tipopac"+;
		" FROM  Zabpresuaut  Where PA_idPresu = ?midpre and PA_fechapas = ?mfecpas ", "mwkPresaut")


If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif