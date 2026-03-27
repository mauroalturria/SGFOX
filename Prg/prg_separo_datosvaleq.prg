****
** Separo los datos para la impresion del vale
****

parameter mresp1, mresp2,nroitem

nroitem = 0
store '' to dat_vale
store '' to item_vale
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
mconta22 = atc(chr(9), mresp1, 22)

** asi lo mandan de vax
** P1=NEM_SP1_DSERV_SP1_FEC_SP1_HOR_SP1_HC_SP1_AFI_SP1_HCLI_SP1_SEX_SP1_ED_SP1_NOM_SP1_;
**		CONT_SP1_DCONT_SP1_URG_SP1_COM_SP1_PROTO_SP1__CNSLT_SP1_MEDPREST_SP1_DMEDPREST_;
**		SP1_SOLIC_SP1_DSOLIC_SP1_nrobono_SP1_Operadro

	dat_vale(2)  = subs(mresp1,  1, (mconta1 -1))
	dat_vale(3)  = subs(mresp1,  mconta1  + 1, (mconta2  -1) - (mconta1))
	dat_vale(4)  = subs(mresp1,  mconta2  + 1, (mconta3  -1) - (mconta2))
	dat_vale(5)  = subs(mresp1,  mconta3  + 1, (mconta4  -1) - (mconta3))
	dat_vale(6)  = subs(mresp1,  mconta4  + 1, (mconta5  -1) - (mconta4))
	dat_vale(7)  = subs(mresp1,  mconta5  + 1, (mconta6  -1) - (mconta5))
	dat_vale(8)  = subs(mresp1,  mconta6  + 1, (mconta7  -1) - (mconta6))
	dat_vale(9)  = subs(mresp1,  mconta7  + 1, (mconta8  -1) - (mconta7))
	dat_vale(10) = subs(mresp1,  mconta8  + 1, (mconta9  -1) - (mconta8))
	dat_vale(11) = subs(mresp1,  mconta9  + 1, (mconta10 -1) - (mconta9))
	dat_vale(12) = subs(mresp1,  mconta10 + 1, (mconta11 -1) - (mconta10))
	dat_vale(13) = subs(mresp1,  mconta11 + 1, (mconta12 -1) - (mconta11))
	dat_vale(14) = subs(mresp1,  mconta12 + 1, (mconta13 -1) - (mconta12))
	dat_vale(15) = subs(mresp1,  mconta13 + 1, (mconta14 -1) - (mconta13))
	dat_vale(16) = subs(mresp1,  mconta14 + 1, (mconta15 -1) - (mconta14))
	dat_vale(17) = subs(mresp1,  mconta15 + 1, (mconta16 -1) - (mconta15))
	dat_vale(18) = subs(mresp1,  mconta16 + 1, (mconta17 -1) - (mconta16))
	dat_vale(19) = subs(mresp1,  mconta17 + 1, (mconta18 -1) - (mconta17))
	dat_vale(20) = subs(mresp1,  mconta18 + 1, (mconta19 -1) - (mconta18))
	dat_vale(21) = subs(mresp1,  mconta19 + 1, (mconta20 -1) - (mconta19))
	dat_vale(22) = subs(mresp1,  mconta20 + 1, (mconta21 -1) - (mconta20))
	dat_vale(23) = subs(mresp1,  mconta21 + 1, (mconta22 -1) - (mconta21))
	

msep1 = 1
msep2 = 2
msep3 = 3
mconta1  = atc(chr(9), mresp2, 1)
mconta2  = atc(chr(9), mresp2, 2)
mconta3  = atc(chr(9), mresp2, 3)

minicial = 1
m_i = 0

do while mconta1 > 0
	m_i = m_i + 1

	item_vale(m_i,1) = subs(mresp2,  minicial, (mconta1 -1) - (minicial -1))
	item_vale(m_i,2) = subs(mresp2,  mconta1 + 1, (mconta2 -1) - (mconta1))
	item_vale(m_i,3) = subs(mresp2,  mconta2 + 1, (mconta3 -1) - (mconta2))
	nroitem = nroitem +iif(!empty(item_vale(m_i,1)),1,0)

	msep1 		= msep1 + 3
	msep2 		= msep2 + 3
	msep3		= msep3 + 3
	minicial 	= mconta3 + 1
	mconta1 	= atc(chr(9), mresp2, msep1)
	mconta2 	= atc(chr(9), mresp2, msep2)
	mconta3 	= atc(chr(9), mresp2, msep3)
	if m_i>=30
		dime vec_vale(m_i+1,4), item_vale(m_i+1,3)
	endif
	
enddo


