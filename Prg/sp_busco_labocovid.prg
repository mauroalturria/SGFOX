Lparameters desde,hasta,admision

madmision = Alltrim(admision)
mdesde = desde
mhasta = hasta
*madmision = '570430-7'
*desde = Ctod('01/06/2020')
*hasta = Ctod('15/07/2020')

Create Cursor mwkcovidpdfvaleslabo (nrovale N)
lcSQL = "select * from VALESASIST where VAL_codadmision = ?madmision and "+;
	"val_codmnemoserv = 'LA' and  val_fechasolicitud between ?mdesde and ?mhasta"
mret = SQLExec(mcon1,lcSQL,'mwkcovidpdfvales')
If mret<0
	Return .F.
Endif
Select mwkcovidpdfvales
Scan All
	mVale = mwkcovidpdfvales.val_codvaleasist
	mValebusco = mwkcovidpdfvales.val_codpun
	lcSQL = "select * from PRESINSUVAS where PIA_VALESASIST = ?mValebusco  and PIA_codprest = 10958"
	mret2=SQLExec(mcon1,lcSQL,'mwkcovidpdfpresta')
	If mret2<0
		Return .F.
	Endif
	Select mwkcovidpdfpresta
	If Reccount('mwkcovidpdfpresta')>0
		Insert Into mwkcovidpdfvaleslabo (nrovale) Values (mVale)
	Endif
	Select mwkcovidpdfvales
Endscan

