Lparameters mOpcion, mId, mEstOrig, mApvobservaciones, mApv_opersolicitud 
	
mFecHoy = sp_busco_fecha_serv('DT')

jj = int(len(alltrim(mApvobservaciones))/250)
for i = 0 to jj
	clin = "linea" + padl(i,3,"0")
	public &clin 
next
for i = 0 to jj
	clin = "linea" + padl(i,3,"0")
	&clin  =''
next

mApvobservacion = prg_concat(alltrim(mApvobservaciones))
Do Case 
	Case mOpcion = 1

		mRet = Sqlexec(mcon1,"Insert into TabAutPrevLog " + ;
			"(APL_IdAutPrev, APL_Estado, APL_Observaciones, APL_Operador, APL_FecHora) " + ;
			"Values " + ;
			"(?mId, ?mEstOrig, " + mApvobservacion + ", ?mApv_opersolicitud, ?mFecHoy)")
Endcase 	

If mRet <= 0
	Messagebox("ERROR AL GUARDAR EL LOG DE AUTORIZACIONES ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 