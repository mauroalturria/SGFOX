*
* Modulo Preparadores (Liberacion de Vales / Preparación) x problemas técnicos - corte de luz
*
Lparameters mvale, mprepara

If Vartype(mvale)<>"N"
	mvale = 0
Endif

If Vartype(mprepara)<>"N"
	mprepara = 0
Endif

If mvale > 0
	mret = SQLExec(mcon1,"UPDATE TABFARMVPDET SET TVD_VALE = 1 WHERE TVD_vale = ?mvale")
Endif

If mprepara > 0
	mret = SQLExec(mcon1,"UPDATE TABFARMVPDET SET TVD_VALE = 1 WHERE TVD_IdPre = ?mprepara")
Endif

If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
