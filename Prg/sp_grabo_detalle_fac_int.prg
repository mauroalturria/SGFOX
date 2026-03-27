parameter mnroFac,mfecha,mUsu,mptovta,mcomp,mletra

sele mwkitemfact
scan
	mbonDes 	= 0
	mbonHas 	= 0
	mcant   	= mwkitemfact.cantidad
	mimp    	= mwkitemfact.Importe
	mtpoB   	= mwkitemfact.motivo
	mobserva 	= mwkitemfact.observa
	mvalUni		= val( strtran( mwkitemfact.mespres, "/", '') )
	if mimp>0
		mdetalle= transform(mcant)+ chr(9) + transform(mimp) + chr(9) +transform(mtpoB)+ chr(9) ;
			+transform(mvalUni)+ chr(9) +transform(mnrofac)+ chr(9) +transform(mfecha)

		mret= sqlexec(mcon1,'INSERT INTO TabdetalleFac(observa,Cantidad, ImporteB,letraComp,'+;
			' NroFactura, tipobono,tipocomp,ptovta,valorUni, fechagraba,usuario,BonoDesde,BonoHasta)' +;
			'VALUES(?mobserva,?mcant,?mimp,?mletra,'+;
			' ?mnrofac, ?mtpob,?mcomp,?mptovta,?mvalUni,?mfecha,?musu,?mbonDes ,?mbonHas )')

		if mret < 0
			=aerr(eros)
			mmsgerr = eros(2)
			do sp_insert_tabCtrlErr with mdetalle, mmsgerr , musu, "sp_grabo_detalle_fac"
			messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS  U R G E N T E  !!!", 48, 'Validacion')
			mret=0
		endif
	endif
Endscan

