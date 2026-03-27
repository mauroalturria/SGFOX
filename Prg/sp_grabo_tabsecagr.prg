*!* -------------------------------------------------------------------
*!*	Grabo tabsecagrup
*!* -------------------------------------------------------------------
parameter msector,magrup1,magrup3,magrup4
mfhasta = ctod("01/01/2100")
mhoy = sp_busco_fecha_serv("DD")
  
mret = sqlexec(mcon1, "select id from Tabsecagrup " + ;
	" where TSA_Sector = ?msector and TSA_Tipo = 1"+;
	" and TSA_FechaHasta = ?mfhasta " , "mwkcontrola")

if mret < 0
	aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 48, "VALIDACION")
	Return .f.
endif

if reccount("mwkcontrola") = 0 
	mret = sqlexec(mcon1, "insert into Tabsecagrup (TSA_Agrupa, TSA_FechaDesde, TSA_FechaHasta, TSA_Sector, TSA_Tipo) " + ;
		" values ( ?magrup1, ?mhoy ,?mfhasta , ?msector,1 )" )
else
	nid = mwkcontrola.id
	mret = sqlexec(mcon1, "update Tabsecagrup set TSA_Agrupa = ?magrup1 " + ;
		" where id = ?nid ")
ENDIF

mret = sqlexec(mcon1, "select id from Tabsecagrup " + ;
	" where TSA_Sector = ?msector and TSA_Tipo = 3"+;
	" and TSA_FechaHasta = ?mfhasta " , "mwkcontrola")

if mret < 0
	aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 48, "VALIDACION")
	Return .f.
endif

if reccount("mwkcontrola") = 0 
	mret = sqlexec(mcon1, "insert into Tabsecagrup (TSA_Agrupa, TSA_FechaDesde, TSA_FechaHasta, TSA_Sector, TSA_Tipo) " + ;
		" values ( ?magrup3, ?mhoy ,?mfhasta , ?msector,3 )" )
else
	nid = mwkcontrola.id
	mret = sqlexec(mcon1, "update Tabsecagrup set TSA_Agrupa = ?magrup3 " + ;
		" where id = ?nid ")
endif

if mret < 0
	aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 48, "VALIDACION")
	Return .f.
endif


mret = sqlexec(mcon1, "select id from Tabsecagrup " + ;
	" where TSA_Sector = ?msector and TSA_Tipo = 4 "+;
	" and TSA_FechaHasta = ?mfhasta " , "mwkcontrola")

if mret < 0
	aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 48, "VALIDACION")
	Return .f.
endif

if reccount("mwkcontrola") = 0 
	mret = sqlexec(mcon1, "insert into Tabsecagrup (TSA_Agrupa, TSA_FechaDesde, TSA_FechaHasta, TSA_Sector, TSA_Tipo) " + ;
		" values ( ?magrup4, ?mhoy ,?mfhasta , ?msector,4 )" )
else
	nid = mwkcontrola.id
	mret = sqlexec(mcon1, "update Tabsecagrup set TSA_Agrupa = ?magrup4 " + ;
		" where id = ?nid ")
endif
if mret < 0
	aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 48, "VALIDACION")
	Return .f.
endif
