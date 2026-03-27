****
** Pedido de prestaciones Vales Demanda Espontanea para guardia
****

Parameters mctexto

mfecpas = Ctod('01/01/1900')
If Used("mwkbustexto")
	Use In mwkbustexto
Endif

mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona   " + ;
	",pre_duracion as PA_duracion, "+;
	" Pre_retiroestudios as PA_retiroestudios, ser_codserv "+;
	',PRE_EdadDesde, PRE_EdadHasta '+;
	"FROM prestacions, servicios, guardiaprestacion " + ;
	"where guardiaprestacion.fechapasiva = ?mfecpas and " + ;
	"guardiaprestacion.codprest = pre_codprest and " + ;
	"pre_codservicio = ser_codserv and " + ;
	"pre_descriprest LIKE '%&mctexto%' " + ;
	"group by pre_codprest " + ;
	"ORDER BY pre_descriprest", "mwkbustexto")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	Do sp_desconexion With "sp_busco_texto_prestacion_guardia"
	Cancel
Endif
