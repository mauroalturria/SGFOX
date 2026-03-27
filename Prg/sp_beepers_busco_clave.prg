*** PRG Busqueda por clave ***
* sp_beepers_busco_clave

Lparameters mBusqueda,mOpcion,mNombre

mFecha = "1900-01-01"

Do sp_conexion

Do Case

Case mOpcion = 1

	misql = "SELECT id,descrip,estado FROM tabestados WHERE propietario = 84 and tipo = 2 and ucase(descrip) like '%"+ mBusqueda + "%'"

	If !prg_ejecutosql(misql,"mwkbusqa_txt")
		Return .F.
	Endif

	misql = "SELECT bee_pin, bee_sector from tabbeepers"
	mFecha = "1900-01-01"
	misql =	"select bee_pin,bee_sector from tabbeepers where BEE_FecHPasiva = ?mFecha"

	If !prg_ejecutosql(misql,"mwkbusqb_txt")
		Return .F.
	Endif

	Select * ;
		FROM mwkbusqa_txt ;
		INNER Join mwkbusqb_txt ;
		ON mwkbusqa_txt.Id = mwkbusqb_txt.bee_sector ;
		INTO Cursor mwkbusqc_txt Order By mwkbusqa_txt.Descrip Asc

	Select mwkbusqc_txt


Case mOpcion = 2

	misql=	"SELECT bee_pin, bee_sector FROM tabbeepers WHERE TO_CHAR(bee_pin, '9999') LIKE '%"+ Alltrim(Str(mBusqueda))+"%' and BEE_FecHPasiva = ?mFecha"

	If !prg_ejecutosql(misql,"mwkbusq1_txt")
		Return .F.
	Endif

	misql = "SELECT id, descrip, estado FROM tabestados WHERE propietario = 84 and tipo = 2"

	If !prg_ejecutosql(misql,"mwkbusq2_txt")
		Return .F.
	Endif

	Select * ;
		FROM mwkbusq1_txt ;
		INNER Join mwkbusq2_txt ;
		ON mwkbusq1_txt.bee_sector = mwkbusq2_txt.Id ;
		INTO Cursor mwkbusq3_txt Order By mwkbusq2_txt.Descrip Asc

	Select mwkbusq3_txt

Otherwise
	Return .F.
Endcase

Do sp_desconexion With mNombre
