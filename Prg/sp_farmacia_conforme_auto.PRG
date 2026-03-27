*
* Conforme automatico desde Farmacia
*
Lparameters mnropre, msector

Use In Select("mwkconformar")

*!*	mret = SQLExec(mcon1,"Select TVD_Vale, VAL_OperadorCarga"+;
*!*		" From TabFarmVPDet"+;
*!*		" Join VALESASIST On val_codvaleasist = TVD_Vale"+;
*!*		" Where TVD_idPre = ?mnropre", "mwkconformar")

mret = SQLExec(mcon1," SELECT TVE_vale , VAL_OperadorCarga, VAL_verficasolicit, VAL_fechasolicitud"+;
	" from TabFarmVPdetent"+;
	" Join VALESASIST On val_codvaleasist = TVE_vale"+;
	" Where TVE_idPre = ?mnropre and TVE_sector = ?msector"+;
	" group by TVE_vale", "mwkconformar")

If mret < 0
	mltabla = "VP DETALLE PREPARADORES"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
