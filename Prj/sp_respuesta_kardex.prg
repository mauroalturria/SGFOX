*
* Verificar respuesta del Kardex
*
Lparameters mLidpre, mShowMsg

mvalida = .F.
mbusco  = 'PR-'+Alltrim(Transform(mLidpre))
mShowMsg = IIF(VARTYPE(mShowMsg) = "N", mShowMsg, 1) && por defecto, para mostrar el mensaje.


Use In Select("mwkpedidos")
mret = SQLExec(mcon1,"select distinct(TFKL_Pedido) as lpedido from TabFarmKardexLog where TFKL_PedidoCompro = ?mbusco and TFKL_OrigenMensa = 'S'","mwkpedidos")

If mret < 0
	mltabla = "CONSULTA LOG MOVIMIENTOS KARDEX PASO 1"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .T.
Endif

If Used("mwkpedidos")
	If Reccount("mwkpedidos") = 0
		mvalida = .T.
	Endif
Endif

Select mwkpedidos
Go Top

Scan All
	mpedido = Alltrim(mwkpedidos.lpedido)

	Use In Select("mwkpedidos2")
	mret = SQLExec(mcon1,"select top 1 * from TabFarmKardexLog where TFKL_Pedido = ?mpedido and TFKL_OrigenMensa = 'K'","mwkpedidos2")
	If mret < 0
		mltabla = "CONSULTA LOG MOVIMIENTOS KARDEX PASO 2"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .T.
	Endif

	If Used("mwkpedidos2")
		If Reccount("mwkpedidos2") = 0
			mvalida = .T.
		Endif
	Endif

Endscan

Use In Select("mwkpedidos")
Use In Select("mwkpedidos2")

If mvalida AND mShowMsg = 1
	Messagebox("EL PROCESO DEL KARDEX AUN NO HA FINALIZADO. VERIFIQUE ESTA SITUACION",48,"ATENCION")
Endif

Return mvalida

