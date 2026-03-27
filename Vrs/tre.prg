set step on

mresp= filetostr("c:\extract.txt" )
mconta1 = atc(";",mresp)
lfin = len(mresp)
msep1 	=  1
minicial = 1
do while mconta1+20 <lfin
	micampo = subs(mresp,  minicial, (mconta1 -1) - (minicial -1))
	msep1 		= msep1 + 1
	minicial 	= mconta1 + 1
	mconta1 	= atc(";", mresp, msep1)
	mtipo= micampo
	micampo = subs(mresp,  minicial, (mconta1 -1) - (minicial -1))
	msep1 		= msep1 + 1
	minicial 	= mconta1 + 1
	mconta1 	= atc(";", mresp, msep1)
	mnombre= micampo
	micampo = subs(mresp,  minicial, (mconta1 -1) - (minicial -1))
	msep1 		= msep1 + 1
	minicial 	= mconta1 + 1
	mconta1 	= atc(";", mresp, msep1)
	mnumero = val(micampo)
	micampo = subs(mresp,  minicial, (mconta1 -1) - (minicial -1))
	msep1 		= msep1 + 1
	minicial 	= mconta1 + 1
	mconta1 	= atc(";", mresp, msep1)
	mtipon = val(micampo)
	insert into telefono values(mtipo,mnombre,mnumero,mtipon)
enddo

