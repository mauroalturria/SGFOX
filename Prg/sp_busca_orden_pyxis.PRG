*
* Busca Nro. Orden PYXIS / elabora LOG
*
* mmov     : 'P-PYXIS' - 'E-PYXIS' (Preparo PYXIS p/obtener nro de orden - Actualizo PYXIS con mensaje Enviado) // Por ahora hay posibilidad de uso futuro
* morden   :
* mmsg     :
* mArch    :
* mtxtomsg :
*
Lparameters mmov, morden, mmsg, mArch, mtxtomsg

muser = mwkusuario.idusuario
mfchr = sp_busco_fecha_serv("DT")
mdetn = Alltrim(Substr(mmov,3))
mesta = Left(mmov,1)

Do Case
Case mmov = 'P-PYXIS' && PREPARADO - envio para PYXIS obtengo numerador

	mArch2 = Substr(mArch, 9)
	
	mret   = SQLExec(mcon1,"insert into TabGriNum (TGN_idusuario, TGN_fecHrmov, TGN_destArch, TGN_nomArch, TGN_mensaje, TGN_estado)"+;
		" values (?muser, ?mfchr, ?mdetn, ?mArch2, ?mmsg, ?mesta)")

	If mret < 0
		mltabla = "PYXIS NRO DE ORDEN PASO 1"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN EL PROCESO "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return morden
	Endif

	Use In Select("mwknro")
	mret = SQLExec(mcon1,"select id as lid from TabGriNum where TGN_idusuario = ?muser and TGN_fecHrmov = ?mfchr and TGN_destArch = ?mdetn","mwknro")

	If mret < 0
		mltabla = "PYXIS NRO DE ORDEN PASO 2"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN EL PROCESO "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return morden
	Endif

	morden = mwknro.lid
	Use In Select("mwknro")


Case mmov = 'E-PYXIS' && ENVIADO - Cierro ciclo de envio a PYXIS todavia no finalizo FTP

	mret = SQLExec(mcon1,"update TabGriNum set TGN_txtArch = ?mtxtomsg, TGN_estado = ?mesta where id = ?morden")

	If mret < 0
		mltabla = "PYXIS ACTUALIZACION TXT FTP"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN EL PROCESO "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		morden = 0
	Endif

Otherwise
*!* Posible Uso Futuro KARDEX
Endcase

Return morden
