Parameters dato1,dato2,dato3,dato4

mcodesp        = dato1
mcodprest      = dato2
mcodmed       = dato3
mtipoconsulta = dato4
mPasiva    = Ctod('01/01/1900')
mhaydatos = 0

lcSql  = "select * from ZabWsMsgReg "+;
	"where ZWN_fechapasiva = ?mPasiva and ZWN_tipmsg = ?mtipoconsulta and "+;
	"(ZWN_codesp = ?mCodEsp or ZWN_codmed = ?mCodMed or ZWN_codprest = ?mCodPres)"
mret = SQLExec(mcon1,lcSql,'mwkWsMsgReg')
If mret<0
	Messagebox('Error en mwkWsMsgReg',48,'AVISO')
	Return .F.
Endif

Select mwkWsMsgReg
Go Top In 'mwkWsMsgReg'

Do While !Eof('mwkWsMsgReg') Or mhaydatos = 0

	If Eof()
		Exit
	Endif

	lcodesp   = Alltrim(mwkWsMsgReg.ZWN_codesp)
	lcodmed  = mwkWsMsgReg.ZWN_codmed
	lcodprest = mwkWsMsgReg.ZWN_codprest

	If lcodesp = mcodesp And lcodmed = 0 And lcodprest = 0
* Solo especialidad
		mhaydatos = 1
	Endif

	If lcodesp = '' And lcodmed = mcodmed And lcodprest = 0
* Solo medico
		mhaydatos = 1
	Endif

	If lcodesp = '' And lcodmed = 0 And lcodprest = mcodprest
* Solo prestacion
		mhaydatos = 1
	Endif

	If lcodesp = mcodesp And lcodmed = mcodmed And lcodprest = 0
* Especialidad y Medico
		mhaydatos = 1
	Endif

	If lcodesp = mcodesp And lcodmed = 0 And lcodprest = mcodprest
* Especialidad y prestacion
		mhaydatos = 1
	Endif

	If lcodesp = mcodesp And lcodmed = mcodmed And lcodprest = mcodprest
* Especialidad, medico y prestacion
		mhaydatos = 1
	Endif

	If lcodesp = '' And lcodmed = mcodmed And lcodprest = mcodprest
* Medico y prestacion
		mhaydatos = 1
	Endif

	If !Eof('mwkWsMsgReg')
		Skip
	Endif

	Loop

Enddo

Use In Select('mwkWsMsgReg')

If mhaydatos = 1
	Return .T.
Else
	Return .F.
Endif
