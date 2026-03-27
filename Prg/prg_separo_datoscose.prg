****
** Separo los datos para la impresion del cose
****

Parameter mrespdet,mrespdeta


** asi lo mandan de vax???
**		  1		2			3			4			5			6
**  P2=SERV_!!_SOLIC_!!_MEDPREST_!!_SQCONSU_!!_SQINCO_!!_CANXTP(TIPOATEN)_!!_;
**		COSE_B_BONOPES_B_BONOOBLI_B_REINTE_B_REQDNI_B_REQCRED_B_REQAUTO	_!!_TIPOATEN_!!_SP2
**  P2=SERV_!!_SOLIC_!!_MEDPREST_!!_SQCONSU_!!_SQINCO_!!_CAN_!!_;
**		COSE_!!_BONO_!!_REINTEGRO_!!_ReqDNI_!!_ReqCred_!!_ReqAuto
**		  7			8		9			10			11			12
**		  1		2			3			4			5			6

** P3=SERV_!!_SOLIC_!!_MEDPREST_!!_SQCONSU_!!_SQINCO_!!_CAN_!!_;
**    $TR($G(VCOSE(SERV,SOLIC,MEDPREST,SQCONSU,SQINCO,COD)),B,!!)_!!_TIPOATEN_!!_CANTBONOS_!!_SP2
**	            	  7	  8		9		 10		11	   12				14			15

mnroitem  = 1
Store '' To dat_cose
Store '' To item_cose
Do While Len(mrespdet) > 4
	mnroitem  = mnroitem + 1
	For i= 1 To 15
		mcontad  = Atc(Chr(9), mrespdet)
		mcontrol  = Atc(Chr(1), mrespdet)
		If mcontrol<mcontad
			mcontad  = mcontrol
		Endif
		dat_cose( mnroitem, i )= Left( mrespdet, mcontad - 1  )
		mrespdet = Substr( mrespdet, mcontad + 1 )
	Next i
	dat_cose(1,7)= Str(Val(dat_cose(1,7))+Val(dat_cose(mnroitem  ,7)))
	dat_cose(1,8)= Str(Val(dat_cose(1,8))+Val(dat_cose(mnroitem  ,8)))
	mcontad 	= Atc(Chr(1), mrespdet, 1)
	mrespdet  	= Subs(mrespdet,  mcontad + 1 )
Enddo
mnroitemdet  = 0
Use In Select('itemscose')
Create Cursor itemscose (itserv N(4),itcose N(12),itBono N(12),itTat N(2))
Do While Len(mrespdeta) > 4
	mnroitemdet  = mnroitemdet + 1
	If mnroitemdet  >40
		Dime item_cose(mnroitemdet  ,20)
	Endif
	For i= 1 To 20
		mcontad  = Atc(Chr(9), mrespdeta)
		mcontrol  = Atc(Chr(1), mrespdeta)
		If mcontrol<mcontad
			mcontad  = mcontrol
			Exit
		Endif
		item_cose( mnroitemdet, i )= Left( mrespdeta, mcontad - 1  )
		mrespdeta = Substr( mrespdeta, mcontad + 1 )
	Next i

	If mnroitemdet >1
*!*			if item_cose(mnroitemdet -1,1)= item_cose(mnroitemdet ,1) and item_cose(mnroitemdet -1,14)= item_cose(mnroitemdet ,14)
*!*				if VAL(item_cose(mnroitemdet,7))>0 or val(item_cose(mnroitemdet ,8))>0
*!*					item_cose(mnroitemdet -1,8)= str(val(item_cose(mnroitemdet -1,8))+val(item_cose(mnroitemdet ,8)))
*!*					item_cose(mnroitemdet -1,7)= str(val(item_cose(mnroitemdet -1,7))+val(item_cose(mnroitemdet ,7)))
*!*					item_cose(mnroitemdet -1,6)= str(val(item_cose(mnroitemdet -1,6))+val(item_cose(mnroitemdet ,6)))
*!*				endif
*!*				item_cose(mnroitemdet ,8)= ''
*!*				item_cose(mnroitemdet ,7)= ''
*!*				item_cose(mnroitemdet ,6)= ''
*!*			endif
*!*			mnroitemdet  = mnroitemdet  - 1
	Endif
	mcontad = 1
	Do While mcontad = 1
		mrespdeta  	= Subs(mrespdeta,  mcontad + 1 )
		mcontad 	= Atc(Chr(1), mrespdeta, 1)

	Enddo
Enddo
For uuy = 1 To mnroitemdet
	If Val(item_cose(uuy,1))>0
		Insert Into itemscose (itserv,itcose ,itBono  ,itTat) ;
			VALUES (Val(item_cose(uuy,1)),Val(item_cose(uuy,7)),Val(item_cose(uuy,8)),Val(item_cose(uuy,14)))
	Endif
Next


