Parameters tcIpServ, tcLetra, tcNro, tcNombre

If Pcount()= 0
	tcIpServ = '172.16.1.9'
	tcLetra = 'A'
	tcNro = ''
	tcNombre = ''
Endif


* Marcelo Torres, 09/10/2024
* utilizo la ip de gustavo para probar.
*If mwkusuario.sector = "SISTEMAS"
*	tcIp = '172.16.1.9'
*Else
	tcIp = MyIp && '172.16.1.9'
*Endif
* ----------------------------------

ldFecPass = Ctod("01/01/1900")

lbResu = .F.
Do While .T.

	TEXT To lcsql Textmerge Noshow Pretext 7
		select *
		from TabTurNum
		where TUN_IpSVR = ?tcIpServ
			And Tun_Letra = ?tcLetra
			And Tun_FecPasiva = ?ldFecPass
	ENDTEXT

	If !Prg_EjecutoSql(lcSql,"mwkExiste")
		Exit
	Endif

	If Reccount("mwkExiste") = 0
		Messagebox("NO ESTA DADA DE ALTA EL NUMERADOR",16,"ERROR")
		Exit

*!*			Text To lcsql Textmerge Noshow Pretext 7
*!*				Insert into TabTurNum
*!*				(TUN_CodigoVax, TUN_IpSVR, Tun_Letra, Tun_FecPasiva,TUN_DesAuto, TUN_DescPrn )
*!*				Values (0, ?tcIpServ, ?tcLetra, ?ldFecPass,0, ?tcNombre )
*!*			Endtext

*!*			If !Prg_EjecutoSql(lcSql,"mwkAux")
*!*				Exit
*!*			Endif

*!*			Loop
	Endif

	TEXT To lcsql Textmerge Noshow Pretext 7
		update TabTurNum
		set TUN_CodigoVax = 1,
			TUN_Ip = ?tcIp
		where TUN_IpSVR = ?tcIpServ and TUN_CodigoVax = 0 And Tun_Letra = ?tcLetra AND Tun_FecPasiva = ?ldFecPass
	ENDTEXT

	If !Prg_EjecutoSql(lcSql,"mwkAux")
		Exit
	Endif

	TEXT To lcsql Textmerge Noshow Pretext 7
		select *
		from TabTurNum
		where TUN_IpSVR = ?tcIpServ
			And TUN_Ip = ?tcIp
			And TUN_CodigoVax = 1
			And Tun_Letra = ?tcLetra
			And Tun_FecPasiva = ?ldFecPass
	ENDTEXT

	If !Prg_EjecutoSql(lcSql,"mwkTurNum")
		Exit
	Endif

	If Reccount("mwkTurNum") = 0
		Loop
	Endif

	tcNro = ""
	If !Obt_Numero(@tcNro)
		Exit
	Endif

&& inserto
	TEXT To lcsql Textmerge Noshow Pretext 7
		insert into tabturnerolog
		(TNL_FechaHoraIng, TNL_IpMaquina, TNL_Numerador, TNL_Tipo, TNL_IpServer, TNL_numdocumento)
		values (getdate(), ?tcIp, ?tcNro, ?tcLetra , ?tcIpServ ,0)
	ENDTEXT

	If !Prg_EjecutoSql(lcSql,"mwkAux")
		Return .F.
	Endif

&& Libre
	TEXT To lcsql Textmerge Noshow Pretext 7
		update TabTurNum
		set TUN_CodigoVax = 0,
			TUN_DesAuto = ?tcNro
		where TUN_IpSVR = ?tcIpServ and TUN_CodigoVax = 1 And Tun_Letra = ?tcLetra And Tun_FecPasiva = ?ldFecPass
	ENDTEXT

	If !Prg_EjecutoSql(lcSql,"mwkAux")
		Exit
	Endif

	lbResu = .T.
	Exit
Enddo

Use In Select("mwkTurNum")

Return (lbResu)


*!*------------------------------------------------------------------------------------------------------------------------------
Function Obt_Numero
Parameters tcNro

tcNro = Alltrim(mwkTurNum.TUN_DesAuto)
If tcNro == '1000'
	lcResN = '0'
Else
	lcResN = Alltrim(Str(Val(tcNro) + 1,16,0))
Endif

tcNro = Padl(lcResN, 4, '0')
*!*------------------------------------------------------------------------------------------------------------------------------

