Parameters admision,dnipac,vale,fecha

ldfechaadmi = fecha
lcadmi = admision
lnvalelog = vale

* Verificamos DNI
msigo = .T.
Do Case
Case  Vartype(dnipac)='C'
	lndnipac = Int(Val(dnipac))
Case Vartype(dnipac)='N'
	lndnipac = dnipac
Otherwise
	msigo = .F.
Endcase

If !msigo
	Return .F.
Endif

* Datos de Registración del paciente
lcsql = "SELECT * FROM REGISTRACIO WHERE REG_numdocumento = ?lndnipac order by reg_nroregistrac desc"
mret = SQLExec(mcon1,lcsql,'mwkpamipacreg')

* Cursor ValeLog
Create Cursor mwkValeLog (vale N)
Insert Into mwkValeLog (vale) Values (lnvalelog)

* Cursor Log
Create Cursor mwkPamiLog (vale N, fecha d, admision c(10), dni N, mailmedico N, mailpaciente N, labo N, rx N, ecg N, ecodop N)

lcsql = 'Select * from zabmedcabecera where NroDocuPac = ?lndnipac'
mret = SQLExec(mcon1,lcsql,'mwkpamicabecera')
Select mwkpamicabecera
lnmailpac = 0
lnmaildoc = 0
lcmailpac = Nvl(Lower(Alltrim(mwkpamicabecera.zmc_emailpac)),'')
lcmaildoc = Lower(Alltrim(mwkpamicabecera.email))
If Empty(lcmaildoc) Or ! '@' $ lcmaildoc
	lnmaildoc = 2
Endif
Create Cursor mwkmaildepac (email c(50))
If Empty(lcmailpac) Or ! '@' $ lcmailpac
	lnmailpac = 2
Else
* Para manual
	lcmailpac = Alltrim(lcmailpac)
	Insert Into mwkmaildepac (email) Values (lcmailpac)
	lnmailpac = 0
Endif


Select mwkPamiLog
Insert Into mwkPamiLog (vale,fecha,admision,dni,mailmedico,mailpaciente) Values (lnvalelog,ldfechaadmi,lcadmi,lndnipac,lnmaildoc,lndnipac)

Do prg_pami_vales With lcadmi

If !Used('mwkpamivales')
	Return .F.
Endif

If !Reccount('mwkpamivales')>0
	Return .F.
Endif

* Acceso a Datos
If Used('mwkusuario')
	musu = mwkusuario.Id
Else
	musu = 0
Endif
mid = 1
mreg = mwkpamipacreg.reg_nroregistrac
mtitulo = Alltrim(mwkexe.nomexe)+" - PAMI - Chequeate en casa"
miususec = ""
Do sp_insert_tabaccesodatos With Alltrim(Upper(miususec)),mid,mreg,mtitulo,musu,16


* Derivaciones
Create Cursor mwkpamipdf (archivo c(50), vale N)
Select mwkpamivales
minicio = 0
minicio = mwkpamivales.vale
Scan All
	mvale = mwkpamivales.vale
	mcodserv = mwkpamivales.nroserv
	madmision = Alltrim(mwkpamivales.admision)
	mtipopac = Alltrim(mwkpamivales.tipopac)
	marchivo = ''
	Do Case
	Case Inlist(mcodserv,6400,7000) && Bacteriología y Laboratorio
		marchivo = prg_pami_labo (mvale)
	Case Inlist(mcodserv,2200,5180,7100,7300,7400,7700,7900,5163,4403,4100,9100) && Imágenes
		marchivo = prg_pami_informe (mvale)
	Case Inlist(mcodserv,4402,7200,7300,7400) && Ergo,Electro,Holter
		marchivo = prg_pami_informeadd (mvale)
	Endcase
	lnlabo = 0
	lnrx = 0
	lnecodop = 0
	lnecg = 0
	If !Empty(marchivo)
		Insert Into mwkpamipdf (archivo,vale) Values (marchivo,mvale)
		Select mwkValeLog
		lnvalelog = mwkValeLog.vale
		Select mwkPamiLog
		Do Case
		Case mcodserv = 7000
			Update mwkPamiLog Set labo =1 Where vale = lnvalelog
		Case mcodserv = 7100
			Update mwkPamiLog Set rx =1 Where vale = lnvalelog
		Case mcodserv = 7200
			Update mwkPamiLog Set ecg =1 Where vale = lnvalelog
		Case mcodserv = 7400
			Update mwkPamiLog Set ecodop =1 Where vale = lnvalelog
		Endcase
	Endif
	Select mwkpamivales
Endscan

If Reccount('mwkpamipdf')>0
	Do prg_pami_pdf

* Grabo Log
	mv1 = ''
	mv2 = 0
	mv3 = 0
	mv4 = Ctod('//')
	mv5 = 0
	mv6 = 0
	mv7 = 0
	mv8 = 0
	mv9 = 0
	mv10 = Ctod('//')


	Select mwkValeLog
	mvalelog = mwkValeLog.vale
	Select mwkPamiLog
	mv1 = Alltrim(mwkPamiLog.admision)
	mv2 = mwkPamiLog.dni
	mv3 = mwkPamiLog.mailmedico
	mv4 = sp_busco_fecha_serv('DT')
	mv5 = mwkPamiLog.vale
	mv6 = mwkPamiLog.labo
	mv7 = mwkPamiLog.rx
	mv8 = mwkPamiLog.ecg
	mv9 = mwkPamiLog.ecodop
	mv10 = mwkPamiLog.fecha
	lcsql = 'select * from zabcheckpami where chp_vale = ?mv5'
	mret = SQLExec(mcon1,lcsql,'mwkcheckpami')
	If mret < 0
		Return .F.
	Endif
	Select mwkcheckpami
	lcsql = ''
	If Reccount('mwkcheckpami')>0
		lcsql = 'update zabcheckpami set chp_admision = ?mv1,'+;
			'chp_dni = ?mv2 , chp_fechaenvio = ?mv4,chp_vale = ?mv5,'+;
			'chp_pdflabo=?mv6,chp_pdfrx=?mv7,chp_pdfelectro=?mv8,chp_doppler=?mv9,chp_fechaadmision=?mv10 '+;
			'Where chp_vale = ?mvalelog'
	Else
		lcsql = 'insert into zabcheckpami (chp_admision,chp_dni,chp_fechaenvio,chp_vale,'+;
			'chp_pdflabo,chp_pdfrx,chp_pdfelectro,chp_doppler,chp_fechaadmision)'+;
			'values (?mv1,?mv2,?mv4,?mv5,?mv6,?mv7,?mv8,?mv9,?mv10)'
	Endif

	mret = SQLExec(mcon1,lcsql,'')
	If mret<0
		Messagebox('Error en la grabación')
	Endif

Endif