*!*	mId = 5523  
*!*	lcBusco = " id = ?mId"
*!*	lcTabla = "TabQuirofano"
*!*	lcForm  = "frmquirof03"

*!*	Do prg_logcambios With lcForm, lcTabla, lcBusco
*------------------------------------------------------
Lparameters lcForm, lcTabla, lcBusco
*------------------------------------------------------
mFechaHoy = sp_busco_fecha_serv("DT")

Do sp_Busco_Qlog With lcForm, lcTabla && mwkqlog
Do sp_Busco_Tabla_Id With lcTabla, lcBusco && mwkTabDat

Select mwkqlog
Scan All

	If type("mwkTabDat" + "." + Alltrim(LTF_Campo)) = "U"
		&& cargamos en el log de errores o no hacemos nada ??????
		Select mwkqlog
		Loop	
	Endif 

	If Not pemstatus(Evaluate(Alltrim(LTF_Objeto)),Alltrim(LTF_Prop),5)
		&& cargamos en el log de errores o no hacemos nada ??????
		Select mwkqlog
		Loop	
	Endif 
		
	&& valores		
	lcValI = Evaluate("mwkTabDat" + "." + Alltrim(LTF_Campo))
	lcValD = Evaluate(Alltrim(LTF_Objeto) + "." + Alltrim(LTF_Prop))
	
	&& comparacion
	If Upper(Transform(lcValI)) <> Upper(Transform(lcValD))

		mTLC_Dato = Alltrim(LTF_Campo)  
		mTLC_FecMod = mFechaHoy
		mTLC_Id = mId
		mTLC_Tabla = lcTabla
		mTLC_Tipo = ""    
		mTLC_Usuario = mwkUsuario.codigovax  
		mTLC_ValorAct = Transform(lcValD)
		mTLC_ValorAnt = Transform(lcValI)
	
		Do sp_inserto_logCambios With mTLC_Dato, mTLC_FecMod, mTLC_Id, mTLC_Tabla, mTLC_Tipo, mTLC_Usuario, mTLC_ValorAct, mTLC_ValorAnt
		
	Endif 
		
	Select mwkqlog
EndScan	

If Used("mwkTabDat")
	Use In mwkTabDat
Endif 	

If Used("mwkqlog")
	Use In mwkqlog
Endif 	