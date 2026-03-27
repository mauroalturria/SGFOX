* Homologación de Servicios

* Busca si el servicio está homologado para ese sector

* Restringir los servicios que pueden ser seleccionados como servicio
* responsable y co-responsable para evitar que SAP rechace la generación del CECO.

Lparameters Sector

lcBuscoSector  = sector

* Busco sectores/servicios homologados por sap

ldFecPasiva = Ctod('01/01/1900')

lcSQL = "SELECT Zabsecesp.ID, Zabsecesp.CodAmbito, Zabsecesp.Codesp,"+;
	"Zabsecesp.Fecpasiva, Zabsecesp.codsector, Zabsecesp.codserv,"+;
	"Servicios.SER_descripserv, Especialid.ESP_descripcion "+;
	"FROM "+;
	"ZabSecEsp "+;
	"INNER JOIN SERVICIOS Servicios "+;
	"ON  Zabsecesp.codserv = Servicios.SER_codserv "+;
	"INNER JOIN SQLUser.ESPECIALID Especialid "+;
	"ON  Zabsecesp.Codesp = Especialid.ESP_codesp "+;
	"WHERE  Zabsecesp.CodAmbito = 1 and codsector = ?lcBuscoSector and fecpasiva = ?ldFecPasiva "+;
	"ORDER BY Zabsecesp.codsector, Zabsecesp.CodAmbito, Zabsecesp.Codesp"

If !Prg_EjecutoSql(lcSQL,"mwkHomologar_sap")
	Return .F.
Endif

If !Used('mwkHomologar_sap')
	Return .F.
Endif


* Busco las especialidades

lcSQL = "select * from tabestados where propietario = 25 and tipo = 34"
If !Prg_EjecutoSql(lcSQL,"mwkHomologar_asist")
	Return .F.
Endif

If !Used('mwkHomologar_asist')
	Return .F.
Endif


* Busco Restricciones

Create Cursor mwkHomologar (Id i(10), Descrip c(50), estado i(10), propietario i(3), subestado i(10), tipo i(3))
Insert Into mwkHomologar (Id,Descrip,estado,propietario,subestado,tipo) Values (2390,'',0,25,1,34)

Select mwkHomologar_asist

Scan All

	mId = mwkHomologar_asist.Id
	mDescrip = Alltrim(mwkHomologar_asist.Descrip)
	mEstado = mwkHomologar_asist.estado
	mPropietario = mwkHomologar_asist.propietario
	mSubestado = mwkHomologar_asist.subestado
	mTipo = mwkHomologar_asist.tipo

	Select mwkHomologar_sap
	Locate For Alltrim(mwkHomologar_sap.Esp_Descripcion) = mDescrip
	If Found('mwkHomologar_sap')
		Insert Into mwkHomologar (Id,Descrip,estado,propietario,subestado,tipo) Values (mId,mDescrip,mEstado,mPropietario,mSubestado,mTipo)
	Endif

	Select mwkHomologar_asist
Endscan

Select * From mwkHomologar Order By mwkHomologar.descrip Asc Into Cursor mwksres Readwrite 
Select * From mwkHomologar Order By mwkHomologar.descrip Asc Into Cursor mwkscores Readwrite 

Use In Select('mwkHomologar_asist')
Use In Select('mwkHomologar_sap')
Use In Select('mwkHomologar')