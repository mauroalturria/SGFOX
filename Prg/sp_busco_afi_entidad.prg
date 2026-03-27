*
* Busco entidades acorde a HC desde AFILIACION
*
Parameters mlhc

If Used('mwklentidad')
	Use In mwklentidad
Endif

mret = SQLExec(mcon1,"select entidades.ENT_descrient as lentidad,"+;
	"afiliacion.AFI_codentidad as lcodent,ENT_nroprestadorexterno as lnroexte"+;
	" from afiliacion"+;
	" join registracio on reg_nrohclinica = ?mlhc"+;
	" join entidades on entidades.ENT_codent = afiliacion.AFI_codentidad"+;
	" where afiliacion.registracio = registracio.REG_nroregistrac","mwklentidad")

If mret < 0
	=Aerror(merror)
	Messagebox("EN CONSULTA DE ENTIDADES DESDE AFILIACION"+Chr(10)+;
		alltrim(merror(3)),16,"Validación")
Endif

