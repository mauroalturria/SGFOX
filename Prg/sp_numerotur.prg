parameters lcSigno
*!*	Set Step On
*!*	mcon1 = Sqlconnect("172.16.1.225")
*!*	lcSigno = " + "

lcSql = "select * from TabLlamaIp where LLA_Ippuesto = ?MyIp "
If !prg_EjecutoSql(lcSql,"MwkIpLla")
	Return 
Endif 


If Reccount("MwkIpLla") = 0
	Messagebox("NO ESTA CONFIGURADO EL LLAMADOR",48,"VALIDACION")
	Return .f.
Endif 

*myIp
*lcSigno = "+"
*lcSigno = "-"

lnCantDig = 3 && SOLO PARA EL CASO DE LETRAS
lnCodigoVax = mwkUsuario.codigovax

Select MwkIpLla
Go Top 
lcIpSvr = MwkIpLla.Lla_ipserver

*-------------------------------------------------
*!*	** agregado
*!* ---------------------------------------------------------------------------  
lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null Order By TNL_FechaHoraIng"

If !Prg_EjecutoSql(lcSql,"mwkTurallamar") 
	Return .f.
Endif 	

If Reccount("mwkTurallamar") > 0
	If Messagebox("HAY MAS NUMEROS DE AUTOGESTION" + Chr(13) + "DESEA CONTINUAR ?" + Chr(13) + "Nro:" + Alltrim(mwkTurallamar.TNL_Numerador)  ,4+32+256,"VALIDACION") = 7
		Use IN Select("mwkTurallamar")
		Return 
	Endif 
Endif

Use IN Select("mwkTurallamar")
*!*		
*!*	*!*	** agregado
*!* --------------------------------------------------------------------------- 

lcSql = "Select * from TabTurNum WHERE TUN_IPSVR = ?lcIpSVR "

If !prg_EjecutoSql(lcSql,"mwkTurNum")
	Return 
Endif 
*-------------------------------------------------
lcNumero = Alltrim(mwkTurNum.TUN_DesNumero)
lbIsNumero = Isdigit(Left(lcNumero,1))
lnTope  = Val(Padr("1",lnCantDig+1,"0"))
lnValIni = 0

If lbIsNumero
	Do While .t.	

		lcSql = "Update TabTurNum set TUN_CodigoVax = ?lnCodigoVax, TUN_Ip = ?myIp  Where TUN_CodigoVax = 0 and TUN_IpSVR = ?lcIpSvr "

		If !prg_EjecutoSql(lcSql,"")
			Return 
		Endif 

		lcSql = "Select * from TabTurNum Where TUN_CodigoVax = ?lnCodigoVax and TUN_Ip = ?myIp and TUN_IpSVR = ?lcIpSvr"

		If !prg_EjecutoSql(lcSql,"mwkTurNum")
			Return 
		Endif 
		
		If Reccount("mwkTurNum")>0
			
			If Alltrim(lcSigno) = "+"
			Do Case 
				Case  Val(mwkTurNum.TUN_DesNumero) + 1 > lnTope  
					lcValUpd = Alltrim(Str(lnValIni,16,0)) 
				
				Case  Val(mwkTurNum.TUN_DesNumero) + 1 < lnValIni 
					lcValUpd = Padl(Alltrim(Str(lnTope,16,0)) ,lnCantDig,"0")  
			
				Otherwise 
					lnValorN =  Val(mwkTurNum.TUN_DesNumero) + 1
					If lnValorN = lnTope 
						lcValUpd = Alltrim(Str(lnValorN,16,0))
					Else
						lcValUpd = Padl(Alltrim(Str(lnValorN ,16,0)) ,lnCantDig,"0")  
					Endif 	
		
			Endcase 
		Else
			Do Case 
				Case  Val(mwkTurNum.TUN_DesNumero) = lnValIni 
					lnValorN = lnTope
				
				Otherwise 
					lnValorN =  Val(mwkTurNum.TUN_DesNumero) - 1
			Endcase 

			If lnValorN = lnTope 
				lcValUpd = Alltrim(Str(lnValorN,16,0))
			Else
				lcValUpd = Padl(Alltrim(Str(lnValorN ,16,0)) ,lnCantDig,"0")  
			Endif 	

		Endif
			lcSql = "Update TabTurNum set TUN_DesNumero = ?lcValUpd Where TUN_CodigoVax = ?lnCodigoVax and TUN_Ip = ?myIp and TUN_IpSVR = ?lcIpSvr"

			If !prg_EjecutoSql(lcSql,"")
				Return 
			Endif 
			
			Exit 
		Endif 
	Enddo 

Else

	Do While .t.	

		lcSql = "Update TabTurNum set TUN_CodigoVax = ?lnCodigoVax, TUN_Ip = ?myIp  Where TUN_CodigoVax = 0  and TUN_IpSVR = ?lcIpSvr"
		If !prg_EjecutoSql(lcSql,"")
			Return 
		Endif 
		
		lcSql = "Select * from TabTurNum Where TUN_CodigoVax = ?lnCodigoVax and TUN_Ip = ?myIp and TUN_IpSVR = ?lcIpSvr"

		If !prg_EjecutoSql(lcSql,"mwkTurNum")
			Return 
		Endif 
		If Reccount("mwkTurNum")>0
			Exit 
		Endif 
	Enddo 	
	
	lcLetra = Left(Alltrim(mwkTurNum.Tun_desnumero),1)
	lnValor = Val(Substr(Alltrim(mwkTurNum.Tun_desnumero),2))
	
	
	If Alltrim(lcSigno) = "+"
		If lnValor < lnTope
			lcLetraN = lcLetra 
			lnValorN = Evaluate("lnValor " + lcSigno + " 1 ")
		Else
			lcLetraN = Evaluate("Chr( Asc(lcLetra ) "  + lcSigno  + " 1)" )
			lnValorN = lnValIni && 
		Endif 

	Else && NEGATIVO

		If lnValor <> lnValIni
			lcLetraN = lcLetra 
			lnValorN = Evaluate("lnValor " + lcSigno + " 1 ")
		Else
			lcLetraN = Evaluate("Chr( Asc(lcLetra ) "  + lcSigno  + " 1)" )
			lnValorN = (lnTope)
		Endif 
	Endif 	
	
	If lnValorN = lnTope 
		lcTurNumero = lcLetraN + Alltrim(Str(lnValorN,16,0))
	Else
		lcTurNumero = lcLetraN + Padl(Alltrim(Str(lnValorN,16,0)) ,lnCantDig,"0")
	Endif 	
	
	lcSql = "Update TabTurNum set TUN_DesNumero = ?lcTurNumero Where TUN_CodigoVax = ?lnCodigoVax and TUN_Ip = ?myIp and TUN_IpSVR = ?lcIpSvr"

	If !prg_EjecutoSql(lcSql,"mwkTurNum")
		Return 
	Endif 

Endif 
*!* --------------------------------------------------------------------------- 

	lcSql = "Select * from TabTurNum Where TUN_CodigoVax = ?lnCodigoVax and TUN_Ip = ?myIp and TUN_IpSVR = ?lcIpSvr"

	If !prg_EjecutoSql(lcSql,"mwkTurNum")
		Return 
	Endif
	
*!* --------------------------------------------------------------------------- 

*!*	VUELVO A 0
lcSql = "Update TabTurNum set TUN_CodigoVax = 0 Where TUN_CodigoVax = ?lnCodigoVax and TUN_Ip = ?myIp and TUN_IpSVR = ?lcIpSvr"

If !prg_EjecutoSql(lcSql,"")
	Return 
Endif 

lcNumeroFin = Alltrim(mwkTurNum.Tun_desnumero)

mfecha = sp_busco_fecha_serv("DT")
mFecNull = ctod("01/01/1900")

lcSql = "Select * from tabstpuesto where puesto = ?myIp"

If !prg_EjecutoSql(lcSql,"mwkPuesto")
	Return 
Endif 

lcConsultorio = Alltrim(mwkPuesto.Nroconsultorio)
*Set Step On

lcSql = "Insert into TabLlamador (LLA_ipMaquina, LLA_IpServer, LLA_FechaSol, LLA_consultorio, LLA_espec, " + ;
	"LLA_NroRegistrac, LLA_fechaPant, LLA_NumeroLlamado) values (?MyIp, ?lcIpSvr , ?mfecha, ?lcConsultorio , '', 1, ?mFecNull, ?lcNumeroFin  )"
			

If !prg_EjecutoSql(lcSql,"")
	Return 
Endif 

Select mwkTurNum
Messagebox("DEBE LLAMAR A : " + Alltrim(mwkTurNum.Tun_desnumero), 64,"AVISO")

Use In mwkTurNum
