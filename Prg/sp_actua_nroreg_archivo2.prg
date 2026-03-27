****
** Actualizo nro de registracio en archivo por pasaje de consumos
***

parameter nroregistra, newregistra, mfhdes ,mfhhas ,newhclinica
mccodbarra= '*' + padl( alltrim( strtran( strtran( newhclinica, '/', '' ), '-', '' )) , 8, '0' ) + '*'

mret = sqlexec(mcon1,"select * FROM TabHCArchivo " + ;
	" where hca_registrac = ?newregistra ", "mwkaux" )
if reccount( "mwkaux" ) = 0
	mret= sqlexec(mcon1," insert into TabHCArchivo (hca_registrac, hca_codbarra, hca_reimprime " + ;
		", hca_estado, hca_motfalta, hca_orden) values ( ?newregistra , ?mccodbarra" + ;
		", 0, 0, 0 ,9999 ) " )
endif



mret = sqlexec(mcon1, "update TabHCMovct  set hcm_registrac = ?newregistra " + ;
	"where hcm_registrac = ?nroregistra " +;
	" and hcm_fechatur >=?mfhdes "+;
	" and hcm_fechatur <=?mfhhas ")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR ARCHIVO, AVISAR A SISTEMAS",16, "Validacion")
endif

mret = sqlexec(mcon1, "update TabHCMovst  set hcm_registrac = ?newregistra " + ;
	"where hcm_registrac = ?nroregistra "+;
	" and hcm_fechatur >=?mfhdes "+;
	" and hcm_fechatur <=?mfhhas ")

if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR ARCHIVO, AVISAR A SISTEMAS",16, "Validacion")
endif

mret = sqlexec(mcon1, "update TabHCHisct set hcm_registrac = ?newregistra " + ;
	"where hcm_registrac = ?nroregistra" +;
	" and hcm_fechatur >=?mfhdes "+;
	" and hcm_fechatur <=?mfhhas ")

if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR ARCHIVO, AVISAR A SISTEMAS",16, "Validacion")
endif




