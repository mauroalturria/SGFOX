Lparameters desde,hasta,admision


madmision = Alltrim(admision)
mdesde = desde
mhasta = hasta
*madmision = '570430-7'
*desde = Ctod('01/06/2020')
*hasta = Ctod('15/07/2020')
If !Used('mwkpdfvaleslabo')
	Create Cursor mwkpdfvaleslabo (vale n,fecha d,hora c(8), admision c(12), observaciones c(30),estado n)
Endif
*!*	lcSQL = "select * from VALESASIST where VAL_codadmision = ?madmision and "+;
*!*	"val_codservvale = 7000 and  val_fechasolicitud between ?mdesde and ?mhasta"
lcSQL = "select * from VALESASIST where VAL_codadmision = ?madmision and "+;
	"val_codservvale = 7000 and val_estado = 3"
mret = SQLExec(mcon1,lcSQL,'mwkpdfvales')
If mret<0
	Return .F.
Endif
Select mwkpdfvales
Scan All
	mVale = mwkpdfvales.val_codvaleasist
	mfecha = mwkpdfvales.val_fechasolicitud
	mhora = mwkpdfvales.val_horasolicitud
	madmision = mwkpdfvales.val_codadmision
	mobserva = Nvl(mwkpdfvales.val_observaciones,'')
	mestado = 0
	Insert Into mwkpdfvaleslabo (vale,fecha,hora,admision,observaciones,estado) Values (mVale,mfecha,mhora,madmision,mobserva,mestado)
	Select mwkpdfvales
Endscan

Use In Select('mwkpdfvales')