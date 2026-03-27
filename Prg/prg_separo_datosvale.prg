****
** Separo los datos para la impresion del vale
****

Parameter mresp1, mresp2,nroitem

nroitem = 0
mivale = dat_vale(1)
Store '' To dat_vale
Store '' To item_vale
dat_vale(1) = mivale
mconta1  = Atc(Chr(9), mresp1, 1)
mconta2  = Atc(Chr(9), mresp1, 2)
mconta3  = Atc(Chr(9), mresp1, 3)
mconta4  = Atc(Chr(9), mresp1, 4)
mconta5  = Atc(Chr(9), mresp1, 5)
mconta6  = Atc(Chr(9), mresp1, 6)
mconta7  = Atc(Chr(9), mresp1, 7)
mconta8  = Atc(Chr(9), mresp1, 8)
mconta9  = Atc(Chr(9), mresp1, 9)
mconta10 = Atc(Chr(9), mresp1, 10)
mconta11 = Atc(Chr(9), mresp1, 11)
mconta12 = Atc(Chr(9), mresp1, 12)
mconta13 = Atc(Chr(9), mresp1, 13)
mconta14 = Atc(Chr(9), mresp1, 14)
mconta15 = Atc(Chr(9), mresp1, 15)
mconta16 = Atc(Chr(9), mresp1, 16)
mconta17 = Atc(Chr(9), mresp1, 17)
mconta18 = Atc(Chr(9), mresp1, 18)
mconta19 = Atc(Chr(9), mresp1, 19)
mconta20 = Atc(Chr(9), mresp1, 20)
mconta21 = Atc(Chr(9), mresp1, 21)
mconta22 = Atc(Chr(9), mresp1, 22)
mconta23 = Atc(Chr(9), mresp1, 23)
mconta24 = Atc(Chr(9), mresp1, 24)
mconta25 = Atc(Chr(9), mresp1, 25)
mconta26 = Atc(Chr(9), mresp1, 26)
mconta27 = Atc(Chr(9), mresp1, 27)


** asi lo mandan de vax
** P1=NEM_SP1_DSERV_SP1_FEC_SP1_HOR_SP1_HC_SP1_AFI_SP1_HCLI_SP1_SEX_SP1_ED_SP1_NOM_SP1_;
**		CONT_SP1_DCONT_SP1_URG_SP1_COM_SP1_PROTO_SP1__CNSLT_SP1_MEDPREST_SP1_DMEDPREST_;
**		SP1_SOLIC_SP1_DSOLIC_SP1_nrobono_SP1_Operadro_SP1_sec_SP1_codpun_SP1_codent_SP1_fecNac

dat_vale(2)  = Subs(mresp1,  1, (mconta1 -1))							&&NEM
dat_vale(3)  = Subs(mresp1,  mconta1  + 1, (mconta2  -1) - (mconta1))	&&DSERV
dat_vale(4)  = Subs(mresp1,  mconta2  + 1, (mconta3  -1) - (mconta2))	&&FEC
dat_vale(5)  = Subs(mresp1,  mconta3  + 1, (mconta4  -1) - (mconta3))	&&HOR
dat_vale(6)  = Subs(mresp1,  mconta4  + 1, (mconta5  -1) - (mconta4))	&&HC
dat_vale(7)  = Subs(mresp1,  mconta5  + 1, (mconta6  -1) - (mconta5))	&&AFI
dat_vale(8)  = Subs(mresp1,  mconta6  + 1, (mconta7  -1) - (mconta6))	&&HCLI
dat_vale(9)  = Subs(mresp1,  mconta7  + 1, (mconta8  -1) - (mconta7))	&&SEX
dat_vale(10) = Subs(mresp1,  mconta8  + 1, (mconta9  -1) - (mconta8))	&&ED
dat_vale(11) = Subs(mresp1,  mconta9  + 1, (mconta10 -1) - (mconta9))	&&NOM
dat_vale(12) = Subs(mresp1,  mconta10 + 1, (mconta11 -1) - (mconta10))	&&CONT
dat_vale(13) = Subs(mresp1,  mconta11 + 1, (mconta12 -1) - (mconta11))	&&DCONT
dat_vale(14) = Subs(mresp1,  mconta12 + 1, (mconta13 -1) - (mconta12)) 	&&URG
dat_vale(15) = Subs(mresp1,  mconta13 + 1, (mconta14 -1) - (mconta13))	&&COM
dat_vale(16) = Subs(mresp1,  mconta14 + 1, (mconta15 -1) - (mconta14))  &&PROTO
dat_vale(17) = Subs(mresp1,  mconta15 + 1, (mconta16 -1) - (mconta15))	&&
dat_vale(18) = Subs(mresp1,  mconta16 + 1, (mconta17 -1) - (mconta16))	&&CNSLT
dat_vale(19) = Subs(mresp1,  mconta17 + 1, (mconta18 -1) - (mconta17))	&&MEDPREST
dat_vale(20) = Subs(mresp1,  mconta18 + 1, (mconta19 -1) - (mconta18))	&&SOLIC nombre
dat_vale(21) = Subs(mresp1,  mconta19 + 1, (mconta20 -1) - (mconta19))	&&DSOLIC
dat_vale(22) = Subs(mresp1,  mconta20 + 1, (mconta21 -1) - (mconta20))	&&nrobono
dat_vale(23) = Subs(mresp1,  mconta21 + 1, (mconta22 -1) - (mconta21))	&&Operador
dat_vale(24) = Subs(mresp1,  mconta22 + 1, (mconta23 -1) - (mconta22))	&&sec
dat_vale(25) = Subs(mresp1,  mconta23 + 1, (mconta24 -1) - (mconta23))	&&codpun
dat_vale(26) = Subs(mresp1,  mconta24 + 1, (mconta25 -1) - (mconta24))	&&codent
dat_vale(27) = Subs(mresp1,  mconta25 + 1, (mconta26 -1) - (mconta25))	&&fecha Nacim
If mconta27>0
	dat_vale(28) = Subs(mresp1,  mconta26 + 1, (mconta27 -1) - (mconta26))	&&nro docu
Else
	dat_vale(28) = ''&&nro docu
Endif

msep1 = 1
msep2 = 2
msep3 = 3
mconta1  = Atc(Chr(9), mresp2, 1)
mconta2  = Atc(Chr(9), mresp2, 2)
mconta3  = Atc(Chr(9), mresp2, 3)
 	
minicial = 1
m_i = 0
Use In Select('mwk_X_items')
Create Cursor mwk_X_items (x_codigo c(13),x_cant c(3),x_descrip c(50),x_extra c(50))
Do While mconta1 > 0
	m_i = m_i + 1

	item_vale(m_i,1) = Subs(mresp2,  minicial, (mconta1 -1) - (minicial -1))
	item_vale(m_i,2) = Subs(mresp2,  mconta1 + 1, (mconta2 -1) - (mconta1))
	item_vale(m_i,3) = Subs(mresp2,  mconta2 + 1, (mconta3 -1) - (mconta2))
	nroitem = nroitem +Iif(!Empty(item_vale(m_i,1)),1,0)
	Insert Into mwk_X_items (x_codigo,x_cant ,x_descrip,x_extra );
		values (Transform(item_vale(m_i,1)),Transform(item_vale(m_i,2)),Transform(item_vale(m_i,3)),'')
	msep1 		= msep1 + 3
	msep2 		= msep2 + 3
	msep3		= msep3 + 3
	minicial 	= mconta3 + 1
	mconta1 	= Atc(Chr(9), mresp2, msep1)
	mconta2 	= Atc(Chr(9), mresp2, msep2)
	mconta3 	= Atc(Chr(9), mresp2, msep3)
	If m_i>=30
		Dime vec_vale(m_i+1,4), item_vale(m_i+1,3)
	Endif
ENDDO
mcodadm = dat_vale(6)
micentro =  sp_busco_npac(mcodadm,7) 
dat_vale(29) = micentro 
