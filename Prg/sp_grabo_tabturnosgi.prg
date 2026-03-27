Parameters m.liOpcion, m.liId, m.liGi_codvaleasist, m.liGi_idturno
*!*	&& ALTA
*!*	m.liOpcion = 1
*!*	m.liId = 0
*!*	m.liGi_codvaleasist = 4
*!*	m.liGi_idturno = 2

*!*	&& BAJA
*!*	m.liOpcion = 3
*!*	m.liId = 1

*!*	----------------------------------------------------
m.liGi_codigovax = mwkUsuario.codigovax
 
Do Case 
	Case m.liOpcion = 1 && ALTA
		m.ltGi_fecalta = sp_busco_fecha_serv('DT')
		m.ltGi_fecpasiva = Dtot(Ctod("01/01/1900"))
		
		mRet = Sqlexec(mcon1,"INSERT INTO TABTURNOSGI ( " + ;
			  "GI_CodigoVaxalta, Gi_codvaleasist, Gi_fecalta, Gi_fecpasiva, Gi_idturno, Gi_codigovaxpasiva ) " + ;
		  " VALUES ( " + ;
			"  ?m.liGi_codigovax " + ;
			", ?m.liGi_codvaleasist " + ;
			", ?m.ltGi_fecalta " + ;
			", ?m.ltGi_fecpasiva " + ;
			", ?m.liGi_idturno " + ;
			", 0 )")


*!*	---
	Case m.liOpcion = 2 && NO HAY MODIFICACION 

	Case m.liOpcion = 3 && BAJA
		m.ltGi_fecpasiva = sp_busco_fecha_serv('DT')
		
		mRet = Sqlexec(mcon1,"UPDATE TABTURNOSGI SET " + ;
			"Gi_fecpasiva = ?m.ltGi_fecpasiva, " + ;
			"Gi_codigovaxpasiva = ?m.liGi_codigovax " + ;
			"WHERE ID = ?m.liId ") 
		
		
Endcase 


If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR AL ACTUALIZAR",48,"VALIDACION")
 	Return .f.
Endif  



