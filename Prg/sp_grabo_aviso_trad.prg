*!* -------------------------------------------------------------------
*!*	Grabo el aviso de traditum (TabAvisos)
*!* -------------------------------------------------------------------
Parameter mentidad, mcontrato, mtipopac, mpresta, medtaviso, mabm, mfpasiva,linserto
 
mfpasiva = Ctod("01/01/1900")
 
jj = Int(Len(Alltrim(medtaviso))/250)+1
For i = 0 To jj
	clin = "linea" + Padl(i,3,"0")
	Public &clin
Next
If Vartype(linserto)="U"
	linserto = .F.
Endif
maviso = prg_concat(Alltrim(medtaviso))

mfecha  = DATETIME()
mfechadate = Ttod(mfecha)

mccpoamb = ''
mcampo = ""
minser = ""
mcpoupd = ''

mret = SQLExec(mcon1, "insert into TabAvisos (AV_codent, AV_codcont, " + ;
	"AV_tipopaciente, AV_prestacion ,AV_Aviso,av_fecha,av_fechaUM, " + ;
	"av_fechaPasiva &mcampo ) values " + ;
	"( ?mentidad, ?mcontrato ,?mtipopac, ?mpresta, " + maviso + ", " + ;
	"?mfechadate,?mfecha,?mfpasiva &minser )" )

For i = 0 To jj
	clin = "linea" + Padl(i,3,"0")
	Release &clin
Next
