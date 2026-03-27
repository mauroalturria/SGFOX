Lparameters mFecha, mUsuario

Local mFecAnterior
Local mFecAhora 
Local lResult

lResult = .T.
mFecAhora = sp_busco_fecha_serv("DT")

*** ---------------------------- Buscar la fecha actual
mret = SQLExec(mcon1,"select * from ZSAPG12","mwkFecSap")

If mret < 0

	Messagebox("ERROR EN LA LECTURA : FECHA SAP A PROCESAR",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.

Endif

Select mwkFecSap
Go Top

mFecAnterior = Dtoc(mwkFecSap. ZSAP_FechaPeriodo)

*** ----------------------------- Pasar a LOG
mret = SQLExec(mcon1,"insert into ZabLogQuiroEventos (ZLQ_Descrip,ZLQ_Tipo,ZLQ_DescriTipo,ZLQ_FecLog,ZLQ_Usuario) values (" +;
	"?mFecAnterior,1,'FECSAPTRANSAC',?mFecAhora,?mUsuario)")

If mret < 0

	Messagebox("ERROR EN INSERT : LOG FECHA SAP A PROCESAR",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.

Endif


*** ---------------------------- Actualizar la fecha actual
mret = SQLExec(mcon1,"update ZSAPG12 set  ZSAP_FechaPeriodo = ?mFecha")

If mret < 0

	Messagebox("ERROR DE ESCRITURA : FECHA SAP A PROCESAR",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.

ENDIF

USE IN SELECT("mwkFecSap")

Return lResult


