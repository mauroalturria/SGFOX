*!* -------------------------------------------------------------------
*!*	Grabo el aviso de la entidad (TabAvisos)
*!* -------------------------------------------------------------------
parameter mentidad, mcontrato, mtipopac, mpresta, medtaviso, mabm, mfpasiva

if type('mfpasiva')#"D"
	mfpasiva = ctod("01/01/1900")
endif

jj = int(len(alltrim(medtaviso))/250)
for i = 0 to jj
	clin = "linea" + padl(i,3,"0")
	public &clin 
next

maviso = prg_concat(alltrim(medtaviso))

mfecha  = sp_busco_fecha_srv2('DT')
mfechadate = ttod(mfecha)

mret = sqlexec(mcon1, "select * from TabAvisosMarcelo " + ;
	"where AV_codent = ?mentidad and AV_codcont = ?mcontrato "+;
	"and AV_prestacion = ?mpresta" + ;
	" and AV_tipopaciente= ?mtipopac ", "mwkTabAvisos")

if mret < 0
	aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 48, "VALIDACION")
	Return .f.
endif

if reccount("mwktabavisos") > mabm
	messagebox("ALGUIEN MODIFICO EL AVISO, SE PERDERA LA MODIFICACION ANTERIOR", 48, "VALIDACION")
endif

if reccount("mwktabavisos") = 0
	mret = sqlexec(mcon1, "insert into TabAvisosMarcelo (AV_codent, AV_codcont, " + ;
		"AV_tipopaciente, AV_prestacion ,AV_Aviso,av_fecha,av_fechaUM, " + ;
		"av_fechaPasiva) values " + ;
		"( ?mentidad, ?mcontrato ,?mtipopac, ?mpresta, " + maviso + ", " + ;
		"?mfechadate,?mfecha,?mfpasiva)" )
else
	nid = mwkTabAvisos.id
	mret = sqlexec(mcon1, "update TabAvisosMarcelo set AV_Aviso = " + maviso + ", " + ;
		"av_fechaUM = ?mfecha, av_fechaPasiva = ?mfpasiva " + ;
		"where id = ?nid ")
endif

if mret < 0
	aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 48, "VALIDACION")
	Return .f.
endif

for i = 0 to jj
	clin = "linea" + padl(i,3,"0")
	release &clin 
next
