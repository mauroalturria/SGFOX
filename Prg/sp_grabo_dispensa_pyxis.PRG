*
* Llevo un control de Vales que se derivaron al PYXIS
*
Lparameters mvale, minsumo, mnotifica

muser = mwkusuario.idusuario
mfchr = sp_busco_fecha_serv("DT")

mret = SQLExec(mcon1,"insert into TabGriPyxis (TGP_vale, TGP_insumo, TGP_notifica, TGP_idusuario, TGP_fecHrmov)"+;
	" values (?mvale, ?minsumo, ?mnotifica, ?muser, ?mfchr)")

If mret < 0
	mltabla = "TABLA DISPENSA PYXIS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
