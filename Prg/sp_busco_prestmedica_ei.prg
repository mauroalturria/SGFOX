**********************************************************************
* Program....: SP_BUSCO_PRESTMEDICA_EI.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 27 October 2021, 10:23:28
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 27 October 2021 / 10:23:28
* Purpose....:
**********************************************************************
*
Lparameters Sector

*-- Asignamos parametro a variable local para la busqueda
lcBuscoSector  = Sector

* Busco datos cargados en tabla
ldFecPasiva = Ctod('01/01/1900')
ldFechasistea = Sp_Busco_Fecha_Serv("DD")

lcCMDSQL_MedPre = ''
*-- Consulta de Especialidad solo de las prestaciones que tienen agenda médica
TEXT TO lcCMDSQL_MedPre TEXTMERGE NOSHOW PRETEXT 7
	SELECT Prestacions.pre_codPrest, Especialid.esp_codEsp, Medpresta.*
	FROM MedPresta
		INNER JOIN Prestacions ON Prestacions.pre_codPrest = Medpresta.codprest
		INNER JOIN Especialid ON Especialid.esp_codEsp = Medpresta.codesp
	WHERE
		MedPresta.FecvigenH >= ?ldFechasistea AND
		MedPresta.FecvigenH <> MedPresta.FecVigenD AND
		MedPresta.GeneraAgen = 1
	GROUP BY MedPresta.CodEsp
	ORDER BY Especialid.esp_codEsp
ENDTEXT

lnReturn = SQLExec( mcon1, lcCMDSQL_MedPre, 'mwkMedPres')
If lnReturn < 0
   Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Messagebox('No se pudo consultr la tabla MedPresta. Avise a Sistemas.',16,'Aviso al Usuario')
   Return .F.
Endif

*--
lcSQL = "SELECT Zabsecesp.ID, Zabsecesp.CodAmbito, Zabsecesp.Codesp, Zabsecesp.Fecpasiva, Zabsecesp.codsector, Zabsecesp.codserv,"+;
   "Servicios.SER_descripserv, Especialid.ESP_descripcion "+;
   "FROM ZabSecEsp "+;
   "INNER JOIN SERVICIOS Servicios ON  Zabsecesp.codserv = Servicios.SER_codserv "+;
   "INNER JOIN ESPECIALID Especialid ON  Zabsecesp.Codesp = Especialid.ESP_codesp "+;
   "WHERE Zabsecesp.CodAmbito = 1 AND Zabsecesp.CodSector = ?lcBuscoSector AND Zabsecesp.FecPasiva = ?ldFecPasiva "+;
   "ORDER BY Zabsecesp.CodSector, Zabsecesp.CodAmbito, Zabsecesp.CodEsp"

lnReturn = SQLExec( mcon1, lcSQL, 'mwkZabSecEsp')
If lnReturn < 0
   Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Messagebox('No se pudo consultr la tabla Zabsecesp. Avise a Sistemas.',16,'Aviso al Usuario')
   Return .F.
Endif

* Busco los estados
lcSQL = "SELECT * FROM TabEstados WHERE Propietario = 25 and tipo = 34"

lnReturn = SQLExec( mcon1, lcSQL, 'mwkTabEstados')
If lnReturn < 0
   Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Messagebox('No se pudo consultar la tabla TabEstados. Avise a Sistemas.',16,'Aviso al Usuario')
   Return .F.
Endif

*-- Filtramos solo los que estan en MedPress
Select mwkZabSecEsp.Id, mwkZabSecEsp.CodAmbito, mwkZabSecEsp.CodEsp, mwkZabSecEsp.Fecpasiva, mwkZabSecEsp.CodSector, mwkZabSecEsp.codserv, mwkZabSecEsp.SER_descripserv, mwkZabSecEsp.ESP_descripcion ;
   FROM mwkZabSecEsp ;
   WHERE mwkZabSecEsp.CodEsp In( Select mwkMedPres.CodEsp From mwkMedPres ) ;
   INTO Cursor mwkZabSecEsp_Temp

* Armo cursor final
Create Cursor mwkFinalEspecialid (Id i(10), Descrip c(50), estado i(10), propietario i(3), subestado i(10), tipo i(3) , CodEsp c(4) )
Insert Into mwkFinalEspecialid (Id,Descrip,estado,propietario,subestado,tipo) Values (2390,'',0,25,1,34)

Select mwkTabEstados
Scan All
   mId = mwkTabEstados.Id
   mDescrip = Alltrim(mwkTabEstados.Descrip)
   mEstado = mwkTabEstados.estado
   mPropietario = mwkTabEstados.propietario
   mSubestado = mwkTabEstados.subestado
   mTipo = mwkTabEstados.tipo

   Select mwkZabSecEsp_Temp 				&&  antes mwkZabSecEsp
   Locate For Alltrim(mwkZabSecEsp_Temp.ESP_descripcion) = mDescrip
   If Found('mwkZabSecEsp_Temp')
      nCodesp  = mwkZabSecEsp_Temp.CodEsp
      *-- Se agrega Código Especialidad para Formulario FRMADMISION47.scx (Grilla)
      Insert Into mwkFinalEspecialid ( Id,Descrip, estado, propietario, subestado, tipo, CodEsp ) ;
         Values (mId, mDescrip, mEstado, mPropietario, mSubestado, mTipo, nCodesp )
   Endif

   Select mwkTabEstados
Endscan

*-- Genero los cursores finales para mostra los datos 
Select * From mwkFinalEspecialid Order By mwkFinalEspecialid.Descrip Asc Into Cursor mwksres Readwrite
Select * From mwkFinalEspecialid Order By mwkFinalEspecialid.Descrip Asc Into Cursor mwkscores Readwrite

*-- Cerramos las tablas de consulta que se usaron
Use In Select('mwkTabEstados')
Use In Select('mwkZabSecEsp')
Use In Select('mwkFinalEspecialid')
Use In Select('mwkMedPres')
Use In Select('mwkZabSecEsp_Temp' )



