
local loSession, lnRetval
loSession=EVALUATE([xfrx("XFRX#INIT")])
lnRetVal = loSession.SetParams('PE_0330.htm',,,,,,'HTML')
If lnRetVal = 0
loSession.ProcessReport( '..\rep\repplan10',,,,,.t.)
	loSession.finalize()
Endif