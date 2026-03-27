Local cTabla

cTabla = Upper(Alias(Select(0)))

Do Case
Case cTabla = "MWKBUSQC_TXT"
	Select * From mwkcbosector Where mwkcbosector.estado = mwkbusqc_txt.estado Into Cursor mwkABMsector Readwrite

Case cTabla = "MWKBUSQ3_TXT"
	Select * From mwkcbosector Where mwkcbosector.estado = mwkbusq3_txt.estado Into Cursor mwkABMsector Readwrite

Case cTabla = "MWKBUSQUEDAFINAL"
	Select * From mwkcbosector Where mwkcbosector.estado = mwkbusquedafinal.estado Into Cursor mwkABMsector Readwrite
Endcase
