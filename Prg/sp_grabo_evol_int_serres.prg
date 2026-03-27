*!*	servicio a cargo
Parameters  mISidevol, mimedcab,mcodadmision,mchclin,mdiagno,lareacerrada
If Vartype(lareacerrada)<>"N"
	lareacerrada=0
Endif
mfechahora  = sp_busco_fecha_serv("DT")
mfechadia = Ttod(mfechahora )
mfecini = Ctod("01/01/1900")
mfecfin = Ctod("01/01/2100")
mret = SQLExec(mcon1, "select TabIntServ.id from TabIntServ  "+ ;
" inner join TabintHCE on  tabintHCE.id = TabIntServ.IS_idevol " + ;
" where tabintHCE.IH_admision = ?mcodadmision ", "mkwctrsrSAP")
Select mwkservires
lservresp= .F.
If myip='172.16.1.7'
	Set Step On
Endif

Select * From mwkservires Where Id = 1 Into Cursor mwksernew
If Reccount('mwksernew')>0 &&&anulo todos
	lcSql =  "update TabIntServ set IS_fechaHH = ?mfechadia where IS_idevol = ?mISidevol and"+;
	"   IS_responsable = 1 and IS_fechaHH =?mfecfin "
	If !Prg_EjecutoSql(lcSql,'',.F.)
*			return .f.
	Endif

	Select mwksernew
	GO top
	miserv = IS_servicio
	mifecd = IS_fechaHD
	mifech = IS_fechaHH
	msg = Nvl(mwkinterna.IH_secagrup,'')
	mret = SQLExec(mcon1, "select * from TabIntServ where IS_idevol = ?mISidevol and  IS_secagrup = ?msg and IS_responsable = 1  ","mkwctrsr")
	If Reccount("mkwctrsr") = 0
		lcSql  = "insert into TabIntServ (IS_codmed , IS_fechaHD , IS_fechaHH , IS_idevol , IS_responsable , IS_secagrup , IS_servicio  ) "+;
		" values(?mimedcab, ?mifecd, ?mifech, ?mISidevol,1,'',?miserv )"
		If !Prg_EjecutoSql(lcSql,'',.F.)
*			return .f.
		Endif
	Endif
Endif


&& Servicio co responsable
Select mwkservicresg
Scan
	miserv = IS_servicio
	mifecd = IS_fechaHD
	mifech = IS_fechaHH
	mtres = IS_responsable
	If !lservresp Or lareacerrada = 1
		Select mwkServEspec
		Locate For NroServicio = miserv
	Endif
	msg = Nvl(mwkinterna.IH_secagrup,'')
	mret = SQLExec(mcon1, "select * from TabIntServ where IS_idevol = ?mISidevol and IS_responsable = ?mtres  and IS_servicio = ?miserv "+;
	" and IS_fechaHD = ?mifecd ","mkwctrsr")
	If Reccount("mkwctrsr") = 0
		lcSql = "insert into TabIntServ (IS_codmed , IS_fechaHD , IS_fechaHH , IS_idevol , IS_responsable , IS_secagrup , IS_servicio  ) "+;
		" values(?mimedcab, ?mifecd, ?mifech, ?mISidevol,2,'',?miserv )"
		If !Prg_EjecutoSql(lcSql,'',.F.)
*			return .f.
		Endif

	Else
		If mifech = mfechadia
			mid = mkwctrsr.Id
			lcSql = "update TabIntServ set IS_fechaHH = ?mfechadia where id = ?mid"
			If !Prg_EjecutoSql(lcSql,'',.F.)
*			return .f.
			Endif
		Endif
	Endif
Endscan
If Used("mkwctrsrSAP")
	mespec = Iif(lareacerrada=1,mwkServEspec.Codesp,mwkServEspec.Codesp)
	If Reccount("mkwctrsrSAP") = 0
		Do cws_admision With "INT",mchclin,mcodadmision,mdiagno,mespec,1,,,mimedcab
		Do cws_traslado_alta With 1, mcodadmision,"9",mespec,,,,,mimedcab
	Else
		Do cws_traslado With 1, mcodadmision,"9",mespec,,,,,mimedcab
	Endif
	Use In Select('mkwctrsrSAP')
Endif

