Lparameters mInfoExport,mNombre

If Used("mwk_infoexport")
	Use In mwk_infoexport
Endif

*****************************
* Armo cursor para exportar *
*****************************

Do sp_conexion

Create Cursor cursor_temp (sector c(50), descripcion c(50), pin N(7), estadoid N(5))

misql = ""
misql = "select * from tabestados where propietario = 84 and tipo = 1 order by estado asc"

If !prg_ejecutosql(misql,"mwkexpo")
	Return .F.
Endif

Hora = sp_busco_fecha_serv("DD")


* Búsqueda de sectores

misqlb = "select * from tabbeepers "

If !prg_ejecutosql(misqlb,"mwkexpo_pin")
	Return .F.
Endif

Select mwkexpo
*Go Bottom
*mnReg = mwkexpo.estado
*Messagebox("hay " + Str(mnReg))
Go Top

Do While Not Eof("mwkexpo")

	mcSector = mwkexpo.Descrip

	misqla = "select * from tabestados where propietario = 84 and tipo = 2 and estado = ?mwkexpo.estado"

	If !prg_ejecutosql(misqla,"mwkexpo_tab")
		Return .F.
	Endif


	Select mwkexpo_tab.Descrip, mwkexpo_tab.Id, mwkexpo_pin.bee_pin  ;
		FROM mwkexpo_pin ;
		INNER Join mwkexpo_tab ;
		ON mwkexpo_tab.Id = mwkexpo_pin.bee_sector ;
		INTO Cursor mwkrepbusca Readwrite


	Select mwkrepbusca
	Scan All

		If Isnull(mwkrepbusca.bee_pin)
			Insert Into cursor_temp (sector,descripcion,estadoid,pin) Values (mcSector, mwkrepbusca.Descrip, mwkrepbusca.Id, 0)
		Else
			Insert Into cursor_temp (sector,descripcion,estadoid,pin) Values (mcSector, mwkrepbusca.Descrip, mwkrepbusca.Id, mwkrepbusca.bee_pin)
		Endif

		Select mwkrepbusca
	Endscan

	Select mwkexpo
	Skip

Enddo


Select * From cursor_temp Order By sector, descripcion Into Cursor mwk_infoexport

Use In "cursor_temp"

Do Case

Case mInfoExport = 1 && Reporte

	oFormRep = Createobject("Form")
	With oFormRep
		.Caption = "Beepers - Listado para Impresión"
		.ScrollBars = 2
		.WindowState = 2
		.Show()
		Report Form repbeepers Preview Window (.Name)
		.Release()
	Endwith

	Return .F.

Case mInfoExport = 2 && Excel

	Select mwk_infoexport
	Return .F.

Case mInfoExport = 3 && PDF

	Do foxypreviewer.App
	cFILE = "c:\temp\beepers\beepers" + Left(Ttoc(Hora,1),8) +".pdf"
	Report Form repbeepers Object Type 10 To File &cFILE
	Do foxypreviewer.App With 'Release' && Desactiva
	Return .F.

Endcase


Do sp_desconexion With mNombre


****************************************************
* Exporto para Excel u Open Calc si está instalado *
****************************************************

*!*	Export To Beepers.xls type Xls Fields descripcion, pin

*!*	Para exportar datos en formato ODS OPEN CALC de OPEN OFFICE sería:

*!*	Export To Beepers.ods Type Xls Fields descripcion, pin

*!*	Messagebox("Se exportaron correctamente los datos.", 64,"Exportar Listado a Excel")

*!*	Return -1




