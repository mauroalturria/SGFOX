****
** Actualizo nro de registracio en turnos por pasaje de consumos
***

parameter nroregistra, newregistra,mfecdes,mfechas

do sp_actua_nroreg_control with nroregistra, newregistra,mfecdes,mfechas

mret = prg_ejecutosql1("update turnos set afiliado = ?newregistra " + ;
	"where afiliado = ?nroregistra" +;
	" and fechatur>=?mfecdes "+;
	" and fechatur<=?mfechas ")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update turnoshis set afiliado = ?newregistra " + ;
	"where afiliado = ?nroregistra" +;
	" and fechatur>=?mfecdes "+;
	" and fechatur<=?mfechas ")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR TURNOS HISTORICOS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update turnoshishis set afiliado = ?newregistra " + ;
	"where afiliado = ?nroregistra" +;
	" and fechatur>=?mfecdes "+;
	" and fechatur<=?mfechas ")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR TURNOS HISTORICOS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1( "update turnoscancel set afiliado = ?newregistra " + ;
	"where afiliado = ?nroregistra" +;
	" and fechatur>=?mfecdes "+;
	" and fechatur<=?mfechas ")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
endif

mret = prg_ejecutosql1( "update tabprotocolo set tpregistrac = ?newregistra " + ;
	"where tpregistrac = ?nroregistra" +;
	" and tpfecharetiro>=?mfecdes "+;
	" and tpfecharetiro<=?mfechas ")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR TURNOS CANCELADOS , AVISAR A SISTEMAS",16, "Validacion")
endif

mfhdes = prg_dtoc(mfecdes)
mfhhas = prg_dtoc(mfechas +1)

mret = prg_ejecutosql1("update tabfacturas set nroregistracio = ?newregistra " + ;
	"where nroregistracio = ?nroregistra" +;
	" and fechahora>=?mfhdes "+;
	" and fechahora<=?mfhhas ")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1( "update Tabambonco set TAO_registracio = ?newregistra " + ;
	"where TAO_registracio = ?nroregistra"+;
	" and TAO_fturno>=?mfhdes "+;
	" and TAO_fturno<=?mfhhas ")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR tabambonco, AVISAR A SISTEMAS",16, "Validacion")
endif

mret = prg_ejecutosql1("update TabRegRCV  set TRR_registracio = ?newregistra " + ;
	"where TRR_registracio = ?nroregistra"+;
	" and TRR_fechah >=?mfhdes "+;
	" and TRR_fechah <=?mfhhas ")
	

if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR REGISTRO RCV, AVISAR A SISTEMAS",16, "Validacion")
endif


