
close all
use demoreps\invoices order customer
local loSession, lnRetval
loSession=EVALUATE([xfrx("XFRX#INIT")])
lnRetVal = loSession.SetParams("invoices.htm",,,,,,"HTML")
If lnRetVal = 0
	loSession.ProcessReport("demoreps\splash",,,,,.t.)
	loSession.ProcessReport("demoreps\invhead",,,,,.t.)
	loSession.ProcessReport("demoreps\invsim",,,,,.t.)
	loSession.finalize()
Endif



close all
loSession=xfrx("XFRX#Init")
SELECT 0
USE demoreps\invoices order customer
loProgress = createobject("progress")	
lnRetVal = loSession.SetParams("INVHEAD",,,,,,"HTML") 								
If lnRetVal = 0
	loSession.setProgressObj(loProgress,2)
	loSession.ProcessReport("C:\XFRX\DEMOREPS\INVHEAD.FRX","invoiceno < 290",,)
	loSession.finalize
EndIf


define class progress as custom
	procedure updateProgress
	lpara tnReport,tnPage,tnPercentage
	wait window nowait "Page #: "+allt(str(tnPage))+" Report #: "+allt(str(tnReport))+" ("+allt(str(tnPercentage))+"%)"
enddef