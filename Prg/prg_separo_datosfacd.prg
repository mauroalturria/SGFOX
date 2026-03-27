****
** Separo los datos para la impresion de la factura
****

parameter mresp1, mrespdet

	store '' to dat_fac
	mnroitem  = 0
	mconta1  = atc(chr(9), mresp1, 1)
	mconta2  = atc(chr(9), mresp1, 2)
	mconta3  = atc(chr(9), mresp1, 3)
	mconta4  = atc(chr(9), mresp1, 4)
	mconta5  = atc(chr(9), mresp1, 5)
	mconta6  = atc(chr(9), mresp1, 6)
	mconta7  = atc(chr(9), mresp1, 7)
	mconta8  = atc(chr(9), mresp1, 8)
	mconta9  = atc(chr(9), mresp1, 9)
	mconta10 = atc(chr(9), mresp1, 10)
	mconta11 = atc(chr(9), mresp1, 11)
	mconta12 = atc(chr(9), mresp1, 12)
	mconta13 = atc(chr(9), mresp1, 13)
	mconta14 = atc(chr(9), mresp1, 14)
	mconta15 = atc(chr(9), mresp1, 15)
	mconta16 = atc(chr(9), mresp1, 16)
	mconta17 = atc(chr(9), mresp1, 17)
	mconta18 = atc(chr(9), mresp1, 18)
	mconta19 = atc(chr(9), mresp1, 19)
	mconta20 = atc(chr(9), mresp1, 20)
	mconta21 = atc(chr(9), mresp1, 21)
  
*		1			2		3			4		5		  6	  	  7		  8        9                  
**   P1=XVALE_SP1_XTC_SP1_XLETRA_SP1_XPUVEN_SP1_XNRO_SP1_FEC_SP1_NOM_SP1_DIR_SP1_IMP_SP1_
**      FACREFE_SP1_CAUSA_SP1_OPE_SP1_HC_SP1_HCLI_SP1_NREGIS_SP1_ENTORIG_SP1_FECHOR_SP1_CUIT_SP1_NROIN_SP1cae sp1 ftocae
*		10			11		  12	  13	  14		15		  16			17		18			19		20		21
	dat_fac(1)  = subs(mresp1,  1, (mconta1 -1))
	dat_fac(2)  = subs(mresp1,  mconta1 + 1, (mconta2 -1) - (mconta1))
	dat_fac(3)  = subs(mresp1,  mconta2 + 1, (mconta3 -1) - (mconta2))
	dat_fac(4)  = subs(mresp1,  mconta3 + 1, (mconta4 -1) - (mconta3))
	dat_fac(5)  = subs(mresp1,  mconta4 + 1, (mconta5 -1) - (mconta4))
	dat_fac(6)  = ctod(subs(mresp1,  mconta5 + 1, (mconta6 -1) - (mconta5)))
	dat_fac(7)  = subs(mresp1,  mconta6 + 1, (mconta7 -1) - (mconta6))
	dat_fac(8)  = subs(mresp1,  mconta7 + 1, (mconta8 -1) - (mconta7))
	dat_fac(9)  = subs(mresp1,  mconta8 + 1, (mconta9 -1) - (mconta8))

	do case
		case month(dat_fac(6)) = 01 
			mmes = 'Enero'
		case month(dat_fac(6)) = 02
			mmes = 'Febrero' 
		case month(dat_fac(6)) = 03
			mmes = 'Marzo'
		case month(dat_fac(6)) = 04
			mmes = 'Abril'
		case month(dat_fac(6)) = 05
			mmes = 'Mayo' 
		case month(dat_fac(6)) = 06
			mmes = 'Junio' 
		case month(dat_fac(6)) = 07
			mmes = 'Julio' 
		case month(dat_fac(6)) = 08
			mmes = 'Agosto'
		case month(dat_fac(6)) = 09
			mmes = 'Septiembre' 
		case month(dat_fac(6)) = 10
			mmes = 'Octubre'
	 	case month(dat_fac(6)) = 11
	 		mmes = 'Noviembre'
		OTHERWISE
			mmes = 'Diciembre'
	endcase
	dat_fac(10) = str(day(dat_fac(6)),2) + ' de ' +  mmes + ' de ' + str(year(dat_fac(6)),4)
	dat_fac(11)  = subs(mresp1,  mconta9 + 1, (mconta10 -1) - (mconta9))
	dat_fac(12)  = subs(mresp1,  mconta10 + 1, (mconta11 -1) - (mconta10))
	dat_fac(13)  = subs(mresp1,  mconta11 + 1, (mconta12 -1) - (mconta11))
	dat_fac(14)  = subs(mresp1,  mconta12 + 1, (mconta13 -1) - (mconta12))
	dat_fac(15)  = subs(mresp1,  mconta13 + 1, (mconta14 -1) - (mconta13))
	dat_fac(16)  = subs(mresp1,  mconta14 + 1, (mconta15 -1) - (mconta14))
	dat_fac(17)  = subs(mresp1,  mconta15 + 1, (mconta16 -1) - (mconta15))
	dat_fac(18)  = ctot(subs(mresp1,  mconta16 + 1, (mconta17 -1) - (mconta16)))
	dat_fac(19)  = subs(mresp1,  mconta17 + 1, (mconta18 -1) - (mconta17))
	dat_fac(23)  = subs(mresp1,  mconta18 + 1, (mconta19 -1) - (mconta18))
	dat_fac(28)  = subs(mresp1,  mconta19 + 1, (mconta20 -1) - (mconta19))
	dat_fac(29)  = subs(mresp1,  mconta20 + 1, (mconta21 -1) - (mconta20))


*  01=XVALE  02_XTC  03_XLETRA  04_XPUVEN  05_XNRO 06_FEC 07_NOM  08_DIR 09_IMP 
*  10_FACREFE  11_CAUSA  12_OPE  13_HC  14_HCLI  15_NREGIS  16_ENTORIG 17_FECHOR  

** detalle de factura
*!*		mdetalle =  mdetalle  +  mmespres + chr(9) + mmotivo  + chr(9) +;
*!*				transform(mimpo) + chr(9) + transform(mcant)+ chr(9) +;
*!*				transform(mref) + chr(9) + transform(mcontr )+ chr(9) + chr(1)  

	do while len(mrespdet) > 4
		mnroitem  = mnroitem + 1
		for i= 1 to 6
			mcontad  = atc(chr(9), mrespdet)
			det_fac( mnroitem, i )= left( mrespdet, mcontad - 1  )
			mrespdet = substr( mrespdet, mcontad + 1 )
		next i		
		mcontad 	= atc(chr(1), mrespdet, 1)
		mrespdet  	= subs(mrespdet,  mcontad + 1 )
	enddo	
	