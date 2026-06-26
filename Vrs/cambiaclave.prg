SELECT * FROM tabusuario_med WHERE len(ALLTRIM(usuarpas)) >7 AND diasaviso<CTOD("01/01/2100") INTO CURSOR ver
SELECT * FROM ver WHERE  prg_control_clave(usuarpas)  INTO CURSOR mal


Select mal
SET STEP ON
Scan
	micla = usuarpas
	micod = codigovax
	Select tabusuario_med
	Locate For codigovax = micod
	Replace  Password With  micla, fecexpira With Date()+60;
		,diasaviso With Ctod("01/01/2100")
	Select mal

ENDSCAN


SELECT * FROM tabusu_medex WHERE len(ALLTRIM(usuarpas)) >7 AND diasaviso<CTOD("01/01/2100") INTO CURSOR ver
SELECT * FROM ver WHERE  prg_control_clave(usuarpas)  INTO CURSOR mal


Select mal
SET STEP ON
Scan
	micla = usuarpas
	micod = codigovax
	Select tabusu_medex
	Locate For codigovax = micod
	Replace  Password With  micla, fecexpira With Date()+60;
		,diasaviso With Ctod("01/01/2100")
	Select mal

Endscan