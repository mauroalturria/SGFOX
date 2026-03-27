****
** Separa los Nro de Vales y Facturas
** codprest_sep_vale_sep_factura
****
Parameter mresp

msep1 = 1
msep2 = 2
msep3 = 1
Store 0  To vec_vale

mconta1 = Atc(Chr(9), mresp, msep1)
mconta2 = Atc(Chr(9), mresp, msep2)
mconta3 = Atc(Chr(1), mresp, msep3)

minicial = 1
m_i = 0
m_i   =  0
Do While Len(mresp) > 1
	m_i   = m_i  + 1
	mcontad  = Atc(Chr(9), mresp)
	mcontrol  = Atc(Chr(1), mresp)
	If mcontrol<mcontad
		exit
	Endif
	If m_i  >=30
		Dime vec_vale(m_i+1,4)
	Endif
	m_j = 0
	Do While Len(mresp) > 1 And m_j<4
		mcontad  = Atc(Chr(9), mresp)
		mcontrol  = Atc(Chr(1), mresp)
		If mcontrol<mcontad
			exit
		Endif
		m_j = m_j +1
		vec_vale( m_i,m_j )= INT(VAL(Left( mresp, mcontad - 1  )))
		mresp = Substr( mresp, mcontad + 1 )
	ENDDO
	mcontrol  = Atc(Chr(1), mresp)
	mresp = Substr( mresp, mcontrol + 1 )

Enddo
