****
** Separo los datos que vienen con chr(9) y finaliza con chr(1)
****

Parameter mresp,mnroitems,mnroitem 

msep1 = 1
msep3 = 1
Store 0  To vec_vale
mrespu = mresp
mconta1 = Atc(Chr(9), mresp, msep1)
mconta3 = Atc(Chr(1), mresp, msep3)
mnroitem = 0
minicial = 1
m_i = 1
mcols =1
Do While  mconta1>0 And Len(mrespu)>0
	vec_vale(m_i,mcols) = Left(mrespu,   (mconta1 -1))
	mcols = mcols +1
	If mcols>mnroitems
		m_i = m_i +1
		mcols=1
	Endif
	mrespu= Substr(mrespu,mconta1+1)
	mconta1 = Atc(Chr(9), mrespu, msep1)
	mconta3 = Atc(Chr(1), mrespu, msep3)
	If mconta1>mconta3
		mconta1=mconta3
	Endif
	If m_i>=30
		Dime vec_vale(m_i+1,4)
	Endif
Enddo
m_i = m_i + 1
vec_vale(m_i,mnroitems) = mrespu
mnroitem =m_i

