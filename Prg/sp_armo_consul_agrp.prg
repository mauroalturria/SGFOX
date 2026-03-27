*
* Armo consulta, Ocupación de Consultorios Agrupada
*
If used('consul')
	If reccount('consul')>0
		Create cursor mwkconsag;
			(nombre c(50), espec c(50), consultorio c(20), dia D,cdia c(10);
			, h00 c(1), h01 c(1), h02 c(1), h03 c(1), h04 c(1), h05 c(1), h06 c(1) ;
			, h07 c(1), h08 c(1), h09 c(1), h10 c(1), h11 c(1), h12 c(1), h13 c(1);
			, h14 c(1), h15 c(1), h16 c(1), h17 c(1), h18 c(1), h19 c(1), h20 c(1);
			, h21 c(1), h22 c(1), h23 c(1), h24 c(1) ;
			, hdes n(4), ft n(1) ;
			, h0a6 c(1), h22a24 c(1), porc n(6,2) )

		Select * from consul order by dia, consultorio into cursor mwkcons01
		Select mwkcons01
		Scan
			mdiasem = mwkcons01.dia
			mcdia = mwkcons01.cdia
			monmbre = ""
			mespec  = ""
			msala   = mwkcons01.consultorio
			mhdes   = mwkcons01.hdes
			mft     = mwkcons01.ft
			mh0a6   = mwkcons01.h0a6
			mh22a24 = mwkcons01.h22a24
			mporc   = mwkcons01.porc
			For mi = 0 to 24
				mvarh1  = "mh" + transf(mi,"@L 99")
				mvarh2  = "mwkcons01.h"+ transf(mi,"@L 99")
				mvar    = &mvarh2
				&mvarh1 = nvl(mvar,' ')
			Next mi
			Select mwkconsag
			Go top
			Locate for dia = mdiasem and consultorio = msala
			If !found()
				Insert into mwkconsag ;
					(nombre, espec ,consultorio, dia,cdia, h07, h08, h09, h10;
					, h11, h12, h13, h14, h15, h16, h17, h18, h19, h20, h21, ;
					hdes, ft, h01, h02, h03, h04, h05, h06, h22, h23, h24, h00,;
					h0a6, h22a24, porc ) ;
					values ;
					(mnombre, mespec ,msala, mdiasem, mcdia, mh07, mh08, mh09, mh10,;
					mh11, mh12, mh13, mh14, mh15, mh16, mh17, mh18, mh19, mh20,;
					mh21,mhdes,mft,mh01, mh02, mh03, mh04, mh05, mh06, mh22,;
					mh23, mh24, mh00,;
					mh0a6, mh22a24,	mporc )
			Else
				For mi = 0 to 24
					mvarh3 = "mhg" + transf(mi,"@L 99")
					mcampG = "mwkconsag.h"+ transf(mi,"@L 99")
					&mvarh3 = &mcampG
				Next mi
				For mi = 0 to 24				
					mcompar1 = "mh" +transf(mi,"@L 99")
					mcompar2 = "mhg"+transf(mi,"@L 99")
					mcampoac = "mwkconsag.h" + transf(mi,"@L 99")					
					If (&mcompar2=' ' and (&mcompar1='X' or &mcompar1='/')) or ;
							(&mcompar2='/' and &mcompar1='X')
						Replace &mcampoac with &mcompar1
					Endif					
				Next mi
				If mwkconsag.h0a6 = ' ' and mh0a6 = '|'
					Replace mwkconsag.h0a6 with mh0a6
				Endif
				If mwkconsag.h22a24 = ' ' and mh22a24 = '|'
					Replace mwkconsag.h22a24 with mh22a24
				Endif
			Endif
			Select mwkcons01
		Endscan

	Endif
Endif
