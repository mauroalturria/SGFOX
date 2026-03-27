****
** Separo los datos que vienen con ',' y finaliza con '<BR>'
****

Parameter mresp,mnroitems ,mnroitem

msep1 = 1
msep3 = 1
mnroitems = 10
Store ''  To token_resp
mrespu = mresp
mconta1 = Atc(',', mresp, msep1)
mconta3 = Atc('<BR>', mresp, msep3)
mnroitem = 0
minicial = 1
m_i = 1
mcols =1
Do While  (mconta1>0 Or mconta3>0) And Len(mrespu)>0
	If mconta1>mconta3
		token_resp(m_i,mcols) = Left(mrespu,   (mconta3 -1))
		mrespu= Substr(mrespu,mconta3+4)
		mconta1 = Atc(',', mrespu, msep1)
		mconta3 = Atc('<BR>', mrespu, msep3)
		m_i = m_i +1
		mcols =1

	Else
		If mconta1=0
			token_resp(m_i,mcols) = Left(mrespu,   (mconta3 -1))
			Exit
		Else
			token_resp(m_i,mcols) = Left(mrespu,(mconta1 -1))
			mcols = mcols +1
			If mcols>mnroitems
				m_i = m_i +1
				mcols=1
			Endif
			mrespu= Substr(mrespu,mconta1+1)
			mconta1 = Atc(',', mrespu, msep1)
			mconta3 = Atc('<BR>', mrespu, msep3)

			If m_i>=300
				Dime token_resp(m_i+1,10)
			Endif
		Endif
	Endif
Enddo
mnroitem =m_i

