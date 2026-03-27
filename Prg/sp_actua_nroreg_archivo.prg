****
** Actualizo nro de registracio en archivo por unificacion
***

Parameter nroregistra, newregistra, newhclinica

mccodbarra= '*' + padl( alltrim( strtran( strtran( newhclinica, '/', '' ), '-', '' )) , 8, '0' ) + '*'

If used('mwkaux2')
	Use in mwkaux2
Endif

mfecnull = ctot("01/01/1900")
mfecactu = mfecnull

mret = prg_ejecutosql1("select * FROM TabHCArchivo " + ;
	" where hca_registrac = ?nroregistra ", "mwkaux2" )

If used('mwkaux2')
	If reccount('mwkaux2') > 0
		mfecactu = mwkaux2.hca_fechaInic
	Endif
	Use in mwkaux2
Endif

mret = prg_ejecutosql1("delete FROM TabHCArchivo " + ;
	" where hca_registrac = ?nroregistra")

If mret < 0
	Messagebox("EN ELIMINACION DE ARCHIVO H.C., AVISAR A SISTEMAS",16, "ERROR")
	Return
Endif

mret = prg_ejecutosql1("select * FROM TabHCArchivo " + ;
	" where hca_registrac = ?newregistra ", "mwkaux" )

If reccount( "mwkaux" ) = 0

	mret = prg_ejecutosql1(" insert into TabHCArchivo (hca_registrac, hca_codbarra, hca_reimprime " + ;
		", hca_estado, hca_motfalta, hca_orden, hca_fechaInic) values ( ?newregistra , ?mccodbarra" + ;
		", 0, 0, 0 ,9999, ?mfecactu ) " )

Else
	If mfecactu < mwkaux.hca_fechaInic and mfecactu <> mfecnull

		mret = prg_ejecutosql1("update TabHCArchivo set hca_fechaInic = ?mfecactu"+;
			" where hca_registrac = ?newregistra")

	Endif
Endif

If mret < 0
	=aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ARCHIVO, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update TabHCMovct  set hcm_registrac = ?newregistra " + ;
	"where hcm_registrac = ?nroregistra")
If mret < 0
	=aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ARCHIVO, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update TabHCMovst  set hcm_registrac = ?newregistra " + ;
	"where hcm_registrac = ?nroregistra")
If mret < 0
	=aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ARCHIVO, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update TabHCHisct set hcm_registrac = ?newregistra " + ;
	"where hcm_registrac = ?nroregistra")
If mret < 0
	=aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ARCHIVO, AVISAR A SISTEMAS",16, "Validacion")
Endif
* Archivo de internados

mret = prg_ejecutosql1(" UPDATE tabhciarchivo SET hca_registrac =?newregistra " +;
	" WHERE hca_registrac = ?nroregistra ")
If mret < 0
	=aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ARCHIVO, AVISAR A SISTEMAS",16, "Validacion")
Endif
mret = prg_ejecutosql1(" UPDATE  tabhcimovst SET hcmnrohcli =?newhclinica,"+;
	" hcmregistrac =?newregistra WHERE hcmregistrac = ?nroregistra  ")
If mret < 0
	=aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ARCHIVO, AVISAR A SISTEMAS",16, "Validacion")
Endif
