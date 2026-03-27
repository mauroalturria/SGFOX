*!*	Create Cursor datos(NOMBRE_PAC c(50),APELLIDO_P c(50),DNI_PACIEN  c(50),NRO_BENEFI  c(50);
*!*		,TEL_PACIEN c(50),MAIL_PACIE c(50),LOCALIDAD c(50),AGENCIA c(50),UGL c(50),APELLIDO_M c(50);
*!*		,NOMBRE_MED c(50),TEL_MEDICO c(50),MAIL_MEDIc c(50),Fecha_Naci d)
 	
Use c:\desaguemes\datos.Dbf In 0 Exclusive
USE c:\desaguemes\datos2.dbf IN 0 EXCLUSIVE
Set Step On
Select datos2
ZAP
PACK
*Append From c:/desaguemes/turnos.txt Delimited With Tab
Public MRET
Set Step On
 	APPEND FROM datos
Do sp_conexion
Do sp_tablas_loca_pcia1
Select datos2
Scan
	If !EMPTY(TRANSFORM(NRO_BENEFI))
		mnomb = Alltrim(APELLIDO_P   )&&+","+NOMBRE_pac
		mcodent = 876
		mcoddocu= 4
		mnrodoc = Int(DNI_PACIEN )
		mnroafi = Alltrim(NRO_BENEFI )
		mdomici= "NRO AFILIADO "+mnroafi
		mcodpos= 1001
		mtel= Alltrim(TEL_PACIEN)
		mloca = Alltrim(LOCALIDAD )
		Select mwkloca
		Locate For Descrip=mloca
		If Found()
			mloca =  mwkloca.Id
		Else
			mloca = 1
		Endif
		Select datos2

		mpcia= mwkloca.idprovincia
		msexo = 'F'
		mfecnac= Fecha_Naci
		mid = 0
		memail = Iif(At("@",MAIL_PACIE )>0,Alltrim(MAIL_PACIE),'NO TIENE')
		qbusca = 'REG_numdocumento'
		mctexto = mnrodoc
		msql_reg = ''
		mbusco1 = "where REG_numdocumento = ?mctexto and "
		Do sp_busco_nombre_paciente With mbusco1,1

		If Reccount("mwkbuspacie")=0
			msql_reg = ''
			mctexto = mnrodoc
			mbusco1 = "where REG_numdocumento = ?mctexto and "
			Do sp_busco_nombre_paciente With mbusco1,2
			If Reccount("mwkbuspacie")=0
				mid = 0
			Else
				If At("NAf:",mwkbuspacie.reg_domicilio)=0
					mdomici  = Alltrim(mwkbuspacie.reg_domicilio)+ "NAf:"+mnroafi
				Endif
				mid = mwkbuspacie.REG_nroregistrac
			Endif
			Do sp_insert_preregistra With mnomb, mcodent, mcoddocu, mnrodoc, mnroafi, mdomici, mcodpos, mtel, ;
				mloca, mpcia, msexo, mfecnac,mid,memail
			If MRET = 0
				Set Step On
			Endif
		Endif
		Select datos2
		mmape = APELLIDO_M
		mmnom = ''&&NOMBRE_MED
		mmtel =TEL_MEDICO
		mmmail =  Iif(At("@",MAIL_MEDIC )>0,Alltrim(MAIL_MEDIC),'NO TIENE')
		MRET= SQLExec(mcon1,"INSERT INTO ZabMedCabecera ( apellido , email , nombre , nroDocuPac , telefono ,ZMC_emailpac) "+;
			"VALUES ( ?mmape ,?mmmail,?mmnom,?mnrodoc ,?mmtel,?memail)")
	Endif
Endscan
Do sp_desconexion
