****
** busco prestaciones por servicio y nemonico
****

Parameter mcodprest

mfecpas = Ctod('01/01/1900')

mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad  " + ;
	",pre_duracion as PA_duracion, "+;
	" Pre_retiroestudios as PA_retiroestudios "+;
	',PRE_EdadDesde, PRE_EdadHasta '+;
	"FROM prestacions, servicios, guardiaprestacion " + ;
	"where codprest = pre_codprest and " + ;
	"fechapasiva = ?mfecpas and " + ;
	"pre_fechapasiva is null and " + ;
	"pre_codservicio = ser_codserv and " + ;
	"pre_codprest = ?mcodprest " + ;
	"group by pre_codprest " + ;
	"ORDER BY pre_codprest", "mwkbustexto")

