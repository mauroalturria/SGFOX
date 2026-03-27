****
** Separo los datos que vienen con chr(9) y finaliza con chr(1)
****

parameter mresp,mnroitem

msep1 = 1
msep3 = 1
store 0  to vec_vale

mconta1 = atc(chr(9), mresp, msep1)
mconta3 = atc(chr(1), mresp, msep3)

minicial = 1
m_i = 0

do while mconta1 > 0
	m_i = m_i + 1

	vec_vale(m_i,1) = subs(mresp,  minicial, (mconta1 -1) - (minicial -1))
	vec_vale(m_i,2) = subs(mresp,  mconta1 + 1, (mconta3 -1) - (mconta1))
	mnroitem = mnroitem +1
	msep1 		= msep1 + 1
	msep3		= msep3 + 1
	minicial 	= mconta3 + 1
	mconta1 	= atc(chr(9), mresp, msep1)
	mconta3 	= atc(chr(1), mresp, msep3)

	if m_i>=30
		dime vec_vale(m_i+1,4)
	endif
enddo

