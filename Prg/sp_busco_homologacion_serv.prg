**********************************************************************
* Program....: SP_BUSCO_HOMOLOGACION_SERV.PRG
* Version....:
* Author.....: 
* Date.......: 
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A. 
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: 
* Purpose....: Homologación de Servicios
********************************************************************** 
* Busca si el servicio está homologado para ese sector

* Restringir los servicios que pueden ser seleccionados como servicio
* responsable y co-responsable para evitar que SAP rechace la generación del CECO.

Lparameters Sector

lcBuscoSector  = sector

* Busco sectores/servicios homologados por sap

ldFecPasiva = Ctod('01/01/1900')

*-- Se agrega campo CodEsp - Eduardo 15/10/2021
lcSQL = "SELECT Zabsecesp.ID, Zabsecesp.CodAmbito, Zabsecesp.Codesp, Zabsecesp.Fecpasiva, Zabsecesp.codsector, Zabsecesp.codserv,"+;
	"Servicios.SER_descripserv, Especialid.ESP_descripcion "+;
	"FROM ZabSecEsp "+;
	"INNER JOIN SERVICIOS Servicios ON  Zabsecesp.codserv = Servicios.SER_codserv "+;
	"INNER JOIN ESPECIALID Especialid ON  Zabsecesp.Codesp = Especialid.ESP_codesp "+;
	"WHERE  Zabsecesp.CodAmbito = 1 and codsector = ?lcBuscoSector and fecpasiva = ?ldFecPasiva "+;
	"ORDER BY Zabsecesp.codsector, Zabsecesp.CodAmbito, Zabsecesp.Codesp"

If !Prg_EjecutoSql(lcSQL,"mwkHomologar_sap")
	Return .F.
Endif

If !Used('mwkHomologar_sap')
	Return .F.
Endif

* Busco las especialidades
lcSQL = "SELECT * FROM tabEstados WHERE propietario = 25 and tipo = 34"
If !Prg_EjecutoSql(lcSQL,"mwkHomologar_asist")
	Return .F.
Endif

If !Used('mwkHomologar_asist')
	Return .F.
Endif


* Busco Restricciones

Create Cursor mwkHomologar (Id i(10), Descrip c(50), estado i(10), propietario i(3), subestado i(10), tipo i(3) , CodEsp C(4) )
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
  	    nCodesp  = mwkHomologar_sap.Codesp
  	    *-- Se agrega Código Especialidad para Formulario FRMADMISION47.scx (Grilla)
		Insert Into mwkHomologar (Id,Descrip,estado,propietario,subestado,tipo, Codesp ) ;
		Values (mId,mDescrip,mEstado,mPropietario,mSubestado,mTipo, nCodesp )
	Endif

	Select mwkHomologar_asist
Endscan

Select * From mwkHomologar WHERE subestado=1 Order By mwkHomologar.descrip Asc Into Cursor mwksres Readwrite 
Select * From mwkHomologar WHERE subestado=1 Order By mwkHomologar.descrip Asc Into Cursor mwkscores Readwrite 

Use In Select('mwkHomologar_asist')
Use In Select('mwkHomologar_sap')
Use In Select('mwkHomologar')