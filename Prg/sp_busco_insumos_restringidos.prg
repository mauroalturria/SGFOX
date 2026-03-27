****
** Pedido de insumos todos o por descripcion
****

parameters mtipo,ccursor
if vartype(ccursor)#"C"
	ccursor=  "mwkbustexto"
Endif
mbusco = ''
if vartype(mtipo)="N"
	mbusco = ' and TIR_tipo = ?mtipo '
Endif
mret = sqlexec(mcon1,"select INS_descriinsumo, INS_codinsumo, INS_grupo, "+;
	"insumos.insumos, INS_CODPUNTERO ,INS_MedSensi, INS_DDD, INS_UniDDD,INS_Contenido " + ;
	"from TabInsRestriccion inner join insumos on TIR_codpuntero = INS_CODPUNTERO " + ;
	"where INS_fechapasivo is null and TIR_fecpasiva = '1900-01-01' " + mbusco +;
	"order by INS_descriinsumo",ccursor)

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "Err buscotextoinsumo"
	cancel
endif
