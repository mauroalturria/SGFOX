****
** busco todas las prestaciones de guardia ****
Lparameters mbusco

If Vartype(mbusco)#"C"
	mbusco=''
Endif

mfecpas = Ctod('01/01/1900')

mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest, pre_codservicio, ranqueo,nivel,"+;
	"pre_especialidad,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona  " + ;
	"FROM guardiaprestacion, prestacions " + ;
	"where codprest = pre_codprest and " + ;
	"fechapasiva = ?mfecpas " + mbusco +;
	"ORDER BY ranqueo desc, pre_descriprest", "mwkprestgua")


If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 48, "Validacion")
	Cancel
Endif
