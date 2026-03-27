** ------- 10/12/2019 - Alta complejidad. Tratamientos empirico o completo.
** ------- Solicitado por Daniel Estevez - Aduditoria.
** ------- Devolvemos cantidad de dias de tratamiento obligatorio para medicamentos.

LPARAMETERS mCodInsumo

LOCAL mret 
LOCAL cResultado

mRet = 0
cResultado = ""

mret = SQLEXEC(mcon1,"select * from TabInsAc " +;
"where TIA_insumocodig = ?mCodInsumo and TIA_fpasiva = '1900-01-01' ","mwkCtrlInsAC")

If mRet<=0
	Messagebox("ERROR EN LA LECTURA DE INSUMOS TRATAMIENTO EMPIRICO-COMPLETO",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

SELECT mwkCtrlInsAC
GO top

IF RECCOUNT() > 0
   cResultado = mwkCtrlInsAC.TIA_tratamiento 
ENDIF 

USE IN SELECT("mwkCtrlInsAC")

RETURN cResultado