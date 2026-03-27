Do SP_CONEXION
Select csvs
Set Step On
MESV_parAltura=0
MESV_parFreCard=0
MESV_parGluc=0
MESV_parNivCon=0
MESV_parSatur=0
MESV_parTemBuc=0
MESV_parTensAM=0
MESV_parTensSis=0
MESV_parFreResp=0
MESV_parGlucCorr=0
MESV_parpic=0
MESV_parTemAxl=0
MESV_parTemRct=0
MESV_parTensDia=0
MESV_parPeso=0

midevol= Nvl(idevol,0)
midusuario  = idusu

Go Top
Do While !Eof()
	mnurse = ''
	mfechahora = Ctot("07/08/2023 "+HORA)
	mhoratoma 	= Strtran(hora,":","")
	mnurse = mnurse + ' Datos de las '+Transform(mhoratoma)+Chr(10)
	Do While !Eof() And midevol=  Nvl(idevol,0) And midusuario  = idusu
		Do Case
		Case idcsv  = 17
			MESV_parNivCon=MVALOR
			mnurse = mnurse + ' Nivel de conciencia:'+ Iif(MVALOR =1," Alerta",Iif(MVALOR =2," Voz",Iif(MVALOR =1,;
			" Dolor",' Inconciente') ) ) + Chr(10)
		Case idcsv  = 13
			mnurse = mnurse + Alltrim(Descr )+ Chr(10)
		Case Inlist(idcsv ,1,2,3,4,5)
			mnurse = mnurse + Alltrim(Descr )+ Transf(MVALOR ,'999')+ Chr(10)
			Do Case
			Case idcsv  = 1
				MESV_parFreCard = MVALOR
			Case idcsv  = 2
				MESV_parFreResp = MVALOR
			Case idcsv  = 3
				MESV_parSatur = MVALOR
			Case idcsv  = 4
				MESV_parTensDia=MVALOR
			Case idcsv  = 5
				MESV_parTensSis=MVALOR
			Endcase
		Case idcsv  = 8
			MESV_parTemAxl=MVALOR
			mnurse = mnurse + Alltrim(Descr )+ Transf(MVALOR ,'99.9')+ Chr(10)
		Case idcsv  = 11
			MESV_parGluc = MVALOR
			mnurse = mnurse + Alltrim(Descr )+ Transf(MVALOR ,'9999') + ' mg/dl '+ Chr(10)
		Case idcsv  = 12
			MESV_parGlucCorr = MVALOR
			mnurse = mnurse + Alltrim(Descr )+ Transf(MVALOR ,'9999') + ' UI  '+ Chr(10)
		Otherwise
			Set Step On
		Endcase
		Skip
	Enddo

	mnurse = Iif(!Empty(mnurse), 'C.S.V. ' + Chr(10) + mnurse,'')
	If  midevol >0
		mobs = mnurse
		mret = SQLExec(mcon1, "insert into TabIntEvolParcial " + ;
		"(EIP_evol , EIP_fechaH , EIP_idevol   , EIP_tipoEvol , EIP_tipoUsuario , EIP_usuario  )"+;
		" values "+;
		" (?mobs,?mfechahora,?midevol,'V', 2, ?midusuario )" )
		If mret < 0
			Set Step On
		Endif


		mret = SQLExec(mcon1, "insert into TabIntCSV" + ;
		" (ESV_fechah ,ESV_hora ,ESV_parfrecard , ESV_parfreresp , ESV_pargluc ,ESV_parpic ," + ;
		"ESV_parpeso , ESV_parsatur , ESV_partemaxl , ESV_partembuc , ESV_partemrct , " + ;
		"ESV_partensdia , ESV_partenssis , ESV_parTensAM, ESV_idevol , ESV_usuario,ESV_parAltura, ESV_parGlucCorr   "+;
		",ESV_parNivCon  ) values "+;
		" (?mfechahora , ?mhoratoma,?MESV_parfrecard , ?MESV_parfreresp , ?MESV_pargluc ,?MESV_parpic ," + ;
		"?MESV_parpeso , ?MESV_parsatur , ?MESV_partemaxl , ?MESV_partembuc , ?MESV_partemrct , " + ;
		"?MESV_partensdia , ?MESV_partenssis , ?MESV_parTensAM, ?midevol, ?midusuario ,?MESV_parAltura, ?MESV_parGlucCorr   "+;
		",?MESV_parNivCon )" )
		If mret < 0
			Set Step On
		Endif
	Endif
	Select csvs
	midevol=  Nvl(idevol,0)
	midusuario  = idusu
	MESV_parAltura=0
	MESV_parFreCard=0
	MESV_parGluc=0
	MESV_parNivCon=0
	MESV_parSatur=0
	MESV_parTemBuc=0
	MESV_parTensAM=0
	MESV_parTensSis=0
	MESV_parFreResp=0
	MESV_parGlucCorr=0
	MESV_parpic=0
	MESV_parTemAxl=0
	MESV_parTemRct=0
	MESV_parTensDia=0
	MESV_parPeso=0

Enddo
Do SP_DESCONEXION

*!*	MESV_parAltura	  MESV_parFreCard	  MESV_parGluc	  MESV_parNivCon	  MESV_parSatur
*!*	MESV_parTemBuc	  MESV_parTensAM	  MESV_parTensSis	 MESV_parFreResp
*!*	MESV_parGlucCorr	 MESV_parpic	 MESV_parTemAxl	 MESV_parTemRct
*!*	MESV_parTensDia	 MESV_parPeso

*!*	LECT ESV_usuario,   ESV_fechaH,;
*!*	ESV_hora, ESV_idevol, ESV_parAltura,;
*!*	ESV_parFreCard, ESV_parFreResp,;
*!*	ESV_parGluc, ESV_parGlucCorr,;
*!*	ESV_parNivCon, ESV_parpic, ESV_parPeso,;
*!*	ESV_parSatur, ESV_parTemAxl,;
*!*	ESV_parTemBuc, ESV_parTemRct,;
*!*	ESV_parTensAM, ESV_parTensDia,;
*!*	ESV_parTensSis;
