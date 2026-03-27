
local loSession, lnRetval
loSession=EVALUATE([xfrx("XFRX#INIT")])
lnRetVal = loSession.SetParams('epdef.htm',,.T.,,,,'HTML')
If lnRetVal = 0
loSession.ProcessReport( 'c:\qepd1a1\exe\rep\repplan11',,,,,.t.)
	loSession.finalize()
Endif