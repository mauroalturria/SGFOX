****
** busco prestaciones por servicio
****

parameter mcodins

mfecpas = ctod('01/01/1900')

mret = sqlexec(mcon1,"select INS_descriinsumo, INS_codinsumo, INS_grupo, insumos " + ;
	"from insumos " + ;
	"where INS_fechapasivo is null and " + ;
	"insumos in(select codinsumo from guardiainsumos " + ;
	"where fechapasiva = ?mfecpas) " + ;
	"order by INS_grupo, INS_descriinsumo ", "mwkbustexto")


if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 48, "Validacion")
	cancel
endif
