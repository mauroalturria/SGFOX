****
** busco prestaciones por servicio
****

parameter mcodserv, mbusco

mfecpas = ctod('01/01/1900')
if vartype(mbusco)#"C"	
	mbusco = ""
endif
mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest, pre_codservicio, ranqueo,nivel,PRE_TipoMuestra " + ;
	"FROM prestacions, guardiaprestacion " + ;
	"where pre_codservicio = ?mcodserv and " + ;
	"pre_automatica = 'N' and " + ;
	"pre_fechapasiva is null and " + ;
	"pre_codprest not in(select codprest from guardiaprestacion " + ;
	"where codserv = ?mcodserv and " + ;
	"fechapasiva = ?mfecpas) " + mbusco +;
	"group by pre_codprest " + ;
	"ORDER BY ranqueo desc, pre_descriprest", "mwkbustexto")

mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest, pre_codservicio, ranqueo,nivel,PRE_TipoMuestra " + ;
	"FROM guardiaprestacion, prestacions " + ;
	"where codprest = pre_codprest and " + ;
	"codserv = ?mcodserv and " + ;
	"fechapasiva = ?mfecpas " + mbusco +;
	"ORDER BY ranqueo desc, pre_descriprest", "mwkbustexto1")


if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 48, "Validacion")
	cancel
endif
