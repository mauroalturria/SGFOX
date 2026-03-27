**********************************************************************
 * Busca si el servicio está homologado para ese sector

* Restringir los servicios que pueden ser seleccionados como servicio
* responsable y co-responsable para evitar que SAP rechace la generación del CECO.

Lparameters Sectorag ,mtipo
misec = Sectorag 
 mtipoag = mtipo
ldFecPasiva = Ctod('01/01/1900')

*-- Se agrega campo CodEsp - Eduardo 15/10/2021
lcSQL = "SELECT Zabsecesp.ID, Zabsecesp.CodAmbito, Zabsecesp.Codesp, Zabsecesp.Fecpasiva, Zabsecesp.codsector, Zabsecesp.codserv,"+;
	"Servicios.SER_descripserv, Especialid.ESP_descripcion "+;
	"FROM ZabSecEsp "+;
	"INNER JOIN SERVICIOS Servicios ON  Zabsecesp.codserv = Servicios.SER_codserv "+;
	"INNER JOIN ESPECIALID Especialid ON  Zabsecesp.Codesp = Especialid.ESP_codesp "+;
	"WHERE  Zabsecesp.CodAmbito = 1 and codsector in (select TSA_Sector FROM Tabagrup,Tabsecagrup "+;
	" WHERE  TSA_Agrupa = Tabagrup.ID AND TSA_Tipo = ?mtipoag  AND  AGS_secagrup= ?misec  ) and fecpasiva = ?ldFecPasiva "+;
	"ORDER BY Zabsecesp.codsector, Zabsecesp.CodAmbito, Zabsecesp.Codesp"

If !Prg_EjecutoSql(lcSQL,"mwkservagr_sap")
	Return .F.
Endif

If !Used('mwkservagr_sap')
	Return .F.
Endif

* Busco las especialidades
lcSQL = "SELECT * FROM tabEstados WHERE propietario = 25 and tipo = 34"
If !Prg_EjecutoSql(lcSQL,"mwkservagr_asist")
	Return .F.
Endif

If !Used('mwkservagr_asist')
	Return .F.
Endif


* Busco Restricciones

Create Cursor mwkservagr (Id i(10), Descrip c(50), estado i(10), propietario i(3), subestado i(10), tipo i(3) , CodEsp C(4) )
Insert Into mwkservagr (Id,Descrip,estado,propietario,subestado,tipo) Values (2390,'',0,25,1,34)

Select mwkservagr_asist
Scan All
	mId = mwkservagr_asist.Id
	mDescrip = Alltrim(mwkservagr_asist.Descrip)
	mEstado = mwkservagr_asist.estado
	mPropietario = mwkservagr_asist.propietario
	mSubestado = mwkservagr_asist.subestado
	mTipo = mwkservagr_asist.tipo

	Select mwkservagr_sap
	Locate For Alltrim(mwkservagr_sap.Esp_Descripcion) = mDescrip
	If Found('mwkservagr_sap')
  	    nCodesp  = mwkservagr_sap.Codesp
  	    *-- Se agrega Código Especialidad para Formulario FRMADMISION47.scx (Grilla)
		Insert Into mwkservagr (Id,Descrip,estado,propietario,subestado,tipo, Codesp ) ;
		Values (mId,mDescrip,mEstado,mPropietario,mSubestado,mTipo, nCodesp )
	Endif

	Select mwkservagr_asist
Endscan
USE IN SELECT('mwksresag')
Select * From mwkservagr WHERE subestado=1 Order By mwkservagr.descrip Asc Into Cursor mwksresag 
 
Use In Select('mwkservagr_asist')
Use In Select('mwkservagr_sap')
Use In Select('mwkservagr')