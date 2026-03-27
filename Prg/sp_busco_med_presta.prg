****
**  busco los medicos a partir de una especilidad en medpresta
****

Parameter mcodesp,mcurs,mqfecha,mfiltraCM,lsinMK
 
mfecnul  = Ctod('01/01/1900')
if vartype(mcurs)#"C"
	mcurs = 'mwkmedico2'
endif
if vartype(mqfecha)#"D"
	mqfecha = mfecturno
ENDIF
if vartype(mfiltraCM)#"N"
	mfiltraCM = 0
endif
if used(mcurs)
	use in &mcurs
endif

mcbuscoesp = ''
if vartype(mcodesp)="C"
	mcbuscoesp =" and medpresta.codesp = ?mcodesp " 
endif
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
ENDIF
If Vartype(lsinMK)="N"
	mccpoamb  = mccpoamb + " AND medpresta.usuario <> 'TURNOSMARKEY' "
Endif
IF mfiltraCM = 1
mret = SQLExec(mcon1, "select prestadores.id, prestadores.nombre,TPF_filtro,matriculas  " + ;
	"from medpresta, " + ;
	"prestadores inner join TabUbicacion "+;
	" on {fn concat({fn CONCAT(TabUbicacion.piso, TabUbicacion.descrip) },TabUbicacion.numero)} = MedPresta.sala " +  ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	"where (fecpasivap = ?mfecnul or fecpasivap > ?mqfecha ) and "+;
	"medpresta.codmed = prestadores.id and " + ;
	" medpresta.fecvigenh >= ?mqfecha  and " + ;
	" medpresta.fecvigend <> medpresta.fecvigenh and " + ;
	"(prestadores.estado = 1 or fecpasiva > ?mqfecha ) and  TabUbicacion.centromedico  = ?mxcentromedico " + ;
	mcbuscoesp + mccpoamb +;
	"group by medpresta.codmed order by nombre",mcurs)
ELSE
mret = SQLExec(mcon1, "select prestadores.id, prestadores.nombre,TPF_filtro,matriculas  " + ;
	"from medpresta, " + ;
	"prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	"where (fecpasivap = ?mfecnul or fecpasivap > ?mqfecha ) and "+;
	"medpresta.codmed = prestadores.id and " + ;
	" medpresta.fecvigenh >= ?mqfecha  and " + ;
	" medpresta.fecvigend <> medpresta.fecvigenh and " + ;
	"(prestadores.estado = 1 or fecpasiva > ?mqfecha ) " + ;
	mcbuscoesp + mccpoamb +;
	"group by medpresta.codmed order by nombre",mcurs)
endif

If mret < 1
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",48,"Validacion")
	Do prg_cancelo
Endif
