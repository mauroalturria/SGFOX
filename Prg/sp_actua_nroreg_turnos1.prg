****
** Actualizo nro de registracio en turnos por unificacion
***

Parameter nroregistra, newregistra
mfecha 		= sp_busco_fecha_serv('DT')
musuario 	= mwkusuario.idusuario
fecnul=Ctod("01/01/1900")
Do sp_actua_nroreg_control With nroregistra, newregistra
mret = prg_ejecutosql1( "update turnos set afiliado = ?newregistra " + ;
	"where afiliado = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
Endif
mret = prg_ejecutosql1("update turnoshis set afiliado = ?newregistra " + ;
	"where afiliado = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update turnoshishis set afiliado = ?newregistra " + ;
	"where afiliado = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
Endif
mret = prg_ejecutosql1( "update turnoscancel set afiliado = ?newregistra " + ;
	"where afiliado = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
Endif
mret = prg_ejecutosql1( "update turnoscancelhis set afiliado = ?newregistra " + ;
	"where afiliado = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
Endif
mret = prg_ejecutosql1("update tabfacturas set nroregistracio = ?newregistra " + ;
	"where nroregistracio = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
Endif
mret = prg_ejecutosql1("update Tabwregistra set TWR_Registra = ?newregistra " + ;
	"where TWR_Registra = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR REGISTRO WEB, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update Zabregctgagenda set ZCA_REGISTRACION = ?newregistra " + ;
	"where ZCA_REGISTRACION = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR AGENDA CONTAGIO, AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update Zabregcontagio set RC_nroregistracio = ?newregistra " + ;
	"where RC_nroregistracio = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR REGISTRO CONTAGIO, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update Zabtltreg set TLR_Nroregistrac = ?newregistra " + ;
	"where TLR_Nroregistrac = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR GRUPO TLT, AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabEstratificacion set ZES_registracion = ?newregistra " + ;
	"where ZES_registracion = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ESTRATIFICACION, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update Zabregflia set TRF_Nroregistrac = ?newregistra " + ;
	"where TRF_Nroregistrac = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR GRUPO FAMILIAR, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update Zabregflia set TRF_NroRegFliar = ?newregistra " + ;
	"where TRF_NroRegFliar = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR GRUPO FAMILIAR, AVISAR A SISTEMAS",16, "Validacion")
Endif
mret = prg_ejecutosql1("update Zabobitos set ZO_NroRegistracio = ?newregistra " + ;
	"where ZO_NroRegistracio = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR OBITOS, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update ZabTcSalas set ZTC_registrac = ?newregistra " + ;
	"where ZTC_registrac = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR SALAS, AVISAR A SISTEMAS",16, "Validacion")
Endif
mret = prg_ejecutosql1("update ZabTcEvol set ZTE_registrac = ?newregistra " + ;
	"where ZTE_registrac = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR SALAS, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update Zabfichepncov19 set COV_Registrac = ?newregistra " + ;
	"where COV_Registrac = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR FICHA COVID, AVISAR A SISTEMAS",16, "Validacion")
Endif

mret = prg_ejecutosql1("update ZabRegReceta set RP_nroregistrac = ?newregistra " + ;
	"where RP_nroregistrac = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR RECETAS, AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabAnes set ZAn_Registracion = ?newregistra " + ;
	"where ZAn_Registracion = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR PREANESTESIA, AVISAR A SISTEMAS",16, "Validacion")
Endif

