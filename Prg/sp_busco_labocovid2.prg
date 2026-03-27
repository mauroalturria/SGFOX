Lparameters desde,hasta,admision

madmision = Alltrim(admision)
mdesde = desde
mhasta = hasta
*madmision = '570430-7'
*desde = Ctod('01/06/2020')
*hasta = Ctod('15/07/2020')
If !Used('mwkcovidpdfvaleslabo')
	Create Cursor mwkcovidpdfvaleslabo (vale N, fecha d, hora c(8) , admision c(15), observaciones c(50), estado N)
Endif
lcSQL = "select * from VALESASIST where VAL_codadmision = ?madmision and "+;
	"val_codservvale = 7000 and  val_estado=3"
mret = SQLExec(mcon1,lcSQL,'mwkcovidpdfvales')
If mret<0
	Return .F.
Endif
Select mwkcovidpdfvales
Scan All
	mVale = mwkcovidpdfvales.val_codvaleasist
	mValebusco = mwkcovidpdfvales.val_codpun
	mfecha = mwkcovidpdfvales.val_fechasolicitud
	mhora = mwkcovidpdfvales.val_horasolicitud
	madmision = mwkcovidpdfvales.val_codadmision
	mobserva = Nvl(mwkcovidpdfvales.val_observaciones,'')
	mestado = 0
	lcSQL = "select * from PRESINSUVAS where PIA_VALESASIST = ?mValebusco  and PIA_codprest = 10958"
	mret2=SQLExec(mcon1,lcSQL,'mwkcovidpdfpresta')
	If mret2<0
		Return .F.
	Endif
	Select mwkcovidpdfpresta
	If Reccount('mwkcovidpdfpresta')>0
		Insert Into mwkcovidpdfvaleslabo (vale,fecha,hora,admision,observaciones,estado) Values (mVale,mfecha,mhora,madmision,mobserva,mestado)
	Endif
	Select mwkcovidpdfvales
Endscan

Use In Select('mwkcovidpdfvales')