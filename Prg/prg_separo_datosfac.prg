****
** Separo los datos para la impresion de la factura
****

parameter mresp1,mresp2,mresp3

if vartype(mresp1)#"C"
	mresp1 = ''
endif
if vartype(mresp2)#"C"
	mresp2 = ''
endif
if vartype(mresp3)#"C"
	mresp3 = ''
endif

store '' to dat_fac
store '' to dat_facc
store '' to det_fac
*	1			2		3			4		5		6			7		8		9		10			
*P1=XVALE_SP1_XTC_SP1_XLETRA_SP1_XPUVEN_SP1_XNRO_SP1_FEC_SP1_NOM_SP1_DIRE_SP1_IMP_SP1_FACREFE_SP1_;
*	11			12	  13	14		  15			16		17			18		 19			20
*	CAUSA_SP1_OPE_SP1_HC_SP1_HCLI_SP1_NREGIS_SP1_ENTORIG_SP1_FECHOR_SP1_CUIT_SP1_NUIN_SP1_CAE_SP1_;
*	21			22		23			24		25	 	 26			27		 		
*	FVTOCAE_SP1_LOC_SP1_COPO_SP1_OPEXEN_SP1_IVA_SP1_CATIVA_SP1_INOS_SP1
*	  1			2			3		4		5			  6			7			8			9
*P4=COMENT1_SP1_COMENT2_SP1_COP_SP1_ENT27_SP1_IVA(2)_SP1_IVAIVA_SP1_IVA(3)_SP1_IVAPERC_SP1_IVA(4)_SP1_;
*    10				11			12
*	(IVAIVA/2)_SP1_INGBRUTO_SP1_PORCBRUT_SP1
*P3=PUN
*P2=DETFEC_SP1_DETMOTI_SP1_DETIMP_SP1_DETCANT_SP1_DETREFE_SP1_DETCON_SP1_SP2
mnroitem  =  0
do while len(mresp1) > 1
	mnroitem  = mnroitem + 1
	mcontad  = atc(chr(9), mresp1)
	mcontrol  = atc(chr(1), mresp1)
	if mcontrol<mcontad
		mcontd = mcontrol
	endif
	if mnroitem >=30
		dime dat_fac(mnroitem+1)
	endif

	dat_fac( mnroitem )= left( mresp1, mcontad - 1  )
	mresp1 = substr( mresp1, mcontad + 1 )
enddo
dat_fac(6)  = ctod(dat_fac(6))
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
	otherwise
		mmes = 'Diciembre'
ENDCASE
dat_fac(9)  = strtran(dat_fac(9) ,".",",")
dat_fac(17)  = ctot(dat_fac(17))
dat_fac(99) = str(day(dat_fac(6)),2) + ' de ' +  mmes + ' de ' + str(year(dat_fac(6)),4)
dat_fac(21)  = ctod(dat_fac(21))
*** datos cabecera anexos
mnroitem  =  0
do while len(mresp2) > 1
	mnroitem  = mnroitem + 1
	mcontad  = atc(chr(9), mresp2)
	mcontrol  = atc(chr(1), mresp2)
	if mcontrol<mcontad
		mcontd = mcontrol
	endif
	if mnroitem >=20
		dime dat_facc(mnroitem+1)
	endif

	dat_facc( mnroitem )= left( mresp2, mcontad - 1  )
	mresp2 = substr( mresp2, mcontad + 1 )
ENDDO
if mnroitem>0
	dat_facc(6) = VAL(strtran(dat_facc(6) ,".",","))
	dat_facc(5) = VAL(strtran(dat_facc(5) ,".",","))
	dat_facc(10) = VAL(strtran(dat_facc(10) ,".",","))
	dat_facc(11) = VAL(strtran(dat_facc(11) ,".",","))
	dat_facc(12) = VAL(strtran(dat_facc(12) ,".",","))
endif
*** datos detalle
mnroitem  = 0
do while len(mresp3) > 4
	mnroitem  = mnroitem + 1
	for i= 1 to 6
		mcontad  = atc(chr(9), mresp3)
		mcontrol  = atc(chr(1), mresp3)
		if mcontrol<mcontad 
			mcontd = mcontrol
		endif
		det_fac( mnroitem, i )= left( mresp3, mcontad - 1  )
		mresp3 = substr( mresp3, mcontad + 1 )
	next i
	det_fac( mnroitem,3) =VAL(strtran(det_fac( mnroitem,3) ,".",","))
	if mnroitem >=200
		dime det_fac(mnroitem+1)
	endif
	mcontad 	= atc(chr(1), mresp3, 1)
	mresp3  	= subs(mresp3,  mcontad + 1 )
enddo

