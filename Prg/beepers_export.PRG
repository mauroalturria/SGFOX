Lparameters mInfoExport


If Used("mwk_infoexport")
	Use In mwk_infoexport
Endif

*****************************
* Armo cursor para exportar *
*****************************


Create Cursor cursor_temp (sector c(50), descripcion c(50), pin N(7), estadoid N(5))

misql = ""
misql = "select * from tabestados where propietario = 84 and tipo = 1 order by estado asc"

If !prg_ejecutosql(misql,"mwkexpo")
	Return .F.
Endif



* Búsqueda de sectores

misqlb = "select * from tabbeepers"

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
	



* La consulta de cursores la hago del lado del fox, por eso no uso variable y pongo into cursor

	Select mwkexpo_tab.Descrip, mwkexpo_tab.id, mwkexpo_pin.bee_pin  ;
	FROM mwkexpo_pin ;
	INNER Join mwkexpo_tab ;
	ON mwkexpo_tab.id = mwkexpo_pin.bee_sector ;
	INTO Cursor mwkbusquedafinal Readwrite


* El resultado obtendio lo subo al cursor temp y le agrego el sector

*Select CURSOR_TEMP
*Append From Dbf("mwkbusquedafinal")

	Select mwkbusquedafinal
	Scan All
	
		If Isnull(mwkbusquedafinal.bee_pin)
			Insert Into cursor_temp (sector,descripcion,estadoid,pin) Values (mcSector, mwkbusquedafinal.Descrip, mwkbusquedafinal.id, 0)
		else	
			Insert Into cursor_temp (sector,descripcion,estadoid,pin) Values (mcSector, mwkbusquedafinal.Descrip, mwkbusquedafinal.id, mwkbusquedafinal.bee_pin)
		endif

		Select mwkbusquedafinal
	Endscan

	Select mwkexpo
	Skip

Enddo


Select * From cursor_temp Order By sector, descripcion Into Cursor mwk_infoexport

Use In "cursor_temp"


If mInfoExport = 1
	Do Form frmbeepers03
Endif

Return -1


****************************************************
* Exporto para Excel u Open Calc si está instalado *
****************************************************

*!*	Export To Beepers.xls type Xls Fields descripcion, pin

*!*	Para exportar datos en formato ODS OPEN CALC de OPEN OFFICE sería:

*!*	Export To Beepers.ods Type Xls Fields descripcion, pin

*!*	Messagebox("Se exportaron correctamente los datos.", 64,"Exportar Listado a Excel")

*!*	Return -1




