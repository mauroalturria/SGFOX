**mret=SQLExec(mcon1,"SELECT *,TABUSUARIO.nomape as nombre,TQR_Cargo AS CARGONEW FROM TabQuejaResponsables "+;
	" left join tabusuario on codigovax = tqr_codigovax ","MWKRESPONSABLES")


mret=SQLExec(mcon1,"SELECT a.id as _id,b.nomape as nombre,a.TQR_Cargo AS CARGONEW,NVL(a.TQR_resagrup,0) as TQR_resagrup,TQR_codigovax " +;
     "FROM TabQuejaResponsables as a "+;
	 "left join tabusuario as b on b.codigovax = a.tqr_codigovax " + ;
	 "where NVL(TQR_cargo,'') <> '' and NVL(a.TQR_codigovax,0) > 0 ","MWKRESPONSABLES1")
	 
	 **"where NVL(TQR_codigovax,0) > 0 ","MWKRESPONSABLES1")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA CONSULTA RESPONSABLES DE QUEJAS.",48,"VALIDACION")
	Return .F.
ENDIF

SELECT distinct nombre,TQR_resagrup,TQR_codigovax,_id FROM MWKRESPONSABLES1 WHERE _ID = TQR_resagrup INTO CURSOR MWKRESPONSABLES2

*!*	SELECT a._id,a.nombre,a.cargonew,a.TQR_resagrup,a.TQR_codigovax,b.nombre as nombre2,b.TQR_codigovax as codivax2 ;
*!*	FROM MWKRESPONSABLES1 as a ;
*!*	LEFT JOIN MWKRESPONSABLES2 as b ON a.TQR_resagrup = b._Id ;
*!*	INTO CURSOR MWKRESPONSABLES3

SELECT a._id,a.nombre,a.cargonew,a.TQR_resagrup,a.TQR_codigovax,IIF(a.TQR_codigovax = b.TQR_codigovax,SPACE(50), b.nombre) as nombre2,b.TQR_codigovax as codivax2 ;
FROM MWKRESPONSABLES1 as a ;
LEFT JOIN MWKRESPONSABLES2 as b ON a.TQR_resagrup = b._Id ;
INTO CURSOR MWKRESPONSABLES3


USE IN SELECT("mwkResponsables")

USE DBF("MWKRESPONSABLES3") IN 0 AGAIN ALIAS MWKRESPONSABLES

**Use Dbf('mwkexcell2') In 0 Again Alias mwkexcell3
USE IN SELECT("MWKRESPONSABLES3")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif