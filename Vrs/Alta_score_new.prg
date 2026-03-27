select tabiiintrcsv
go top
scan
	mifec = ESV_fechaH
	mihora = ESV_hora
	miidevol = ESV_idevol
	mFC = ESV_parFreCard
	mfr = ESV_parFreResp
	mNC = nvl(ESV_parNivCon,0)
	mso2 = ESV_parSatur
	mtemp = ESV_parTemAxl
	mtas = ESV_parTensSis
	musu = ESV_usuario
	miescore = prg_calcula_news(mFR,mSO2,mTemp,mTAS,mFC,mNC)
	if miescore>=0
		insert into tabintscore(EIS_fechaH, EIS_idevol,EIS_observacion, EIS_tiposcore,;
	  EIS_usuario, EIS_valor) values (mifec ,miidevol ,'',13,musu,miescore )
	endif
endscan
