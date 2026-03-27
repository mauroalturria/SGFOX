****
* Ejecuta el cursor de prestaciones, trae el codigo y
* la descripción ordenada por descripción para listar combos                                            *
****
Parameter mcodserv,mbusco

If Used('mwkbustexto')
	Select mwkbustexto
	Use
Endif
If Vartype(mbusco)#"C"
	mbusco = ""
Endif
mfecpas = Ctod('01/01/1900')

mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, ser_descripserv, ranqueo,nivel,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona   " + ;
	",pre_duracion as PA_duracion, "+;
	" Pre_retiroestudios as PA_retiroestudios, ser_codserv  "+;
	',PRE_EdadDesde, PRE_EdadHasta '+;
	"FROM prestacions, servicios, guardiaprestacion " + ;
	"where codprest = pre_codprest and " + ;
	"pre_fechapasiva is null and " + ;
	"fechapasiva = ?mfecpas and " + ;
	"codserv = ser_codserv and " + ;
	"codserv = ?mcodserv " + mbusco +;
	"group by pre_descriprest " + ;
	"ORDER BY ranqueo desc, pre_descriprest", "mwkbustexto")
If mret <= 0
	Messagebox("ERROR DE LECTURA. EVOLUCION ",16,"ERROR")
	Do log_errores With Error(), Message(), mbusco, Program(), Lineno()
Endif
