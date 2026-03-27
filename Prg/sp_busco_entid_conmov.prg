parameters mfechaDesde,mfechaHasta
****
** busca las  entidades
****

mret = sqlexec(mcon1,"Select ENT_descrient,ent_codent,ent_capita,ENT_nroprestadorexterno,ent_codagrup "+;
	"from entidades order by  ent_descrient","mwkentid")
if mret < 0
	messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE', 16,'Validacion')
	do prg_cancelo
endif
