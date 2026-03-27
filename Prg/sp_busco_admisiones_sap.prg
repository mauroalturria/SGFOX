Lparameters win

* Armo las admisiones que se necesitan para procesar las HCE en pdf desde el excel que emite SAP 
* Modificado 2021/'07

mwin = win && para buscar copias de archivos generadas por windows

* Enumero las admisiones

Create Cursor mwkadmisiones (hc c(15),nombre c(50), admision c(8), desde d, hasta d, estado N, entidad N, nroadmi N, factura c(20), siniestro c(10))

Select mwkexcel
Scan All
	lnombre = Alltrim(mwkexcel.nombre)
	ladmision = Alltrim(mwkexcel.admision)
	lhc = Alltrim(mwkexcel.hc)
	ldesde = mwkexcel.desde
	lhasta = mwkexcel.hasta
	lestado = mwkexcel.estado
	lentidad = mwkexcel.entidad
	lnroadmi = 0
	lfact = Alltrim(mwkexcel.factura)
	lsiniestro = Alltrim(mwkexcel.siniestro)
	Insert Into mwkadmisiones (nombre,admision,hc,desde,hasta,estado,entidad,nroadmi,factura,siniestro) Values (lnombre,ladmision,;
		lhc,ldesde,lhasta,lestado,lentidad,lnroadmi,lfact,lsiniestro)
	Select mwkexcel
Endscan

Select mwkadmisiones
mcant = 0
mAdmisionBack = ''
Scan All
	madmision = mwkadmisiones.admision
	If Empty(mAdmisionBack)  Or mAdmisionBack = madmision
	Else
		mcant = mcant + 1
	Endif
	Replace mwkadmisiones.nroadmi With mcant
	mAdmisionBack = madmision
Endscan

* Proceso fechas desde-hasta

Create Cursor mwkadmisiones3 (hc c(15),nombre c(50), admision c(8), desde d, hasta d, estado N, entidad N, nroadmi N, archivopdf c(20),factura c(20),siniestro c(15))
Select mwkadmisiones
Scan All
	mnroadmi = mwkadmisiones.nroadmi
	Select * From mwkadmisiones Where nroadmi = mnroadmi Order By desde Asc Into Cursor mwkadmisiones2
	Select mwkadmisiones2
	mhc = mwkadmisiones2.hc
	mnombre = Alltrim(mwkadmisiones2.nombre)
	madmision = Alltrim(mwkadmisiones2.admision)
	mdesde = mwkadmisiones2.desde
	mestado = mwkadmisiones2.estado
	mentidad = mwkadmisiones2.entidad
	mnroadmi = mwkadmisiones2.nroadmi
	Go Bottom In 'mwkadmisiones2'
	mhasta = mwkadmisiones2.hasta
	mnombrearchivo = ''
	mfact = mwkadmisiones2.factura
	msiniestro = mwkadmisiones2.siniestro
	Insert Into mwkadmisiones3 (nombre,admision,hc,desde,hasta,estado,entidad,nroadmi,archivopdf,factura,siniestro) Values (mnombre,madmision,;
		mhc,mdesde,mhasta,mestado,mentidad,mnroadmi,mnombrearchivo,mfact,msiniestro)
	Select mwkadmisiones
Endscan

* Genero nombre archivo según la cantidad de admisiones

Select * From mwkadmisiones3 Group By nroadmi Into Cursor mwkadmisiones4 Readwrite
Select * From mwkadmisiones4 Group By admision Into Cursor mwkadmisiones5 Readwrite
Select  mwkadmisiones5
Scan All
	madmision = Alltrim(mwkadmisiones5.admision)
	Select * From mwkadmisiones4 Where admision = madmision Into Cursor mwkadmisiones6 Readwrite
	Select mwkadmisiones6
	mext = 1
	If mwin
	mext = 2
	Endif
	mrecord = 0
	Select mwkadmisiones6
	Scan All
		morden = mwkadmisiones6.nroadmi
		If mrecord > 0
			If mwin
			mnroadmi = Alltrim(mwkadmisiones6.admision) + ' (' + Alltrim(Str(mext)) + ')'
			Else
			mnroadmi = Alltrim(mwkadmisiones6.admision) + '-' + Alltrim(Str(mext))
			Endif
			Update mwkadmisiones4 Set archivopdf = mnroadmi Where nroadmi = morden
			mext = mext + 1
		Else
			mnroadmi = Alltrim(mwkadmisiones6.admision)
			Update mwkadmisiones4 Set archivopdf = mnroadmi Where nroadmi = morden
		Endif
		mrecord = mrecord + 1
		Select mwkadmisiones6
	Endscan
	Select mwkadmisiones5
Endscan

Select * From mwkadmisiones4 Order By nombre Asc Into Cursor mwkadmisiones Readwrite

Use In Select('mwkadmisiones2')
Use In Select('mwkadmisiones3')
Use In Select('mwkadmisiones4')
Use In Select('mwkadmisiones5')
Use In Select('mwkadmisiones6')
