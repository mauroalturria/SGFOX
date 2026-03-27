****
** Separa los Nro de admision y pajarera
****
parameter mresp1, mresp2, ncant

npos1 = 1
npos2 = 1

for i= 1 to ncant 
	mconta1 = atc(chr(9), mresp1, i)
	mconta2 = atc(chr(9), mresp2, i)

	mnroadm = subs(mresp1, npos1, (mconta1 - npos1))	

	mnropaj = subs(mresp2, npos2, (mconta2 - npos2))	
	
	npos1 = mconta1 + 1
	npos2 = mconta2 + 1
	
	insert into numeros (nroadmision,nropalomar) values ( mnroadm, mnropaj )
next 