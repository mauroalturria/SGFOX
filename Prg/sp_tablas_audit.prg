****
** Tablas para Auditoria
****
	do sp_tablas_loca_pcia
	do sp_tabla_documentos
	mret = prg_ejecutosql1("select * from planes  where id<1000 ", "mwkplanpre")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	cancel
endif

if used('entidades')
		use in entidades
endif
	mret = prg_ejecutosql1("select ENT_codent, ENT_descrient,Ent_codagrup,ENT_tipo , ENT_nroprestadorexterno from entidades " + ;
	"order by ENT_descrient", "entidades" )

