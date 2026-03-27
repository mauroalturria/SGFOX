Parameters mcSector

misqla = "select * from tabestados where propietario = 84 and tipo = 2 and estado = ?mcSector"

if !prg_ejecutosql(misqla,"mwkabmtab_id")
	Return .F.
Endif

misqlb = "select bee_pin, bee_sector from tabbeepers where bee_fechpasiva='1900-01-01'"

If !prg_ejecutosql(misqlb,"mwkabmbee_pin")
	Return .F.
Endif

Select * ;
From mwkabmbee_pin ;
Inner Join mwkabmtab_id ;
On mwkabmtab_id.id = mwkabmbee_pin.bee_sector ;
Into Cursor mwkbusquedafinal order By mwkabmtab_id.descrip readwrite