** Fecha en formato DATE
** Hora en formato 9999
Lparameters mFecha,mHora

Local nCamasOcupadas
Local nCamasDisp
Local lResult
Local nIn
LOCAL cVar1
LOCAL cVar2
LOCAL nVar3
LOCAL cSelect

mret = 0


** ------------- Recuperamos la cantidad de camas por horario
mret = SQLExec(mcon1,"select * from TabEstados where Propietario = 24 and tipo = 6 and subestado = 1","mwkEstHoraIqb")

If mret<=0
	Messagebox("ERROR EN LA LECTURA DE CAMAS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

** ------------- Recuperamos las camas para la fecha seleccionada
mret = SQLExec(mcon1,"select * from Tabpqx " +;
	"where PQ_fechaprog = ?mFecha and PQ_fecpasiva = '1900-01-01' and PQ_tipopac = 4","mwkCamasDisp")

If mret<=0
	Messagebox("ERROR EN LA LECTURA DE CAMAS IQB",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Use In Select("mwkEstHoraIqb")
	Return .F.
Endif

*--------------------------
Select mwkEstHoraIqb
Go Top

lResult = .F.

Scan All

	cStatement = Alltrim(mwkEstHoraIqb.descrip)

	cVar1 = Strtran(cStatement,"$var",Alltrim(Str(mHora)))
	cVar2 = Strtran(cStatement,"$var","pq_horaest")
	nVar3 = mwkEstHoraIqb.Estado

	If EVALUATE(cVar1)
	
		Select mwkCamasDisp
		Go Top
		Count For &cVar2. To nCamasOcupadas

		nCamasDisp = nVar3 -nCamasOcupadas
		If nCamasDisp >= 1
			lResult = .T.
			Exit
		Endif

	Endif
    Select mwkEstHoraIqb
    
Endscan


*!*	lResult = .F.
*!*	Select mwkCamasDisp
*!*	Go Top

*!*	Do Case
*!*	Case mHora <= 1200

*!*		Count For pq_horaest <= 1200 To nCamasOcupadas

*!*		nCamasDisp = 13-nCamasOcupadas
*!*		If nCamasDisp >= 1
*!*			lResult = .T.
*!*		Endif

*!*	Case mHora > 1200 And mHora <= 1700

*!*		Count For pq_horaest > 1200 To nCamasOcupadas

*!*		nCamasDisp = 7-nCamasOcupadas
*!*		If nCamasDisp >= 1
*!*			lResult = .T.
*!*		Endif

*!*	Case mHora > 1700

*!*	Endcase

Use In Select("mwkCamasDisp")
Use In Select("mwkEstHoraIqb")

Return lResult

